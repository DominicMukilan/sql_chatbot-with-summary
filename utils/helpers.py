import json
from typing import Dict, List, Any, Optional
import pandas as pd

def format_query_result(result):
    """
    Format query result for display in Streamlit
    
    Args:
        result: Query result from SQL service
        
    Returns:
        pandas.DataFrame: Formatted result for display
    """
    import pandas as pd
    
    # Check if result is None or empty
    if not result:
        return pd.DataFrame()
    
    # Check if result has entity field and it's a list
    if "entity" in result and isinstance(result["entity"], list):
        data = result["entity"]
        if data:
            return pd.DataFrame(data)
    
    # If we have a status field but no proper entity data
    if "status" in result and result["status"] and "raw_response" in result:
        if "entity" in result["raw_response"] and isinstance(result["raw_response"]["entity"], list):
            return pd.DataFrame(result["raw_response"]["entity"])
    
    # If we couldn't extract data in the expected format, try to create a DataFrame from the entire result
    try:
        return pd.DataFrame([result])
    except:
        # If all else fails, return empty DataFrame
        return pd.DataFrame()

def get_chat_history_context(history: List[Dict[str, str]], max_messages: int = 5) -> str:
    """
    Format chat history as context for the LLM
    
    Args:
        history: List of chat messages
        max_messages: Maximum number of messages to include
        
    Returns:
        str: Formatted chat history
    """
    # Get the last N messages
    recent_messages = history[-max_messages:] if len(history) > max_messages else history
    
    context = "Previous conversation:\n"
    for msg in recent_messages:
        role = "User" if msg["role"] == "user" else "Assistant"
        context += f"{role}: {msg['content']}\n"
    
    return context

def sanitize_input(text: str) -> str:
    """
    Sanitize user input to prevent injection attacks
    
    Args:
        text: User input text
        
    Returns:
        str: Sanitized text
    """
    # Remove any potentially harmful characters
    sanitized = text.replace("<", "&lt;").replace(">", "&gt;")
    return sanitized