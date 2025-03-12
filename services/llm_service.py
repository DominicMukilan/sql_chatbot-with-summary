import json
import re
import requests
from typing import Dict, List, Optional, Any, Tuple

from config.settings import OLLAMA_BASE_URL, OLLAMA_MODEL

class LLMService:
    """
    Service to interact with Ollama LLM for generating SQL queries and natural language responses
    """
    
    def __init__(self, model: str = OLLAMA_MODEL):
        """
        Initialize the LLM service
        
        Args:
            model: Name of the Ollama model to use
        """
        self.base_url = OLLAMA_BASE_URL
        # Use the specific model format matching your downloaded model
        self.model = "llama3.3:70b-instruct-q3_K_M"
        self.product_summary = None
        self.max_retries = 3
        
    def set_product_summary(self, summary: str):
        """
        Set the product summary to enhance query context
        
        Args:
            summary: Product context information
        """
        self.product_summary = summary
        
    def generate_sql(self, user_query: str, schema_description: str) -> str:
        """
        Generate SQL query from natural language query
        
        Args:
            user_query: Natural language query from the user
            schema_description: Description of the database schema
            
        Returns:
            str: Generated SQL query
        """
        prompt = self._create_sql_generation_prompt(user_query, schema_description)
        response = self._call_ollama_with_retry(prompt)
        
        # Extract SQL from the response
        sql_query = self._extract_sql_from_response(response)
        
        # Try to fix common SQL errors before returning
        fixed_sql = self._fix_common_sql_errors(sql_query)
        return fixed_sql
        
    def generate_sql_with_custom_prompt(self, custom_prompt: str) -> str:
        """
        Generate SQL query using a custom prompt
        
        Args:
            custom_prompt: Custom prompt including error feedback
            
        Returns:
            str: Generated SQL query
        """
        response = self._call_ollama_with_retry(custom_prompt)
        
        # Extract SQL from the response
        sql_query = self._extract_sql_from_response(response)
        
        # Try to fix common SQL errors before returning
        fixed_sql = self._fix_common_sql_errors(sql_query)
        return fixed_sql
    
    def generate_response(self, user_query: str, sql_query: str, query_result: Any) -> str:
        """
        Generate natural language response from SQL query results
        
        Args:
            user_query: Original natural language query from the user
            sql_query: Generated SQL query
            query_result: Result of executing the SQL query
            
        Returns:
            str: Natural language response explaining the results
        """
        prompt = self._create_response_generation_prompt(user_query, sql_query, query_result)
        response = self._call_ollama_with_retry(prompt)
        return response
    
    def _call_ollama_with_retry(self, prompt: str) -> str:
        """
        Call Ollama API with retry mechanism
        
        Args:
            prompt: Prompt to send to the LLM
            
        Returns:
            str: Generated response
        """
        attempt = 1
        last_error = None
        
        while attempt <= self.max_retries:
            try:
                print(f"Attempt {attempt}/{self.max_retries} to call Ollama API")
                response = self._call_ollama_streaming(prompt)
                return response
                
            except Exception as e:
                last_error = str(e)
                print(f"Attempt {attempt} failed: {last_error}")
                attempt += 1
        
        print(f"All {self.max_retries} attempts failed. Last error: {last_error}")
        return f"Error: Failed to generate response after {self.max_retries} attempts. Last error: {last_error}"
    
    def _call_ollama_streaming(self, prompt: str) -> str:
        """
        Call Ollama API with streaming to avoid timeouts
        
        Args:
            prompt: Prompt to send to the LLM
            
        Returns:
            str: Generated response
        """
        try:
            url = f"{self.base_url}/api/generate"
            payload = {
                "model": self.model,
                "prompt": prompt,
                "stream": True  # Enable streaming
            }
            
            print(f"Calling Ollama API at {url} with model {self.model}")
            
            # Use streaming to avoid timeouts
            response = requests.post(url, json=payload, stream=True, timeout=300)  # 5-minute timeout
            response.raise_for_status()
            
            full_response = ""
            for line in response.iter_lines(decode_unicode=True):
                if line:
                    try:
                        json_response = json.loads(line)
                        chunk = json_response.get('response', '')
                        full_response += chunk
                    except json.JSONDecodeError:
                        continue
            
            return full_response
            
        except requests.exceptions.ConnectionError as e:
            error_msg = f"Connection error to Ollama API: {str(e)}"
            print(error_msg)
            raise Exception(error_msg)
            
        except requests.exceptions.Timeout as e:
            error_msg = f"Request to Ollama API timed out: {str(e)}"
            print(error_msg)
            raise Exception(error_msg)
            
        except Exception as e:
            error_msg = f"Failed to call Ollama API: {str(e)}"
            print(error_msg)
            raise Exception(error_msg)
    
    def _create_sql_generation_prompt(self, user_query: str, schema_description: str) -> str:
        """
        Create a prompt for SQL generation
        
        Args:
            user_query: Natural language query from the user
            schema_description: Description of the database schema
            
        Returns:
            str: Prompt for the LLM
        """
        # Add product context if available
        product_context = ""
        if self.product_summary:
            product_context = f"""
Product Context:
{self.product_summary}

This product context will help you understand the business domain when generating SQL queries.
"""

        return f"""{product_context}You are an expert SQL query generator. Your task is to convert natural language questions into valid SQL queries.

Database Schema:
{schema_description}

User Question: {user_query}

Generate a SQL query that answers this question. The query should be efficient and follow best practices.
Only return the SQL query without any explanations or additional text. The query should be enclosed in ```sql and ``` tags.

Rules to follow:
1. Use table aliases for readability (e.g., ad for appointment_details)
2. Include WHERE is_deleted = false for tables with this column
3. Enclose camelCase column names like "createdAt" or "updatedAt" in double quotes
4. For recent/latest data, add ORDER BY for time-based columns in descending order (e.g., ORDER BY ad.appointment_date DESC)
5. For city names, use city_masters table and the city_name column
6. IMPORTANT: Always use double quotes around camelCase column names, especially in ORDER BY clauses
"""
    
    def _create_response_generation_prompt(self, user_query: str, sql_query: str, query_result: Any) -> str:
        """
        Create a prompt for generating a natural language response
        
        Args:
            user_query: Original natural language query from the user
            sql_query: Generated SQL query
            query_result: Result of executing the SQL query
            
        Returns:
            str: Prompt for the LLM
        """
        # Convert query_result to a string representation
        if isinstance(query_result, list) or isinstance(query_result, dict):
            result_str = json.dumps(query_result, indent=2)
        else:
            result_str = str(query_result)
            
        return f"""You are an expert data analyst. Your task is to explain the results of a SQL query in natural language.

        User Question: {user_query}
        
        SQL Query Used:
        ```sql
        {sql_query}
        ```"""

    def _extract_sql_from_response(self, response: str) -> str:
        """
        Extract SQL query from LLM response that's wrapped in SQL code block markers

        Args:
            response: Raw response from the LLM

        Returns:
            str: Extracted SQL query
        """
        # Look for SQL between ```sql and ``` markers
        start_marker = "```sql"
        end_marker = "```"

        try:
            # Find the start of SQL code block
            start_idx = response.find(start_marker)
            if start_idx == -1:
                # If no start marker found, try looking for just ``` without sql
                start_marker = "```"
                start_idx = response.find(start_marker)

            if start_idx == -1:
                # If still no markers found, return the response as is
                return response.strip()

            # Move past the start marker
            start_idx += len(start_marker)

            # Find the end of SQL code block
            end_idx = response.find(end_marker, start_idx)
            if end_idx == -1:
                # If no end marker, take the rest of the response
                return response[start_idx:].strip()

            # Extract and clean the SQL query
            sql_query = response[start_idx:end_idx].strip()
            return sql_query

        except Exception as e:
            raise Exception(f"Failed to extract SQL from response: {str(e)}")
            
    def _fix_common_sql_errors(self, sql_query: str) -> str:
        """
        Fix common SQL errors, especially with camelCase column names
        
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
        if "city_masters" in fixed_query and "public.city_masters" not in fixed_query:
            fixed_query = fixed_query.replace("city_masters", "public.city_masters")
            
        # Fix potential comma issues in SELECT
        fixed_query = re.sub(r',\s*FROM', r' FROM', fixed_query)
        
        # Add missing semicolon at the end if needed
        if not fixed_query.strip().endswith(';'):
            fixed_query = fixed_query.strip() + ';'
            
        return fixed_query

    def generate_result_summary(self, result_data, sql_query):
        """
        Generate a summary of the query results
        
        Args:
            result_data: List of result dictionaries
            sql_query: SQL query used
            
        Returns:
            str: Summary of the results
        """
        try:
            # Convert result data to a string representation
            result_str = json.dumps(result_data[:10], indent=2)  # Limit to first 10 records to avoid token limits
            
            # Add product context if available
            product_context = ""
            if self.product_summary:
                product_context = f"""
This data is from a product with the following context:
{self.product_summary}

Use this context to make your summary more relevant to the business domain.
"""
            
            # Create prompt for summarizing the results
            prompt = f"""
            Analyze the following query results and provide a concise summary:
            
            {result_str}
            The query that was used to get the result : {sql_query}
            {product_context}
            
            You are an AI assistant that **formats SQL query results** in a structured, professional format.

## **Your Task:**
- **Analyze the query results** and determine the type of data.
- **Start with a dynamic one-line introduction** (e.g., `"Below are the cities:"`, `"Here is the list of appointments:"`).
- **Format the response as a numbered list, one per line**, like:
- **No extra explanations, no additional text—just the intro sentence and the structured list.**
- **Ensure clarity and professional readability.**



- **Do not include unnecessary explanations, only the structured output.**
            """

            # Generate summary using the LLM
            summary = self._call_ollama_with_retry(prompt)
            
            return summary
            
        except Exception as e:
            print(f"Error generating result summary: {str(e)}")
            return "Unable to generate summary of the results."