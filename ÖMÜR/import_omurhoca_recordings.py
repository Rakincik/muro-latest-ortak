import os
import sys
import re
import uuid
import datetime
import json
import argparse
import openpyxl

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
    # Strip numeric prefixes UNLESS they are followed by 'sayili' or 'sayılı'
    if not re.search(r'^\d+\s*sayı?l', s):
        s = re.sub(r'^\d+\s*', '', s)
    
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
        ".env.omr", "../.env.omr", "../../.env.omr",
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
                break # Stop at the first found env file
            except Exception:
                pass
    return config

def main():
    parser = argparse.ArgumentParser(description="OMURHOCA LMS - Okinar Recordings Import Tool")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO OMURHOCA - RECORDINGS IMPORT & BINDING TOOL      {Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # Load env
    env_config = load_env()
    db_host = args.host or env_config.get("DB_HOST", "localhost")
    db_port = args.port or int(env_config.get("DB_PORT", 5432))
    db_name = args.dbname or env_config.get("DB_NAME", "muro_demo")
    db_user = args.user or env_config.get("DB_USER", "muro_user")
    db_pass = args.password or env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Try discovering local Docker Postgres IP on server
    if not args.host:
        try:
            import subprocess
            result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
            ip = result.decode('utf-8').strip()
            if ip:
                db_host = ip
                print(f"[*] Resolved DB container IP: {db_host}")
        except Exception:
            pass

    # Paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    excel_path = os.path.join(script_dir, "Taşınacak Ders Listesi Ömür.xlsx")
    json_path = os.path.join(script_dir, "omurhoca.okinar.com_recordings.json")
    if not os.path.exists(json_path):
        json_path = os.path.join(script_dir, "..", "okinar dersler", "omurhoca.okinar.com_recordings.json")

    print(f"[*] Reading Excel file: '{excel_path}'...")
    if not os.path.exists(excel_path):
        print(f"{Colors.FAIL}[X] ERROR: Excel file not found at '{excel_path}'{Colors.ENDC}")
        sys.exit(1)

    wb = openpyxl.load_workbook(excel_path, data_only=True)
    sheet = wb.active
    rows = list(sheet.iter_rows(values_only=True))
    
    excel_courses = []
    for r in rows:
        if any(cell is not None for cell in r):
            dt, name, hsh = r[0], r[1], r[2]
            if name and hsh:
                excel_courses.append({
                    'name': name.strip(),
                    'norm_name': normalize(name),
                    'hash': hsh.strip()
                })
    print(f"    - Loaded {len(excel_courses)} courses from Excel.")

    print(f"[*] Reading JSON file: '{json_path}'...")
    if not os.path.exists(json_path):
        print(f"{Colors.FAIL}[X] ERROR: JSON recordings file not found at '{json_path}'{Colors.ENDC}")
        sys.exit(1)

    with open(json_path, 'r', encoding='utf-8') as f:
        recordings = json.load(f)
    print(f"    - Loaded {len(recordings)} recordings.")

    # Group recordings by normalized className
    recording_by_class = {}
    for rec in recordings:
        c_name = rec.get('className', '')
        norm_c_name = normalize(c_name)
        if norm_c_name not in recording_by_class:
            recording_by_class[norm_c_name] = []
        recording_by_class[norm_c_name].append(rec)

    # Connect to Database
    print(f"[*] Connecting to database '{db_name}' on {db_host}:{db_port}...")
    conn = None
    cur = None
    db_courses = {}
    db_sessions = set()
    no_db_mode = False

    try:
        import psycopg2
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        print(f"{Colors.GREEN}[+] Connected to database successfully!{Colors.ENDC}")
        cur = conn.cursor()
    except Exception as e:
        print(f"{Colors.WARNING}[!] Connection failed on {db_host}: {e}{Colors.ENDC}")
        print("[*] Retrying with localhost...")
        try:
            conn = psycopg2.connect(host="localhost", port=db_port, dbname=db_name, user=db_user, password=db_pass)
            print(f"{Colors.GREEN}[+] Connected on localhost successfully!{Colors.ENDC}")
            cur = conn.cursor()
        except Exception as e2:
            print(f"{Colors.WARNING}[!] DB Connection on localhost also failed: {e2}{Colors.ENDC}")
            print(f"{Colors.WARNING}[i] Falling back to LOCAL SIMULATION MODE (No database connection){Colors.ENDC}")
            no_db_mode = True

    try:
        if not no_db_mode and cur:
            # Cache existing courses
            cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
            db_courses = {normalize(r[1]): r[0] for r in cur.fetchall()}
            print(f"[*] Cached {len(db_courses)} existing courses from DB.")

            # Cache existing sessions
            cur.execute('SELECT "CourseId", "BbbMeetingId" FROM "Sessions" WHERE "IsDeleted" = False;')
            db_sessions = {(r[0], r[1]) for r in cur.fetchall()}
            print(f"[*] Cached {len(db_sessions)} existing sessions from DB.")
        else:
            print("[*] Running in mock database environment.")

        courses_created = 0
        sessions_created = 0
        sessions_skipped = 0

        # Import loop
        print(f"\n{Colors.BLUE}[*] Processing Excel Courses and Binding Recordings...{Colors.ENDC}")

        for course in excel_courses:
            class_name = course['name']
            class_norm = course['norm_name']
            
            # Find matched recordings in JSON
            matched_recs = recording_by_class.get(class_norm, [])
            if not matched_recs:
                print(f" {Colors.WARNING}[!] Warning: No recordings found in JSON for course '{class_name}'{Colors.ENDC}")
                continue

            # Ensure course exists in database
            c_id = db_courses.get(class_norm)
            if not c_id:
                # Create Course
                c_id = str(uuid.uuid4())
                if cur:
                    cur.execute(
                        'INSERT INTO "Courses" ("Id", "Title", "IsDeleted", "IsPublished", "CourseType", "Mode", "Order", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                        (c_id, class_name, False, True, 'Online', 'Offline', 0, datetime.datetime.utcnow())
                    )
                db_courses[class_norm] = c_id
                courses_created += 1
                print(f"    -> [+] Created/Simulated new Course: '{class_name}' (ID: {c_id})")

            for rec in matched_recs:
                record_id = rec.get('recordID', '').strip()
                if not record_id:
                    continue

                # Skip if already exists
                if (c_id, record_id) in db_sessions:
                    sessions_skipped += 1
                    continue

                recording_name = rec.get('recordingName') or rec.get('videoName') or f"{class_name}"
                recording_name = str(recording_name).strip()
                
                duration_str = rec.get('duration', '60')
                try:
                    dur_mins = int(duration_str) if duration_str else 60
                except ValueError:
                    dur_mins = 60

                # Parse start time from recordID timestamp (last part after '-')
                dt = None
                if '-' in record_id:
                    try:
                        ts_part = record_id.split('-')[-1]
                        if len(ts_part) >= 10:
                            ts_ms = int(ts_part[:13])
                            dt = datetime.datetime.utcfromtimestamp(ts_ms / 1000.0)
                    except Exception:
                        pass

                if dt:
                    created_at_str = dt.strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = created_at_str
                    end_dt = dt + datetime.timedelta(minutes=dur_mins)
                    scheduled_end_str = end_dt.strftime("%Y-%m-%d %H:%M:%S")
                else:
                    created_at_str = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = None
                    scheduled_end_str = None

                # Playback URL for omr.muro.click tenant
                video_url = f"https://canli.omr.muro.click/playback/presentation/2.3/{record_id}"
                session_id = str(uuid.uuid4())

                # Insert Session
                if cur:
                    cur.execute(
                        'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                        'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                        (session_id, c_id, recording_name, video_url, record_id, False, created_at_str, 'Ended', 0, True, False, scheduled_start_str, scheduled_end_str, dur_mins)
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
        print(f" [Video] Bound New Video Sessions    : {sessions_created}")
        print(f" [Video] Skipped Existing Sessions   : {sessions_skipped}")

        if args.execute and not no_db_mode and conn:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Changes successfully committed to the database!{Colors.ENDC}")
        else:
            if conn:
                conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE (Dry-Run): No writes performed.{Colors.ENDC}")
            if no_db_mode:
                print("    (Note: This was a local offline simulation as the DB was not reachable).")
            else:
                print("    To save changes to the database, run with '--execute':")
                print("    python import_omurhoca_recordings.py --execute")

    except Exception as e:
        if conn:
            conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED (Rollback changes): {e}{Colors.ENDC}")
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == '__main__':
    main()
