import psycopg2
import uuid
import sys
import subprocess
from datetime import datetime, timezone

# 4T Akademi Course ID
COURSE_ID = "31cb881c-fbdc-4b34-b38b-4877c5a09ede"
DOMAIN = "canli.4takademi.com"

# The 6 newly uploaded recordings
NEW_RECORDINGS = [
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784995380549", "title": "Ders Kaydı - 1"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784998604262", "title": "Ders Kaydı - 2"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785002216250", "title": "Ders Kaydı - 3"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785081870424", "title": "Ders Kaydı - 4"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785085107408", "title": "Ders Kaydı - 5"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785088352642", "title": "Ders Kaydı - 6"},
]

def main():
    print("=" * 60)
    print("    4T AKADEMİ (3U) - YENİ KAYIT AKTARICI VE DOMAIN GÜNCELLEYİCİ")
    print("=" * 60)
    
    # Try finding docker container IP or localhost
    db_host = "localhost"
    try:
        res = subprocess.check_output(["docker", "inspect", "-f", "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}", "muro_3u_postgres"])
        if res.decode("utf-8").strip():
            db_host = res.decode("utf-8").strip()
    except Exception:
        pass

    print(f"PostgreSQL IP: {db_host}")
    
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=5432,
            dbname="muro_demo",
            user="muro_user",
            password="MuroDem0_2026!Str0ng"
        )
        cur = conn.cursor()
    except Exception as e:
        print(f"HATA: Veritabanına bağlanılamadı: {e}")
        return

    # 1. Mevcut ders oturumlarının domain adreslerini update et (ör: canli.4takademi.com)
    print(f"\n1. Course ID {COURSE_ID} için mevcut linklerin domainleri {DOMAIN} olarak güncelleniyor...")
    cur.execute("""
        UPDATE "Sessions"
        SET "VideoUrl" = regexp_replace("VideoUrl", 'https://[^/]+/', 'https://' || %s || '/')
        WHERE "CourseId" = %s AND "VideoUrl" IS NOT NULL
    """, (DOMAIN, COURSE_ID))
    print(f"  + {cur.rowcount} adet mevcut oturum linki güncellendi.")

    # 2. Sınıfın max order değerini bul
    cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s', (COURSE_ID,))
    max_order_res = cur.fetchone()
    next_order = (max_order_res[0] + 1) if max_order_res and max_order_res[0] is not None else 1

    total_added = 0
    now = datetime.now(timezone.utc)

    # 3. Yeni 6 videoyu ekle
    print(f"\n2. Yeni 6 adet video ekleniyor...")
    for item in NEW_RECORDINGS:
        uid = item["uid"]
        title = item["title"]
        video_url = f"https://{DOMAIN}/playback/presentation/2.3/{uid}"

        # Var mı kontrol et
        cur.execute('SELECT "Id" FROM "Sessions" WHERE "BbbMeetingId" = %s OR "VideoUrl" = %s', (uid, video_url))
        exists = cur.fetchone()
        if exists:
            print(f"  - Zaten var: {uid[-10:]}")
            continue

        session_id = str(uuid.uuid4())
        media_id = str(uuid.uuid4())

        # Sessions insert
        cur.execute("""
            INSERT INTO "Sessions"
            ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "Order", "Status", "RecordingEnabled", "IsDeleted", "IsFree", "CreatedAt")
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (session_id, COURSE_ID, title, video_url, uid, next_order, 2, True, False, False, now))

        # CourseMedias insert
        cur.execute("""
            INSERT INTO "CourseMedias"
            ("Id", "CourseId", "SessionId", "OrderIndex", "CustomTitle", "CreatedAt")
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (media_id, COURSE_ID, session_id, next_order, title, now))

        print(f"  + EKLENDİ: {title} ({uid[-10:]}) -> {video_url}")
        next_order += 1
        total_added += 1

    conn.commit()
    conn.close()
    print("\n" + "=" * 60)
    print(f"İŞLEM BAŞARIYLA TAMAMLANDI! Toplam {total_added} yeni video eklendi.")
    print("=" * 60)

if __name__ == '__main__':
    main()
