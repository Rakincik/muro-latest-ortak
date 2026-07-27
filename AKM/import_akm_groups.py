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
        return f"ogrenci_{str(uuid.uuid4())[:8]}@akademikmasa.com"
    if len(parts) == 1:
        return f"{parts[0]}@akademikmasa.com"
    return f"{parts[0]}.{parts[-1]}@akademikmasa.com"

def generate_password(name, phone):
    first, last = parse_name(name)
    first_clean = normalize(first).split()
    first_val = first_clean[0] if first_clean else "ogrenci"
    
    last_clean = normalize(last)
    last_char = last_clean[0] if last_clean else "x"
    
    phone_val = str(phone)
    phone_suffix = phone_val[-2:] if len(phone_val) >= 2 else "00"
    
    return f"{first_val}.{phone_suffix}.{last_char}"

def load_env():
    config = {}
    env_paths = [
        "/opt/akm/.env", ".env.akm", "../.env.akm",
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
    parser = argparse.ArgumentParser(description="MURO LMS AKM - Okinar Group Sync Tool")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--json", default="okinar_grup_hiyerarsi_ve_dersler.json", help="Path to scraped JSON file")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    parser.add_argument("--auto-create-users", action="store_true", help="Automatically create missing student users")
    parser.add_argument("--sync", action="store_true", help="Synchronize memberships by removing students not in Okinar group")
    parser.add_argument("--fresh", action="store_true", help="Clean wipe all existing groups and memberships before starting")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO AKM - OKINAR GROUPS & COURSE SYNCHRONIZER       {Colors.ENDC}")
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
            result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres'], stderr=subprocess.DEVNULL)
            ip = result.decode('utf-8').strip()
            if ip:
                db_host = ip
                print(f"[*] Resolved DB container IP: {db_host}")
        except Exception:
            pass

    # Read JSON
    json_path = args.json
    if not os.path.exists(json_path):
        # Check in current dir or script dir
        script_dir = os.path.dirname(os.path.abspath(__file__))
        json_path = os.path.join(script_dir, os.path.basename(json_path))
        if not os.path.exists(json_path):
            print(f"{Colors.FAIL}[X] ERROR: JSON file not found at '{args.json}'{Colors.ENDC}")
            sys.exit(1)

    print(f"[*] Reading Okinar groups JSON from '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        scraped_groups = json.load(f)
    print(f"    - Loaded {len(scraped_groups)} groups.")

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

        # Truncate tables if --fresh flag is passed
        if args.fresh:
            print(f"{Colors.WARNING}[!] --fresh flag detected. Cleaning up all existing groups, memberships, and course assignments...{Colors.ENDC}")
            if args.execute:
                cur.execute('TRUNCATE TABLE "GroupMembers", "CourseGroups", "Groups" CASCADE;')
                print(f"{Colors.GREEN}[+] Tables truncated successfully!{Colors.ENDC}")
            else:
                print(f"{Colors.WARNING}[*] DRY RUN: Tables would be truncated in execute mode.{Colors.ENDC}")

        # Cache existing Groups by path hierarchy to prevent duplicate name clashes
        cur.execute('SELECT "Id", "Name", "ParentId" FROM "Groups" WHERE "IsDeleted" = False;')
        db_groups_raw = cur.fetchall()
        
        group_nodes = {r[0]: {"name": r[1], "parent_id": r[2]} for r in db_groups_raw}
        def get_group_path(g_uuid):
            path = []
            curr = g_uuid
            visited = set()
            while curr in group_nodes and curr not in visited:
                visited.add(curr)
                node = group_nodes[curr]
                path.append(node["name"].lower().strip())
                curr = node["parent_id"]
            path.reverse()
            return " -> ".join(path)

        db_groups_by_path = {}
        for g_uuid in group_nodes:
            path_key = get_group_path(g_uuid)
            db_groups_by_path[path_key] = g_uuid

        # Cache existing Courses
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses = {normalize(r[1]): r[0] for r in cur.fetchall()}

        # Cache existing CourseGroups mappings
        cur.execute('SELECT "CourseId", "GroupId" FROM "CourseGroups";')
        db_course_groups = set((r[0], r[1]) for r in cur.fetchall())

        # Cache existing users
        cur.execute('SELECT "Id", "Email", "Phone", "Username", "FirstName", "LastName" FROM "Users";')
        db_users_raw = cur.fetchall()
        db_users_by_email = {r[1].lower().strip(): r[0] for r in db_users_raw if r[1]}
        db_users_by_phone = {r[2].strip(): r[0] for r in db_users_raw if r[2]}
        db_users_by_username = {r[3].lower().strip(): r[0] for r in db_users_raw if r[3]}
        
        users_by_name = {}
        user_id_to_name = {}
        for r in db_users_raw:
            u_id = r[0]
            full_name = f"{r[4]} {r[5]}".strip()
            users_by_name[normalize(full_name)] = u_id
            user_id_to_name[u_id] = full_name

        # Cache existing tenant members
        db_tenant_members = set()
        if has_tenant_memberships:
            cur.execute('SELECT "UserId" FROM "TenantMemberships" WHERE "Status" = \'active\';')
            db_tenant_members = set(r[0] for r in cur.fetchall())

        # Cache existing memberships
        cur.execute('SELECT "GroupId", "UserId" FROM "GroupMembers" WHERE "Status" = \'active\';')
        db_members = set((r[0], r[1]) for r in cur.fetchall())

        print(f"[*] Cached from DB: {len(db_groups_by_path)} groups, {len(db_courses)} courses, {len(db_users_raw)} users.")

        # Default password hash for new students
        cur.execute('SELECT "PasswordHash" FROM "Users" WHERE "Role" = \'Student\' AND "PasswordHash" IS NOT NULL AND "PasswordHash" != \'\' LIMIT 1;')
        row = cur.fetchone()
        default_password_hash = row[0] if row else "AQAAAAIAAYagAAAAEFL6u7bH8g9kS3XfL52i" # Mock default fallback

        # Filter out groups with no students
        active_scraped_groups = [
            g for g in scraped_groups 
            if len(g.get('students', [])) > 0
        ]
        print(f"[*] Filtering active groups: {len(active_scraped_groups)} active groups (Wiped {len(scraped_groups) - len(active_scraped_groups)} groups with 0 students)")

        # Sort scraped groups so parents are resolved/created first
        sorted_groups = sorted(active_scraped_groups, key=lambda g: len(g.get('parentChain', [])))

        # Counters
        groups_created = 0
        groups_updated = 0
        cg_created = 0
        users_created = 0
        members_created = 0
        members_deleted = 0
        members_skipped = 0
        students_not_found = 0

        # Sync Loop
        print(f"\n{Colors.BLUE}[*] Starting Synchronization...{Colors.ENDC}")

        for g_info in sorted_groups:
            raw_group_name = g_info.get('groupName', '').strip()
            parent_chain = g_info.get('parentChain', [])
            scraped_courses = g_info.get('courses', [])
            scraped_students = g_info.get('students', [])

            if not raw_group_name:
                continue

            # 1. Resolve Parent Group Hierarchy by Path
            current_parent_id = None
            path_so_far = []
            for p_name in parent_chain:
                path_so_far.append(p_name.lower().strip())
                path_key = " -> ".join(path_so_far)
                p_uuid = db_groups_by_path.get(path_key)
                if not p_uuid:
                    p_uuid = str(uuid.uuid4())
                    desc = f"Okinar Parent Group: {p_name}"
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "Groups" ("Id", "Name", "Description", "ParentId", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s)',
                            (p_uuid, p_name, desc, current_parent_id, False, datetime.datetime.utcnow())
                        )
                    db_groups_by_path[path_key] = p_uuid
                    groups_created += 1
                    print(f"   -> [+] Created parent group: '{p_name}' (ID: {p_uuid})")
                current_parent_id = p_uuid

            # 2. Get/Create Group itself by Path
            path_so_far.append(raw_group_name.lower().strip())
            g_path_key = " -> ".join(path_so_far)
            g_id = db_groups_by_path.get(g_path_key)
            if not g_id:
                g_id = str(uuid.uuid4())
                desc = f"Okinar Group: {raw_group_name}"
                if args.execute:
                    cur.execute(
                        'INSERT INTO "Groups" ("Id", "Name", "Description", "ParentId", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s)',
                        (g_id, raw_group_name, desc, current_parent_id, False, datetime.datetime.utcnow())
                    )
                db_groups_by_path[g_path_key] = g_id
                groups_created += 1
                print(f"   -> [+] Created group: '{raw_group_name}' (ID: {g_id})")

            # 3. Connect Courses (CourseGroups)
            for c_info in scraped_courses:
                c_name = c_info.get('courseName', '').strip()
                if not c_name:
                    continue
                c_norm = normalize(c_name)
                c_id = db_courses.get(c_norm)
                if not c_id:
                    # Let's search by prefix or substring as fallback
                    for c_title_norm, db_c_id in db_courses.items():
                        if c_norm in c_title_norm or c_title_norm in c_norm:
                            c_id = db_c_id
                            break

                if c_id:
                    if (c_id, g_id) not in db_course_groups:
                        if args.execute:
                            cg_mode = 'Online' # Defaulting to Online, or Offline if video in course title
                            if 'video' in c_name.lower():
                                cg_mode = 'Offline'
                            cur.execute(
                                'INSERT INTO "CourseGroups" ("Id", "CourseId", "GroupId", "Mode", "AssignedAt") VALUES (%s, %s, %s, %s, %s)',
                                (str(uuid.uuid4()), c_id, g_id, cg_mode, datetime.datetime.utcnow())
                            )
                        db_course_groups.add((c_id, g_id))
                        cg_created += 1
                        print(f"      - [+] Assigned course '{c_name}' to group '{raw_group_name}'")
                else:
                    print(f"      - {Colors.WARNING}[!] Warning: Course '{c_name}' not found in MURO database. Skipping assignment.{Colors.ENDC}")

            # 4. Map and Sync Group Members (Students)
            scraped_student_ids = set()
            for s_info in scraped_students:
                s_name = s_info.get('name', '').strip()
                s_phone = clean_phone_number(s_info.get('phone', ''))
                s_email = s_info.get('email', '').strip().lower()

                if not s_name:
                    continue

                u_id = None
                # Try finding student by phone, email or normalized name
                if s_phone and s_phone in db_users_by_phone:
                    u_id = db_users_by_phone[s_phone]
                elif s_email and s_email in db_users_by_email:
                    u_id = db_users_by_email[s_email]
                else:
                    u_id = users_by_name.get(normalize(s_name))

                # Auto-create missing user if requested
                if not u_id and args.auto_create_users:
                    u_id = str(uuid.uuid4())
                    email = s_email if s_email else generate_mock_email(s_name)
                    phone = s_phone if s_phone else generate_mock_phone(s_name)
                    username = email.split('@')[0]
                    if username in db_users_by_username:
                        username = f"{username}_{str(uuid.uuid4())[:4]}"
                    db_users_by_username[username] = u_id

                    first, last = parse_name(s_name)
                    pw_plain = generate_password(s_name, phone)

                    if args.execute:
                        # Insert User
                        cur.execute(
                            'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Phone", "Username", "PasswordHash", "Role", "IsActive", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                            (u_id, first, last, email, phone, username, default_password_hash, "Student", True, False, datetime.datetime.utcnow())
                        )
                        # Insert TenantMembership
                        if has_tenant_memberships:
                            cur.execute(
                                'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "CreatedAt") VALUES (%s, %s, %s, %s, %s)',
                                (str(uuid.uuid4()), u_id, "Student", "active", datetime.datetime.utcnow())
                            )
                    
                    db_users_by_email[email.lower().strip()] = u_id
                    db_users_by_phone[phone.strip()] = u_id
                    users_by_name[normalize(s_name)] = u_id
                    user_id_to_name[u_id] = s_name
                    users_created += 1
                    print(f"      - [+] Created missing user: '{s_name}' (Email: {email}, Phone: {phone})")

                if u_id:
                    scraped_student_ids.add(u_id)
                    # Add to group if not already a member
                    if (g_id, u_id) not in db_members:
                        if args.execute:
                            cur.execute(
                                'INSERT INTO "GroupMembers" ("Id", "GroupId", "UserId", "Role", "Status", "AddedAt") VALUES (%s, %s, %s, %s, %s, %s)',
                                (str(uuid.uuid4()), g_id, u_id, 2, "active", datetime.datetime.utcnow())
                            )
                        db_members.add((g_id, u_id))
                        members_created += 1
                        print(f"      - [+] Added student to group: '{s_name}'")
                    else:
                        members_skipped += 1
                else:
                    students_not_found += 1
                    print(f"      - {Colors.WARNING}[!] Warning: Student '{s_name}' not found in MURO database. Run with --auto-create-users to auto create.{Colors.ENDC}")

            # 5. Group Membership Cleanup (Sync)
            if args.sync and args.execute:
                # Find DB memberships for this group that are NOT in scraped list
                db_users_in_group = [pair[1] for pair in db_members if pair[0] == g_id]
                for db_u_id in db_users_in_group:
                    if db_u_id not in scraped_student_ids:
                        cur.execute('UPDATE "GroupMembers" SET "Status" = \'removed\' WHERE "GroupId" = %s AND "UserId" = %s;', (g_id, db_u_id))
                        members_deleted += 1
                        db_members.discard((g_id, db_u_id))
                        name_lbl = user_id_to_name.get(db_u_id, db_u_id)
                        print(f"      - [-] Removed student from group: '{name_lbl}' (Not in Okinar list)")

        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}[+] Changes committed to the database successfully!{Colors.ENDC}")
        else:
            print(f"\n{Colors.WARNING}[*] DRY RUN: Database changes were NOT written. Run with --execute to commit.{Colors.ENDC}")

        # Summary
        print(f"\n==================== SYNCHRONIZATION SUMMARY ====================")
        print(f" * Groups Created              : {groups_created}")
        print(f" * Groups Hierarchy Updated    : {groups_updated}")
        print(f" * Course-Group Assignments    : {cg_created}")
        print(f" * Missing Users Auto-Created  : {users_created}")
        print(f" * Group Memberships Added     : {members_created}")
        print(f" * Group Memberships Removed   : {members_deleted}")
        print(f" * Group Memberships Skipped   : {members_skipped}")
        print(f" * Unmatched Students Warning  : {students_not_found}")
        print(f"================================================================")

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
