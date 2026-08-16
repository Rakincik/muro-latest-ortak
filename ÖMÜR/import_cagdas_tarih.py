import os
import sys
import re
import uuid
import datetime
import psycopg2
import argparse

# Colors for terminal output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

# The 16 record IDs from the user's screenshot
RECORD_IDS = [
    "260add033f7edbe413cb15685221c0131d1c4347-1781613099578",
    "260add033f7edbe413cb15685221c0131d1c4347-1780728398115",
    "260add033f7edbe413cb15685221c0131d1c4347-1780403463157",
    "260add033f7edbe413cb15685221c0131d1c4347-1781333478659",
    "260add033f7edbe413cb15685221c0131d1c4347-1780735871372",
    "260add033f7edbe413cb15685221c0131d1c4347-1780410657905",
    "260add033f7edbe413cb15685221c0131d1c4347-1781616981009",
    "260add033f7edbe413cb15685221c0131d1c4347-1781011940816",
    "260add033f7edbe413cb15685221c0131d1c4347-1781098918609",
    "260add033f7edbe413cb15685221c0131d1c4347-1780406959975",
    "260add033f7edbe413cb15685221c0131d1c4347-1781700095333",
    "260add033f7edbe413cb15685221c0131d1c4347-1780732194269",
    "260add033f7edbe413cb15685221c0131d1c4347-1781703106352",
    "260add033f7edbe413cb15685221c0131d1c4347-1781008357494",
    "260add033f7edbe413cb15685221c0131d1c4347-1781337011816",
    "260add033f7edbe413cb15685221c0131d1c4347-1781095394951"
]

