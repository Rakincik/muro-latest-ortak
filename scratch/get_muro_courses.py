import pg8000

try:
    conn = pg8000.connect(
        host="31.214.152.143",
        port=5434,
        database="muro_prod",
        user="muro_user",
        password="MuroDb2026!Pr0d"
    )
    cursor = conn.cursor()
    cursor.execute("""
        SELECT c."Id", c."Title", COUNT(s."Id") 
        FROM "Courses" c 
        LEFT JOIN "Sessions" s ON c."Id" = s."CourseId" AND s."IsDeleted" = False
        WHERE c."IsDeleted" = False 
        GROUP BY c."Id", c."Title" 
        ORDER BY c."Title" ASC;
    """)
    rows = cursor.fetchall()
    print(f"Total active courses: {len(rows)}")
    for idx, r in enumerate(rows):
        print(f"  {idx+1}. ID: {r[0]} | Title: {r[1]} | Sessions: {r[2]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Error: {e}")
