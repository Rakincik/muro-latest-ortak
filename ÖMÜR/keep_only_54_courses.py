import os
import sys
import openpyxl
import psycopg2
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
    parser = argparse.ArgumentParser(description="OMR DB Course Filter Tool")
    parser.add_argument("--execute", action="store_true", help="Soft-delete all other courses in database")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO OMR - KEEP ONLY 54 COURSES MIGRATION TOOL       {Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # 1. Read course list from Excel
    script_dir = os.path.dirname(os.path.abspath(__file__))
    excel_path = os.path.join(script_dir, "Taşınacak Ders Listesi Ömür.xlsx")
    
    if not os.path.exists(excel_path):
        print(f"{Colors.FAIL}[X] ERROR: Excel file '{excel_path}' not found!{Colors.ENDC}")
        sys.exit(1)

    print(f"[*] Reading courses from '{excel_path}'...")
    wb = openpyxl.load_workbook(excel_path, data_only=True)
    sheet = wb.active
    rows = list(sheet.iter_rows(values_only=True))

    excel_courses = []
    # Assumes Column B (index 1) has the course names. Starting from row 1 or 2.
    # Let's clean and filter empty values.
    for r in rows:
        val = r[1] # Column B
        if val and str(val).strip() and str(val).strip() != "Ders Adı" and str(val).strip() != "ders":
            excel_courses.append(str(val).strip())

    print(f"[+] Found {len(excel_courses)} courses in the Excel file.")
    print("Listing courses from Excel:")
    for idx, cname in enumerate(sorted(excel_courses)):
        print(f"  {idx+1}. {cname}")

    # 2. Database Connection
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

    print(f"[*] Connecting to OMR database on {db_host}:{db_port}...")
    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
        print(f"{Colors.GREEN}[+] Connected successfully!{Colors.ENDC}")
    except Exception as e:
        print(f"{Colors.FAIL}[X] Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        # Get active courses in DB
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses = cur.fetchall()
        db_courses_map = {r[1].strip(): r[0] for r in db_courses}
        
        print(f"\n[*] Database has {len(db_courses)} active courses.")

        # Exact title comparison
        excel_titles_set = set(excel_courses)
        
        courses_to_keep = []
        courses_to_delete = []

        for title, uuid_id in db_courses_map.items():
            if title in excel_titles_set:
                courses_to_keep.append((title, uuid_id))
            else:
                courses_to_delete.append((title, uuid_id))

        print(f"\n{Colors.GREEN}[+] Matches found in DB (to be kept): {len(courses_to_keep)} courses{Colors.ENDC}")
        for t, uid in sorted(courses_to_keep):
            print(f"  Keep: {t} (ID: {uid})")

        print(f"\n{Colors.WARNING}[!] No match in Excel (to be marked as deleted): {len(courses_to_delete)} courses{Colors.ENDC}")
        for t, uid in sorted(courses_to_delete):
            print(f"  Delete: {t} (ID: {uid})")

        # Check if there are Excel courses that were not found in DB (just for info)
        missing_in_db = [c for c in excel_courses if c not in db_courses_map]
        if missing_in_db:
            print(f"\n{Colors.WARNING}[!] Courses in Excel but NOT found in DB: {len(missing_in_db)}{Colors.ENDC}")
            for c in sorted(missing_in_db):
                print(f"  Missing: {c}")

        if not args.execute:
            print(f"\n{Colors.WARNING}[i] DRY-RUN MODE: No database changes made.{Colors.ENDC}")
            print("    To soft-delete these courses, run with '--execute':")
            print("    python ÖMÜR/keep_only_54_courses.py --execute")
        else:
            print(f"\n[*] Executing HARD delete in database...")
            delete_ids = [uid for _, uid in courses_to_delete]
            
            if delete_ids:
                # 1. Discover all tables that have foreign keys pointing to "Courses"
                cur.execute("""
                    SELECT
                        tc.table_name, 
                        kcu.column_name
                    FROM 
                        information_schema.table_constraints AS tc 
                        JOIN information_schema.key_column_usage AS kcu
                          ON tc.constraint_name = kcu.constraint_name
                          AND tc.table_schema = kcu.table_schema
                        JOIN information_schema.constraint_column_usage AS ccu
                          ON ccu.constraint_name = tc.constraint_name
                          AND ccu.table_schema = tc.table_schema
                    WHERE tc.constraint_type = 'FOREIGN KEY' AND ccu.table_name='Courses';
                """)
                referencing_tables = cur.fetchall()
                
                print("[*] Found referencing tables to clean first:")
                for tbl_name, col_name in referencing_tables:
                    # Clean referencing table
                    # Using psycopg2.sql is safer, but direct formatting is fine since names are from system catalogue
                    query = f'DELETE FROM "{tbl_name}" WHERE "{col_name}" = ANY(%s::uuid[]);'
                    cur.execute(query, (delete_ids,))
                    print(f"  [-] Deleted {cur.rowcount} records from '{tbl_name}' ({col_name})")
                
                # 2. Finally hard delete from Courses table
                cur.execute('DELETE FROM "Courses" WHERE "Id" = ANY(%s::uuid[]);', (delete_ids,))
                print(f"{Colors.GREEN}[+] Permanently deleted {cur.rowcount} courses from 'Courses'.{Colors.ENDC}")
            else:
                print("No courses to delete.")
                
            conn.commit()
            print(f"\n{Colors.GREEN}[OK] SUCCESS: Hard delete cascade completed successfully!{Colors.ENDC}")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR: {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
