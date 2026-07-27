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
    cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False ORDER BY "Title" LIMIT 20;')
    rows = cursor.fetchall()
    print("Success! Active courses in 4takademi:")
    for idx, r in enumerate(rows):
        print(f"  {idx+1}. ID: {r[0]} | Title: {r[1]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Failed to connect to 4takademi: {e}")
