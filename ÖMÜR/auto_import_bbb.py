import json
import psycopg2
import uuid
import sys
from datetime import datetime, timezone
import os

def load_env():
    config = {}
    env_paths = [".env.omr", "../.env.omr", ".env", "../.env"]
    for ep in env_paths:
        if os.path.exists(ep):
            with open(ep, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#") and "=" in line:
                        k, v = line.split("=", 1)
                        config[k.strip()] = v.strip()
            break
    return config

def main():
    print("=" * 60)
    print("      OMURHOCA - OTOMATIK BBB KAYIT AKTARICI")
    print("=" * 60)
    
    config = load_env()
    if not config:
        print("HATA: .env.omr bulunamadi!")
        return

    # 1. JSON Kayıtlarını Oku
    json_path = "omurhoca.okinar.com_recordings.json"
    if not os.path.exists(json_path):
        json_path = "ÖMÜR/" + json_path
        if not os.path.exists(json_path):
            print("HATA: JSON dosyası bulunamadı!")
            return
            
    with open(json_path, "r", encoding="utf-8") as f:
        all_recordings = json.load(f)
        
    print(f"Toplam {len(all_recordings)} kayit JSON'dan okundu.")

    # 2. Kullanıcının verdiği eşleştirmeleri oku
    mapping_file = "courses_mapping.txt"
    if not os.path.exists(mapping_file):
        mapping_file = "ÖMÜR/courses_mapping.txt"
        
    mappings = []
    with open(mapping_file, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or "|" not in line: continue
            meeting_id, course_name = line.split("|", 1)
            mappings.append({
                "meeting_id": meeting_id.strip(),
                "course_name": course_name.strip()
            })

    import subprocess
    db_host = "localhost"
    
    if len(sys.argv) > 1:
        db_host = sys.argv[1]
    else:
        try:
            # PostgreSQL docker konteynerinin IP adresini otomatik bul
            res = subprocess.check_output(["docker", "inspect", "-f", "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}", "muro_omr_postgres"])
            db_host = res.decode("utf-8").strip()
        except Exception as e:
            print("Docker container IP'si bulunamadi, localhost denenecek.")

    print(f"Veritabanı IP Adresi: {db_host} olarak ayarlandı.")

    # 3. Veritabanına Bağlan
    conn = psycopg2.connect(
        host=db_host,
        port=5432,
        dbname=config.get("DB_NAME", "muro_demo"),
        user=config.get("DB_USER", "muro_user"),
        password=config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    )
    cur = conn.cursor()
    
    total_added = 0

    for m in mappings:
        meeting_id = m["meeting_id"]
        course_name = m["course_name"]
        
        # Veritabanında dersi bul
        cur.execute('SELECT "Id" FROM "Courses" WHERE "Title" ILIKE %s LIMIT 1', (f"%{course_name}%",))
        course = cur.fetchone()
        if not course:
            print(f"UYARI: '{course_name}' adinda ders bulunamadi! Atliyorum...")
            continue
            
        course_id = course[0]
        
        # Bu meeting_id ile başlayan JSON kayıtlarını bul
        matches = [r for r in all_recordings if r.get("recordID", "").startswith(meeting_id)]
        
        if not matches:
            print(f"UYARI: '{course_name}' icin JSON'da hic BBB kaydi bulunamadi! (ID: {meeting_id[:8]}...)")
            continue
            
        print(f"\n[{course_name}] -> {len(matches)} adet video bulundu.")
        
        # Sira numarasini bul
        cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s', (course_id,))
        max_order_res = cur.fetchone()
        next_order = (max_order_res[0] + 1) if max_order_res and max_order_res[0] is not None else 0
        
        # startTime ornegin: "23.06.2026 14:57:56"
        def parse_date(date_str):
            try:
                return datetime.strptime(date_str, "%d.%m.%Y %H:%M:%S")
            except:
                return datetime.min
                
        matches.sort(key=lambda x: parse_date(x.get("startTime", "")))

        for rec in matches:
            full_record_id = rec["recordID"]
            video_title = rec.get("recordingName", "Ders Kaydı")
            video_url = f"https://canli.omurhoca.muro.click/playback/presentation/2.3/{full_record_id}"
            
            # Zaten Session'da var mi?
            cur.execute('SELECT "Id" FROM "Sessions" WHERE "VideoUrl" = %s AND "CourseId" = %s', (video_url, course_id))
            session_res = cur.fetchone()
            
            if session_res:
                session_id = session_res[0]
                # Session var, ama Admin paneli icin CourseMedias'da var mi?
                cur.execute('SELECT "Id" FROM "CourseMedias" WHERE "SessionId" = %s', (session_id,))
                if cur.fetchone():
                    print(f"  - Zaten var: {video_title} ({full_record_id[-10:]})")
                    continue
                else:
                    course_media_id = str(uuid.uuid4())
                    now = datetime.now(timezone.utc)
                    cur.execute("""
                        INSERT INTO "CourseMedias"
                        ("Id", "CourseId", "SessionId", "OrderIndex", "CustomTitle", "CreatedAt")
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (course_media_id, course_id, session_id, next_order, video_title, now))
                    print(f"  + DUZELTILDI (Panele Eklendi): {video_title}")
                    next_order += 1
                    total_added += 1
                    continue
            
            session_id = str(uuid.uuid4())
            course_media_id = str(uuid.uuid4())
            now = datetime.now(timezone.utc)
            
            # 1. Session olustur
            cur.execute("""
                INSERT INTO "Sessions" 
                ("Id", "CourseId", "Title", "VideoUrl", "Order", "Status", "RecordingEnabled", "IsDeleted", "IsFree", "CreatedAt", "BbbMeetingId")
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (session_id, course_id, video_title, video_url, next_order, 2, True, False, False, now, full_record_id))
            
            # 2. CourseMedias tablosuna bagla ki Admin Panelinde (Medya ve Kayitlar) gozuksun
            cur.execute("""
                INSERT INTO "CourseMedias"
                ("Id", "CourseId", "SessionId", "OrderIndex", "CustomTitle", "CreatedAt")
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (course_media_id, course_id, session_id, next_order, video_title, now))
            
            print(f"  + EKLENDI: {video_title}")
            next_order += 1
            total_added += 1

    conn.commit()
    conn.close()
    
    print("=" * 60)
    print(f"ISLEM TAMAM! Toplam {total_added} yeni video basariyla eklendi.")
    print("=" * 60)

if __name__ == '__main__':
    main()
