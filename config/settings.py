import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Ollama settings
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3")

# API settings for SQL execution
SQL_API_URL = os.getenv("SQL_API_URL", "https://bms.mapskil.com/api/v1/ai/execute")
SQL_API_KEY = os.getenv("SQL_API_KEY", "")

# Schema settings
SCHEMA_FILE_PATH = os.getenv("SCHEMA_FILE_PATH", "schema.sql")

# App settings
APP_TITLE = "SQL Query Assistant"
APP_DESCRIPTION = "Convert natural language to SQL queries and get insights from your database."

# Logging directory
LOG_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "logs")
if not os.path.exists(LOG_DIR):
    os.makedirs(LOG_DIR)
LOG_FILE_PATH = os.path.join(LOG_DIR, "query_logs.json")