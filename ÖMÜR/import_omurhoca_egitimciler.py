import os
import sys
import re
import uuid
import datetime
import json
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

def normalize(name_str):
    if not name_str:
        return ""
    char_map = {
        'ı': 'i', 'İ': 'i', 'I': 'i',
        'ş': 's', 'Ş': 's',
        'ğ': 'g', 'Ğ': 'g',
        'ü': 'u', 'Ü': 'u',
        'ö': 'o', 'Ö': 'o',
        'ç': 'c', 'Ç': 'c'
    }
    s = str(name_str).strip().lower()
    for tr, eng in char_map.items():
        s = s.replace(tr, eng)
    s = re.sub(r'[^a-z0-9\s]', '', s)
    return " ".join(s.split())

def parse_name(full_name):
    parts = str(full_name).strip().split()
    if not parts:
        return "", ""
    if len(parts) == 1:
        return parts[0], ""
    return " ".join(parts[:-1]), parts[-1]

def clean_phone_number(phone):
    if not phone:
        return None
    s = re.sub(r'\D', '', str(phone))
    if len(s) == 11 and s.startswith('0'):
        s = s[1:]
    elif len(s) == 12 and s.startswith('90'):
        s = s[2:]
    elif len(s) == 13 and s.startswith('+90'):
        s = s[3:]
    if len(s) == 10 and s.startswith('5'):
        return s
    return None

def generate_mock_phone(name):
    import hashlib
    h = hashlib.md5(normalize(name).encode('utf-8')).hexdigest()
    suffix = str(int(h, 16))[:7]
    while len(suffix) < 7:
        suffix += "0"
    return "111" + suffix

def generate_mock_email(name):
    parts = normalize(name).split()
    if not parts:
        return f"egitimci_{str(uuid.uuid4())[:8]}@omurhoca.muro.click"
    if len(parts) == 1:
        return f"{parts[0]}@omurhoca.muro.click"
    return f"{parts[0]}.{parts[-1]}@omurhoca.muro.click"

def generate_password(name, phone):
    first, last = parse_name(name)
    first_clean = normalize(first).split()
    first_val = first_clean[0] if first_clean else "egitimci"
    
    last_clean = normalize(last)
    last_char = last_clean[0] if last_clean else "x"
    
    phone_val = str(phone)
    phone_suffix = phone_val[-2:] if len(phone_val) >= 2 else "00"
    
    return f"{first_val}.{phone_suffix}.{last_char}"

