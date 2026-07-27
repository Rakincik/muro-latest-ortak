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
        return f"ogrenci_{str(uuid.uuid4())[:8]}@3u.muro.click"
    if len(parts) == 1:
        return f"{parts[0]}@3u.muro.click"
    return f"{parts[0]}.{parts[-1]}@3u.muro.click"

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
        ".env.mng", "../.env.mng", "../../.env.mng",
        ".env.3u", "../.env.3u", "../../.env.3u",
        ".env.mvz", "../.env.mvz", "../../.env.mvz",
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
    parser = argparse.ArgumentParser(description="MURO LMS 3U - 4T Okinar Group Sync Tool")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--json", default="okinar_grup_hiyerarsi_ve_dersler.json", help="Path to scraped JSON file")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    parser.add_argument("--auto-create-users", action="store_true", help="Automatically create missing student users")
    parser.add_argument("--auto-create-courses", action="store_true", help="Automatically create missing courses")
    parser.add_argument("--sync", action="store_true", help="Synchronize memberships by removing students not in Okinar group")
    parser.add_argument("--clear", action="store_true", help="Clear all existing groups and student accounts before import")
    parser.add_argument("--flat-students", help="Path to scraped flat students list JSON (optional)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO 3U - 4T OKINAR GROUPS & COURSE SYNCHRONIZER       {Colors.ENDC}")
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
        possible_containers = ['muro_3u_postgres', 'muro_mng_postgres', 'muro_mvz_postgres']
        for container in possible_containers:
            try:
                import subprocess
                result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', container], stderr=subprocess.DEVNULL)
                ip = result.decode('utf-8').strip()
                if ip:
                    db_host = ip
                    db_port = 5432  # Container internal port is always 5432
                    print(f"[*] Resolved DB container '{container}' IP: {db_host} (Internal port: {db_port})")
                    break
            except Exception:
                pass

    # Read JSON
    json_path = args.json
    if not os.path.exists(json_path):
        fallbacks = [
            "okinar_grup_hiyerarsi_ve_dersler.json",
            "okinar_grup_hiyerarsi_ve_dersler (2).json",
            "okinar_grup_hiyerarsi_ve_dersler(2).json"
        ]
        for f in fallbacks:
            if os.path.exists(f):
                json_path = f
                break
            # Check in script dir
            script_dir = os.path.dirname(os.path.abspath(__file__))
            sd_path = os.path.join(script_dir, f)
            if os.path.exists(sd_path):
                json_path = sd_path
                break
                
        if not os.path.exists(json_path):
            print(f"{Colors.FAIL}[X] ERROR: JSON file not found at '{args.json}'{Colors.ENDC}")
            sys.exit(1)

    print(f"[*] Reading Okinar groups JSON from '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        scraped_groups = json.load(f)
    print(f"    - Loaded {len(scraped_groups)} groups.")

    # Read Flat Students JSON if provided
    flat_students = []
    if args.flat_students:
        f_path = args.flat_students
        if not os.path.exists(f_path):
            # Check in script dir
            script_dir = os.path.dirname(os.path.abspath(__file__))
            sd_path = os.path.join(script_dir, os.path.basename(f_path))
            if os.path.exists(sd_path):
                f_path = sd_path
        if os.path.exists(f_path):
            print(f"[*] Reading flat students list from '{f_path}'...")
            with open(f_path, 'r', encoding='utf-8') as f:
                flat_students = json.load(f)
            print(f"    - Loaded {len(flat_students)} students from flat list.")
        else:
            print(f"{Colors.WARNING}[!] WARNING: Flat students JSON file not found at '{args.flat_students}'. Skipping.{Colors.ENDC}")

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

        # -------------------------------------------------------------
        # WIPE DB (IF --clear TIGGERED)
        # -------------------------------------------------------------
        if args.clear:
            print(f"\n{Colors.WARNING}{Colors.BOLD}[!] CLEARING EXISTING GROUPS, MEMBERSHIPS, AND STUDENTS...{Colors.ENDC}")
            if args.execute:
                try:
                    # Clean group structures first
                    cur.execute('DELETE FROM "GroupMembers";')
                    cur.execute('DELETE FROM "CourseGroups";')
                    cur.execute('DELETE FROM "Groups";')
                    
                    # Wipe student accounts and dependent records safely by verifying columns first
                    referencing_tables = [
                        'TenantMemberships', 'DeviceSessions', 'CourseStudents', 
                        'ExamResults', 'ExamSubmissionQueues', 'AssignmentSubmissions',
                        'VideoProgresses', 'VideoNotes', 'SupportTickets', 'SupportMessages',
                        'SessionAttendances'
                    ]
                    for table in referencing_tables:
                        # Check if table exists and has UserId column in PostgreSQL schema
                        cur.execute('SELECT EXISTS (SELECT FROM information_schema.columns WHERE table_name = %s AND column_name = %s);', (table, 'UserId'))
                        has_col = cur.fetchone()[0]
                        if has_col:
                            cur.execute(f'DELETE FROM "{table}" WHERE "UserId" IN (SELECT "Id" FROM "Users" WHERE "Role" = \'Student\');')
                            
                    cur.execute('DELETE FROM "Users" WHERE "Role" = \'Student\';')
                    print(f"{Colors.GREEN}[+] Cleaned existing groups, memberships, and student accounts successfully.{Colors.ENDC}")
                except Exception as wipe_err:
                    print(f"{Colors.FAIL}[X] WIPE ERROR: {wipe_err}{Colors.ENDC}")
                    # Rollback aborted transaction so we can run fallback queries on a clean state
                    conn.rollback()
                    # Fallback to group soft-reset
                    try:
                        cur.execute('DELETE FROM "GroupMembers";')
                        cur.execute('DELETE FROM "CourseGroups";')
                        cur.execute('DELETE FROM "Groups";')
                        print(f"{Colors.WARNING}[!] Soft cleared groups and memberships only.{Colors.ENDC}")
                    except Exception as soft_err:
                        print(f"{Colors.FAIL}[X] Soft reset failed: {soft_err}{Colors.ENDC}")
            else:
                print(f"{Colors.WARNING}[i] SIMULATION: Would wipe all groups, group memberships, and student accounts.{Colors.ENDC}")
        # -------------------------------------------------------------------------

        # Cache existing Groups
        cur.execute('SELECT "Id", "Name", "ParentId" FROM "Groups" WHERE "IsDeleted" = False;')
        db_groups_raw = cur.fetchall()
        db_groups_by_name = {r[1].lower().strip(): r[0] for r in db_groups_raw}
        db_group_parent_map = {r[0]: r[2] for r in db_groups_raw}

        # Cache existing Courses
        cur.execute('SELECT "Id", "Title", "IsDeleted" FROM "Courses";')
        all_db_courses = cur.fetchall()
        print(f"[*] Database courses status check: Total = {len(all_db_courses)}")
        print(f"    - Active (IsDeleted=False): {sum(1 for c in all_db_courses if not c[2])}")
        print(f"    - Deleted (IsDeleted=True): {sum(1 for c in all_db_courses if c[2])}")
        if len(all_db_courses) > 0:
            print("    - Sample courses in DB:", [c[1] for c in all_db_courses[:5]])
        db_courses = {normalize(r[1]): r[0] for r in all_db_courses if not r[2]}

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

        print(f"[*] Cached from DB: {len(db_groups_by_name)} groups, {len(db_courses)} courses, {len(db_users_raw)} users.")

        # Default password hash for new students
        cur.execute('SELECT "PasswordHash" FROM "Users" WHERE "Role" = \'Student\' AND "PasswordHash" IS NOT NULL AND "PasswordHash" != \'\' LIMIT 1;')
        row = cur.fetchone()
        default_password_hash = row[0] if row else "AQAAAAIAAYagAAAAEFL6u7bH8g9k..."

        # Counters
        groups_created = 0
        groups_updated = 0
        courses_created = 0
        cg_created = 0
        users_created = 0
        members_created = 0
        members_deleted = 0
        members_skipped = 0
        students_not_found = 0

        # -------------------------------------------------------------
        # PRE-CREATE FLAT STUDENTS (IF --flat-students PROVIDED)
        # -------------------------------------------------------------
        if flat_students and args.auto_create_users:
            print(f"\n{Colors.BLUE}[*] Pre-creating student accounts from flat list...{Colors.ENDC}")
            for std in flat_students:
                std_name = std.get('name', '').strip()
                std_phone = clean_phone_number(std.get('phone'))
                std_email = std.get('email', '').strip().lower()
                norm_name = normalize(std_name)

                # Match user
                u_id = None
                if std_email and std_email in db_users_by_email:
                    u_id = db_users_by_email[std_email]
                elif std_phone and std_phone in db_users_by_phone:
                    u_id = db_users_by_phone[std_phone]
                elif std_phone and std_phone in db_users_by_username:
                    u_id = db_users_by_username[std_phone]
                elif norm_name in users_by_name:
                    u_id = users_by_name[norm_name]

                if not u_id:
                    # Create student
                    phone_val = std_phone if std_phone else generate_mock_phone(std_name)
                    email_val = std_email if std_email else generate_mock_email(std_name)
                    pwd = generate_password(std_name, phone_val)
                    first, last = parse_name(std_name)

                    u_id = str(uuid.uuid4())
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Username", "Phone", "PasswordHash", "Role", "StudentType", "IsActive", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                            (u_id, first, last, email_val, phone_val, phone_val, pwd, 'Student', 'Active', True, False, datetime.datetime.utcnow())
                        )
                    db_users_by_email[email_val.lower().strip()] = u_id
                    db_users_by_phone[phone_val] = u_id
                    db_users_by_username[phone_val] = u_id
                    users_by_name[norm_name] = u_id
                    user_id_to_name[u_id] = std_name
                    users_created += 1
                    print(f"      [+] Created student account: '{std_name}'")

                # Add TenantMembership if missing
                if has_tenant_memberships and u_id not in db_tenant_members:
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "JoinedAt") VALUES (%s, %s, %s, %s, %s)',
                            (str(uuid.uuid4()), u_id, 'Student', 'active', datetime.datetime.utcnow())
                        )
                    db_tenant_members.add(u_id)
        # -------------------------------------------------------------

        # Sort scraped groups so parents are resolved/created first
        sorted_groups = sorted(scraped_groups, key=lambda g: len(g.get('parentChain', [])))

        # Sync Loop
        print(f"\n{Colors.BLUE}[*] Starting Synchronization...{Colors.ENDC}")

        for g_info in sorted_groups:
            raw_group_name = g_info.get('groupName', '').strip()
            parent_chain = g_info.get('parentChain', [])
            scraped_courses = g_info.get('courses', [])
            scraped_students = g_info.get('students', [])

            if not raw_group_name:
                continue

            # 1. Resolve Parent Group Hiyerarşi (Hierarchy)
            current_parent_id = None
            for p_name in parent_chain:
                p_key = p_name.lower().strip()
                p_uuid = db_groups_by_name.get(p_key)
                if not p_uuid:
                    # Create parent group
                    p_uuid = str(uuid.uuid4())
                    desc = f"Okinar Parent Group: {p_name}"
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "Groups" ("Id", "Name", "Description", "ParentId", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s)',
                            (p_uuid, p_name, desc, current_parent_id, False, datetime.datetime.utcnow())
                        )
                    db_groups_by_name[p_key] = p_uuid
                    groups_created += 1
                    print(f"   -> [+] Created parent group: '{p_name}' (ID: {p_uuid})")
                current_parent_id = p_uuid

            # 2. Get/Create Group itself
            g_key = raw_group_name.lower().strip()
            g_id = db_groups_by_name.get(g_key)
            if not g_id:
                # Create Group
                g_id = str(uuid.uuid4())
                desc = f"Okinar Group: {raw_group_name}"
                if args.execute:
                    cur.execute(
                        'INSERT INTO "Groups" ("Id", "Name", "Description", "ParentId", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s)',
                        (g_id, raw_group_name, desc, current_parent_id, False, datetime.datetime.utcnow())
                    )
                db_groups_by_name[g_key] = g_id
                groups_created += 1
                print(f"   -> [+] Created group: '{raw_group_name}' (ID: {g_id})")
            else:
                # Update ParentId if it has changed
                existing_parent_id = db_group_parent_map.get(g_id)
                if existing_parent_id != current_parent_id:
                    if args.execute:
                        cur.execute('UPDATE "Groups" SET "ParentId" = %s WHERE "Id" = %s;', (current_parent_id, g_id))
                    db_group_parent_map[g_id] = current_parent_id
                    groups_updated += 1
                    print(f"   -> [~] Updated parent hierarchy for: '{raw_group_name}'")

            # 3. Connect Courses (CourseGroups)
            for c_info in scraped_courses:
                c_name = c_info.get('courseName', '').strip()
                c_mode_str = c_info.get('mode', '').strip()
                c_norm = normalize(c_name)
                c_id = db_courses.get(c_norm)

                if not c_id:
                    # Fallback to loose name matching
                    c_id = db_courses.get(normalize(c_name.replace('  ', ' ')))

                if not c_id and args.auto_create_courses:
                    c_id = str(uuid.uuid4())
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "Courses" ("Id", "Title", "IsDeleted", "IsPublished", "CourseType", "Mode", "Order", "CreatedAt") '
                            'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                            (c_id, c_name, False, True, 'Online', 'Offline', 0, datetime.datetime.utcnow())
                        )
                    db_courses[c_norm] = c_id
                    courses_created += 1
                    print(f"   -> [+] Created course automatically: '{c_name}' (ID: {c_id})")

                if c_id:
                    if (c_id, g_id) not in db_course_groups:
                        # Insert CourseGroups mapping
                        cg_mode = 'Offline' if 'video' in c_mode_str.lower() else 'Online'
                        if args.execute:
                            cur.execute(
                                'INSERT INTO "CourseGroups" ("Id", "CourseId", "GroupId", "Mode", "AssignedAt") VALUES (%s, %s, %s, %s, %s)',
                                (str(uuid.uuid4()), c_id, g_id, cg_mode, datetime.datetime.utcnow())
                            )
                        db_course_groups.add((c_id, g_id))
                        cg_created += 1
                else:
                    print(f"   ⚠️ WARNING: Course '{c_name}' not found in MURO database.")

            # 4. Process Student Memberships
            target_user_ids = set()
            for std in scraped_students:
                std_name = std.get('name', '').strip()
                std_phone = clean_phone_number(std.get('phone'))
                std_email = std.get('email', '').strip().lower()
                norm_name = normalize(std_name)

                # Match user
                u_id = None
                if std_email and std_email in db_users_by_email:
                    u_id = db_users_by_email[std_email]
                elif std_phone and std_phone in db_users_by_phone:
                    u_id = db_users_by_phone[std_phone]
                elif std_phone and std_phone in db_users_by_username:
                    u_id = db_users_by_username[std_phone]
                elif norm_name in users_by_name:
                    u_id = users_by_name[norm_name]

                if not u_id:
                    # User not found
                    if args.auto_create_users:
                        # Generate missing values
                        phone_val = std_phone if std_phone else generate_mock_phone(std_name)
                        email_val = std_email if std_email else generate_mock_email(std_name)
                        pwd = generate_password(std_name, phone_val)
                        first, last = parse_name(std_name)

                        u_id = str(uuid.uuid4())
                        if args.execute:
                            cur.execute(
                                'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Username", "Phone", "PasswordHash", "Role", "StudentType", "IsActive", "IsDeleted", "CreatedAt") VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                                (u_id, first, last, email_val, phone_val, phone_val, pwd, 'Student', 'Active', True, False, datetime.datetime.utcnow())
                            )
                        db_users_by_email[email_val.lower().strip()] = u_id
                        db_users_by_phone[phone_val] = u_id
                        db_users_by_username[phone_val] = u_id
                        users_by_name[norm_name] = u_id
                        user_id_to_name[u_id] = std_name
                        users_created += 1
                        print(f"      [+] Created new student user: '{std_name}' (Email: {email_val})")
                    else:
                        print(f"      ⚠️ Student '{std_name}' not found in MURO database.")
                        students_not_found += 1
                        continue

                # Add TenantMembership if missing
                if has_tenant_memberships and u_id not in db_tenant_members:
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "JoinedAt") VALUES (%s, %s, %s, %s, %s)',
                            (str(uuid.uuid4()), u_id, 'Student', 'active', datetime.datetime.utcnow())
                        )
                    db_tenant_members.add(u_id)

                target_user_ids.add(u_id)

            # Retrieve active group members in MURO currently
            cur.execute('SELECT "UserId" FROM "GroupMembers" WHERE "GroupId" = %s AND "Status" = \'active\';', (g_id,))
            current_user_ids = {r[0] for r in cur.fetchall()}

            # If sync is selected, remove members not in Okinar
            if args.sync:
                users_to_remove = current_user_ids - target_user_ids
                for r_uid in users_to_remove:
                    r_name = user_id_to_name.get(r_uid, f"Bilinmeyen (ID: {r_uid})")
                    if args.execute:
                        cur.execute('DELETE FROM "GroupMembers" WHERE "GroupId" = %s AND "UserId" = %s;', (g_id, r_uid))
                    print(f"      [-] Removed student from group: '{r_name}'")
                    members_deleted += 1

            # Add missing members to group
            users_to_add = target_user_ids - current_user_ids
            for a_uid in users_to_add:
                a_name = user_id_to_name.get(a_uid, f"Bilinmeyen (ID: {a_uid})")
                if args.execute:
                    cur.execute(
                        'INSERT INTO "GroupMembers" ("Id", "GroupId", "UserId", "Role", "Status", "AddedAt") VALUES (%s, %s, %s, %s, %s, %s)',
                        (str(uuid.uuid4()), g_id, a_uid, 2, 'active', datetime.datetime.utcnow())
                    )
                db_members.add((g_id, a_uid))
                members_created += 1

            members_skipped += len(target_user_ids & current_user_ids)
 
        print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"{Colors.GREEN}{Colors.BOLD}                     MIGRATION SUMMARY")
        print(f"{Colors.GREEN}{Colors.BOLD}============================================================")
        print(f" - Groups Created                    : {groups_created}")
        print(f" - Groups Hierarchy Updated          : {groups_updated}")
        print(f" - Courses Created                   : {courses_created}")
        print(f" - Course-Group Connections Created : {cg_created}")
        print(f" - Student Users Created             : {users_created}")
        print(f" - Group Memberships Created         : {members_created}")
        print(f" - Group Memberships Deleted (Sync)  : {members_deleted}")
        print(f" - Group Memberships Skipped         : {members_skipped}")
        print(f" - Students Not Found (Skipped)      : {students_not_found}")
 
        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] SUCCESS: Changes committed to database successfully!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULATION MODE (Dry-Run): No writes performed.{Colors.ENDC}")
            print("    To save changes, run with '--execute':")
            print("    python import_4t_groups.py --execute --sync --auto-create-users --auto-create-courses")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] ERROR OCCURRED (Rollback changes): {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
