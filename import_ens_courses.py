import os
import sys
import uuid
import datetime
import json
import re
import argparse
import pg8000

def normalize(s):
    if not s:
        return ''
    s = str(s).lower().strip()
    s = s.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    return re.sub(r'[^a-z0-9]', '', s)

def clean_phone_number(phone):
    if not phone:
        return None
    phone_str = str(phone).strip()
    main_part = phone_str.split('.')[0].split(',')[0]
    digits = "".join(c for c in main_part if c.isdigit())
    while digits.startswith("0"):
        digits = digits[1:]
    if len(digits) == 12 and digits.startswith("90"):
        digits = digits[2:]
    return digits if digits else None

def main():
    parser = argparse.ArgumentParser(description="Import scraped student course enrollments into MURO CourseStudents for ENS")
    parser.add_argument("--host", default="postgres", help="PostgreSQL host")
    parser.add_argument("--port", type=int, default=5432, help="PostgreSQL port")
    parser.add_argument("--dbname", default="muro_demo", help="PostgreSQL database name")
    parser.add_argument("--user", default="muro_user", help="PostgreSQL username")
    parser.add_argument("--password", default="MuroDem0_2026!Str0ng", help="PostgreSQL password")
    parser.add_argument("--json", default="okinar_bireysel_dersler.json", help="Path to scraped JSON file")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    args = parser.parse_args()

    print("=" * 60)
    print("      ENS INDIVIDUAL STUDENT-COURSE ENROLLMENT INTEGRATOR")
    print("=" * 60)

    json_path = args.json
    if not os.path.exists(json_path):
        print(f"[!] Error: JSON file '{json_path}' not found.")
        sys.exit(1)

    print(f"[*] Reading scraped data from '{json_path}'...")
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            scraped_data = json.load(f)
    except Exception:
        with open(json_path, 'r', encoding='windows-1254') as f:
            scraped_data = json.load(f)
    print(f"    - Loaded {len(scraped_data)} students from JSON.")

    print(f"[*] Connecting to PostgreSQL database {args.dbname} on {args.host}:{args.port}...")
    try:
        conn = pg8000.connect(
            host=args.host,
            port=args.port,
            database=args.dbname,
            user=args.user,
            password=args.password
        )
        cur = conn.cursor()
        print("[+] Connected successfully!")
    except Exception as e:
        print(f"[!] Connection failed: {e}")
        sys.exit(1)

    try:
        # Load courses
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
        db_courses = {normalize(r[1]): r[0] for r in cur.fetchall()}
        print(f"    - Loaded {len(db_courses)} active courses from DB.")

        # Load users (Students)
        cur.execute('SELECT "Id", "FirstName", "LastName", "Email", "Phone", "Username" FROM "Users" WHERE "Role" = \'Student\';')
        db_users_raw = cur.fetchall()
        
        users_by_phone = {}
        users_by_email = {}
        users_by_username = {}
        users_by_name = {}
        
        for u_id, first, last, email, phone, username in db_users_raw:
            full_name = f"{first} {last}".strip()
            norm_name = normalize(full_name)
            cleaned_phone = clean_phone_number(phone)
            email_lower = email.lower().strip() if email else None
            
            if cleaned_phone:
                users_by_phone[cleaned_phone] = u_id
            if email_lower:
                users_by_email[email_lower] = u_id
            if username:
                users_by_username[username.strip()] = u_id
            if norm_name:
                users_by_name[norm_name] = u_id

        # Load current enrollments
        cur.execute('SELECT "CourseId", "UserId" FROM "CourseStudents";')
        db_course_students = {(r[0], r[1]) for r in cur.fetchall()}
        print(f"    - Loaded {len(db_course_students)} existing course enrollments from DB.")

        created_count = 0
        skipped_count = 0
        user_not_found = 0
        course_not_found = set()

        print("\n[*] Processing enrollments...")
        for entry in scraped_data:
            name = entry.get('name')
            phone = clean_phone_number(entry.get('phone'))
            email = entry.get('email', '').lower().strip()
            courses = entry.get('courses', [])

            if not courses:
                continue

            u_id = None
            
            # Match 1: Phone
            if phone and phone in users_by_phone:
                u_id = users_by_phone[phone]
            # Match 2: Username
            elif phone and phone in users_by_username:
                u_id = users_by_username[phone]
            # Match 3: Email
            elif email and email in users_by_email:
                u_id = users_by_email[email]
            # Match 4: Name (Fallback)
            else:
                norm_name = normalize(name)
                # Skip if name is a date/time stamp
                if norm_name and not re.match(r'^\d{4}\d{2}\d{2}', norm_name):
                    if norm_name in users_by_name:
                        u_id = users_by_name[norm_name]

            if not u_id:
                print(f"   ⚠️ Eşleşmeyen Öğrenci: {name} (Telefon: {phone}, Eposta: {email})")
                user_not_found += 1
                continue

            for c_info in courses:
                c_name = c_info.get('courseName')
                c_name_clean = normalize(c_name)
                
                c_id = db_courses.get(c_name_clean)
                if not c_id:
                    course_not_found.add(c_name)
                    continue

                if (c_id, u_id) not in db_course_students:
                    if args.execute:
                        cur.execute(
                            'INSERT INTO "CourseStudents" ("Id", "CourseId", "UserId", "AssignedAt", "ExpiresAt") VALUES (%s, %s, %s, %s, %s);',
                            (str(uuid.uuid4()), c_id, u_id, datetime.datetime.now(datetime.timezone.utc), None)
                        )
                    db_course_students.add((c_id, u_id))
                    created_count += 1
                else:
                    skipped_count += 1

        print("\n" + "=" * 50)
        print("                 MIGRATION SUMMARY")
        print("=" * 50)
        print(f" - Enrollments to create: {created_count}")
        print(f" - Enrollments skipped (already exist): {skipped_count}")
        print(f" - Users not found in MURO: {user_not_found}")
        if course_not_found:
            print(f" - Courses not found in MURO DB ({len(course_not_found)}):")
            for cn in sorted(course_not_found):
                print(f"    * {cn}")

        if args.execute:
            conn.commit()
            print("\n[+] Database writes executed and committed successfully!")
        else:
            print("\n[!] DRY RUN ONLY. Run with --execute to write changes to the database.")

    except Exception as e:
        conn.rollback()
        print(f"\n[!] Error during migration: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
