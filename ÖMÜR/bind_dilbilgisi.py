import os
import sys
import xml.etree.ElementTree as ET
import uuid
import datetime
import html
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

# Hardcoded list of the 13 directories we saw on your disk
FOLDER_NAMES = [
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1783446598589",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1782841891227",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1782236932979",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1775584342956",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1776189660197",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1780422659861",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1777399086189",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1778003498191",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1778691571860",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1781851869433",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1776792235600",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1781027778738",
    "c960496adb917a9f04d3e689fc43561a0adf0fbe-1779213292120"
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

def parse_metadata(folder_path):
    metadata_path = os.path.join(folder_path, "metadata.xml")
    if not os.path.exists(metadata_path):
        return None, None
        
    try:
        tree = ET.parse(metadata_path)
        root = tree.getroot()
        
        # Parse meetingName
        meeting_name = None
        meeting_name_node = root.find(".//meetingName")
        if meeting_name_node is not None and meeting_name_node.text:
            meeting_name = html.unescape(meeting_name_node.text).strip()
            
        # Parse start_time (ms)
        start_time_ms = None
        start_time_node = root.find(".//start_time")
        if start_time_node is not None and start_time_node.text:
            try:
                start_time_ms = int(start_time_node.text.strip())
            except ValueError:
                pass
                
        return meeting_name, start_time_ms
    except Exception as e:
        print(f"  [!] metadata.xml parsing error: {e}")
        return None, None

def find_course(cur, target_id):
    cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Id" = %s AND "IsDeleted" = False LIMIT 1', (target_id,))
    res = cur.fetchone()
    if res:
        return res
    print(f"{Colors.FAIL}[X] Verilen Course ID ({target_id}) veritabanında bulunamadı!{Colors.ENDC}")
    return None

def main():
    parser = argparse.ArgumentParser(description="Bind Dil Bilgisi 2. Anlatım recordings")
    parser.add_argument("--course-id", required=True, help="Target Course UUID from database")
    parser.add_argument("--execute", action="store_true", help="Execute database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}       OMURHOCA - DILBILGISI 2. ANLATIM BINDING TOOL        {Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    config = load_env()
    db_name = config.get("DB_NAME", "muro_demo")
    db_user = config.get("DB_USER", "muro_user")
    db_pass = config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    db_host = "localhost"
    db_port = 5432

    # Discover Docker Postgres IP
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
            print(f"[*] Resolved DB container IP: {db_host}")
    except Exception:
        pass

    try:
        import psycopg2
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
        print(f"{Colors.GREEN}[+] Connected to database successfully!{Colors.ENDC}")
    except Exception as e:
        print(f"{Colors.FAIL}[X] Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        # Find Course
        course = find_course(cur, args.course_id)
        if not course:
            return
            
        course_id, course_title = course
        print(f"[*] Target Course: '{course_title}' (ID: {course_id})")

        # Get existing sessions and order
        cur.execute('SELECT "BbbMeetingId", "Id", "VideoUrl" FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False', (course_id,))
        existing_sessions_raw = cur.fetchall()
        existing_meetings = {r[0]: r[1] for r in existing_sessions_raw if r[0]}
        existing_urls = {r[1]: r[2] for r in existing_sessions_raw}
        
        cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False', (course_id,))
        max_order_res = cur.fetchone()
        next_order = (max_order_res[0] + 1) if max_order_res and max_order_res[0] is not None else 1
        
        # Scan directories
        pres_dir = "/var/bigbluebutton/published/presentation"
        prefix = "c960496adb917a9f04d3e689fc43561a0adf0fbe"
        
        matching_dirs = []
        using_fallback = False
        
        if os.path.exists(pres_dir):
            print(f"[*] Scanning '{pres_dir}' for folders starting with '{prefix}'...")
            all_dirs = os.listdir(pres_dir)
            matching_dirs = [d for d in all_dirs if d.startswith(prefix)]
            print(f"[*] Found {len(matching_dirs)} matching folders on disk.")
        else:
            print(f"{Colors.WARNING}[!] BBB dizini bulunamadı (LMS sunucusundasınız). Sabit liste kullanılıyor.{Colors.ENDC}")
            matching_dirs = FOLDER_NAMES
            using_fallback = True
            
        recordings_to_process = []
        
        for folder_name in matching_dirs:
            folder_path = os.path.join(pres_dir, folder_name)
            
            title, ts_ms = None, None
            if not using_fallback:
                title, ts_ms = parse_metadata(folder_path)
            
            # Parse timestamp from folder name
            if not ts_ms:
                try:
                    ts_ms = int(folder_name.split("-")[-1])
                except:
                    ts_ms = int(datetime.datetime.utcnow().timestamp() * 1000)
            
            rec_dt = datetime.datetime.utcfromtimestamp(ts_ms / 1000.0)
            
            if not title:
                # E.g. "DİL BİLGİSİ 2. ANLATIM 2026 - 30.06.2026"
                title = f"{course_title} - {rec_dt.strftime('%d.%m.%Y')}"
                    
            recordings_to_process.append({
                'folder_name': folder_name,
                'title': title,
                'ts_ms': ts_ms,
                'path': folder_path,
                'is_new': folder_name not in existing_meetings
            })
            
        if not recordings_to_process:
            print(f"{Colors.GREEN}[+] No matching folders to process!{Colors.ENDC}")
            return
            
        # Sort chronologically by start time
        recordings_to_process.sort(key=lambda x: x['ts_ms'])
        
        new_count = sum(1 for r in recordings_to_process if r['is_new'])
        exist_count = len(recordings_to_process) - new_count
        
        print(f"[*] Processing: {new_count} new recordings, {exist_count} existing recordings.")

        for rec in recordings_to_process:
            rec_id = rec['folder_name']
            rec_title = rec['title']
            rec_dt = datetime.datetime.utcfromtimestamp(rec['ts_ms'] / 1000.0)
            video_url = f"https://canli.omurhoca.muro.click/playback/presentation/2.3/{rec_id}"
            
            if rec['is_new']:
                session_id = str(uuid.uuid4())
                course_media_id = str(uuid.uuid4())
                
                print(f"  {Colors.GREEN}+ [NEW] [{rec_dt.strftime('%d.%m.%Y %H:%M')}] '{rec_title}' (Order: {next_order}){Colors.ENDC}")
                
                if args.execute:
                    # Insert Session
                    cur.execute("""
                        INSERT INTO "Sessions" 
                        ("Id", "CourseId", "Title", "VideoUrl", "Order", "Status", "RecordingEnabled", "IsDeleted", "IsFree", "CreatedAt", "BbbMeetingId", "DurationMinutes")
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (session_id, course_id, rec_title, video_url, next_order, 2, True, False, False, rec_dt, rec_id, 60))
                    
                    # Insert CourseMedia mapping
                    cur.execute("""
                        INSERT INTO "CourseMedias"
                        ("Id", "CourseId", "SessionId", "OrderIndex", "CustomTitle", "CreatedAt")
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (course_media_id, course_id, session_id, next_order, rec_title, rec_dt))
                    next_order += 1
            else:
                session_id = existing_meetings[rec_id]
                current_url = existing_urls.get(session_id, "")
                
                # Check if we need to correct URL
                if current_url != video_url:
                    print(f"  {Colors.BLUE}~ [UPDATE LINK] '{rec_title}' -> {video_url}{Colors.ENDC}")
                    if args.execute:
                        cur.execute('UPDATE "Sessions" SET "VideoUrl" = %s WHERE "Id" = %s', (video_url, session_id))
                else:
                    print(f"  [OK] '{rec_title}' is already correct.")

            # Apply permissions if executing and files exist locally
            if args.execute and os.path.exists(rec['path']):
                try:
                    os.system(f"chown -R bigbluebutton:bigbluebutton '{rec['path']}'")
                    os.system(f"find '{rec['path']}' -type d -exec chmod 755 {{}} \;")
                    os.system(f"find '{rec['path']}' -type f -exec chmod 644 {{}} \;")
                except Exception as pe:
                    print(f"    [!] Failed to set permissions for {rec_id}: {pe}")
            
        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Successfully bound new videos, updated links, and set database entries!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE (Dry-Run): No writes performed.{Colors.ENDC}")
            print(f"    To execute this on the database for real, run with --execute:")
            print(f"    python3 bind_dilbilgisi.py --course-id {course_id} --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED: {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
