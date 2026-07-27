import os
import sys
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
    env_config = load_env()
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    db_host = "localhost"
    db_port = 5432

    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
    except Exception as e:
        print(f"Connection failed: {e}")
        sys.exit(1)

    try:
        cur.execute('SELECT COUNT(*) FROM "Sessions";')
        total_sessions = cur.fetchone()[0]
        
        cur.execute('SELECT COUNT(*) FROM "CourseMedias";')
        total_medias = cur.fetchone()[0]

        print(f"Total sessions in DB: {total_sessions}")
        print(f"Total course medias in DB: {total_medias}")

        cur.execute("""
            SELECT c."Title", COUNT(s."Id") 
            FROM "Courses" c
            LEFT JOIN "Sessions" s ON c."Id" = s."CourseId"
            GROUP BY c."Title"
            ORDER BY COUNT(s."Id") DESC;
        """)
        courses = cur.fetchall()
        print("\nCourses and their session counts in DB:")
        for title, count in courses:
            print(f"  - {title}: {count} sessions")

    except Exception as e:
        print(f"Query failed: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
