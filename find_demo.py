import psycopg2
try:
    conn = psycopg2.connect("host=31.214.152.143 port=5434 dbname=muro_demo user=muro_user password=MuroDem0_2026!Str0ng")
    cur = conn.cursor()
    cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" ILIKE \'%SORU%\';')
    rows = cur.fetchall()
    for row in rows:
        print(f"{row[0]} - {row[1]}")
    cur.close()
    conn.close()
except Exception as e:
    print(e)
