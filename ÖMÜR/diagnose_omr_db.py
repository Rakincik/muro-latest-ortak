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
    print("============================================================")
    print("            MURO OMR (ÖMÜR HOCA) - DATABASE DIAGNOSTIC       ")
    print("============================================================")

    env_config = load_env()
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    db_host = "localhost"
    db_port = 5432

    # Try discovering local Docker Postgres IP on server
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
        print("[+] Connected to OMR database successfully!")
    except Exception as e:
        print(f"[X] DB Connection failed: {e}")
        sys.exit(1)

    try:
        # Course and Session stats
        cur.execute('SELECT COUNT(*) FROM "Courses" WHERE "IsDeleted" = False;')
        courses_count = cur.fetchone()[0]

        cur.execute('SELECT COUNT(*) FROM "Sessions" WHERE "IsDeleted" = False;')
        sessions_count = cur.fetchone()[0]

        cur.execute('SELECT COUNT(*) FROM "Groups" WHERE "IsDeleted" = False;')
        groups_count = cur.fetchone()[0]

        cur.execute('SELECT COUNT(*) FROM "GroupMembers" WHERE "Status" = \'active\';')
        members_count = cur.fetchone()[0]

        print("\n--- GENERAL STATS ---")
        print(f" * Active Courses Count      : {courses_count}")
        print(f" * Active Sessions (Videos)  : {sessions_count}")
        print(f" * Active Groups Count       : {groups_count}")
        print(f" * Active Group Memberships  : {members_count}")

        # Check courses with 0 sessions
        cur.execute("""
            SELECT c."Title", COUNT(s."Id") 
            FROM "Courses" c 
            LEFT JOIN "Sessions" s ON c."Id" = s."CourseId" AND s."IsDeleted" = False
            WHERE c."IsDeleted" = False 
            GROUP BY c."Title" 
            HAVING COUNT(s."Id") = 0 
            ORDER BY c."Title" ASC;
        """)
        empty_courses = cur.fetchall()
        print(f"\n--- COURSES WITH 0 VIDEOS ({len(empty_courses)} total) ---")
        if empty_courses:
            print(" Listing first 15 empty courses in OMR:")
            for ec_title, _ in empty_courses[:15]:
                print(f"  - {ec_title}")
            if len(empty_courses) > 15:
                print(f"  ... and {len(empty_courses) - 15} more empty courses.")
        else:
            print("  - [SUCCESS] All OMR courses have at least 1 video!")

        # Check total unique meeting IDs mapped to sessions
        cur.execute('SELECT COUNT(DISTINCT "BbbMeetingId") FROM "Sessions" WHERE "IsDeleted" = False AND "BbbMeetingId" IS NOT NULL;')
        unique_meetings = cur.fetchone()[0]
        print(f"\n--- SESSION MAPPING ANALYSIS ---")
        print(f" * Unique BBB Meeting IDs in Sessions: {unique_meetings}")
        print(f" * (Expected count: ~1327 folders/meetings from list)")

    except Exception as e:
        print(f"[X] Query failed: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
