import sys
import uuid
import datetime
import psycopg2

COURSE_ID = "2e151150-d248-45eb-8986-9fee00edaadf" # İstatistik 2026
DOMAIN = "canli.4takademi.com"

def main():
    if len(sys.argv) < 3:
        print("HATA: Eksik parametre!")
        print("Kullanım: python3 bind_bbb_hls.py <klasor_adi> \"<video_basligi>\" [--execute]")
        return

    folder_name = sys.argv[1].strip()
    video_title = sys.argv[2].strip()
    execute = "--execute" in sys.argv

    # HLS URL (BBB Sunucusundan çalacak)
    hls_url = f"https://{DOMAIN}/playback/presentation/2.3/{folder_name}/master.m3u8"

    # Docker Postgres IP'sini bul
    db_host = "localhost"
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    try:
        conn = psycopg2.connect(host=db_host, port=5432, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng")
        cur = conn.cursor()
    except Exception as e:
        print(f"Veritabanı bağlantı hatası: {e}")
        return

    try:
        # Mevcut en son ders sırasını bul
        cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False', (COURSE_ID,))
        max_order = cur.fetchone()[0] or 0
        next_order = max_order + 1

        session_id = str(uuid.uuid4())
        media_asset_id = str(uuid.uuid4())
        course_media_id = str(uuid.uuid4())
        now = datetime.datetime.utcnow()

        if execute:
            # 1. MediaAssets tablosuna dış HLS olarak ekle
            cur.execute("""
                INSERT INTO "MediaAssets" ("Id", "Title", "HlsPath", "Status", "CreatedAt", "DurationSeconds", "IsDeleted")
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (media_asset_id, video_title, hls_url, 2, now, 0, False))

            # 2. Sessions tablosuna ekle
            cur.execute("""
                INSERT INTO "Sessions" ("Id", "CourseId", "Title", "MediaAssetId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (session_id, COURSE_ID, video_title, media_asset_id, False, now, 2, next_order, True, False))

            # 3. CourseMedias tablosuna bağla
            cur.execute("""
                INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt")
                VALUES (%s, %s, %s, %s, %s)
            """, (course_media_id, COURSE_ID, session_id, next_order, now))

            conn.commit()
            print(f"[OK] BAŞARILI: '{video_title}' videosu İstatistik 2026 dersine başarıyla eklendi!")
            print(f"HLS URL: {hls_url}")
        else:
            print(f"[DRY-RUN] Eklenecek Video: {video_title}")
            print(f"Klasör Adı: {folder_name}")
            print(f"Oluşturulacak HLS Linki: {hls_url}")
            print("\nGerçekten kaydetmek için komutun sonuna --execute ekle:")
            print(f"python3 bind_bbb_hls.py {folder_name} \"{video_title}\" --execute")

    except Exception as e:
        conn.rollback()
        print(f"HATA: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
