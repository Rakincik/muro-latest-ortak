import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port=5433,
        database="muro_demo",
        user="muro_user",
        password="MuroDem0_2026!Str0ng"
    )
    cursor = conn.cursor()
    cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False ORDER BY "Title" LIMIT 10;')
    rows = cursor.fetchall()
    print("Success! Active courses in local muro_demo on port 5433:")
    for idx, r in enumerate(rows):
        print(f"  {idx+1}. ID: {r[0]} | Title: {r[1]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Failed to connect to local muro_demo on port 5433: {e}")
