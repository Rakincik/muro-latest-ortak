import os
import sys
import re
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
    match = re.search(r'(?:Klasör:\s*|^)([a-zA-Z0-9_-]+-\d{10,13})', line)
    if match:
        return match.group(1).strip()
    return None

def main():
    env_config = load_env()
    db_host = env_config.get("DB_HOST", "localhost")
    db_port = int(env_config.get("DB_PORT", 5432))
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Resolve local docker IP if running on server
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    recent_file = "recent_folders.txt"
    if not os.path.exists(recent_file):
        print(f"{Colors.FAIL}[X] ERROR: '{recent_file}' not found!{Colors.ENDC}")
        sys.exit(1)

    record_ids = []
    with open(recent_file, "r", encoding="utf-8") as f:
        for line in f:
            rid = extract_record_id(line)
            if rid:
                record_ids.append(rid)

    if not record_ids:
        print(f"{Colors.FAIL}[X] ERROR: No valid record IDs found in '{recent_file}'!{Colors.ENDC}")
        sys.exit(1)

    print(f"[*] Connecting to database to check {len(record_ids)} records...")
    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
    except Exception as e:
        print(f"{Colors.FAIL}[X] Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        cur.execute("""
            SELECT s."BbbMeetingId", c."Title", s."Title", s."CreatedAt", s."VideoUrl"
            FROM "Sessions" s
            JOIN "Courses" c ON s."CourseId" = c."Id"
            WHERE s."BbbMeetingId" = ANY(%s) AND s."IsDeleted" = False
            ORDER BY c."Title", s."Title";
        """, (record_ids,))
        
        rows = cur.fetchall()
        print(f"\n{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"{Colors.CYAN}{Colors.BOLD}            MEVCUT VİDEOLARIN BAĞLI OLDUĞU KURSLAR           {Colors.ENDC}")
        print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
        
        if not rows:
            print("[i] Bu listedeki kayıtlardan hiçbirisi veritabanında bulunamadı.")
        else:
            current_course = None
            for bbb_id, course_title, session_title, created_at, video_url in rows:
                if course_title != current_course:
                    current_course = course_title
                    print(f"\n{Colors.GREEN}{Colors.BOLD}[KURS]: {current_course}{Colors.ENDC}")
                print(f"  - Ders: {session_title}")
                print(f"    ID  : {bbb_id}")
                print(f"    Tarih: {created_at}")
                print(f"    URL : {video_url}")

        print(f"\n{Colors.CYAN}============================================================{Colors.ENDC}")
        print(f"Toplam {len(rows)} adet eşleşme bulundu.")

    except Exception as e:
        print(f"{Colors.FAIL}[X] Query failed: {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
