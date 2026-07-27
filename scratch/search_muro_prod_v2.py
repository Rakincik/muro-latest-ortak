import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()
# Get columns of Courses table
cursor.execute('SELECT * FROM "Courses" LIMIT 1')
col_names = [desc[0] for desc in cursor.description]
print("Courses table columns:", col_names)

# Query courses matching rehber
cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False AND "Title" ILIKE \'%rehber%\' ORDER BY "Title"')
rows = cursor.fetchall()
print(f"\nMatching courses containing 'rehber': {len(rows)}")
for idx, r in enumerate(rows):
    print(f"  {idx+1}. ID: {r[0]} | Title: {r[1]}")

conn.close()
