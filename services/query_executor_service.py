import json
from typing import Dict, Any, Tuple, Optional

from services.llm_service import LLMService
from services.sql_service import SQLService

class QueryExecutorService:
    """
    Service to coordinate between LLM and SQL services, handling retries and error recovery
    """
    
    def __init__(self, llm_service: LLMService = None, sql_service: SQLService = None):
        """
        Initialize the query executor service
        
        Args:
            llm_service: LLM service for generating SQL queries
            sql_service: SQL service for executing SQL queries
        """
        self.llm_service = llm_service or LLMService()
        self.sql_service = sql_service or SQLService()
        self.max_retries = 3
        
    def execute_natural_language_query(self, user_query: str, schema_description: str) -> Dict[str, Any]:
        """
        Execute a natural language query with retries and error recovery
        
        Args:
            user_query: Natural language query from the user
            schema_description: Description of the database schema
            
        Returns:
            Dict: Result of the query execution with metadata
        """
        attempt = 1
        last_sql_query = None
        last_error = None
        error_context = ""
        
        while attempt <= self.max_retries:
            print(f"Attempt {attempt}/{self.max_retries} to execute natural language query")
            
            try:
                # Generate SQL query with error context from previous attempts
                prompt = self._create_sql_generation_prompt_with_error_feedback(
                    user_query, schema_description, error_context
                )
                
                sql_query = self.llm_service.generate_sql_with_custom_prompt(prompt)
                last_sql_query = sql_query
                
                print(f"Generated SQL (attempt {attempt}): {sql_query}")
                
                # Validate query for safety
                if not self.sql_service.validate_query(sql_query):
                    last_error = "Query contains unsafe operations"
                    return {
                        "status": False,
                        "message": f"SQL query validation failed: {last_error}",
                        "sql_query": sql_query,
                        "attempt": attempt,
                        "max_retries": self.max_retries
                    }
                
                # Execute SQL query
                result = self.sql_service.execute_query(sql_query)
                
                # Check if the query was successful
                if result.get("status", False):
                    # Success! Return the result
                    result["sql_query"] = sql_query
                    result["attempt"] = attempt
                    result["max_retries"] = self.max_retries
                    return result
                else:
                    # Execution failed, build error context for the next attempt
                    error_message = result.get("message", "Unknown error")
                    error_details = result.get("details", {})
                    
                    # Extract specific error information
                    error_code = None
                    error_routine = None
                    error_position = None
                    error_hint = None
                    
                    if isinstance(error_details, dict) and "parent" in error_details:
                        parent = error_details.get("parent", {})
                        error_code = parent.get("code")
                        error_routine = parent.get("routine")
                        error_position = parent.get("position")
                        error_hint = parent.get("hint")
                    
                    error_context = self._format_error_context(
                        sql_query, error_message, error_code, error_routine, error_position, error_hint
                    )
                    
                    last_error = error_message
                    print(f"SQL execution failed. Error: {error_message}")
                    print(f"Error context for next attempt: {error_context}")
            
            except Exception as e:
                last_error = str(e)
                error_context = f"Exception occurred: {last_error}"
                print(f"Exception during query execution: {last_error}")
            
            attempt += 1
        
        # All attempts failed
        return {
            "status": False,
            "message": f"Failed to execute query after {self.max_retries} attempts. Last error: {last_error}",
            "sql_query": last_sql_query,
            "attempt": self.max_retries,
            "max_retries": self.max_retries
        }
    
    def _format_error_context(
        self, sql_query: str, error_message: str, 
        error_code: Optional[str], error_routine: Optional[str],
        error_position: Optional[str], error_hint: Optional[str]
    ) -> str:
        """
        Format error information for feedback to the LLM
        
        Args:
            sql_query: Failed SQL query
            error_message: Error message
            error_code: Database error code
            error_routine: Error routine name
            error_position: Position in the query where the error occurred
            error_hint: Hint provided with the error
            
        Returns:
            str: Formatted error context
        """
        context = "Previous SQL query failed with the following error:\n"
        context += f"- Error message: {error_message}\n"
        
        if error_code:
            context += f"- Error code: {error_code}\n"
        
        if error_routine:
            context += f"- Error routine: {error_routine}\n"
        
        # Add specific guidance based on error type
        if error_code == "42703" or error_routine == "errorMissingColumn":
            context += "This error typically occurs when a column name is not found or not properly quoted.\n"
            context += "Make sure to use double quotes around camelCase column names like \"createdAt\" or \"updatedAt\".\n"
        
        elif error_code == "42P01" or error_routine == "errorMissingFrom":
            context += "This error typically occurs when a table name is not found.\n"
            context += "Make sure to use schema qualification (public.table_name) and check table names for typos.\n"
        
        elif error_code == "42601" or error_routine == "scanner_yyerror":
            context += "This is a syntax error in the SQL query.\n"
            if error_position:
                context += f"The error occurred around position {error_position} in the query.\n"
        
        if error_hint:
            context += f"- Hint from database: {error_hint}\n"
        
        context += f"\nFailed query:\n{sql_query}\n"
        
        return context
    
    def _create_sql_generation_prompt_with_error_feedback(
        self, user_query: str, schema_description: str, error_context: str
    ) -> str:
        """
        Create a prompt for SQL generation with error feedback from previous attempts
        
        Args:
            user_query: Natural language query from the user
            schema_description: Description of the database schema
            error_context: Error information from previous attempts
            
        Returns:
            str: Prompt for the LLM
        """
        product_context = ""
        if hasattr(self.llm_service, 'product_summary') and self.llm_service.product_summary:
            product_context = f"""
Product Context:
{self.llm_service.product_summary}

This product context will help you understand the business domain when generating SQL queries.
"""

        error_feedback = ""
        if error_context:
            error_feedback = f"""
I previously tried to generate a SQL query, but it failed with errors.

{error_context}

Please generate a corrected SQL query that addresses these errors.
"""

        return f"""{product_context}You are an expert SQL query generator. Your task is to convert natural language questions into valid SQL queries.

Database Schema:
{schema_description}

User Question: {user_query}

{error_feedback}

Generate a SQL query that answers this question. The query should be efficient and follow best practices.
Only return the SQL query without any explanations or additional text. The query should be enclosed in ```sql and ``` tags.

Rules to follow:
1. Use table aliases for readability (e.g., ad for appointment_details)
2. Include WHERE is_deleted = false for tables with this column
3. ALWAYS enclose camelCase column names like "createdAt" or "updatedAt" in double quotes
4. For recent/latest data, add ORDER BY for time-based columns in descending order (e.g., ORDER BY ad.appointment_date DESC)
5. For city names, use city_masters table and the city_name column
6. For SQL syntax, always use proper schema qualification (e.g., public.table_name)
7. Ensure there's a space between DESC/ASC and any following keywords in ORDER BY clauses
8. Add semicolon at the end of the query
9. If you get a column not found error for "createdAt", try removing the ORDER BY clause entirely
10. Only use columns that are explicitly mentioned in the schema
11. For service_provider_center_details table, avoid using "createdAt" as it may not exist
"""