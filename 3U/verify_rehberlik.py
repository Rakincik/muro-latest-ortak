import psycopg2
import os

def load_env():
    config = {}
    env_paths = [".env.3u", ".env"]
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
    env = load_env()
    db_host = "localhost"
    db_port = "5432"
    db_name = env.get("DB_NAME", "muro_demo")
    db_user = env.get("DB_USER", "muro_user")
    db_pass = env.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    try:
        conn = psycopg2.connect(host=db_host, port=db_port, database=db_name, user=db_user, password=db_pass)
        cursor = conn.cursor()
    except Exception as e:
        print(f"Connection failed: {e}")
        return

    # Check REHBERLİK 4
    cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" = \'REHBERLİK 4\' AND "IsDeleted" = False;')
    course = cursor.fetchone()
    if course:
        cid, title = course
        print(f"Course: {title} | ID: {cid}")
        
        # Check sessions count
        cursor.execute('SELECT COUNT(*) FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False;', (cid,))
        s_cnt = cursor.fetchone()[0]
        print(f"Sessions count for {title} in DB: {s_cnt}")
        
        # Print actual sessions
        cursor.execute('SELECT "Id", "Title", "BbbMeetingId", "IsDeleted" FROM "Sessions" WHERE "CourseId" = %s LIMIT 5;', (cid,))
        sessions = cursor.fetchall()
        for s in sessions:
            print(f"  - Session ID: {s[0]} | Title: {s[1]} | BbbMeetingId: {s[2]} | Deleted: {s[3]}")
    else:
        print("Course 'REHBERLİK 4' not found in database!")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
