import requests
import json

# Define the API endpoint
API_URL = "https://bms.mapskil.com/api/v1/ai/execute"

# Define the SQL query
QUERY = """
SELECT c.table_name, 
       c.column_name, 
       c.data_type, 
       c.is_nullable, 
       c.character_maximum_length, 
       c.column_default, 
       tc.constraint_type,
       fk.referenced_table,
       fk.referenced_column
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu 
       ON c.table_name = kcu.table_name 
       AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc 
       ON kcu.constraint_name = tc.constraint_name 
       AND tc.table_name = c.table_name
LEFT JOIN (
    SELECT r.table_name, r.column_name, 
           u.table_name AS referenced_table, 
           u.column_name AS referenced_column
    FROM information_schema.key_column_usage r
    JOIN information_schema.referential_constraints rc 
           ON r.constraint_name = rc.constraint_name
    JOIN information_schema.key_column_usage u 
           ON rc.unique_constraint_name = u.constraint_name
) fk 
ON c.table_name = fk.table_name AND c.column_name = fk.column_name
WHERE c.table_schema = 'public'
ORDER BY c.table_name, c.ordinal_position;
"""

# Prepare the JSON payload
payload = {
    "query": QUERY
}

# Define headers
HEADERS = {
    "Content-Type": "application/json"
}

# (Optional) Add an Authorization token if required
# HEADERS["Authorization"] = "Bearer YOUR_ACCESS_TOKEN"

# Send the POST request
try:
    response = requests.post(API_URL, headers=HEADERS, json=payload)
    
    # Check if the request was successful
    if response.status_code == 200:
        data = response.json()  # Convert response to JSON
        print("Schema fetched successfully!")

        # Save the response to a JSON file
        with open("db_schema.json", "w", encoding="utf-8") as f:
            json.dump(data, f, indent=4)

        print("Response saved to db_schema.json")
    else:
        print(f"Error: {response.status_code} - {response.text}")

except requests.RequestException as e:
    print(f"Request failed: {e}")
