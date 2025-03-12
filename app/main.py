import sys
import streamlit as st
import pandas as pd
import json
import os
import datetime
from typing import Dict, List, Any, Optional
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.settings import APP_TITLE, APP_DESCRIPTION, SCHEMA_FILE_PATH
from models.schema_parser import SchemaParser
from services.llm_service import LLMService
from services.sql_service import SQLService
from services.query_executor_service import QueryExecutorService
from utils.helpers import format_query_result, get_chat_history_context, sanitize_input
from utils.logger import QueryLogger

class SQLChatbotApp:
    """
    Main Streamlit application for SQL Chatbot
    """
    
    def __init__(self):
        """Initialize the application"""
        self.setup_page()
        self.initialize_session_state()
        self.initialize_services()
        
    def setup_page(self):
        """Set up the Streamlit page configuration"""
        st.set_page_config(
            page_title=APP_TITLE,
            page_icon="🤖",
            layout="wide"
        )
        
        st.title(APP_TITLE)
        st.markdown(APP_DESCRIPTION)
        
    def initialize_services(self):
        """Initialize the services used by the application"""
        try:
            # Initialize schema parser
            self.schema_parser = SchemaParser(SCHEMA_FILE_PATH)
            self.schema_description = ""
            
            # Check if schema is already loaded in session state
            if st.session_state.schema_content:
                # Write schema content to file
                with open(SCHEMA_FILE_PATH, "w") as f:
                    f.write(st.session_state.schema_content)
                
                # Parse schema from content in session state
                self.schema_parser.parse()
                self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                st.session_state.schema_loaded = True
            # Otherwise check if file exists
            elif os.path.exists(SCHEMA_FILE_PATH):
                self.schema_parser.parse()
                self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                st.session_state.schema_loaded = True
            
            # Initialize LLM service with product summary if available
            self.llm_service = LLMService()
            if st.session_state.product_summary:
                self.llm_service.set_product_summary(st.session_state.product_summary)
            
            # Initialize SQL service
            self.sql_service = SQLService()
            
            # Initialize query executor service
            self.query_executor = QueryExecutorService(
                llm_service=self.llm_service,
                sql_service=self.sql_service
            )
            
            # Initialize query logger
            log_file_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "logs", "query_logs.json")
            self.query_logger = QueryLogger(log_file_path)
            
        except Exception as e:
            st.error(f"Error initializing services: {str(e)}")
    
    def initialize_session_state(self):
        """Initialize Streamlit session state variables"""
        if "chat_history" not in st.session_state:
            st.session_state.chat_history = []
            
        if "schema_loaded" not in st.session_state:
            st.session_state.schema_loaded = os.path.exists(SCHEMA_FILE_PATH)
            
        if "last_query" not in st.session_state:
            st.session_state.last_query = ""
            
        if "last_sql" not in st.session_state:
            st.session_state.last_sql = ""
            
        if "last_result" not in st.session_state:
            st.session_state.last_result = None
            
        if "schema_content" not in st.session_state:
            st.session_state.schema_content = None
            
        if "product_summary" not in st.session_state:
            st.session_state.product_summary = None
    
    def render_chat_history(self):
        """Render the chat history in the UI"""
        for message in st.session_state.chat_history:
            with st.chat_message(message["role"]):
                st.markdown(message["content"])
                
                # Show SQL query if available
                if message["role"] == "assistant" and "sql_query" in message:
                    with st.expander("View SQL Query"):
                        st.code(message["sql_query"], language="sql")
                
                # Show attempts info if available
                if message["role"] == "assistant" and "attempt" in message:
                    with st.expander("Query Execution Details"):
                        st.markdown(f"Generated and executed in {message['attempt']} of {message['max_retries']} attempts.")
                
                # Show result summary if available
                if message["role"] == "assistant" and "result_summary" in message and message["result_summary"]:
                    with st.expander("Result Summary"):
                        st.markdown(message["result_summary"])
                
                # Show query result if available
                if message["role"] == "assistant" and "result_data" in message and message["result_data"] is not None:
                    with st.expander("View Raw Data"):
                        formatted_data = format_query_result(message["result_data"])
                        if not formatted_data.empty:
                            st.dataframe(formatted_data, use_container_width=True)
                        else:
                            st.info("No data available to display.")
    
    def handle_user_input(self):
        """Handle user input and generate responses"""
        user_query = st.chat_input("Ask a question about your data...")
        
        if user_query:
            # Sanitize input
            user_query = sanitize_input(user_query)
            
            # Add user message to chat history
            st.session_state.chat_history.append({
                "role": "user",
                "content": user_query
            })
            
            # Display user message
            with st.chat_message("user"):
                st.markdown(user_query)
            
            # Check if schema is loaded
            if not st.session_state.schema_loaded:
                with st.chat_message("assistant"):
                    st.markdown("Please upload a database schema file or paste schema content first.")
                    
                st.session_state.chat_history.append({
                    "role": "assistant",
                    "content": "Please upload a database schema file or paste schema content first."
                })
                return
            
            # Generate response
            with st.chat_message("assistant"):
                with st.spinner("Thinking..."):
                    # Use the query executor to handle the entire process with retries
                    result = self.query_executor.execute_natural_language_query(
                        user_query, 
                        self.schema_description
                    )
                    
                    sql_query = result.get("sql_query", "")
                    attempt = result.get("attempt", 1)
                    max_retries = result.get("max_retries", 3)
                    
                    # Check if query execution was successful
                    if result.get("status", False):
                        # Generate a summary of the results using LLM
                        result_summary = None
                        if result and result.get("status") and isinstance(result.get("entity"), list) and len(result.get("entity", [])) > 0:
                            result_summary = self.llm_service.generate_result_summary(result.get("entity", []), sql_query)
                            response = result_summary
                        else:
                            response = ""
                        
                        # Show result summary if available
                        if result_summary:
                            with st.expander("Result Summary", expanded=True):
                                st.markdown(result_summary)
                        
                        # Show query result
                        with st.expander("View Result"):
                            # Format and display the data
                            formatted_data = format_query_result(result)
                            if not formatted_data.empty:
                                st.dataframe(formatted_data, use_container_width=True)
                            else:
                                st.info("No data available to display.")
                        
                        # Save to session state
                        st.session_state.last_query = user_query
                        st.session_state.last_sql = sql_query
                        st.session_state.last_result = result
                        
                        # Add to chat history
                        st.session_state.chat_history.append({
                            "role": "assistant",
                            "content": response,
                            "sql_query": sql_query,
                            "result_data": result,
                            "result_summary": result_summary,
                            "attempt": attempt,
                            "max_retries": max_retries
                        })

                        self.query_logger.log_query(user_query, sql_query,llm_response=result,result_summary= result_summary)
                        
                    else:
                        # Query execution failed
                        error_message = result.get("message", "Unknown error")
                        st.error(f"Failed to execute query: {error_message}")
                        
                        st.session_state.chat_history.append({
                            "role": "assistant",
                            "content": f"I encountered an error while trying to execute the SQL query: {error_message}",
                            "sql_query": sql_query,
                            "attempt": attempt,
                            "max_retries": max_retries
                        })
                        
                        # Log the error
                        self.query_logger.log_query(user_query, sql_query, {"status": "error", "error": error_message})
    
    def render_logs_page(self):
        """Render the logs page with query history"""
        st.header("Query Logs")
        
        # Get logs
        logs = self.query_logger.get_logs()
        
        if not logs:
            st.info("No query logs found.")
            return
        
        # Display logs in a table
        log_data = []
        for log in logs:
            timestamp = datetime.datetime.fromisoformat(log["timestamp"]).strftime("%Y-%m-%d %H:%M:%S")
            log_data.append({
                "Timestamp": timestamp,
                "User Query": log["user_query"],
                "Query": log["sql_query"],
                 "LLM Response": log.get("result_summary", "N/A"),
            })
        
        log_df = pd.DataFrame(log_data)
        st.dataframe(log_df)
        
        # Show detailed log view
        st.subheader("Detailed Log View")
        selected_log_index = st.selectbox("Select a log entry to view details:", 
                                         range(len(logs)), 
                                         format_func=lambda i: f"{log_data[i]['Timestamp']} - {log_data[i]['User Query'][:50]}...")
        
        if selected_log_index is not None:
            selected_log = logs[selected_log_index]
            
            st.markdown(f"**Timestamp:** {datetime.datetime.fromisoformat(selected_log['timestamp']).strftime('%Y-%m-%d %H:%M:%S')}")
            st.markdown(f"**User Query:** {selected_log['user_query']}")
            
            with st.expander("SQL Query"):
                st.code(selected_log['sql_query'], language="sql")
            
            if selected_log.get("result_summary"):
                with st.expander("Result Summary"):
                    st.markdown(selected_log["result_summary"])
            if selected_log.get("llm_response"):
                with st.expander("LLM Response"):
                    formatted_data = format_query_result(selected_log["llm_response"])
                    if not formatted_data.empty:
                        st.dataframe(formatted_data, use_container_width=True)
    
    def render_sidebar(self):
        """Render the sidebar with configuration options and navigation"""
        with st.sidebar:
            st.header("Application Navigation")
            page = st.radio("Go to", ["Chat", "Logs"])
            
            st.header("Configuration")
            
            # Schema Configuration Section
            st.subheader("Database Schema")
            schema_tab1, schema_tab2 = st.tabs(["📁 Upload", "📝 Paste"])
            
            with schema_tab1:
                # Schema file upload
                schema_file = st.file_uploader("Upload SQL Schema File", type=["sql"])
                
                if schema_file is not None:
                    if st.button("Load Schema from File"):
                        # Save uploaded file
                        schema_content = schema_file.getvalue().decode("utf-8")
                        with open(SCHEMA_FILE_PATH, "wb") as f:
                            f.write(schema_file.getbuffer())
                        
                        # Store in session state
                        st.session_state.schema_content = schema_content
                        
                        # Reinitialize schema parser
                        self.schema_parser = SchemaParser(SCHEMA_FILE_PATH)
                        self.schema_parser.parse()
                        self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                        
                        st.session_state.schema_loaded = True
                        st.success("Schema file uploaded successfully!")
            
            with schema_tab2:
                # Schema pasting
                pasted_schema = st.text_area("Paste SQL Schema Here", height=150)
                
                if pasted_schema.strip() and st.button("Load Pasted Schema"):
                    # Save pasted schema to file
                    with open(SCHEMA_FILE_PATH, "w") as f:
                        f.write(pasted_schema)
                    
                    # Store in session state
                    st.session_state.schema_content = pasted_schema
                    
                    # Reinitialize schema parser
                    self.schema_parser = SchemaParser(SCHEMA_FILE_PATH)
                    self.schema_parser.parse()
                    self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                    
                    st.session_state.schema_loaded = True
                    st.success("Schema loaded successfully from text input!")
            
            # Product Summary Section
            with st.expander("📋 Product Context", expanded=False):
                st.write("Add product details to enhance query understanding.")
                
                product_summary = st.text_area(
                    "Product Summary", 
                    value=st.session_state.product_summary if st.session_state.product_summary else "",
                    height=150,
                    help="Provide context about the product/database to improve query results"
                )
                
                if product_summary.strip() and st.button("Save Product Summary"):
                    st.session_state.product_summary = product_summary
                    # Update LLM service with the new summary
                    if hasattr(self, 'llm_service'):
                        self.llm_service.set_product_summary(product_summary)
                    st.success("Product summary saved successfully!")
            
            return page
    
    def _create_focused_schema(self, relevant_tables):
        """
        Create a focused schema description with only the relevant tables
        
        Args:
            relevant_tables (set): Set of relevant table names
            
        Returns:
            str: Focused schema description
        """
        schema_parts = ["Database Schema (Focused):\n"]
        
        # Add tables
        for table_name in relevant_tables:
            if table_name in self.schema_parser.tables:
                table_info = self.schema_parser.tables[table_name]
                
                # Add table name
                schema_parts.append(f"Table: {table_name}\nColumns:")
                
                # Add columns
                for col_name, col_info in table_info["columns"].items():
                    pk = " (Primary Key)" if col_info.get("primary_key") else ""
                    nn = " NOT NULL" if col_info.get("not_null") else ""
                    default = f" DEFAULT {col_info['default']}" if col_info.get("default") else ""
                    schema_parts.append(f"  - {col_name}: {col_info['type']}{nn}{default}{pk}")
                
                schema_parts.append("")
        
        # Add relationships between relevant tables
        schema_parts.append("Relationships:")
        for rel in self.schema_parser.relationships:
            if rel["source_table"] in relevant_tables and rel["target_table"] in relevant_tables:
                schema_parts.append(
                    f"  - {rel['source_table']}.{rel['source_column']} -> {rel['target_table']}.{rel['target_column']}"
                )
        
        return "\n".join(schema_parts)
    
    def run(self):
        """Run the Streamlit application"""
        page = self.render_sidebar()
        
        if page == "Chat":
            # Render chat history
            self.render_chat_history()
            
            # Handle user input
            self.handle_user_input()
        elif page == "Logs":
            self.render_logs_page()


if __name__ == "__main__":
    app = SQLChatbotApp()
    app.run()