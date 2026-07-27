import os
import sys
import argparse
import psycopg2

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
    parser = argparse.ArgumentParser(description="MURO LMS MVZ - Cleanup Duplicate Courses")
    parser.add_argument("--execute", action="store_true", help="Execute deletion")
    args = parser.parse_args()

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

    print(f"{Colors.CYAN}=== DUPLICATE COURSES CLEANUP ==={Colors.ENDC}")
    
    # Select courses created today
    query = """
        SELECT "Id", "Title", "CreatedAt" 
        FROM "Courses" 
        WHERE "CreatedAt" >= '2026-07-26 00:00:00' 
        ORDER BY "CreatedAt" DESC;
    """
    cur.execute(query)
    rows = cur.fetchall()
    
    print(f"[*] Found {len(rows)} courses created today:")
    for row in rows:
        print(f" - Title: '{row[1]}' (Id: {row[0]}, CreatedAt: {row[2]})")

    if not rows:
        print("[i] No duplicate courses found to delete.")
        cur.close()
        conn.close()
        return

    if args.execute:
        print(f"\n{Colors.WARNING}[!] Deleting {len(rows)} duplicate courses...{Colors.ENDC}")
        # Delete from Courses (any mapping is already cleared or we handle cascade if needed)
        for row in rows:
            # Delete mappings first just in case
            cur.execute('DELETE FROM "CourseMedias" WHERE "CourseId" = %s;', (row[0],))
            cur.execute('DELETE FROM "Sessions" WHERE "CourseId" = %s;', (row[0],))
            cur.execute('DELETE FROM "Courses" WHERE "Id" = %s;', (row[0],))
        conn.commit()
        print(f"{Colors.GREEN}[+] Deletion complete. Database is clean!{Colors.ENDC}")
    else:
        print(f"\n{Colors.WARNING}[i] DRY-RUN: Run with --execute to delete these duplicate courses from the database:{Colors.ENDC}")
        print("python3 cleanup_mvz_courses.py --execute")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
