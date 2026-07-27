import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port="5433",
    database="muro_demo",
    user="muro_user",
    password="MuroDem0_2026!Str0ng"
)
cur = conn.cursor()
cur.execute('SELECT "Status", COUNT(*) FROM "Sessions" GROUP BY "Status";')
for r in cur.fetchall():
    print(r)
cur.close()
conn.close()