def load_env():
    config = {}
    env_paths = [
        ".env.omr", "../.env.omr", "../../.env.omr",
        ".env", "../.env", "../../.env",
        "/opt/omr/.env.omr", "/opt/omr/.env"
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
                break
            except Exception:
                pass
    return config

def parse_record_id_date(record_id):
    if '-' in record_id:
        try:
            ts_part = record_id.split('-')[-1]
            if len(ts_part) >= 10:
                ts_ms = int(ts_part[:13])
                # Convert milliseconds to datetime object
                return datetime.datetime.utcfromtimestamp(ts_ms / 1000.0)
        except Exception:
            pass
    return datetime.datetime.min

def main():
    parser = argparse.ArgumentParser(description="OMURHOCA LMS - Import Cagdas Tarih Videos")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}    MURO OMURHOCA - IMPORT & BIND CAGDAS TARIH VIDEOS        {Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # Load env
    env_config = load_env()
    db_host = env_config.get("DB_HOST", "localhost")
    db_port = int(env_config.get("DB_PORT", 5432))
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Try resolving OMR container IP
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
            print(f"[*] Resolved OMR DB container IP: {db_host}")
    except Exception:
        pass

    # Connect to DB
    print(f"[*] Connecting to database '{db_name}' on {db_host}:{db_port}...")
    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
        print(f"{Colors.GREEN}[+] Connected to database successfully!{Colors.ENDC}")
    except Exception as e:
        print(f"{Colors.FAIL}[X] Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        # 1. Find the Course ID of "2024 çağdaş Türk ve dünya tarihi"
        search_pattern = "%çağdaş%türk%dünya%tarihi%"
        print(f"[*] Searching for course matching: 'çağdaş Türk ve dünya tarihi'...")
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" ILIKE %s AND "IsDeleted" = False LIMIT 1;', (search_pattern,))
        course_res = cur.fetchone()

        if not course_res:
            # Fallback search with broader terms
            print(f"{Colors.WARNING}[!] Course not found with precise search, trying broader search...{Colors.ENDC}")
            cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" ILIKE %s AND "IsDeleted" = False LIMIT 1;', ("%çağdaş%",))
            course_res = cur.fetchone()

        if not course_res:
            print(f"{Colors.FAIL}[X] ERROR: Course '2024 çağdaş Türk ve dünya tarihi' could not be found in the database!{Colors.ENDC}")
            sys.exit(1)

        course_id, course_title = course_res
        print(f"{Colors.GREEN}[+] FOUND TARGET COURSE:{Colors.ENDC}")
        print(f"    - ID   : {Colors.BOLD}{course_id}{Colors.ENDC}")
        print(f"    - Title: {Colors.BOLD}{course_title}{Colors.ENDC}")

        # Get existing sessions count under this course to figure out starting Order
        cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False', (course_id,))
        max_order_res = cur.fetchone()
        next_order = (max_order_res[0] + 1) if max_order_res and max_order_res[0] is not None else 1
        print(f"[*] Next starting session order index: {next_order}")

        # Sort the record IDs chronologically based on their timestamp
        sorted_recordings = []
        for rid in RECORD_IDS:
            dt = parse_record_id_date(rid)
            sorted_recordings.append({
                "id": rid,
                "date": dt
            })
        
        # Sort chronologically (oldest first)
        sorted_recordings.sort(key=lambda x: x["date"])

        print(f"[*] Chronological order of videos to import:")
        for idx, item in enumerate(sorted_recordings, 1):
            date_str = item["date"].strftime("%d.%m.%Y %H:%M:%S") if item["date"] != datetime.datetime.min else "Bilinmiyor"
            print(f"    {idx}. {item['id']} ({date_str})")

        # Start importing
        sessions_created = 0
        sessions_skipped = 0

        for idx, item in enumerate(sorted_recordings):
            record_id = item["id"]
            dt = item["date"]
            
            # Format title
            date_str = dt.strftime("%d.%m.%Y") if dt != datetime.datetime.min else "Kayıt"
            recording_name = f"Çağdaş Türk ve Dünya Tarihi - {next_order}. Ders ({date_str})"
            video_url = f"https://canli.omurhoca.muro.click/playback/presentation/2.3/{record_id}"

            # Check if this video is already mapped in this course
            cur.execute('SELECT "Id" FROM "Sessions" WHERE "BbbMeetingId" = %s AND "CourseId" = %s AND "IsDeleted" = False;', (record_id, course_id))
            existing_session = cur.fetchone()

            if existing_session:
                print(f" {Colors.WARNING}[-] Video already exists in this course, skipping: {record_id}{Colors.ENDC}")
                sessions_skipped += 1
                continue

            session_id = str(uuid.uuid4())
            course_media_id = str(uuid.uuid4())
            
            created_at_str = dt.strftime("%Y-%m-%d %H:%M:%S") if dt != datetime.datetime.min else datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
            scheduled_start_str = created_at_str
            scheduled_end_str = (dt + datetime.timedelta(minutes=120)).strftime("%Y-%m-%d %H:%M:%S") if dt != datetime.datetime.min else None
            dur_mins = 120

            # Print action info
            action_prefix = "[EXECUTE]" if args.execute else "[DRY-RUN]"
            color_prefix = Colors.GREEN if args.execute else Colors.WARNING
            print(f" {color_prefix}{action_prefix} Mapped: '{recording_name}' -> URL: {video_url}{Colors.ENDC}")

            if args.execute:
                # 1. Insert into Sessions
                cur.execute(
                    'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                    (session_id, course_id, recording_name, video_url, record_id, False, created_at_str, 2, next_order, True, False, scheduled_start_str, scheduled_end_str, dur_mins)
                )

                # 2. Insert into CourseMedias
                cur.execute(
                    'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s)',
                    (course_media_id, course_id, session_id, next_order, datetime.datetime.utcnow())
                )
            
            next_order += 1
            sessions_created += 1

        print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"{Colors.GREEN}{Colors.BOLD}                      IMPORT SUMMARY")
        print(f"{Colors.GREEN}{Colors.BOLD}============================================================")
        print(f" [Course ID] Target Course ID        : {course_id}")
        print(f" [Course Title] Target Course Title  : {course_title}")
        print(f" [Video] Bound New Video Sessions    : {sessions_created}")
        print(f" [Video] Skipped Existing Sessions   : {sessions_skipped}")

        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Changes successfully committed to the database!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE (Dry-Run): No writes performed.{Colors.ENDC}")
            print("    To save changes to the database, run with '--execute':")
            print("    python3 ÖMÜR/import_cagdas_tarih.py --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED (Rollback changes): {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
