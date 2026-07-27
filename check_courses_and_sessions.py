import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port="5433",
    database="muro_demo",
    user="muro_user",
    password="MuroDem0_2026!Str0ng"
)
cur = conn.cursor()

# Query all courses
cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False ORDER BY "Title";')
courses = cur.fetchall()

print(f"Total Active Courses: {len(courses)}")
print("\n--- Courses list ---")
for cid, title in courses:
    cur.execute('SELECT COUNT(*) FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False;', (cid,))
    scnt = cur.fetchone()[0]
    if scnt > 0 or "TVS" in title or "Vergi" in title:
        print(f"ID: {cid} | Title: {title} | Sessions: {scnt}")

cur.close()
conn.close()
