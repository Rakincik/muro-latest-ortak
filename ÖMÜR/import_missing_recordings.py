import os
import sys
import json
import uuid
import datetime
import psycopg2

def load_env():
    config = {}
    env_paths = [
        "/opt/omr/.env.omr", ".env.omr", "../.env.omr",
        ".env", "../.env"
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

def main():
    json_path = None
    possible_paths = [
        "missing_recordings.json",
        "missing_recordings (1).json",
        "missing_recordings(1).json"
    ]
    for p in possible_paths:
        if os.path.exists(p):
            json_path = p
            break
        # Check script dir
        script_dir = os.path.dirname(os.path.abspath(__file__))
        sd_path = os.path.join(script_dir, p)
        if os.path.exists(sd_path):
            json_path = sd_path
            break

    if not json_path:
        print(f"Error: missing_recordings.json or missing_recordings (1).json not found!")
        sys.exit(1)

    print(f"[*] Reading JSON file: '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    env_config = load_env()
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    db_host = "localhost"
    db_port = 5432

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

    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
        print("[+] Connected to OMR database successfully.")
    except Exception as e:
        print(f"[-] Connection failed: {e}")
        sys.exit(1)

    try:
        sessions_created = 0
        
        for item in data:
            cname = item['courseName']
            recs = item['recordings']
            
            # Get course ID from DB by matching name
            cur.execute('SELECT "Id" FROM "Courses" WHERE "Title" = %s AND "IsDeleted" = False;', (cname,))
            row = cur.fetchone()
            if not row:
                print(f"[-] Course '{cname}' not found in Muro database! Skipping...")
                continue
            c_id = row[0]
            
            print(f"[*] Processing {len(recs)} recordings for '{cname}' (ID: {c_id})...")
            
            # Check existing sessions for this course
            cur.execute('SELECT "BbbMeetingId" FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False;', (c_id,))
            existing_sessions = set(r[0] for r in cur.fetchall())

            for rec in recs:
                record_id = rec['recordID']
                video_name = rec['videoName']
                
                if record_id in existing_sessions:
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

                dur_mins = 60
                if dt:
                    created_at_str = dt.strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = created_at_str
                    end_dt = dt + datetime.timedelta(minutes=dur_mins)
                    scheduled_end_str = end_dt.strftime("%Y-%m-%d %H:%M:%S")
                else:
                    created_at_str = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = None
                    scheduled_end_str = None

                video_url = f"https://canli.omr.muro.click/playback/presentation/2.3/{record_id}"
                session_id = str(uuid.uuid4())

                # Insert Session
                cur.execute(
                    'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                    (session_id, c_id, video_name, video_url, record_id, False, created_at_str, 'Ended', 0, True, False, scheduled_start_str, scheduled_end_str, dur_mins)
                )

                # Insert CourseMedia mapping
                course_media_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s)',
                    (course_media_id, c_id, session_id, 0, datetime.datetime.utcnow())
                )
                sessions_created += 1

        conn.commit()
        print(f"[+] Successfully inserted {sessions_created} video sessions into Muro database!")

    except Exception as e:
        conn.rollback()
        print(f"[-] Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
