import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()

# Find users who have watched any video of DERS_52
cursor.execute('''
    SELECT vp."UserId", u."FirstName", u."LastName", u."Email", vp."WatchedSeconds", vp."TotalSeconds", vp."UpdatedAt"
    FROM "VideoProgresses" vp
    JOIN "Users" u ON vp."UserId" = u."Id"
    JOIN "MediaAssets" m ON vp."MediaAssetId" = m."Id"
    WHERE m."Title" LIKE '%DERS_52%' OR m."Title" LIKE '%DERS_7%'
    ORDER BY vp."UpdatedAt" DESC
''')
progress = cursor.fetchall()
print("Video progress records in DB:")
for p in progress:
    print(f" - User: {p[1]} {p[2]} ({p[3]}) | Watched: {p[4]}s ({p[4]/60:.1f}m) | Total: {p[5]}s | UpdatedAt: {p[6]}")

conn.close()
