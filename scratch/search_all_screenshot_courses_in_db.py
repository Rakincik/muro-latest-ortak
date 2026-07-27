import pg8000

screenshot_courses = [
    "REHBERLİK 4",
    "REHBERLİK 3",
    "REHBERLİK 2",
    "MUHASEBE HIZLI KONU - YOĞUN SORU",
    "Muhasebe Ders Taraması ve Soru Çözümü 2026",
    "MEDENİ HUKUK DEMO",
    "MALİYE HIZLI KONU - YOĞUN SORU",
    "Maliye Ders Taraması ve Soru Çözümü 2026",
    "KAYMAKAMILIK İKTİSAT HIZLI KONU YOĞUN SORU KAMPI",
    "KAYMAKAMILIK HIZLI KONU YOĞUN SORU KAMPI 2025",
    "İKTİSAT HIZLI KONU - YOĞUN SORU",
    "HUKUK HIZLI KONU - YOĞUN SORU",
    "GY-GK DEMO"
]

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()
print("Searching for screenshot courses in remote database muro_prod:")
for sc in screenshot_courses:
    cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False AND "Title" = %s', (sc,))
    row = cursor.fetchone()
    if row:
        print(f"  [FOUND] {sc} -> ID: {row[0]}")
    else:
        # Try a case-insensitive search
        cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False AND "Title" ILIKE %s', (sc,))
        row2 = cursor.fetchone()
        if row2:
            print(f"  [FUZZY FOUND] {sc} -> matched '{row2[1]}' (ID: {row2[0]})")
        else:
            print(f"  [NOT FOUND] {sc}")

conn.close()
