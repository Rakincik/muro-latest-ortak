import os
import sys
import psycopg2

def load_env():
    config = {}
    env_paths = [".env.mvz", ".env"]
    for ep in env_paths:
        if os.path.exists(ep):
            with open(ep, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#") and "=" in line:
                        k, v = line.split("=", 1)
                        config[k.strip()] = v.strip()
    return config

def main():
    env_config = load_env()
    db_host = "localhost"
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_mvz_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    conn = psycopg2.connect(host=db_host, port=5432, dbname=db_name, user=db_user, password=db_pass)
    cur = conn.cursor()

    print("=== DATABASE INSPECT ===")
    
    cur.execute('SELECT COUNT(*) FROM "Courses" WHERE "IsDeleted" = False;')
    total_courses = cur.fetchone()[0]
    print(f"Total active Courses in DB: {total_courses}")

    cur.execute('SELECT COUNT(*) FROM "Sessions" WHERE "IsDeleted" = False;')
    total_sessions = cur.fetchone()[0]
    print(f"Total active Sessions in DB: {total_sessions}")

    cur.execute('SELECT COUNT(*) FROM "CourseMedias";')
    total_mappings = cur.fetchone()[0]
    print(f"Total CourseMedias mappings: {total_mappings}")

    print("\n=== COURSES WITH SESSIONS ===")
    query = """
        SELECT c."Id", c."Title", COUNT(cm."Id") as session_count
        FROM "Courses" c
        LEFT JOIN "CourseMedias" cm ON c."Id" = cm."CourseId"
        WHERE c."IsDeleted" = False
        GROUP BY c."Id", c."Title"
        HAVING COUNT(cm."Id") > 0
        ORDER BY session_count DESC;
    """
    cur.execute(query)
    rows = cur.fetchall()
    if not rows:
        print("No courses have mapped sessions!")
    for row in rows:
        print(f"Course: '{row[1]}' (Id: {row[0]}) -> {row[2]} sessions")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
