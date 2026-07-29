import psycopg2

try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=muro_dev user=muro_user password=muro_pass_2024")
    cur = conn.cursor()
    cur.execute("""
        SELECT "Id", "Title" 
        FROM "Courses" 
        WHERE "Title" ILIKE '%Ticaret%' 
           OR "Title" ILIKE '%İktisat%' 
           OR "Title" ILIKE '%Maliye%' 
           OR "Title" ILIKE '%İcra%'
           OR "Title" ILIKE '%Borçlar%';
    """)
    rows = cur.fetchall()
    print("Found courses:")
    for r in rows:
        print(f"ID: {r[0]} | Title: {r[1]}")
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
