import os
import sys
import re
import uuid
import datetime
import json
import argparse

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def normalize(s):
    if not s:
        return ''
    s = str(s).lower().strip()
    char_map = {
        'ı': 'i', 'İ': 'i', 'I': 'i',
        'ş': 's', 'Ş': 's',
        'ğ': 'g', 'Ğ': 'g',
        'ü': 'u', 'Ü': 'u',
        'ö': 'o', 'Ö': 'o',
        'ç': 'c', 'Ç': 'c'
    }
    for tr, eng in char_map.items():
        s = s.replace(tr, eng)
    s = re.sub(r'[^a-z0-9]', '', s)
    return s

def load_env():
    config = {}
    env_paths = [
        ".env.trk", "../.env.trk", "../../.env.trk",
        ".env", "../.env", "../../.env"
    ]
    for ep in env_paths:
        if os.path.exists(ep):
            try:
                with open(ep, "r", encoding="utf-8") as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith("#") and "=" in line:
                            k, v = line.split("=", 1)
                            config[k.strip()] = v.strip()
            except Exception:
                pass
    return config

def main():
    parser = argparse.ArgumentParser(description="MURO LMS TRK - Okinar Recordings/Sessions Import")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--file", default="okinar dersler/ataniyorumhocam.okinar.com_recordings.json", help="Path to recordings JSON file")
    parser.add_argument("--after-date", help="Only process recordings after this date (format: DD.MM.YYYY, e.g. 28.06.2026)")
    parser.add_argument("--execute", action="store_true", help="Execute database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO TRK - OKINAR RECORDINGS IMPORT TOOL{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # Load env
    env_config = load_env()
    db_host = args.host or env_config.get("DB_HOST", "localhost")
    db_port = args.port or int(env_config.get("DB_PORT", 5432))
    db_name = args.dbname or env_config.get("DB_NAME", "muro_demo")
    db_user = args.user or env_config.get("DB_USER", "muro_user")
    db_pass = args.password or env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Resolve Docker Container IP on server
    if not args.host:
        try:
            import subprocess
            result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_trk_postgres'], stderr=subprocess.DEVNULL)
            ip = result.decode('utf-8').strip()
            if ip:
                db_host = ip
        except Exception:
            pass

    # Read recordings JSON
    json_path = args.file
    if not os.path.exists(json_path):
        # Fallback to local root
        json_path = os.path.basename(json_path)
        if not os.path.exists(json_path):
            # Try with suffix (1)
            json_path = "ataniyorumhocam.okinar.com_recordings (1).json"
            if not os.path.exists(json_path):
                print(f"{Colors.FAIL}[X] HATA: Recordings JSON dosyası bulunamadı: '{args.file}'{Colors.ENDC}")
                sys.exit(1)

    print(f"[*] Reading recordings from '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        scraped_courses = json.load(f)
    print(f"    - Loaded {len(scraped_courses)} course groups from JSON.")

    # Connect to DB
    print(f"[*] Connecting to database '{db_name}'...")
    conn = None
    try:
        import psycopg2
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
    except ImportError:
        try:
            import pg8000
            conn = pg8000.connect(host=db_host, port=db_port, database=db_name, user=db_user, password=db_pass)
        except ImportError:
            print(f"{Colors.FAIL}[X] HATA: psycopg2 veya pg8000 kütüphanelerinden biri kurulu olmalıdır!{Colors.ENDC}")
            sys.exit(1)
    except Exception as e:
        print(f"{Colors.FAIL}[X] Veritabanı bağlantısı başarısız oldu: {e}{Colors.ENDC}")
        sys.exit(1)

    print(f"{Colors.GREEN}[+] Veritabanına başarıyla bağlanıldı!{Colors.ENDC}")
    cur = conn.cursor()

    try:
        print("[*] Caching existing courses and sessions...")
        
        # Courses
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses = {normalize(r[1]): r[0] for r in cur.fetchall()}

        # Sessions
        cur.execute('SELECT "CourseId", "BbbMeetingId" FROM "Sessions" WHERE "IsDeleted" = False;')
        db_sessions = {(r[0], r[1]) for r in cur.fetchall()}

        print("[+] Caching completed successfully.")

        courses_created = 0
        sessions_created = 0
        sessions_skipped = 0

        # Import loop
        print(f"\n{Colors.BLUE}[*] Processing Video Recordings (Sessions)...{Colors.ENDC}")

        for course_group in scraped_courses:
            class_name = course_group.get('courseName', '').strip()
            recordings_list = course_group.get('recordings', [])
            
            if not class_name or not recordings_list:
                continue

            for rec in recordings_list:
                record_id = rec.get('recordID')
                record_id = str(record_id).strip() if isinstance(record_id, (str, int)) else ""
                
                recording_name = rec.get('videoName') or rec.get('recordingName') or ""
                recording_name = str(recording_name).strip()
                
                duration_str = rec.get('duration', '60')
                duration_str = str(duration_str).strip()
                
                if not record_id:
                    continue

                # Parse start time date from BBB meeting ID timestamp
                dt = None
                if '-' in record_id:
                    try:
                        ts_part = record_id.split('-')[-1]
                        if len(ts_part) >= 10:
                            ts_ms = int(ts_part[:13])
                            dt = datetime.datetime.utcfromtimestamp(ts_ms / 1000.0)
                    except Exception:
                        pass

                # Filter by after_date if supplied
                if args.after_date and dt:
                    try:
                        limit_dt = datetime.datetime.strptime(args.after_date, "%d.%m.%Y")
                        if dt < limit_dt:
                            sessions_skipped += 1
                            continue
                    except ValueError:
                        print(f"{Colors.WARNING}[!] Geçersiz tarih formatı: {args.after_date}. Filtre uygulanamadı.{Colors.ENDC}")

                # Check if course exists, otherwise create it
                class_name_clean = normalize(class_name)
                c_id = db_courses.get(class_name_clean)
                if not c_id:
                    class_name_alt = normalize(class_name.replace('  ', ' '))
                    c_id = db_courses.get(class_name_alt)
                    
                if not c_id:
                    c_id = str(uuid.uuid4())
                    cur.execute(
                        'INSERT INTO "Courses" ("Id", "Title", "IsDeleted", "IsPublished", "CourseType", "Mode", "Order", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                        (c_id, class_name, False, True, 'Online', 'Offline', 0, datetime.datetime.utcnow())
                    )
                    db_courses[class_name_clean] = c_id
                    courses_created += 1
                    print(f"    -> [+] Created new Course for recordings: '{class_name}'")

                # Check duplicate session
                if (c_id, record_id) in db_sessions:
                    sessions_skipped += 1
                    continue

                # Clean recording title
                title = recording_name if recording_name else f"{class_name}"
                
                if dt:
                    created_at_str = dt.strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = created_at_str
                    try:
                        dur_mins = int(duration_str) if duration_str else 60
                    except ValueError:
                        dur_mins = 60
                    end_dt = dt + datetime.timedelta(minutes=dur_mins)
                    scheduled_end_str = end_dt.strftime("%Y-%m-%d %H:%M:%S")
                else:
                    created_at_str = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = None
                    scheduled_end_str = None
                    dur_mins = 60

                # BBB Playback URL for TRK (Atanıyorum Hocam)
                video_url = f"https://canli.trk.muro.click/playback/presentation/2.3/{record_id}"
                session_id = str(uuid.uuid4())
                
                # Insert Session
                cur.execute(
                    'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                    (session_id, c_id, title, video_url, record_id, False, created_at_str, 'Ended', 0, True, False, scheduled_start_str, scheduled_end_str, dur_mins)
                )
                
                # Insert CourseMedia mapping
                course_media_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s)',
                    (course_media_id, c_id, session_id, 0, datetime.datetime.utcnow())
                )
                db_sessions.add((c_id, record_id))
                sessions_created += 1

        print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"{Colors.GREEN}{Colors.BOLD}                      IMPORT SUMMARY")
        print(f"{Colors.GREEN}{Colors.BOLD}============================================================")
        print(f" [Course] Created New Courses Count  : {courses_created}")
        print(f" [Video] Created Video Sessions      : {sessions_created}")
        print(f" [Video] Skipped Video Sessions      : {sessions_skipped}")

        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Changes successfully committed to the database!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE: No writes performed.{Colors.ENDC}")
            print(f"    To execute changes, run with '--execute':")
            print(f"    python3 import_trk_recordings.py --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED (Rollback changes): {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
