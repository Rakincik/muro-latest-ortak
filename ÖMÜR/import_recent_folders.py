import os
import sys
import re
import uuid
import datetime
import json
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

def normalize(s):
    if not s:
        return ''
    s = str(s).lower().strip()
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

def extract_record_id(line):
    line = line.strip()
    if not line:
        return None
    # Matches record IDs like "f4c633a7df48f6c475ca3a58772670f89123dc26-1779126771599"
    # Even if prefixed with "Klasör: " or followed by " | ..."
    match = re.search(r'(?:Klasör:\s*|^)([a-zA-Z0-9_-]+-\d{10,13})', line)
    if match:
        return match.group(1).strip()
    return None

def main():
    parser = argparse.ArgumentParser(description="OMURHOCA LMS - Import Recent Folders Tool")
    parser.add_argument("--file", default="recent_folders.txt", help="Path to file containing list of folders")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}    MURO OMURHOCA - IMPORT & BIND RECENT UPLOADED FOLDERS   {Colors.ENDC}")
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

    # Read folder list
    if not os.path.exists(args.file):
        print(f"{Colors.FAIL}[X] ERROR: Input file '{args.file}' not found!{Colors.ENDC}")
        print(f"    Please create '{args.file}' with the list of folder names or output.")
        sys.exit(1)

    record_ids = []
    with open(args.file, "r", encoding="utf-8") as f:
        for line in f:
            rid = extract_record_id(line)
            if rid:
                record_ids.append(rid)

    if not record_ids:
        print(f"{Colors.FAIL}[X] ERROR: No valid record IDs found in '{args.file}'!{Colors.ENDC}")
        sys.exit(1)

    print(f"[*] Found {len(record_ids)} record IDs to process from '{args.file}'.")

    # Read recordings JSON metadata
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "omurhoca.okinar.com_recordings.json")
    if not os.path.exists(json_path):
        json_path = os.path.join(script_dir, "..", "okinar dersler", "omurhoca.okinar.com_recordings.json")

    if not os.path.exists(json_path):
        print(f"{Colors.FAIL}[X] ERROR: Recordings JSON file not found at '{json_path}'{Colors.ENDC}")
        sys.exit(1)

    print(f"[*] Reading JSON file: '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        all_recordings = json.load(f)

    # Map recordID to details
    recordings_map = {rec['recordID'].strip(): rec for rec in all_recordings if 'recordID' in rec}
    print(f"[*] Loaded {len(recordings_map)} metadata entries from JSON.")

    # Map prefix to className dynamically
    prefix_to_class = {}
    for rec in all_recordings:
        rid = rec.get('recordID', '').strip()
        if rid and '-' in rid:
            prefix = rid.split('-')[0]
            cname = rec.get('className', '').strip()
            if prefix and cname:
                prefix_to_class[prefix] = cname
    print(f"[*] Generated {len(prefix_to_class)} dynamic prefix mappings from JSON.")

    # Connect to DB
    print(f"[*] Connecting to database '{db_name}' on {db_host}:{db_port}...")
    try:
        import psycopg2
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
        print(f"{Colors.GREEN}[+] Connected to database successfully!{Colors.ENDC}")
    except Exception as e:
        print(f"{Colors.FAIL}[X] Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        # Cache existing courses (Title -> Id)
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses = {normalize(r[1]): r[0] for r in cur.fetchall()}
        
        # Cache reverse course titles to get exact case
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses_exact = {r[0]: r[1] for r in cur.fetchall()}
        print(f"[*] Cached {len(db_courses)} existing courses from DB.")

        # Cache existing sessions (CourseId, BbbMeetingId)
        cur.execute('SELECT "CourseId", "BbbMeetingId" FROM "Sessions" WHERE "IsDeleted" = False;')
        db_sessions = {(r[0], r[1]) for r in cur.fetchall()}
        print(f"[*] Cached {len(db_sessions)} existing sessions from DB.")

        sessions_created = 0
        sessions_skipped = 0
        courses_created = 0

        for record_id in record_ids:
            rec = recordings_map.get(record_id)
            if rec:
                class_name = rec.get('className', '').strip()
                recording_name = rec.get('recordingName') or rec.get('videoName') or class_name
                recording_name = str(recording_name).strip()
                duration_str = rec.get('duration', '60')
            else:
                # Fallback to prefix matching for newer recordings not in JSON snapshot
                prefix = record_id.split('-')[0] if '-' in record_id else None
                class_name = prefix_to_class.get(prefix) if prefix else None
                if not class_name:
                    print(f" {Colors.WARNING}[!] Warning: Record ID '{record_id}' has no matching prefix/course in JSON! Skipping...{Colors.ENDC}")
                    continue
                
                # Parse date from timestamp for the title
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
                    date_str = dt.strftime("%d.%m.%Y")
                else:
                    date_str = datetime.datetime.utcnow().strftime("%d.%m.%Y")
                
                recording_name = f"{class_name} - {date_str}"
                duration_str = "60"
                print(f" [*] Prefix matched: '{record_id}' -> Linked to '{class_name}' as '{recording_name}'")

            class_norm = normalize(class_name)
            try:
                dur_mins = int(duration_str) if duration_str else 60
            except ValueError:
                dur_mins = 60

            # Get or create course ID
            c_id = db_courses.get(class_norm)
            if not c_id:
                # Create Course if not exists
                c_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "Courses" ("Id", "Title", "IsDeleted", "IsPublished", "CourseType", "Mode", "Order", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                    (c_id, class_name, False, True, 'Online', 'Offline', 0, datetime.datetime.utcnow())
                )
                db_courses[class_norm] = c_id
                db_courses_exact[c_id] = class_name
                courses_created += 1
                print(f"    -> [+] Created new Course: '{class_name}' (ID: {c_id})")

            # Check if session is already mapped
            if (c_id, record_id) in db_sessions:
                sessions_skipped += 1
                continue

            # Parse start time from recordID timestamp
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

            video_url = f"https://canli.omurhoca.muro.click/playback/presentation/2.3/{record_id}"
            session_id = str(uuid.uuid4())

            # Insert Session
            cur.execute(
                'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                (session_id, c_id, recording_name, video_url, record_id, False, created_at_str, 2, 0, True, False, scheduled_start_str, scheduled_end_str, dur_mins)
            )

            # Insert CourseMedia mapping
            course_media_id = str(uuid.uuid4())
            cur.execute(
                'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") '
                'VALUES (%s, %s, %s, %s, %s)',
                (course_media_id, c_id, session_id, 0, datetime.datetime.utcnow())
            )

            print(f"    -> [+] Linked Video: '{recording_name}' to Course: '{db_courses_exact[c_id]}'")
            db_sessions.add((c_id, record_id))
            sessions_created += 1

        print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"{Colors.GREEN}{Colors.BOLD}                      IMPORT SUMMARY")
        print(f"{Colors.GREEN}{Colors.BOLD}============================================================")
        print(f" [Course] Created New Courses Count  : {courses_created}")
        print(f" [Video] Bound New Video Sessions    : {sessions_created}")
        print(f" [Video] Skipped Existing Sessions   : {sessions_skipped}")

        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Changes successfully committed to the database!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE (Dry-Run): No writes performed.{Colors.ENDC}")
            print("    To save changes to the database, run with '--execute':")
            print("    python3 import_recent_folders.py --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED (Rollback changes): {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
