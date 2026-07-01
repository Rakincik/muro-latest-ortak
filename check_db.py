import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()
cursor.execute('SELECT COUNT(*) FROM "MediaAssets" WHERE "ThumbnailPath" IS NOT NULL')
cnt = cursor.fetchone()[0]
print(f"MediaAssets with thumbnails: {cnt}")

cursor.execute('SELECT "Id", "Title", "ThumbnailPath" FROM "MediaAssets" WHERE "ThumbnailPath" IS NOT NULL LIMIT 5')
for row in cursor.fetchall():
    print(f"ID: {row[0]}, Title: {row[1]}, Thumb: {row[2]}")

conn.close()
