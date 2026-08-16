import psycopg2
try:
    conn = psycopg2.connect("host=31.214.152.143 port=5434 dbname=postgres user=muro_user password=MuroDb2026!Pr0d")
    cur = conn.cursor()
    cur.execute("SELECT datname FROM pg_database;")
    for row in cur.fetchall():
        print(row[0])
    cur.close()
    conn.close()
except Exception as e:
    print(e)
