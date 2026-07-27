import os
import sys
import re
import uuid
import datetime
import json
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

def normalize(s):
    if not s:
        return ''
    s = str(s).lower().strip()
    char_map = {
        'ı': 'i', 'İ': 'i', 'I': 'i',
        'ş': 's', 'Ş': 's',
        'ğ': 'g', 'Ğ': 'g',
        'ü': 'u', 'Ü': 'u',
        'ö': 'o', 'Ö': 'o',
        'ç': 'c', 'Ç': 'c'
    }
    for tr, eng in char_map.items():
        s = s.replace(tr, eng)
    s = re.sub(r'[^a-z0-9]', '', s)
    return s

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

def generate_mock_phone(name, existing_phones):
    import hashlib
    h = hashlib.md5(normalize(name).encode('utf-8')).hexdigest()
    val = int(h, 16)
    base_suffix = val % 10000000 # 7 digits
    phone = f"111{base_suffix:07d}"
    while phone in existing_phones:
        base_suffix = (base_suffix + 1) % 10000000
        phone = f"111{base_suffix:07d}"
    existing_phones.add(phone)
    return phone

def generate_mock_email(name, existing_emails):
    import uuid
    norm = normalize(name)
    parts = norm.split()
    if not parts:
        base_email = f"ogrenci_{str(uuid.uuid4())[:8]}"
    elif len(parts) == 1:
        base_email = parts[0]
    else:
        base_email = f"{parts[0]}.{parts[-1]}"
        
    email = f"{base_email}@mng.muro.click"
    counter = 1
    while email in existing_emails:
        email = f"{base_email}{counter}@mng.muro.click"
        counter += 1
    existing_emails.add(email)
    return email

def generate_password(name, phone):
    first, last = parse_name(name)
    first_clean = normalize(first).split()
    first_val = first_clean[0] if first_clean else "ogrenci"
    last_clean = normalize(last)
    last_char = last_clean[0] if last_clean else "x"
    phone_val = str(phone)
    phone_suffix = phone_val[-2:] if len(phone_val) >= 2 else "00"
    return f"{first_val}.{phone_suffix}.{last_char}"

def load_env(env_path=".env.mng"):
    config = {}
    if os.path.exists(env_path):
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    k, v = line.split("=", 1)
                    config[k.strip()] = v.strip()
    return config