def load_env():
    config = {}
    env_paths = [
        "/opt/omr/.env.omr", ".env.omr", "../.env.omr",
        ".env", "../.env", "../../.env"
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
    parser = argparse.ArgumentParser(description="MURO LMS OMR - Okinar Educator Importer")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--json", default="omr_egitimciler.json", help="Path to scraped JSON file")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO OMR - OKINAR INSTRUCTORS / EDUCATORS IMPORT       {Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # Load env
    env_config = load_env()
    db_host = args.host or env_config.get("DB_HOST", "localhost")
    db_port = args.port or int(env_config.get("DB_PORT", 5432))
    db_name = args.dbname or env_config.get("DB_NAME", "muro_demo")
    db_user = args.user or env_config.get("DB_USER", "muro_user")
    db_pass = args.password or env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Try discovering local Docker Postgres IP on server
    if not args.host:
        try:
            import subprocess
            result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
            ip = result.decode('utf-8').strip()
            if ip:
                db_host = ip
                print(f"[*] Resolved DB container IP: {db_host}")
        except Exception:
            pass

    # Read JSON
    json_path = args.json
    if not os.path.exists(json_path):
        script_dir = os.path.dirname(os.path.abspath(__file__))
        json_path = os.path.join(script_dir, os.path.basename(json_path))
        if not os.path.exists(json_path):
            print(f"{Colors.FAIL}[X] ERROR: JSON file not found at '{args.json}'{Colors.ENDC}")
            sys.exit(1)

    print(f"[*] Reading Okinar educators JSON from '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        scraped_educators = json.load(f)
    print(f"    - Loaded {len(scraped_educators)} educators.")

    # Connect to Database
    print(f"[*] Connecting to database '{db_name}' on {db_host}:{db_port}...")
    conn = None
    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
        print(f"{Colors.GREEN}[+] Connected to database successfully!{Colors.ENDC}")
    except Exception as e:
        print(f"{Colors.FAIL}[X] DB Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        # Check TenantMemberships table
        cur.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'TenantMemberships'
            );
        """)
        has_tenant_memberships = cur.fetchone()[0]

        # Cache existing users
        cur.execute('SELECT "Id", "Email", "Phone", "Username", "Role" FROM "Users";')
        db_users_raw = cur.fetchall()
        db_users_by_email = {r[0]: r[1].lower().strip() for r in db_users_raw if r[1]}
        db_users_by_phone = {r[0]: r[2].strip() for r in db_users_raw if r[2]}
        
        email_to_id = {v: k for k, v in db_users_by_email.items()}
        phone_to_id = {v: k for k, v in db_users_by_phone.items()}
        id_to_role = {r[0]: r[4] for r in db_users_raw}

        # Cache existing tenant memberships
        db_tenant_memberships = {}
        if has_tenant_memberships:
            cur.execute('SELECT "UserId", "Role" FROM "TenantMemberships" WHERE "Status" = \'active\';')
            db_tenant_memberships = {r[0]: r[1] for r in cur.fetchall()}

        # Default password hash (same format as others)
        cur.execute('SELECT "PasswordHash" FROM "Users" WHERE "PasswordHash" IS NOT NULL AND "PasswordHash" != \'\' LIMIT 1;')
        row = cur.fetchone()
        default_password_hash = row[0] if row else "AQAAAAIAAYagAAAAEFL6u7bH8g9kS3XfL52i"

        created_count = 0
        updated_count = 0
        skipped_count = 0

        print(f"\n{Colors.BLUE}[*] Starting Instructor Import...{Colors.ENDC}")

        for edu in scraped_educators:
            name = edu.get("name", "").strip()
            email = edu.get("email", "").strip().lower()
            phone = clean_phone_number(edu.get("phone", ""))
            
            if not name:
                continue

            # Determine ID if user already exists
            u_id = None
            if email and email in email_to_id:
                u_id = email_to_id[email]
            elif phone and phone in phone_to_id:
                u_id = phone_to_id[phone]

            # If user does not exist, create them
            if not u_id:
                u_id = str(uuid.uuid4())
                user_email = email if email else generate_mock_email(name)
                user_phone = phone if phone else generate_mock_phone(name)
                username = user_email.split('@')[0]
                
                # Check username uniqueness in DB
                cur.execute('SELECT EXISTS(SELECT 1 FROM "Users" WHERE "Username" = %s);', (username,))
                if cur.fetchone()[0]:
                    username = f"{username}_{str(uuid.uuid4())[:4]}"

                first, last = parse_name(name)
                
                if args.execute:
                    # Insert into Users
                    cur.execute(
                        'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Phone", "Username", "PasswordHash", "Role", "IsActive", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                        (u_id, first, last, user_email, user_phone, username, default_password_hash, "Instructor", True, False, datetime.datetime.utcnow())
                    )
                    # Insert into TenantMemberships
                    if has_tenant_memberships:
                        cur.execute(
                            'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "CreatedAt") VALUES (%s, %s, %s, %s, %s)',
                            (str(uuid.uuid4()), u_id, "Instructor", "active", datetime.datetime.utcnow())
                        )
                
                email_to_id[user_email] = u_id
                phone_to_id[user_phone] = u_id
                created_count += 1
                print(f" [+] Created Instructor: '{name}' (Email: {user_email}, Phone: {user_phone})")

            else:
                # User exists. Update role to Instructor if they are not already Instructor/Admin
                current_role = id_to_role.get(u_id)
                if current_role not in ["Instructor", "Admin"]:
                    if args.execute:
                        # Update Users table role
                        cur.execute('UPDATE "Users" SET "Role" = \'Instructor\' WHERE "Id" = %s;', (u_id,))
                        # Update TenantMemberships role
                        if has_tenant_memberships:
                            cur.execute(
                                'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "CreatedAt") '
                                'VALUES (%s, %s, %s, %s, %s) '
                                'ON CONFLICT ("UserId") DO UPDATE SET "Role" = \'Instructor\', "Status" = \'active\';',
                                (str(uuid.uuid4()), u_id, "Instructor", "active", datetime.datetime.utcnow())
                            )
                    updated_count += 1
                    print(f" [~] Upgraded existing user to Instructor: '{name}' (Previous Role: {current_role})")
                else:
                    skipped_count += 1
                    print(f" [ ] Skipped (already Instructor/Admin): '{name}'")

        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}[+] Changes committed to the database successfully!{Colors.ENDC}")
        else:
            print(f"\n{Colors.WARNING}[*] DRY RUN: Database changes were NOT written. Run with --execute to commit.{Colors.ENDC}")

        print(f"\n==================== IMPORT SUMMARY ====================")
        print(f" * Instructors Created         : {created_count}")
        print(f" * Upgraded to Instructor      : {updated_count}")
        print(f" * Skipped (Already exists)    : {skipped_count}")
        print(f"========================================================")

    except Exception as e:
        if conn:
            conn.rollback()
        print(f"{Colors.FAIL}[X] Transaction failed: {e}{Colors.ENDC}")
        raise e
    finally:
        if conn:
            conn.close()

if __name__ == '__main__':
    main()
