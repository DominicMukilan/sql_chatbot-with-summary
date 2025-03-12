import re
from typing import Dict, List, Any, Optional


class SchemaParser:
    """
    Parses a PostgreSQL SQL schema file to extract table, column, ENUM, and relationship information.
    """

    def __init__(self, schema_file_path: str = None, schema_content: str = None):
        """
        Initialize the schema parser with the path to the schema file or schema content
        
        Args:
            schema_file_path (str, optional): Path to the SQL schema file
            schema_content (str, optional): Direct SQL schema content as string
        """
        self.schema_file_path = schema_file_path
        self.schema_content = schema_content
        self.tables = {}
        self.enums = {}
        self.relationships = []
        
        # Table keyword mappings for easier identification
        self.table_keywords = {
            'appointment_details': {'appointment', 'appointments', 'booking', 'bookings', 'recent', 'latest', 'scheduled'},
            'city_masters': {'city', 'cities', 'location', 'place', 'chennai', 'bangalore', 'mumbai', 'delhi', 'hyderabad', 'coimbatore'},
            'scan_masters': {'scan', 'scans', 'test', 'tests', 'mri', 'ct', 'ultrasound', 'xray', 'x-ray'},
            'users': {'user', 'users', 'patient', 'patients', 'customer', 'customers', 'client', 'clients'},
            'payment_details': {'payment', 'payments', 'transaction', 'transactions', 'price', 'cost', 'bill', 'billing', 'invoice'},
            'service_provider_center_details': {'center', 'centres', 'clinic', 'hospital', 'lab', 'laboratory', 'diagnostic', 'provider', 'facility'},
            'doctor_details': {'doctor', 'doctors', 'physician', 'specialist', 'medical', 'professional', 'practitioner'}
        }
        
        # Core tables that should be included when related tables are used
        self.core_tables = {
            'appointment_details': {'scan_masters', 'city_masters', 'users'},
            'service_provider_center_details': {'city_masters'},
            'payment_details': {'appointment_details', 'appointment_payments'}
        }
        

    def parse(self) -> Dict[str, Any]:
        """
        Parse the schema file or content and extract table, column, ENUM, and relationship information.

        Returns:
            Dict[str, Any]: Parsed schema structure.
        """
        try:
            # First try to get schema content from directly provided content
            schema_sql = self.schema_content
            
            # If not available, read from file
            if not schema_sql and self.schema_file_path:
                with open(self.schema_file_path, 'r', encoding='utf-8') as f:
                    schema_sql = f.read()
                    # Store for future reference
                    self.schema_content = schema_sql

            if not schema_sql:
                raise ValueError("No schema content available. Provide either schema_file_path or schema_content.")

            self._parse_enums(schema_sql)
            self._parse_tables(schema_sql)
            self._extract_relationships(schema_sql)

            return {
                "tables": self.tables,
                "enums": self.enums,
                "relationships": self.relationships,
            }
        except Exception as e:
            raise RuntimeError(f"Failed to parse schema: {e}")

    def _parse_enums(self, schema_sql: str) -> None:
        """
        Extract ENUM type definitions from the schema.

        Args:
            schema_sql (str): SQL schema content.
        """
        enum_pattern = r"CREATE TYPE public\.(\w+) AS ENUM \((.*?)\);"
        matches = re.finditer(enum_pattern, schema_sql, re.DOTALL)

        for match in matches:
            enum_name, values_str = match.groups()
            values = re.findall(r"'([^']*)'", values_str)
            self.enums[enum_name] = values

    def _parse_tables(self, schema_sql: str) -> None:
        """
        Extract table definitions and columns from the schema.

        Args:
            schema_sql (str): SQL schema content.
        """
        table_pattern = r"CREATE TABLE public\.\"?(\w+)\"? \(\s*([\s\S]*?)\);"
        matches = re.finditer(table_pattern, schema_sql, re.DOTALL)

        for match in matches:
            table_name, columns_block = match.groups()
            self.tables[table_name] = {"name": table_name, "columns": {}}
            self._parse_columns(table_name, columns_block)

    def _parse_columns(self, table_name: str, columns_block: str) -> None:
        """
        Extract column definitions from a table.

        Args:
            table_name (str): The name of the table.
            columns_block (str): The column definitions within a CREATE TABLE statement.
        """
        for line in columns_block.split('\n'):
            line = line.strip()
            if not line or line.startswith('--') or "CONSTRAINT" in line:
                continue

            column_match = re.match(r'"?(\w+)"?\s+([\w\s\(\)]+)', line)
            if column_match:
                column_name, column_type = column_match.groups()
                column_info = {
                    "type": column_type.strip(),
                    "not_null": "NOT NULL" in line,
                    "primary_key": "PRIMARY KEY" in line,
                    "default": self._extract_default(line),
                }
                self.tables[table_name]["columns"][column_name] = column_info

    @staticmethod
    def _extract_default(line: str) -> Any:
        """
        Extract default values from a column definition.

        Args:
            line (str): Column definition line.

        Returns:
            Any: Default value if present, else None.
        """
        match = re.search(r"DEFAULT\s+(.*?)(?:,|$)", line)
        return match.group(1) if match else None

    def _extract_relationships(self, schema_sql: str) -> None:
        """
        Extract foreign key relationships from the schema.

        Args:
            schema_sql (str): SQL schema content.
        """
        fk_pattern = (
            r"ALTER TABLE ONLY public\.(\w+) "
            r"ADD CONSTRAINT \w+ FOREIGN KEY \((\w+)\) REFERENCES public\.(\w+)\((\w+)\)"
        )
        matches = re.finditer(fk_pattern, schema_sql)

        for match in matches:
            self.relationships.append({
                "source_table": match.group(1),
                "source_column": match.group(2),
                "target_table": match.group(3),
                "target_column": match.group(4),
            })

    def get_schema_description(self, include_samples=False) -> str:
        """
        Generate a human-readable summary of the parsed schema.
        
        Args:
            include_samples (bool): Whether to include sample queries in the description.
    
        Returns:
            str: Formatted schema description.
        """
        description = ["Database Schema:\n"]
    
        if self.enums:
            description.append("ENUM Types:")
            for enum_name, values in self.enums.items():
                description.append(f"- {enum_name}: {', '.join(values)}")
            description.append("")
    
        for table_name, table_info in self.tables.items():
            description.append(f"Table: {table_name}\nColumns:")
            for col_name, col_info in table_info["columns"].items():
                pk = " (Primary Key)" if col_info["primary_key"] else ""
                nn = " NOT NULL" if col_info["not_null"] else ""
                default = f" DEFAULT {col_info['default']}" if col_info["default"] else ""
                description.append(f"  - {col_name}: {col_info['type']}{nn}{default}{pk}")
            description.append("")
    
        if self.relationships:
            description.append("Relationships:")
            for rel in self.relationships:
                description.append(
                    f"  - {rel['source_table']}.{rel['source_column']} -> {rel['target_table']}.{rel['target_column']}"
                )
            description.append("")
        
        # Add sample queries if requested
        if include_samples and 'appointment_details' in self.tables:
            description.append("Sample Queries:")
            description.append("1. Basic appointment query:")
            description.append("""
    SELECT ad.id, ad.appointment_date, cm.city_name, ad.scan_name, ad.test_name, 
           spcd.center_name, ad.amount, ad.appointment_status 
    FROM appointment_details ad
    JOIN city_masters cm ON ad.city_id = cm.id AND cm.is_deleted = false
    JOIN service_provider_center_details spcd ON ad.center_id = spcd.id AND spcd.is_deleted = false
    WHERE ad.is_deleted = false
    ORDER BY ad.id
    LIMIT 10 OFFSET 0;
            """)
            
            description.append("2. Detailed appointment query with user information:")
            description.append("""
    SELECT ad.id, ad.user_id, ad.appointment_date, ad.scan_name, ad.scan_category, 
           ad.test_name, ad.test_category, cm.city_name, ad.center_id, 
           spcd.center_name, ad.amount, ad.appointment_status 
    FROM appointment_details ad
    JOIN city_masters cm ON ad.city_id = cm.id
    JOIN service_provider_center_details spcd ON ad.center_id = spcd.id
    WHERE ad.is_deleted = false AND cm.is_deleted = false AND spcd.is_deleted = false
    ORDER BY ad.id
    LIMIT 10 OFFSET 0;
            """)
            
            description.append("3. Query with payment information:")
            description.append("""
    SELECT ad.id, ad.appointment_date, cm.city_name, ad.scan_name, 
           spcd.center_name, ad.amount, pd.payment_status, pd.payment_method
    FROM appointment_details ad
    JOIN city_masters cm ON ad.city_id = cm.id
    JOIN service_provider_center_details spcd ON ad.center_id = spcd.id
    LEFT JOIN payment_details pd ON ad.id = pd.appointment_id
    WHERE ad.is_deleted = false
    ORDER BY ad.id
    LIMIT 10;
            """)

        return "\n".join(description)

    def identify_relevant_tables(self, query: str) -> set:
        """
        Identify relevant tables based on a natural language query.
    
        Args:
            query (str): Natural language query.
    
        Returns:
            set: Set of relevant table names.
        """
        query = query.lower()
        relevant_tables = set()
        
        # Common table patterns for appointment queries
        appointment_patterns = [
            'appointment', 'appointments', 'booking', 'schedule', 'recent', 
            'upcoming', 'past', 'scan', 'test', 'payment'
        ]
        
        # Check if query is about appointments
        is_appointment_query = any(pattern in query for pattern in appointment_patterns)
        
        if is_appointment_query:
            # For appointment queries, always include these core tables
            relevant_tables.update(['appointment_details', 'city_masters', 'service_provider_center_details'])
            
            # Add user table if query mentions users or patients
            if any(word in query for word in ['user', 'patient', 'customer', 'client']):
                relevant_tables.add('users')
                
            # Add payment tables if query mentions payments
            if any(word in query for word in ['payment', 'paid', 'cost', 'amount', 'bill']):
                relevant_tables.add('payment_details')
                relevant_tables.add('appointment_payments')
        else:
            # Find directly mentioned tables using keywords
            for table, keywords in self.table_keywords.items():
                if any(keyword in query for keyword in keywords):
                    relevant_tables.add(table)
        
        # If still no tables found, look for column names
        if not relevant_tables:
            for table_name, table_info in self.tables.items():
                if any(col.lower() in query for col in table_info.get("columns", {}).keys()):
                    relevant_tables.add(table_name)
        
        # Add related tables through foreign keys
        related_tables = set()
        for rel in self.relationships:
            if rel["source_table"] in relevant_tables:
                related_tables.add(rel["target_table"])
            elif rel["target_table"] in relevant_tables:
                related_tables.add(rel["source_table"])
        
        # Add core tables if their related tables are used
        for core_table, related in self.core_tables.items():
            if any(t in relevant_tables for t in related) and core_table not in relevant_tables:
                relevant_tables.add(core_table)
        
        return relevant_tables | related_tables

    def get_sample_query(self, tables: set) -> str:
        """
        Generate a sample SQL query for the given tables.

        Args:
            tables (set): Set of table names to include in the query.

        Returns:
            str: Sample SQL query.
        """
        if not tables:
            return "SELECT * FROM appointment_details LIMIT 10;"
        
        # Convert set to list for consistent ordering
        tables_list = list(tables)
        main_table = tables_list[0]
        
        # Start building the query
        select_clause = []
        from_clause = [f"FROM {main_table}"]
        join_clause = []
        
        # Add columns from main table
        if main_table in self.tables:
            for col in list(self.tables[main_table]["columns"].keys())[:3]:  # First 3 columns
                select_clause.append(f"{main_table}.{col}")
        
        # Add joins and columns from other tables
        for table in tables_list[1:]:
            if table in self.tables:
                # Find relationship between main table and this table
                relationship = None
                for rel in self.relationships:
                    if (rel["source_table"] == main_table and rel["target_table"] == table) or \
                       (rel["target_table"] == main_table and rel["source_table"] == table):
                        relationship = rel
                        break
                
                # Add join if relationship found
                if relationship:
                    if relationship["source_table"] == main_table:
                        join_clause.append(f"JOIN {table} ON {main_table}.{relationship['source_column']} = {table}.{relationship['target_column']}")
                    else:
                        join_clause.append(f"JOIN {table} ON {main_table}.{relationship['target_column']} = {table}.{relationship['source_column']}")
                else:
                    # Default join on id if no relationship found
                    join_clause.append(f"LEFT JOIN {table} ON {main_table}.id = {table}.id")
                
                # Add columns from this table
                for col in list(self.tables[table]["columns"].keys())[:2]:  # First 2 columns
                    select_clause.append(f"{table}.{col}")
        
        # Build the final query
        query = "SELECT " + ", ".join(select_clause) + " "
        query += " ".join(from_clause) + " "
        query += " ".join(join_clause) + " "
        query += "LIMIT 10;"
        
        return query