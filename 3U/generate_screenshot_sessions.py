import json
import os
import re
import uuid
import difflib
import argparse
from datetime import datetime

# Turkish char replacement map
TR_MAP = str.maketrans("ığüşöçİĞÜŞÖÇ", "igusocIGUSOC")

def clean(name):
    if not name:
        return ""
    name = name.translate(TR_MAP).lower().strip()
    name = re.sub(r'[^a-z0-9\s]', ' ', name)
    return " ".join(name.split())

def load_env():
    config = {}
    env_paths = [".env.3u", "../.env.3u", ".env", "../.env"]
    for ep in env_paths:
        if os.path.exists(ep):
            try:
                with open(ep, "r", encoding="utf-8") as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith("#") and "=" in line:
                            k, v = line.split("=", 1)
                            config[k.strip()] = v.strip()
                break
            except Exception:
                pass
    return config

def main():
    parser = argparse.ArgumentParser(description="3U LMS - Okinar Kayıtlarını Eşleştirip SQL Üretme Aracı")
    parser.add_argument('--host', default=None, help='PostgreSQL Host')
    parser.add_argument('--port', default=None, help='PostgreSQL Port')
    parser.add_argument('--dbname', default=None, help='PostgreSQL Database Name')
    parser.add_argument('--user', default=None, help='PostgreSQL User')
    parser.add_argument('--password', default=None, help='PostgreSQL Password')
    
    args = parser.parse_args()
    
    env = load_env()
    db_host = args.host or env.get("DB_HOST", "localhost")
    db_port = args.port or env.get("DB_PORT", "5432")
    db_name = args.dbname or env.get("DB_NAME", "muro_demo")
    db_user = args.user or env.get("DB_USER", "muro_user")
    db_pass = args.password or env.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    
    # Try resolving container IP locally on the server if no custom host is provided
    if db_host == "localhost":
        try:
            import subprocess
            result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
            ip = result.decode('utf-8').strip()
            if ip:
                db_host = ip
        except Exception:
            pass

    print(f"[*] Veritabanına bağlanılıyor: {db_host}:{db_port} / {db_name}...")
    import psycopg2
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_pass
        )
        cursor = conn.cursor()
        print("[+] Veritabanı bağlantısı başarılı!")
    except Exception as e:
        print(f"[❌] HATA: Veritabanına bağlanılamadı: {e}")
        return

    # Fetch active courses
    cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
    db_courses = {row[1]: row[0] for row in cursor.fetchall()}
    print(f"[*] Veritabanında {len(db_courses)} aktif ders bulundu.")

    # Read Okinar recordings JSON
    json_path = 'okinar dersler/4tuzem.okinar.com_recordings.json'
    if not os.path.exists(json_path):
        json_path = '4tuzem.okinar.com_recordings.json'
        if not os.path.exists(json_path):
            # check parent directory
            json_path = '../okinar dersler/4tuzem.okinar.com_recordings.json'
            if not os.path.exists(json_path):
                # check one more up
                json_path = '../../okinar dersler/4tuzem.okinar.com_recordings.json'
                if not os.path.exists(json_path):
                    print(f"[❌] HATA: Recordings JSON bulunamadı!")
                    return
            
    with open(json_path, 'r', encoding='utf-8') as f:
        recordings = json.load(f)
    print(f"[*] Okinar kayıt dosyasından {len(recordings)} kayıt yüklendi.")

    # Distinct classNames in Okinar
    okinar_classes = sorted(list({r.get('className', '').strip() for r in recordings if r.get('className')}))

    # Target courses to match
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

    sql_lines = []
    sql_lines.append("-- 3U LMS - 4T Uzem Eşleşen Kayıtlar Entegrasyonu")
    sql_lines.append("BEGIN;")
    
    matched_count = 0
    total_recordings_added = 0
    
    print("\n[+] Eşleştirme işlemi başlatılıyor...")

    for sc in screenshot_courses:
        db_course_id = None
        db_course_title = None
        sc_clean = clean(sc)
        
        # Exact match check first
        for title, cid in db_courses.items():
            if clean(title) == sc_clean:
                db_course_id = cid
                db_course_title = title
                break
                
        # If no exact match, fuzzy check
        if not db_course_id:
            best_m = None
            best_score = 0.0
            for title, cid in db_courses.items():
                score = difflib.SequenceMatcher(None, clean(title), sc_clean).ratio()
                if score > 0.8 and score > best_score:
                    best_m = (title, cid)
                    best_score = score
            if best_m:
                db_course_title, db_course_id = best_m
                
        if not db_course_id:
            continue

        # Now match with Okinar class names
        best_okinar_class = None
        best_okinar_score = 0.0
        
        for oc in okinar_classes:
            oc_clean = clean(oc)
            if sc_clean == oc_clean:
                best_okinar_class = oc
                best_okinar_score = 1.0
                break
            elif sc_clean in oc_clean or oc_clean in sc_clean:
                score = 0.9
                if score > best_okinar_score:
                    best_okinar_class = oc
                    best_okinar_score = score
            else:
                score = difflib.SequenceMatcher(None, sc_clean, oc_clean).ratio()
                if score > 0.6 and score > best_okinar_score:
                    best_okinar_class = oc
                    best_okinar_score = score

        if not best_okinar_class:
            continue

        class_recs = [r for r in recordings if r.get('className', '').strip() == best_okinar_class]
        if not class_recs:
            continue

        print(f"  [EŞLEŞTİ] Yerel: '{db_course_title}' <=> Okinar: '{best_okinar_class}' ({len(class_recs)} kayıt)")
        matched_count += 1
        
        for rec in class_recs:
            rid = rec.get('recordID', '')
            title = rec.get('recordingName', 'Ders').replace("'", "''")
            start = rec.get('startTime', '')
            duration = int(rec.get('duration', '0'))
            
            try:
                dt = datetime.strptime(start, '%d.%m.%Y %H:%M:%S')
                start_sql = dt.strftime('%Y-%m-%d %H:%M:%S')
            except Exception:
                try:
                    dt = datetime.strptime(start, '%d.%m.%Y %H:%M')
                    start_sql = dt.strftime('%Y-%m-%d %H:%M:%S')
                except Exception:
                    start_sql = start
                    
            video_url = f"https://canli.3u.muro.click/playback/presentation/2.3/{rid}"
            session_id = str(uuid.uuid4())
            
            sql = (
                f"INSERT INTO \"Sessions\" "
                f"(\"Id\", \"CourseId\", \"Title\", \"Description\", \"Order\", \"VideoUrl\", \"DurationMinutes\", \"IsFree\", \"ScheduledStart\", \"ScheduledEnd\", \"BbbMeetingId\", \"Status\", \"RecordingEnabled\", \"CreatedAt\", \"IsDeleted\") "
                f"VALUES "
                f"('{session_id}', '{db_course_id}', '{title}', '', 1, '{video_url}', {duration}, false, '{start_sql}', '{start_sql}', '{rid}', 3, true, '{start_sql}', false) "
                f"ON CONFLICT DO NOTHING;"
            )
            sql_lines.append(sql)
            total_recordings_added += 1

    sql_lines.append("COMMIT;")
    
    # Save script to local folder relative to the script execution directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    out_path = os.path.join(script_dir, 'insert_3u_screenshot_sessions.sql')
    with open(out_path, 'w', encoding='utf-8') as out_f:
        out_f.write("\n".join(sql_lines))
        
    print(f"\n[🎉] SQL dosyası başarıyla üretildi: '{out_path}'")
    print(f"    - Eşleşen Ders Sayısı: {matched_count}")
    print(f"    - Toplam Kayıt (Oturum): {total_recordings_added}")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
