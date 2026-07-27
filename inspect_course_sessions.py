import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port="5433",
    database="muro_demo",
    user="muro_user",
    password="MuroDem0_2026!Str0ng"
)
cur = conn.cursor()

# Query sessions for course
cur.execute('SELECT "Id", "Title", "Status", "BbbMeetingId", "IsDeleted" FROM "Sessions" WHERE "CourseId" = \'aeb3af2a-bb0a-4cb7-b776-f685524f5c58\';')
sessions = cur.fetchall()

print(f"Total Sessions: {len(sessions)}")
for s in sessions:
    print(s)

cur.close()
conn.close()
