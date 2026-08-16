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

def main():
    parser = argparse.ArgumentParser(description="Bind recordings to Halk Edebiyatı Course")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}       OMURHOCA - HALK EDEBIYATI RECORDINGS BINDING TOOL     {Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    config = load_env()
    db_name = config.get("DB_NAME", "muro_demo")
    db_user = config.get("DB_USER", "muro_user")
    db_pass = config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    db_host = "localhost"
    db_port = 5432

    # Try resolving OMR container IP
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
        # 1. Find Course ID for 'HALK EDB 2026 (TÜRKÇE)'
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" ILIKE %s AND "IsDeleted" = False LIMIT 1', ('%HALK EDB 2026%',))
        course = cur.fetchone()
        if not course:
            print(f"{Colors.FAIL}[X] ERROR: Course 'HALK EDB 2026' not found in database!{Colors.ENDC}")
            return
            
        course_id, course_title = course
        print(f"[*] Target Course: '{course_title}' (ID: {course_id})")

        # 2. Get current sessions and order index
        cur.execute('SELECT "BbbMeetingId" FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False', (course_id,))
        existing_meetings = {r[0] for r in cur.fetchall() if r[0]}
        
        cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False', (course_id,))
        max_order_res = cur.fetchone()
        next_order = (max_order_res[0] + 1) if max_order_res and max_order_res[0] is not None else 1
        
        # 3. Scan directories
        pres_dir = "/var/bigbluebutton/published/presentation"
        prefix = "b1c9c6f3d47e2985590693f95350eaa94901ce86"
        
        if not os.path.exists(pres_dir):
            print(f"{Colors.FAIL}[X] ERROR: BBB presentation directory '{pres_dir}' not found on this machine!{Colors.ENDC}")
            return
            
        print(f"[*] Scanning '{pres_dir}' for folders starting with '{prefix}'...")
        all_dirs = os.listdir(pres_dir)
        matching_dirs = [d for d in all_dirs if d.startswith(prefix)]
        
        print(f"[*] Found {len(matching_dirs)} matching folders on disk.")
        
        recordings_to_bind = []
        
        for folder_name in matching_dirs:
            folder_path = os.path.join(pres_dir, folder_name)
            
            # Skip if already exists in DB
            if folder_name in existing_meetings:
                continue
                
            title, ts_ms = parse_metadata(folder_path)
            
            # Fallback title & time from folder name
            if not title:
                title = f"Canlı Ders Oturumu"
            if not ts_ms:
                try:
                    ts_ms = int(folder_name.split("-")[-1])
                except:
                    ts_ms = int(datetime.datetime.utcnow().timestamp() * 1000)
                    
            recordings_to_bind.append({
                'folder_name': folder_name,
                'title': title,
                'ts_ms': ts_ms,
                'path': folder_path
            })
            
        if not recordings_to_bind:
            print(f"{Colors.GREEN}[+] All found folders are already mapped to the course. Nothing to do!{Colors.ENDC}")
            return
            
        # Sort recordings chronologically by start time
        recordings_to_bind.sort(key=lambda x: x['ts_ms'])
        print(f"[*] {len(recordings_to_bind)} new recordings will be bound and sorted.")

        # Bind recordings
        for idx, rec in enumerate(recordings_to_bind):
            rec_id = rec['folder_name']
            rec_title = rec['title']
            rec_dt = datetime.datetime.utcfromtimestamp(rec['ts_ms'] / 1000.0)
            
            # Generate UUIDs
            session_id = str(uuid.uuid4())
            course_media_id = str(uuid.uuid4())
            
            video_url = f"https://canli.omurhoca.muro.click/playback/presentation/2.3/{rec_id}"
            
            print(f"  + Binding: [{rec_dt.strftime('%d.%m.%Y %H:%M')}] '{rec_title}' (Order: {next_order})")
            
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
                
                # Fix permissions of the folder automatically
                try:
                    os.system(f"chown -R bigbluebutton:bigbluebutton '{rec['path']}'")
                    os.system(f"find '{rec['path']}' -type d -exec chmod 755 {{}} \;")
                    os.system(f"find '{rec['path']}' -type f -exec chmod 644 {{}} \;")
                except Exception as pe:
                    print(f"    [!] Failed to set permissions for {rec_id}: {pe}")
            
            next_order += 1
            
        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Bound {len(recordings_to_bind)} new videos to '{course_title}' and set permissions successfully!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE (Dry-Run): No database entries written, no permissions changed.{Colors.ENDC}")
            print(f"    To run this for real and bind the videos, run the command with --execute:")
            print(f"    python3 bind_halk_edb.py --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED: {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
