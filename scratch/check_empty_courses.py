import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()

# Get empty courses (courses that have 0 active/IsDeleted=False sessions)
cursor.execute("""
    SELECT c."Id", c."Title"
    FROM "Courses" c
    LEFT JOIN "Sessions" s ON c."Id" = s."CourseId" AND s."IsDeleted" = False
    WHERE c."IsDeleted" = False
    GROUP BY c."Id", c."Title"
    HAVING COUNT(s."Id") = 0
    ORDER BY c."Title";
""")

empty_courses = cursor.fetchall()
print(f"Total courses with 0 sessions: {len(empty_courses)}")
for idx, r in enumerate(empty_courses):
    print(f"  {idx+1}. ID: {r[0]} | Title: {r[1]}")

conn.close()
