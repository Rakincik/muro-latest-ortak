import argparse
import psycopg2
import uuid
from datetime import datetime, timezone

def main():
    parser = argparse.ArgumentParser(description="OMURHOCA LMS - Import Videos")
    parser.add_argument("--host", required=True, help="PostgreSQL host")
    parser.add_argument("--port", type=int, default=5432, help="PostgreSQL port")
    parser.add_argument("--dbname", required=True, help="PostgreSQL database name")
    parser.add_argument("--user", required=True, help="PostgreSQL username")
    parser.add_argument("--password", required=True, help="PostgreSQL password")
    parser.add_argument("--file", default="omr_video_eslestirme.txt", help="Eşleştirme dosyası")
    parser.add_argument("--execute", action="store_true", help="Eğer verilmezse sadece dry-run yapar")
    args = parser.parse_args()

    # Dosya kontrolü
    try:
        with open(args.file, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"HATA: '{args.file}' dosyası bulunamadı!")
        return

    conn = psycopg2.connect(
        host=args.host,
        port=args.port,
        dbname=args.dbname,
        user=args.user,
        password=args.password
    )
    cur = conn.cursor()

    cur.execute("SELECT \"Id\" FROM \"Tenants\" WHERE \"Identifier\" = 'omr'")
    tenant = cur.fetchone()
    if not tenant:
        print("Tenant 'omr' bulunamadi!")
        return
    tenant_id = tenant[0]

    added_count = 0
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("CourseID"):
            continue
        
        parts = line.split(",")
        if len(parts) < 3:
            print(f"Geçersiz satır atlanıyor: {line}")
            continue

        course_id = parts[0].strip()
        folder_name = parts[1].strip()
        video_title = parts[2].strip()

        # Check if course exists
        cur.execute('SELECT "Id" FROM "Courses" WHERE "Id" = %s AND "TenantId" = %s', (course_id, tenant_id))
        if not cur.fetchone():
            print(f"Ders bulunamadı (ID: {course_id}), atlanıyor...")
            continue

        # Get max order index
        cur.execute('SELECT MAX("OrderIndex") FROM "CourseMedias" WHERE "CourseId" = %s', (course_id,))
        max_order_res = cur.fetchone()
        next_order = (max_order_res[0] + 1) if max_order_res and max_order_res[0] is not None else 0

        video_url = f"https://canli.omurhoca.muro.click/playback/presentation/2.3/{folder_name}"
        media_id = str(uuid.uuid4())
        now = datetime.now(timezone.utc)

        if args.execute:
            cur.execute("""
                INSERT INTO "CourseMedias" 
                ("Id", "CourseId", "Title", "Type", "VideoUrl", "OrderIndex", "IsActive", "CreatedAt", "TenantId")
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (media_id, course_id, video_title, "iframe", video_url, next_order, True, now, tenant_id))
            print(f"Eklendi -> Ders: {course_id[:8]} | Video: {video_title} | URL: {video_url}")
            added_count += 1
        else:
            print(f"[DRY-RUN] Eklenecek -> Ders: {course_id[:8]} | Video: {video_title} | Klasör: {folder_name}")

    if args.execute:
        conn.commit()
        print(f"\n✅ Toplam {added_count} adet video başarıyla veritabanına işlendi!")
    else:
        print("\n⚠️ Bu bir DRY-RUN idi. Gerçekten kaydetmek için komutun sonuna '--execute' ekle.")

    conn.close()

if __name__ == '__main__':
    main()
