import os
import uuid
import datetime
import psycopg2

def load_env():
    config = {}
    env_paths = [".env", "../.env"]
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
    env = load_env()
    db_name = env.get("DB_NAME", "muro_demo")
    db_user = env.get("DB_USER", "muro_user")
    db_pass = env.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    
    db_host = "localhost"
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    course_id = "9f3d00b9-d267-4332-b4e4-1d95abad54c1"
    course_title = "DİVAN EDB (KAMP-TÜRKÇE) 2026"
    
    record_ids = [
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1783699430096",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1784909769613",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1784303959270",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1783094338594",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1780678751698",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1781279688701",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1780674000726",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1781283488001",
        "2a17e6d86f4891b8030cebe567119fed892d14fa-1781890960965"
    ]
    
    # Sort oldest to newest based on timestamps
    record_ids.sort(key=lambda x: int(x.split('-')[-1]))
    
    print(f"Connecting to database '{db_name}' on {db_host}...")
    conn = psycopg2.connect(host=db_host, port=5432, dbname=db_name, user=db_user, password=db_pass)
    cur = conn.cursor()
    
    try:
        cur.execute('SELECT "Id" FROM "Courses" WHERE "Id" = %s AND "IsDeleted" = False;', (course_id,))
        if not cur.fetchone():
            print(f"Error: Course with ID {course_id} not found!")
            return
            
        print(f"Importing {len(record_ids)} videos into '{course_title}'...")
        
        for idx, r_id in enumerate(record_ids, 1):
            cur.execute('SELECT "Id" FROM "Sessions" WHERE "BbbMeetingId" = %s AND "CourseId" = %s AND "IsDeleted" = False;', (r_id, course_id))
            if cur.fetchone():
                print(f" - Skip: {r_id} already exists in this course.")
                continue
                
            session_id = str(uuid.uuid4())
            title = f"{course_title} - Ders {idx}"
            video_url = f"https://canli.omr.muro.click/playback/presentation/2.3/{r_id}"
            
            ts_ms = int(r_id.split('-')[-1])
            dt = datetime.datetime.utcfromtimestamp(ts_ms / 1000.0)
            created_at = dt.strftime("%Y-%m-%d %H:%M:%S")
            
            # Insert Session
            cur.execute(
                'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                (session_id, course_id, title, video_url, r_id, False, created_at, 'Ended', idx, True, False, created_at, created_at, 60)
            )
            
            # Insert CourseMedia mapping
            course_media_id = str(uuid.uuid4())
            cur.execute(
                'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") '
                'VALUES (%s, %s, %s, %s, %s)',
                (course_media_id, course_id, session_id, idx, datetime.datetime.utcnow())
            )
            print(f" - Imported: '{title}' (ID: {session_id}, BBB ID: {r_id})")
            
        conn.commit()
        print("Success: All videos successfully imported and bound!")
    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
