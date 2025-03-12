import os
import json
import datetime
from typing import Dict, Any, List

class QueryLogger:
    """
    Logger for SQL chatbot queries and responses
    """
    
    def __init__(self, log_file_path: str):
        """
        Initialize the query logger
        
        Args:
            log_file_path: Path to the log file
        """
        self.log_file_path = log_file_path
        self.logs = []
        self._load_logs()
        
    def _load_logs(self):
        """Load existing logs from file if it exists"""
        if os.path.exists(self.log_file_path):
            try:
                with open(self.log_file_path, 'r') as f:
                    self.logs = json.load(f)
            except (json.JSONDecodeError, FileNotFoundError):
                self.logs = []
        
    def log_query(self, user_query: str, sql_query: str,llm_response: str, result_summary: Dict[str, Any] = None) -> None:
        """
        Log a query and its result
        
        Args:
            user_query: The natural language query from the user
            sql_query: The generated SQL query
            result_summary: Summary of the query result (optional)
        """
        
        # Get current UTC time
        utc_now = datetime.datetime.utcnow()

        # Convert to IST (UTC+5:30)
        ist_now = utc_now + datetime.timedelta(hours=5, minutes=30)
        timestamp_ist = ist_now.isoformat()

        log_entry = {
            "timestamp": timestamp_ist,
            "user_query": user_query,
            "sql_query": sql_query,
            "llm_response":llm_response,
            "result_summary": result_summary
        }
        
        self.logs.append(log_entry)
        self._save_logs()
        
    def _save_logs(self):
        """Save logs to file"""
        os.makedirs(os.path.dirname(self.log_file_path), exist_ok=True)
        with open(self.log_file_path, 'w') as f:
            json.dump(self.logs, f, indent=2)
            
    def get_logs(self, limit: int = None) -> List[Dict[str, Any]]:
        """
        Get the most recent logs
        
        Args:
            limit: Maximum number of logs to return (None for all)
            
        Returns:
            List of log entries
        """
        if limit is None:
            return self.logs
        return self.logs[-limit:]
    
    def get_log_file_path(self) -> str:
        """
        Get the path to the log file
        
        Returns:
            Path to the log file
        """
        return self.log_file_path