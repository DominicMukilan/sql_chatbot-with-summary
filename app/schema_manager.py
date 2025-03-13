import os
import json
import datetime

class SchemaManager:
    """
    Manages the storage and retrieval of database schemas
    """
    
    def __init__(self, schemas_directory):
        """Initialize the schema manager
        
        Args:
            schemas_directory (str): Path to the directory where schemas are stored
        """
        self.schemas_directory = schemas_directory
        self.schemas_index_file = os.path.join(schemas_directory, "schemas_index.json")
        self.schemas_index = self._load_schemas_index()
        
        # Ensure the schemas directory exists
        os.makedirs(self.schemas_directory, exist_ok=True)
        
    def _load_schemas_index(self):
        """Load the schemas index from file
        
        Returns:
            dict: Dictionary of schema metadata
        """
        if os.path.exists(self.schemas_index_file):
            try:
                with open(self.schemas_index_file, 'r') as f:
                    return json.load(f)
            except json.JSONDecodeError:
                return {"schemas": []}
        else:
            return {"schemas": []}
    
    def _save_schemas_index(self):
        """Save the schemas index to file"""
        with open(self.schemas_index_file, 'w') as f:
            json.dump(self.schemas_index, f, indent=2)
    
    def save_schema(self, schema_content, schema_name, original_filename=None, description=None):
        """Save a schema to the storage
        
        Args:
            schema_content (str): SQL schema content
            schema_name (str): User-provided name for the schema
            original_filename (str, optional): Original filename if uploaded
            description (str, optional): Optional description of the schema
            
        Returns:
            str: Schema ID
        """
        # Generate a unique ID for the schema
        schema_id = f"schema_{datetime.datetime.now().strftime('%Y%m%d%H%M%S')}"
        
        # Create schema metadata
        schema_metadata = {
            "id": schema_id,
            "name": schema_name,
            "original_filename": original_filename,
            "description": description,
            "created_at": datetime.datetime.now().isoformat(),
            "last_used_at": datetime.datetime.now().isoformat()
        }
        
        # Save schema content to file
        schema_filepath = os.path.join(self.schemas_directory, f"{schema_id}.sql")
        with open(schema_filepath, 'w') as f:
            f.write(schema_content)
        
        # Update index
        self.schemas_index["schemas"].append(schema_metadata)
        self._save_schemas_index()
        
        return schema_id
    
    def get_schema_content(self, schema_id):
        """Get the content of a schema by ID
        
        Args:
            schema_id (str): Schema ID
            
        Returns:
            str: Schema content or None if not found
        """
        schema_filepath = os.path.join(self.schemas_directory, f"{schema_id}.sql")
        if os.path.exists(schema_filepath):
            with open(schema_filepath, 'r') as f:
                return f.read()
        return None
    
    def get_schema_filepath(self, schema_id):
        """Get the filepath of a schema by ID
        
        Args:
            schema_id (str): Schema ID
            
        Returns:
            str: Schema filepath
        """
        return os.path.join(self.schemas_directory, f"{schema_id}.sql")
    
    def get_all_schemas(self):
        """Get all schema metadata
        
        Returns:
            list: List of schema metadata dictionaries
        """
        return sorted(self.schemas_index["schemas"], 
                     key=lambda x: x.get("last_used_at", ""), 
                     reverse=True)
    
    def get_schema_metadata(self, schema_id):
        """Get metadata for a specific schema
        
        Args:
            schema_id (str): Schema ID
            
        Returns:
            dict: Schema metadata or None if not found
        """
        for schema in self.schemas_index["schemas"]:
            if schema["id"] == schema_id:
                return schema
        return None
    
    def update_last_used(self, schema_id):
        """Update the last used timestamp for a schema
        
        Args:
            schema_id (str): Schema ID
        """
        for schema in self.schemas_index["schemas"]:
            if schema["id"] == schema_id:
                schema["last_used_at"] = datetime.datetime.now().isoformat()
                self._save_schemas_index()
                break
    
    def delete_schema(self, schema_id):
        """Delete a schema
        
        Args:
            schema_id (str): Schema ID
            
        Returns:
            bool: True if successfully deleted, False otherwise
        """
        # Remove from index
        self.schemas_index["schemas"] = [s for s in self.schemas_index["schemas"] if s["id"] != schema_id]
        self._save_schemas_index()
        
        # Delete the file
        schema_filepath = os.path.join(self.schemas_directory, f"{schema_id}.sql")
        if os.path.exists(schema_filepath):
            os.remove(schema_filepath)
            return True
        return False