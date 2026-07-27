import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port="5433",
    database="muro_demo",
    user="muro_user",
    password="MuroDem0_2026!Str0ng"
)
cur = conn.cursor()
cur.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'CourseMedias';")
for row in cur.fetchall():
    print(row)
cur.close()
conn.close()
