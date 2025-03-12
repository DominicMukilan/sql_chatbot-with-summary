import json
import re
import requests
from typing import Dict, Any, Optional

from config.settings import SQL_API_URL, SQL_API_KEY

class SQLService:
    """
    Service to execute SQL queries via an API
    """
    
    def __init__(self, api_url: str = SQL_API_URL, api_key: str = SQL_API_KEY):
        """
        Initialize the SQL service
        
        Args:
            api_url: URL of the SQL execution API
            api_key: API key for authentication
        """
        self.api_url = api_url
        self.api_key = api_key
        self.max_retries = 3
        
    def execute_query(self, sql_query: str) -> Dict[str, Any]:
        """
        Execute a SQL query via the API with retry and error handling
        
        Args:
            sql_query: SQL query to execute
            
        Returns:
            Dict: Result of the query execution
        """
        # Try to fix common SQL errors before execution
        fixed_query = self._fix_common_sql_errors(sql_query)
        
        attempt = 1
        last_error = None
        
        while attempt <= self.max_retries:
            try:
                print(f"Attempt {attempt}/{self.max_retries} to execute SQL query")
                result = self._execute_single_query(fixed_query)
                
                # Check if there's an error in the response
                if not result.get("status", False) or "error" in result:
                    error_response = result.get("entity", {})
                    
                    # If there's an error, try to fix it
                    if attempt < self.max_retries:
                        error_code = error_response.get("parent", {}).get("code", "") if isinstance(error_response, dict) else ""
                        error_message = error_response.get("parent", {}).get("routine", "") if isinstance(error_response, dict) else ""
                        
                        print(f"SQL error: {error_code} - {error_message}")
                        
                        # Try to fix the query based on the error
                        fixed_query = self._fix_query_from_error(fixed_query, error_code, error_message)
                        if fixed_query == sql_query:
                            # If we couldn't fix it, give up
                            break
                        
                        print(f"Fixed query for attempt {attempt+1}: {fixed_query}")
                    else:
                        # Last attempt, return the error
                        return result
                else:
                    # Success, return the result
                    return result
                
            except Exception as e:
                last_error = str(e)
                print(f"Attempt {attempt} failed: {last_error}")
                
            attempt += 1
        
        # If we get here, all attempts failed
        return {"status": False, "message": f"Failed to execute query after {self.max_retries} attempts", "last_error": last_error}
        
    def _execute_single_query(self, sql_query: str) -> Dict[str, Any]:
        """
        Execute a single SQL query via the API without retries
        
        Args:
            sql_query: SQL query to execute
            
        Returns:
            Dict: Result of the query execution
        """
        try:
            response = requests.post(
                self.api_url,
                json={"query": sql_query},
                headers={"Content-Type": "application/json"},
                timeout=60
            )
            
            if response.status_code == 200:
                result = response.json()
                print("API Response: ")
                print(result)
                
                # Check if there's an error in the entity
                if result.get("status") and isinstance(result.get("entity"), dict) and "name" in result.get("entity", {}):
                    # This is an error response with a database error
                    if result["entity"].get("name").startswith("Sequelize"):
                        error_message = result["entity"].get("parent", {}).get("routine", "Database error")
                        print(f"Database error: {error_message}")
                        return {
                            "status": False, 
                            "message": f"Database error: {error_message}",
                            "details": result["entity"]
                        }
                
                # Normal success case with data
                if result.get("status") and isinstance(result.get("entity"), list):
                    entity_count = len(result.get("entity", []))
                    print(f"API query successful: Found {entity_count} results")
                    return result
                # Other success cases
                elif result.get("status"):
                    print("API query successful but returned non-list entity")
                    return {"status": False, "message": "Query returned unexpected format", "raw_response": result}
                else:
                    print(f"API returned error: {result.get('message')}")
                    return result
            else:
                print(f"API returned HTTP error: {response.status_code}")
                return {"status": False, "message": f"HTTP error: {response.status_code}"}
            
        except Exception as e:
            print(f"Error executing query with API: {str(e)}")
            return {"status": False, "message": f"Error: {str(e)}"}
    
    def validate_query(self, sql_query: str) -> bool:
        """
        Validate a SQL query for security and correctness
        
        Args:
            sql_query: SQL query to validate
            
        Returns:
            bool: True if the query is valid, False otherwise
        """
        # Basic validation to prevent dangerous operations
        dangerous_keywords = [
            "DROP", "DELETE", "TRUNCATE", "ALTER", "CREATE", "INSERT", 
            "UPDATE", "GRANT", "REVOKE", "EXEC", "EXECUTE"
        ]
        
        query_upper = sql_query.upper()
        
        # Check for dangerous keywords
        for keyword in dangerous_keywords:
            if keyword in query_upper.split():
                return False
        
        return True
        
    def _fix_common_sql_errors(self, sql_query: str) -> str:
        """
        Fix common SQL errors before execution
        
        Args:
            sql_query: Original SQL query
            
        Returns:
            str: Fixed SQL query
        """
        fixed_query = sql_query
        
        # Fix camelCase columns - ensure they're properly quoted
        common_camel_case_columns = ["createdAt", "updatedAt", "createdBy", "agentId", "appointmentType"]
        for col in common_camel_case_columns:
            # Only quote the column if it's not already quoted
            if col in fixed_query and f'"{col}"' not in fixed_query:
                # Quote the column when used with a table alias
                pattern = r'([a-zA-Z0-9_]+)\.(' + re.escape(col) + r')(\s|,|\)|$)'
                fixed_query = re.sub(pattern, r'\1."\2"\3', fixed_query)
                
                # Also fix in ORDER BY clauses specifically
                order_pattern = r'ORDER BY\s+([a-zA-Z0-9_]+)\.(' + re.escape(col) + r')(\s|$)'
                fixed_query = re.sub(order_pattern, r'ORDER BY \1."\2"\3', fixed_query)
        
        # Ensure proper ORDER BY syntax
        if "ORDER BY" in fixed_query:
            # Check if there's a missing space after the column in ORDER BY
            fixed_query = re.sub(r'ORDER BY([a-zA-Z0-9_\."\s]+)(DESC|ASC)(?!\s)', r'ORDER BY\1 \2', fixed_query)
        
        # Fix missing schema qualification
        table_names = ["appointment_details", "city_masters", "service_provider_center_details", 
                        "payment_details", "users", "scan_masters", "doctor_details"]
        for table in table_names:
            if table in fixed_query and f"public.{table}" not in fixed_query:
                table_pattern = r'\b' + re.escape(table) + r'\b(?!\.\w)'
                fixed_query = re.sub(table_pattern, f"public.{table}", fixed_query)
                
        # Fix potential comma issues in SELECT
        fixed_query = re.sub(r',\s*FROM', r' FROM', fixed_query)
        
        # Add missing semicolon at the end if needed
        if not fixed_query.strip().endswith(';'):
            fixed_query = fixed_query.strip() + ';'
            
        return fixed_query
        
    def _fix_query_from_error(self, query: str, error_code: str, error_message: str) -> str:
        """
        Attempt to fix the query based on the error
        
        Args:
            query: Original SQL query
            error_code: Database error code
            error_message: Error message or routine name
            
        Returns:
            str: Fixed SQL query or original if can't be fixed
        """
        fixed_query = query
        
        # Fix column name errors - often related to camelCase columns (errorMissingColumn)
        if error_code == "42703" or error_message == "errorMissingColumn":
            # Try to identify the problematic column
            # Common camelCase columns that should be quoted
            camel_case_columns = ["createdAt", "updatedAt", "createdBy", "agentId", "appointmentType"]
            
            for col in camel_case_columns:
                # Patterns to fix various occurrences of camelCase columns
                # 1. In ORDER BY clauses
                order_pattern = r'ORDER BY\s+([a-zA-Z0-9_]+)\.(' + re.escape(col) + r')(\s|$)'
                fixed_query = re.sub(order_pattern, r'ORDER BY \1."\2"\3', fixed_query)
                
                # 2. In column references with table aliases
                pattern = r'([a-zA-Z0-9_]+)\.(' + re.escape(col) + r')(\s|,|\)|$)'
                fixed_query = re.sub(pattern, r'\1."\2"\3', fixed_query)
                
                # 3. In standalone column references
                standalone_pattern = r'\b' + re.escape(col) + r'\b(?!\.[a-zA-Z0-9_])'
                fixed_query = re.sub(standalone_pattern, f'"{col}"', fixed_query)
        
        # Fix for missing table/relation (errorMissingFrom)
        elif error_code == "42P01" or error_message == "errorMissingFrom":
            # Try to fix missing schema qualification
            table_names = ["appointment_details", "city_masters", "service_provider_center_details", 
                          "payment_details", "users", "scan_masters", "doctor_details"]
            for table in table_names:
                if table in fixed_query and f"public.{table}" not in fixed_query:
                    table_pattern = r'\b' + re.escape(table) + r'\b(?!\.\w)'
                    fixed_query = re.sub(table_pattern, f"public.{table}", fixed_query)
        
        # Fix syntax errors (scanner_yyerror)
        elif error_code == "42601" or error_message == "scanner_yyerror":
            # Fix incorrect ORDER BY syntax
            if "ORDER BY" in fixed_query:
                # Remove any trailing characters after ORDER BY that could cause syntax errors
                fixed_query = re.sub(r'ORDER BY\s+([^;]*)([;]?)', r'ORDER BY \1\2', fixed_query)
                
            # Remove any trailing commas before FROM, WHERE, etc.
            fixed_query = re.sub(r',\s*(FROM|WHERE|GROUP BY|ORDER BY)', r' \1', fixed_query)
            
            # Fix incomplete GROUP BY clauses
            fixed_query = re.sub(r'GROUP BY\s*,', r'GROUP BY ', fixed_query)
            
            # Fix missing semicolon
            if not fixed_query.strip().endswith(';'):
                fixed_query = fixed_query.strip() + ';'
        
        # Fix column ambiguity (errorAmbiguousColumn)
        elif error_code == "42702" or error_message == "errorAmbiguousColumn":
            # Identify potentially ambiguous columns like 'id', 'name', etc.
            ambiguous_columns = ['id', 'name', 'created_at', 'updated_at', 'is_deleted']
            
            # Extract table aliases from the query
            alias_matches = re.findall(r'FROM\s+(\w+)(?:\s+AS\s+|\s+)(\w+)', fixed_query, re.IGNORECASE)
            alias_matches += re.findall(r'JOIN\s+(\w+)(?:\s+AS\s+|\s+)(\w+)', fixed_query, re.IGNORECASE)
            
            if alias_matches:
                # Get the first (main) table alias
                main_alias = alias_matches[0][1]
                
                # Fix ambiguous columns
                for col in ambiguous_columns:
                    pattern = r'\b' + re.escape(col) + r'\b(?!\.\w)'
                    # Only replace if not already qualified
                    if re.search(pattern, fixed_query):
                        fixed_query = re.sub(pattern, f'{main_alias}.{col}', fixed_query)
        
        return fixed_query