import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()
cursor.execute('SELECT "Id", "Title", "IsDeleted" FROM "Courses" WHERE "IsDeleted" = False ORDER BY "Title"')
courses = cursor.fetchall()
print(f"Total active courses: {len(courses)}")
for i, row in enumerate(courses[:30]):
    print(f"{i+1}. ID: {row[0]}, Title: {row[1]}")

conn.close()
