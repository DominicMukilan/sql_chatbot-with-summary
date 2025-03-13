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
# Import our new SchemaManager
from schema_manager import SchemaManager  # Make sure this file is in the correct location

class SQLChatbotApp:
    """
    Main Streamlit application for SQL Chatbot
    """
    
    def __init__(self):
        """Initialize the application"""
        # Set up the schema manager first
        schemas_directory = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "schemas")
        self.schema_manager = SchemaManager(schemas_directory)
        
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
            # Initialize schema parser with the active schema if available
            if st.session_state.active_schema_id:
                schema_filepath = self.schema_manager.get_schema_filepath(st.session_state.active_schema_id)
                self.schema_parser = SchemaParser(schema_filepath)
                self.schema_parser.parse()
                self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                st.session_state.schema_loaded = True
            else:
                self.schema_parser = SchemaParser(SCHEMA_FILE_PATH)
                self.schema_description = ""
                
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
            st.session_state.schema_loaded = False
            
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
            
        # New session state variables for schema management
        if "active_schema_id" not in st.session_state:
            st.session_state.active_schema_id = None
    
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
                    st.markdown("Please select, upload, or paste a database schema first.")
                    
                st.session_state.chat_history.append({
                    "role": "assistant",
                    "content": "Please select, upload, or paste a database schema first."
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

                        self.query_logger.log_query(user_query, sql_query, llm_response=result, result_summary=result_summary)
                        
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
                        
    def render_schema_selector(self, sidebar=False):
        """Render the grid of saved schemas for selection
        
        Args:
            sidebar (bool): Whether this is being rendered in the sidebar
        """
        st.subheader("Saved Schemas")
        
        # Get all saved schemas
        schemas = self.schema_manager.get_all_schemas()
        
        if not schemas:
            st.info("No saved schemas found. Upload a new schema to get started.")
            return
        
        # If in sidebar, don't use columns (not supported in sidebar)
        if sidebar:
            for schema in schemas:
                schema_name = schema.get("name", "Unnamed Schema")
                schema_date = datetime.datetime.fromisoformat(schema.get("created_at", "")).strftime("%Y-%m-%d")
                
                # Create a container for each schema
                with st.container():
                    # If this is the active schema, highlight it
                    if st.session_state.active_schema_id == schema["id"]:
                        button_label = f"📌 {schema_name}"
                    else:
                        button_label = schema_name
                    
                    # Create a horizontal layout with the button and delete option
                    st.markdown(f"<div style='display: flex; align-items: center;'>", unsafe_allow_html=True)
                    
                    # Selection button
                    if st.button(button_label, key=f"schema_{schema['id']}"):
                        # Load the selected schema
                        schema_filepath = self.schema_manager.get_schema_filepath(schema["id"])
                        schema_content = self.schema_manager.get_schema_content(schema["id"])
                        
                        # Update session state
                        st.session_state.active_schema_id = schema["id"]
                        st.session_state.schema_content = schema_content
                        
                        # Update schema parser
                        self.schema_parser = SchemaParser(schema_filepath)
                        self.schema_parser.parse()
                        self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                        
                        st.session_state.schema_loaded = True
                        
                        # Update last used timestamp
                        self.schema_manager.update_last_used(schema["id"])
                        
                        # Rerun to refresh the UI
                        st.rerun()
                    
                    # Delete button (separate)
                    delete_button = st.button("❌", key=f"delete_{schema['id']}", help=f"Delete schema: {schema_name}")
                    
                    st.markdown("</div>", unsafe_allow_html=True)
                    
                    # Handle delete action
                    if delete_button:
                        # Confirm deletion
                        if st.session_state.get(f"confirm_delete_{schema['id']}", False):
                            # Delete the schema
                            success = self.schema_manager.delete_schema(schema["id"])
                            
                            if success:
                                # If the deleted schema was the active one, reset active schema
                                if st.session_state.active_schema_id == schema["id"]:
                                    st.session_state.active_schema_id = None
                                    st.session_state.schema_loaded = False
                                
                                # Clear confirmation state
                                if f"confirm_delete_{schema['id']}" in st.session_state:
                                    del st.session_state[f"confirm_delete_{schema['id']}"]
                                
                                # Rerun to refresh the UI
                                st.rerun()
                        else:
                            # Set confirmation state
                            st.session_state[f"confirm_delete_{schema['id']}"] = True
                            # Force rerun to show confirmation
                            st.rerun()
                    
                    # Show confirmation prompt if needed
                    if st.session_state.get(f"confirm_delete_{schema['id']}", False):
                        st.warning(f"Are you sure you want to delete '{schema_name}'?")
                        
                        if st.button("Yes, delete", key=f"confirm_{schema['id']}"):
                            # Delete the schema
                            success = self.schema_manager.delete_schema(schema["id"])
                            
                            if success:
                                # If the deleted schema was the active one, reset active schema
                                if st.session_state.active_schema_id == schema["id"]:
                                    st.session_state.active_schema_id = None
                                    st.session_state.schema_loaded = False
                                
                                # Clear confirmation state
                                if f"confirm_delete_{schema['id']}" in st.session_state:
                                    del st.session_state[f"confirm_delete_{schema['id']}"]
                                
                                # Rerun to refresh the UI
                                st.rerun()
                        
                        if st.button("Cancel", key=f"cancel_{schema['id']}"):
                            # Clear confirmation state
                            if f"confirm_delete_{schema['id']}" in st.session_state:
                                del st.session_state[f"confirm_delete_{schema['id']}"]
                            
                            # Rerun to refresh the UI
                            st.rerun()
                    
                    # Show metadata
                    st.caption(f"Created: {schema_date}")
                    if schema.get("description"):
                        st.caption(f"Description: {schema.get('description')[:50]}...")
                    
                    # Add a separator
                    st.markdown("---")
        else:
            # Display schemas in a grid of buttons (3 columns) - for main area
            cols = st.columns(3)
            
            for i, schema in enumerate(schemas):
                col_idx = i % 3
                
                with cols[col_idx]:
                    schema_name = schema.get("name", "Unnamed Schema")
                    schema_date = datetime.datetime.fromisoformat(schema.get("created_at", "")).strftime("%Y-%m-%d")
                    
                    # Create a container for each schema button for styling
                    with st.container():
                        # Create a row for the schema button and delete button
                        button_col, delete_col = st.columns([5, 1])
                        
                        with button_col:
                            # If this is the active schema, highlight it
                            if st.session_state.active_schema_id == schema["id"]:
                                button_label = f"📌 {schema_name}"
                            else:
                                button_label = schema_name
                            
                            if st.button(button_label, key=f"schema_{schema['id']}"):
                                # Load the selected schema
                                schema_filepath = self.schema_manager.get_schema_filepath(schema["id"])
                                schema_content = self.schema_manager.get_schema_content(schema["id"])
                                
                                # Update session state
                                st.session_state.active_schema_id = schema["id"]
                                st.session_state.schema_content = schema_content
                                
                                # Update schema parser
                                self.schema_parser = SchemaParser(schema_filepath)
                                self.schema_parser.parse()
                                self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                                
                                st.session_state.schema_loaded = True
                                
                                # Update last used timestamp
                                self.schema_manager.update_last_used(schema["id"])
                                
                                # Rerun to refresh the UI
                                st.rerun()
                        
                        with delete_col:
                            # Red X button for deletion
                            if st.button("❌", key=f"delete_{schema['id']}", help=f"Delete schema: {schema_name}"):
                                # Confirm deletion
                                if st.session_state.get(f"confirm_delete_{schema['id']}", False):
                                    # Delete the schema
                                    success = self.schema_manager.delete_schema(schema["id"])
                                    
                                    if success:
                                        # If the deleted schema was the active one, reset active schema
                                        if st.session_state.active_schema_id == schema["id"]:
                                            st.session_state.active_schema_id = None
                                            st.session_state.schema_loaded = False
                                        
                                        # Clear confirmation state
                                        if f"confirm_delete_{schema['id']}" in st.session_state:
                                            del st.session_state[f"confirm_delete_{schema['id']}"]
                                        
                                        # Rerun to refresh the UI
                                        st.rerun()
                                else:
                                    # Set confirmation state
                                    st.session_state[f"confirm_delete_{schema['id']}"] = True
                                    # Force rerun to show confirmation
                                    st.rerun()
                        
                        # Show confirmation prompt if needed
                        if st.session_state.get(f"confirm_delete_{schema['id']}", False):
                            st.warning(f"Are you sure you want to delete '{schema_name}'?")
                            
                            confirm_col, cancel_col = st.columns(2)
                            with confirm_col:
                                if st.button("Yes, delete", key=f"confirm_{schema['id']}"):
                                    # Delete the schema
                                    success = self.schema_manager.delete_schema(schema["id"])
                                    
                                    if success:
                                        # If the deleted schema was the active one, reset active schema
                                        if st.session_state.active_schema_id == schema["id"]:
                                            st.session_state.active_schema_id = None
                                            st.session_state.schema_loaded = False
                                        
                                        # Clear confirmation state
                                        if f"confirm_delete_{schema['id']}" in st.session_state:
                                            del st.session_state[f"confirm_delete_{schema['id']}"]
                                        
                                        # Rerun to refresh the UI
                                        st.rerun()
                            
                            with cancel_col:
                                if st.button("Cancel", key=f"cancel_{schema['id']}"):
                                    # Clear confirmation state
                                    if f"confirm_delete_{schema['id']}" in st.session_state:
                                        del st.session_state[f"confirm_delete_{schema['id']}"]
                                    
                                    # Rerun to refresh the UI
                                    st.rerun()
                        
                        # Show metadata
                        st.caption(f"Created: {schema_date}")
                        if schema.get("description"):
                            st.caption(f"Description: {schema.get('description')[:50]}...")
    
    def render_schema_management(self):
        """Render the schema management section"""
        # Display the schema selector grid (already includes delete functionality)
        self.render_schema_selector()
    
    def render_sidebar(self):
        """Render the sidebar with configuration options and navigation"""
        with st.sidebar:
            st.header("Application Navigation")
            page = st.radio("Go to", ["Chat", "Logs"])
            
            st.header("Configuration")
            
            # Schema Configuration Section
            st.subheader("Database Schema")
            
            # Show current active schema if any
            if st.session_state.active_schema_id:
                schema_metadata = self.schema_manager.get_schema_metadata(st.session_state.active_schema_id)
                if schema_metadata:
                    st.success(f"Active Schema: {schema_metadata.get('name', 'Unnamed Schema')}")
            
            schema_tab1, schema_tab2, schema_tab3 = st.tabs(["📚 Select", "📁 Upload", "📝 Paste"])
            
            with schema_tab1:
                # Render saved schemas for selection with sidebar mode
                self.render_schema_selector(sidebar=True)
            
            with schema_tab2:
                # Schema file upload
                schema_file = st.file_uploader("Upload SQL Schema File", type=["sql"])
                
                if schema_file is not None:
                    # Add fields for schema name and description
                    schema_name = st.text_input("Schema Name", value=schema_file.name)
                    schema_description = st.text_area("Schema Description (Optional)", 
                                                    placeholder="Enter a description to help identify this schema later")
                    
                    if st.button("Save Schema"):
                        # Read file content
                        schema_content = schema_file.getvalue().decode("utf-8")
                        
                        # Save to schema manager
                        schema_id = self.schema_manager.save_schema(
                            schema_content=schema_content,
                            schema_name=schema_name,
                            original_filename=schema_file.name,
                            description=schema_description
                        )
                        
                        # Set as active schema
                        st.session_state.active_schema_id = schema_id
                        st.session_state.schema_content = schema_content
                        
                        # Update schema parser
                        schema_filepath = self.schema_manager.get_schema_filepath(schema_id)
                        self.schema_parser = SchemaParser(schema_filepath)
                        self.schema_parser.parse()
                        self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                        
                        st.session_state.schema_loaded = True
                        st.success(f"Schema '{schema_name}' saved and activated!")
                        
                        # Rerun to refresh the UI
                        st.rerun()

            with schema_tab3:
                # Schema pasting
                pasted_schema = st.text_area("Paste SQL Schema Here", height=150)
                
                if pasted_schema.strip():
                    # Add fields for schema name and description
                    schema_name = st.text_input("Schema Name", value="Pasted Schema")
                    schema_description = st.text_area("Schema Description (Optional)", 
                                                    placeholder="Enter a description to help identify this schema later")
                    
                    if st.button("Save Pasted Schema"):
                        # Save to schema manager
                        schema_id = self.schema_manager.save_schema(
                            schema_content=pasted_schema,
                            schema_name=schema_name,
                            description=schema_description
                        )
                        
                        # Set as active schema
                        st.session_state.active_schema_id = schema_id
                        st.session_state.schema_content = pasted_schema
                        
                        # Update schema parser
                        schema_filepath = self.schema_manager.get_schema_filepath(schema_id)
                        self.schema_parser = SchemaParser(schema_filepath)
                        self.schema_parser.parse()
                        self.schema_description = self.schema_parser.get_schema_description(include_samples=True)
                        
                        st.session_state.schema_loaded = True
                        st.success(f"Schema '{schema_name}' saved and activated!")
                        
                        # Rerun to refresh the UI
                        st.rerun()
            
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