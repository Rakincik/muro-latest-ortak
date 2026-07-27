import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port=5432,
        database="ataniyorum_db",
        user="postgres",
        password="postgres"
    )
    cursor = conn.cursor()
    cursor.execute('SELECT "Title" FROM "Courses" WHERE "IsDeleted" = False ORDER BY "Title" LIMIT 10;')
    rows = cursor.fetchall()
    print("Success! Active courses in ataniyorum_db:")
    for idx, r in enumerate(rows):
        print(f"  {idx+1}. {r[0]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Failed to connect to ataniyorum_db: {e}")