def main():
    parser = argparse.ArgumentParser(description="MURO MNG (Derece Uzem) - Okinar JSON Student & Course Importer")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--courses-json", default="okinar_bireysel_dersler.json", help="Path to scraped courses JSON file")
    parser.add_argument("--groups-json", default="okinar_grup_ogrencileri.json", help="Path to scraped groups JSON file")
    parser.add_argument("--recordings-json", default="dereceuzem_guncel_kayitlar.json", help="Path to scraped recordings JSON file")
    parser.add_argument("--after-date", help="Only process recordings after this date (format: DD.MM.YYYY, e.g. 28.06.2026)")
    parser.add_argument("--execute", action="store_true", help="Execute database writes (defaults to dry-run)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO MNG - OKINAR JSON DATA IMPORT TOOL{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # Load from env file
    env_config = load_env()
    db_host = args.host or env_config.get("DB_HOST", "postgres")
    db_port = args.port or int(env_config.get("DB_PORT", 5432))
    db_name = args.dbname or env_config.get("DB_NAME", "muro_demo")
    db_user = args.user or env_config.get("DB_USER", "muro_user")
    db_pass = args.password or env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Connect to DB
    print(f"[*] Connecting to database '{db_name}' on '{db_host}:{db_port}'...")
    db_lib = None
    conn = None
    try:
        import psycopg2
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        db_lib = "psycopg2"
    except ImportError:
        try:
            import pg8000
            conn = pg8000.connect(host=db_host, port=db_port, database=db_name, user=db_user, password=db_pass)
            db_lib = "pg8000"
        except ImportError:
            print(f"{Colors.FAIL}[X] HATA: psycopg2 veya pg8000 kütüphanelerinden biri kurulu olmalıdır!{Colors.ENDC}")
            sys.exit(1)
    except Exception as e:
        print(f"{Colors.FAIL}[X] Veritabanı bağlantısı başarısız oldu: {e}{Colors.ENDC}")
        sys.exit(1)

    print(f"{Colors.GREEN}[+] Veritabanına başarıyla bağlanıldı! (Kütüphane: {db_lib}){Colors.ENDC}")
    cur = conn.cursor()

    scraped_courses = []
    scraped_groups = []
    scraped_recordings = []

    if os.path.exists(args.courses_json):
        print(f"[*] Reading courses data from '{args.courses_json}'...")
        with open(args.courses_json, 'r', encoding='utf-8') as f:
            scraped_courses = json.load(f)
        print(f"    - Loaded {len(scraped_courses)} students from courses JSON.")
    else:
        print(f"{Colors.WARNING}[!] UYARI: '{args.courses_json}' bulunamadı. Bireysel ders atamaları atlanacak.{Colors.ENDC}")

    if os.path.exists(args.groups_json):
        print(f"[*] Reading groups data from '{args.groups_json}'...")
        with open(args.groups_json, 'r', encoding='utf-8') as f:
            scraped_groups = json.load(f)
        print(f"    - Loaded {len(scraped_groups)} groups from groups JSON.")
    else:
        print(f"{Colors.WARNING}[!] UYARI: '{args.groups_json}' bulunamadı. Grup üyelikleri atlanacak.{Colors.ENDC}")

    if os.path.exists(args.recordings_json):
        rec_path = args.recordings_json
        print(f"[*] Reading recordings data from '{rec_path}'...")
        with open(rec_path, 'r', encoding='utf-8') as f:
            scraped_recordings = json.load(f)
        print(f"    - Loaded {len(scraped_recordings)} recordings from recordings JSON.")
    else:
        alt_path = os.path.basename(args.recordings_json)
        if os.path.exists(alt_path):
            print(f"[*] Reading recordings data from '{alt_path}'...")
            with open(alt_path, 'r', encoding='utf-8') as f:
                scraped_recordings = json.load(f)
            print(f"    - Loaded {len(scraped_recordings)} recordings from recordings JSON.")
        else:
            print(f"{Colors.WARNING}[!] UYARI: Video kayıtları dosyası bulunamadı. Video aktarımı atlanacak.{Colors.ENDC}")

    if not scraped_courses and not scraped_groups and not scraped_recordings:
        print(f"{Colors.FAIL}[❌] HATA: İşlenecek hiçbir veri dosyası bulunamadı!{Colors.ENDC}")
        sys.exit(1)

    whitelist_groups = set()

    try:
        cur.execute('SELECT "Id", "Name" FROM "Groups" WHERE "IsDeleted" = False;')
        db_groups = {r[1].strip().lower(): r[0] for r in cur.fetchall()}

        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses = {normalize(r[1]): r[0] for r in cur.fetchall()}

        cur.execute('SELECT "Id", "FirstName", "LastName", "Email", "Phone", "Username" FROM "Users";')
        db_users_raw = cur.fetchall()
        
        users_by_phone = {}
        users_by_email = {}
        users_by_username = {}
        users_by_name = {}
        user_id_to_name = {}
        
        existing_phones = set()
        existing_emails = set()
        
        for u_id, first, last, email, phone, username in db_users_raw:
            full_name = f"{first} {last}".strip()
            norm_name = normalize(full_name)
            cleaned_phone = clean_phone_number(phone)
            email_lower = email.lower().strip() if email else None
            
            if phone:
                existing_phones.add(phone.strip())
            if username:
                existing_phones.add(username.strip())
            if email_lower:
                existing_emails.add(email_lower)
            
            if cleaned_phone:
                users_by_phone[cleaned_phone] = u_id
            if email_lower:
                users_by_email[email_lower] = u_id
            if username:
                users_by_username[username.strip()] = u_id
            if norm_name:
                users_by_name[norm_name] = u_id
            user_id_to_name[u_id] = full_name

        cur.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'TenantMemberships'
            );
        """)
        has_tenant_memberships = cur.fetchone()[0]
        db_tenant_members = set()
        if has_tenant_memberships:
            cur.execute('SELECT "UserId" FROM "TenantMemberships";')
            db_tenant_members = set(r[0] for r in cur.fetchall())

        cur.execute('SELECT "CourseId", "UserId" FROM "CourseStudents";')
        db_course_students = {(r[0], r[1]) for r in cur.fetchall()}

        cur.execute('SELECT "GroupId", "UserId" FROM "GroupMembers" WHERE "Status" = \'active\';')
        db_group_members = {(r[0], r[1]) for r in cur.fetchall()}

        # Load existing sessions (grouped by CourseId to allow duplicates in different courses)
        cur.execute('SELECT "CourseId", "BbbMeetingId" FROM "Sessions" WHERE "IsDeleted" = False;')
        db_sessions = {(r[0], r[1]) for r in cur.fetchall() if r[1]}

        users_created = 0
        tenant_members_created = 0
        courses_assigned = 0
        courses_skipped = 0
        courses_created = 0
        courses_not_found = set()
        groups_created = 0
        group_memberships_created = 0
        group_memberships_skipped = 0
        mock_users_created = 0
        sessions_created = 0
        sessions_skipped = 0
        sessions_unmatched_course = set()

        whitelisted_student_names = set()
        whitelisted_student_phones = set()
        whitelisted_student_emails = set()
        
        if whitelist_groups and scraped_groups:
            for group_entry in scraped_groups:
                g_name = group_entry.get('groupName', '').strip()
                g_key_norm = normalize(g_name)
                
                is_whitelisted = (g_key_norm in whitelist_groups)
                if not is_whitelisted:
                    g_name_clean = re.sub(r'^\d+\s+', '', g_name).strip()
                    if normalize(g_name_clean) in whitelist_groups:
                        is_whitelisted = True
                        
                if is_whitelisted:
                    for std in group_entry.get('students', []):
                        if isinstance(std, dict):
                            name = std.get('name', '').strip()
                            phone = clean_phone_number(std.get('phone'))
                            email = std.get('email', '').strip().lower()
                        else:
                            name = str(std).strip()
                            phone = None
                            email = None
                        
                        if name:
                            whitelisted_student_names.add(normalize(name))
                        if phone:
                            whitelisted_student_phones.add(phone)
                        if email:
                            whitelisted_student_emails.add(email)

        print(f"\n{Colors.BLUE}[+] AŞAMA 1: Öğrenci Hesapları ve Bireysel Ders Atamaları İşleniyor...{Colors.ENDC}")
        user_uuid_map = {}

        for entry in scraped_courses:
            name = entry.get('name', '').strip()
            phone = clean_phone_number(entry.get('phone'))
            email = entry.get('email', '').lower().strip()
            courses = entry.get('courses', [])

            if not name:
                continue

            norm_name = normalize(name)
            
            if whitelist_groups:
                is_in_whitelist = (norm_name in whitelisted_student_names)
                if not is_in_whitelist and phone:
                    is_in_whitelist = (phone in whitelisted_student_phones)
                if not is_in_whitelist and email:
                    is_in_whitelist = (email in whitelisted_student_emails)
                if not is_in_whitelist:
                    continue

            first, last = parse_name(name)

            u_id = None
            if phone and phone in users_by_phone:
                u_id = users_by_phone[phone]
            elif phone and phone in users_by_username:
                u_id = users_by_username[phone]
            elif email and email in users_by_email:
                u_id = users_by_email[email]
            elif norm_name in users_by_name:
                u_id = users_by_name[norm_name]

            mock_phone = phone if phone else generate_mock_phone(name, existing_phones)
            mock_email = email if email else generate_mock_email(name, existing_emails)
            if phone:
                existing_phones.add(phone)
            if email:
                existing_emails.add(email)
            pwd = generate_password(name, mock_phone)

            if not u_id:
                u_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Username", "Phone", "PasswordHash", "Role", "StudentType", "IsActive", "IsDeleted", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                    (u_id, first, last, mock_email, mock_phone, mock_phone, pwd, 'Student', 'Active', True, False, datetime.datetime.utcnow())
                )
                users_created += 1
                users_by_name[norm_name] = u_id
                users_by_phone[mock_phone] = u_id
                user_id_to_name[u_id] = name
            
            user_uuid_map[norm_name] = u_id

            if has_tenant_memberships and u_id not in db_tenant_members:
                cur.execute(
                    'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "JoinedAt") VALUES (%s, %s, %s, %s, %s)',
                    (str(uuid.uuid4()), u_id, 'Student', 'active', datetime.datetime.utcnow())
                )
                db_tenant_members.add(u_id)
                tenant_members_created += 1

            for c_info in courses:
                c_name = c_info.get('courseName')
                c_name_clean = normalize(c_name)
                
                c_id = db_courses.get(c_name_clean)
                if not c_id:
                    c_id = str(uuid.uuid4())
                    cur.execute(
                        'INSERT INTO "Courses" ("Id", "Title", "IsDeleted", "IsPublished", "CourseType", "Mode", "Order", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                        (c_id, c_name, False, True, 'Online', 'Offline', 0, datetime.datetime.utcnow())
                    )
                    db_courses[c_name_clean] = c_id
                    courses_created += 1
                    print(f"   -> [+] Yeni Ders oluşturulacak: '{c_name}'")

                if (c_id, u_id) not in db_course_students:
                    cur.execute(
                        'INSERT INTO "CourseStudents" ("Id", "CourseId", "UserId", "AssignedAt", "ExpiresAt") VALUES (%s, %s, %s, %s, %s);',
                        (str(uuid.uuid4()), c_id, u_id, datetime.datetime.utcnow(), None)
                    )
                    db_course_students.add((c_id, u_id))
                    courses_assigned += 1
                else:
                    courses_skipped += 1

        print(f"\n{Colors.BLUE}[+] AŞAMA 2: Gruplar ve Üyelikler İşleniyor...{Colors.ENDC}")
        for group_entry in scraped_groups:
            group_name = group_entry.get('groupName', '').strip()
            students = group_entry.get('students', [])

            if not group_name:
                continue

            group_key = group_name.lower().strip()
            g_key_norm = normalize(group_name)
            
            is_whitelisted = False
            if not whitelist_groups:
                is_whitelisted = True
            else:
                is_whitelisted = (g_key_norm in whitelist_groups)
                if not is_whitelisted:
                    g_name_clean = re.sub(r'^\d+\s+', '', group_name).strip()
                    if normalize(g_name_clean) in whitelist_groups:
                        is_whitelisted = True
            
            if not is_whitelisted:
                continue

            group_id = db_groups.get(group_key)

            if not group_id:
                group_id = str(uuid.uuid4())
                desc = f"Okinar'dan aktarılan grup: {group_name}"
                cur.execute(
                    'INSERT INTO "Groups" ("Id", "Name", "Description", "ParentId", "IsDeleted", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s, %s)',
                    (group_id, group_name, desc, None, False, datetime.datetime.utcnow())
                )
                db_groups[group_key] = group_id
                groups_created += 1
                print(f"   -> [+] Yeni Grup oluşturulacak: '{group_name}'")

            for std_entry in students:
                if isinstance(std_entry, dict):
                    std_name = std_entry.get('name', '').strip()
                    std_phone = clean_phone_number(std_entry.get('phone'))
                    std_email = std_entry.get('email', '').lower().strip()
                else:
                    std_name = str(std_entry).strip()
                    std_phone = None
                    std_email = None

                if not std_name:
                    continue

                norm_std_name = normalize(std_name)
                
                u_id = None
                if std_phone and std_phone in users_by_phone:
                    u_id = users_by_phone[std_phone]
                elif std_phone and std_phone in users_by_username:
                    u_id = users_by_username[std_phone]
                elif std_email and std_email in users_by_email:
                    u_id = users_by_email[std_email]
                else:
                    u_id = user_uuid_map.get(norm_std_name) or users_by_name.get(norm_std_name)

                if not u_id:
                    u_id = str(uuid.uuid4())
                    first, last = parse_name(std_name)
                    mock_phone = std_phone if std_phone else generate_mock_phone(std_name, existing_phones)
                    mock_email = std_email if std_email else generate_mock_email(std_name, existing_emails)
                    if std_phone:
                        existing_phones.add(std_phone)
                    if std_email:
                        existing_emails.add(std_email)
                    pwd = generate_password(std_name, mock_phone)

                    cur.execute(
                        'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Username", "Phone", "PasswordHash", "Role", "StudentType", "IsActive", "IsDeleted", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                        (u_id, first, last, mock_email, mock_phone, mock_phone, pwd, 'Student', 'Active', True, False, datetime.datetime.utcnow())
                    )
                    mock_users_created += 1
                    users_by_name[norm_std_name] = u_id
                    users_by_phone[mock_phone] = u_id
                    user_uuid_map[norm_std_name] = u_id
                    user_id_to_name[u_id] = std_name

                    if has_tenant_memberships and u_id not in db_tenant_members:
                        cur.execute(
                            'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "JoinedAt") VALUES (%s, %s, %s, %s, %s)',
                            (str(uuid.uuid4()), u_id, 'Student', 'active', datetime.datetime.utcnow())
                        )
                        db_tenant_members.add(u_id)
                        tenant_members_created += 1

                if (group_id, u_id) not in db_group_members:
                    cur.execute(
                        'INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s)',
                        (str(uuid.uuid4()), u_id, group_id, 2, 'active', datetime.datetime.utcnow())
                    )
                    db_group_members.add((group_id, u_id))
                    group_memberships_created += 1
                else:
                    group_memberships_skipped += 1

        if scraped_recordings:
            print(f"\n{Colors.BLUE}[+] AŞAMA 3: Video Kayıtları (Sessions) İşleniyor...{Colors.ENDC}")
            
            flat_recordings = []
            for item in scraped_recordings:
                if isinstance(item, dict) and 'recordings' in item:
                    course_name = item.get('courseName', '').strip()
                    for rec in item.get('recordings', []):
                        flat_recordings.append({
                            'recordID': rec.get('recordID'),
                            'className': course_name,
                            'recordingName': rec.get('videoName') or rec.get('recordingName'),
                            'startTime': rec.get('startTime') or rec.get('createdAt') or rec.get('created_at'),
                            'duration': rec.get('duration') or '60'
                        })
                else:
                    flat_recordings.append(item)

            for item in flat_recordings:
                record_id = item.get('recordID')
                record_id = str(record_id).strip() if isinstance(record_id, (str, int)) else ""
                
                class_name = item.get('className')
                class_name = str(class_name).strip() if isinstance(class_name, (str, int)) else ""
                
                recording_name = item.get('recordingName')
                recording_name = str(recording_name).strip() if isinstance(recording_name, (str, int)) else ""
                
                start_time_str = item.get('startTime')
                start_time_str = str(start_time_str).strip() if isinstance(start_time_str, (str, int)) else ""
                
                duration_str = item.get('duration')
                duration_str = str(duration_str).strip() if isinstance(duration_str, (str, int)) else ""
                
                if not record_id or not class_name:
                    continue
                
                # Duplicate check moved below after matching CourseId

                dt = None
                if start_time_str:
                    for fmt in ("%d.%m.%Y %H:%M:%S", "%d.%m.%Y %H:%M", "%Y/%m/%d %H:%M:%S", "%Y/%m/%d %H:%M", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M"):
                        try:
                            dt = datetime.datetime.strptime(start_time_str, fmt)
                            break
                        except ValueError:
                            pass
                            
                # Fallback: Parse date from BBB meeting ID timestamp if title date parsing failed
                if not dt and record_id and '-' in record_id:
                    try:
                        ts_part = record_id.split('-')[-1]
                        if len(ts_part) >= 10:
                            ts_ms = int(ts_part[:13])
                            dt = datetime.datetime.utcfromtimestamp(ts_ms / 1000.0)
                    except Exception:
                        pass
                            
                if args.after_date and dt:
                    try:
                        limit_dt = datetime.datetime.strptime(args.after_date, "%d.%m.%Y")
                        if dt < limit_dt:
                            sessions_skipped += 1
                            continue
                    except ValueError:
                        print(f"{Colors.WARNING}[!] Geçersiz tarih formatı: {args.after_date}. Filtre uygulanamadı.{Colors.ENDC}")
                  
                class_name_clean = normalize(class_name)
                c_id = db_courses.get(class_name_clean)
                if not c_id:
                    class_name_alt = normalize(class_name.replace('  ', ' '))
                    c_id = db_courses.get(class_name_alt)
                    
                if not c_id:
                    c_id = str(uuid.uuid4())
                    cur.execute(
                        'INSERT INTO "Courses" ("Id", "Title", "IsDeleted", "IsPublished", "CourseType", "Mode", "Order", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                        (c_id, class_name, False, True, 'Online', 'Offline', 0, datetime.datetime.utcnow())
                    )
                    db_courses[class_name_clean] = c_id
                    courses_created += 1
                    print(f"    -> [+] Kayıtlar için yeni Ders oluşturuldu: '{class_name}'")

                # Check duplicate per course
                if (c_id, record_id) in db_sessions:
                    sessions_skipped += 1
                    continue

                title = recording_name if recording_name else f"{class_name} - {start_time_str}"
                
                if dt:
                    created_at_str = dt.strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = created_at_str
                    try:
                        dur_mins = int(duration_str) if duration_str else 60
                    except ValueError:
                        dur_mins = 60
                    end_dt = dt + datetime.timedelta(minutes=dur_mins)
                    scheduled_end_str = end_dt.strftime("%Y-%m-%d %H:%M:%S")
                else:
                    created_at_str = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
                    scheduled_start_str = None
                    scheduled_end_str = None
                    dur_mins = 60

                video_url = f"https://canli.mng.muro.click/playback/presentation/2.3/{record_id}"
                session_id = str(uuid.uuid4())
                
                cur.execute(
                    'INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                    (session_id, c_id, title, video_url, record_id, False, created_at_str, 'Ended', 0, True, False, scheduled_start_str, scheduled_end_str, dur_mins)
                )
                
                # Register the session in CourseMedias curriculum table
                course_media_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s)',
                    (course_media_id, c_id, session_id, 0, datetime.datetime.utcnow())
                )
                db_sessions.add((c_id, record_id))
                sessions_created += 1

        print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"                      IMPORT SUMMARY")
        print(f"============================================================")
        print(f" [User] Oluşturulan Öğrenci Sayısı (Detaylı)    : {users_created}")
        print(f" [Mock] Oluşturulan Öğrenci Sayısı (Yedek/Grup)  : {mock_users_created}")
        print(f" [Tenant] TenantMemberships Eşleştirmesi         : {tenant_members_created}")
        print(f" [Course] Oluşturulan Yeni Ders Sayısı            : {courses_created}")
        print(f" [Course] Bireysel Ders Atamaları (Oluşturulan)  : {courses_assigned}")
        print(f" [Course] Bireysel Ders Atamaları (Zaten Var)    : {courses_skipped}")
        print(f" [Group] Oluşturulan Yeni Grup Sayısı            : {groups_created}")
        print(f" [Member] Gruba Öğrenci Ataması (Oluşturulan)     : {group_memberships_created}")
        print(f" [Member] Gruba Öğrenci Ataması (Zaten Var)       : {group_memberships_skipped}")
        print(f" [Video] Oluşturulan Video Kaydı (Sessions)      : {sessions_created}")
        print(f" [Video] Atlanan Video Kaydı (Zaten Var)        : {sessions_skipped}")
        
        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] BAŞARILI: Tüm değişiklikler veritabanına kaydedildi!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SIMULASYON MODU: Veritabanında hiçbir değişiklik yapılmadı.{Colors.ENDC}")
            print(f"    Canlı veritabanına yazmak için komutun sonuna '--execute' ekleyin:")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] HATA OLUŞTU (Değişiklikler geri alınıyor): {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
