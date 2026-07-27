import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port=5434,
        database="4takademi",
        user="4takademi",
        password="secret"
    )
    cursor = conn.cursor()
    cursor.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        ORDER BY table_name;
    """)
    rows = cursor.fetchall()
    print("Tables in 4takademi:")
    for r in rows:
        print(f"  - {r[0]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Error: {e}")
