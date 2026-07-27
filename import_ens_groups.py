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

def main():
    parser = argparse.ArgumentParser(description="Import scraped group student memberships into MURO Groups/GroupMembers for ENS")
    parser.add_argument("--host", default="postgres", help="PostgreSQL host")
    parser.add_argument("--port", type=int, default=5432, help="PostgreSQL port")
    parser.add_argument("--dbname", default="muro_demo", help="PostgreSQL database name")
    parser.add_argument("--user", default="muro_user", help="PostgreSQL username")
    parser.add_argument("--password", default="MuroDem0_2026!Str0ng", help="PostgreSQL password")
    parser.add_argument("--json", default="okinar_grup_ogrencileri.json", help="Path to scraped groups JSON file")
    parser.add_argument("--execute", action="store_true", help="Execute the database writes (defaults to dry-run)")
    parser.add_argument("--auto-create-users", action="store_true", help="Automatically create student users in MURO if they don't exist")
    parser.add_argument("--sync", action="store_true", help="Synchronize memberships exactly, removing students not in Okinar group")
    args = parser.parse_args()

    print("=" * 60)
    print("      ENS STUDENT-GROUP MEMBERSHIP INTEGRATOR")
    print("=" * 60)

    json_path = args.json
    if not os.path.exists(json_path):
        print(f"[!] Error: JSON file '{json_path}' not found.")
        sys.exit(1)

    print(f"[*] Reading scraped groups data from '{json_path}'...")
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            scraped_groups = json.load(f)
    except Exception as e:
        print(f"[!] Error reading JSON: {e}")
        sys.exit(1)
        
    print(f"    - Loaded {len(scraped_groups)} groups from JSON.")

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
        # Load default password hash from an existing student
        cur.execute('SELECT "PasswordHash" FROM "Users" WHERE "Role" = \'Student\' AND "PasswordHash" IS NOT NULL AND "PasswordHash" != \'\' LIMIT 1;')
        row = cur.fetchone()
        default_password_hash = row[0] if row else "AQAAAAIAAYagAAAAEFL6u7bH8g9k..."

        # Load existing groups in MURO
        cur.execute('SELECT "Id", "Name" FROM "Groups" WHERE "IsDeleted" = False;')
        db_groups = {r[1].strip().lower(): r[0] for r in cur.fetchall()}
        print(f"    - Loaded {len(db_groups)} active groups from DB.")

        # Load users (Students) to match by name
        cur.execute('SELECT "Id", "FirstName", "LastName" FROM "Users" WHERE "Role" = \'Student\';')
        db_users_raw = cur.fetchall()
        
        users_by_name = {}
        user_id_to_name = {}
        for u_id, first, last in db_users_raw:
            full_name = f"{first} {last}".strip()
            norm_name = normalize(full_name)
            if norm_name:
                users_by_name[norm_name] = u_id
            user_id_to_name[u_id] = full_name
                
        print(f"    - Loaded {len(users_by_name)} students from DB.")

        # Load existing group memberships
        cur.execute('SELECT "GroupId", "UserId" FROM "GroupMembers" WHERE "Status" = \'active\';')
        db_members = {(r[0], r[1]) for r in cur.fetchall()}
        print(f"    - Loaded {len(db_members)} existing group memberships from DB.")

        groups_created = 0
        users_created = 0
        members_created = 0
        members_deleted = 0
        members_skipped = 0
        students_not_found = 0

        print("\n[*] Processing groups and memberships...")
        for group_entry in scraped_groups:
            group_name = group_entry.get('groupName', '').strip()
            students = group_entry.get('students', [])
            
            if not group_name:
                continue
                
            print(f"\n📁 Grup: '{group_name}' ({len(students)} öğrenci)")
            
            # Check if group exists
            group_key = group_name.lower()
            if group_key in db_groups:
                group_id = db_groups[group_key]
                print(f"   -> Grup veritabanında zaten mevcut (ID: {group_id})")
            else:
                group_id = str(uuid.uuid4())
                if args.execute:
                    cur.execute(
                        'INSERT INTO "Groups" ("Id", "Name", "IsDeleted", "Description", "Color", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s)',
                        (group_id, group_name, False, "Okinar'dan aktarılan grup.", "#6366f1", datetime.datetime.utcnow())
                    )
                print(f"   -> [+] Yeni grup oluşturulacak: '{group_name}' (ID: {group_id})")
                db_groups[group_key] = group_id
                groups_created += 1
                
            target_user_ids = set()
            for std_name in students:
                norm_name = normalize(std_name)
                user_id = users_by_name.get(norm_name)
                
                if not user_id:
                    if args.auto_create_users:
                        # Split first and last name
                        parts = std_name.strip().split()
                        if len(parts) > 1:
                            first_name = " ".join(parts[:-1])
                            last_name = parts[-1]
                        else:
                            first_name = std_name
                            last_name = ""
                        
                        user_id = str(uuid.uuid4())
                        fake_username = norm_name if norm_name else f"student_{user_id[:8]}"
                        fake_email = f"{fake_username}@ens.muro"
                        
                        if args.execute:
                            cur.execute(
                                'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Username", "PasswordHash", "Role", "IsActive", "CreatedAt", "IsDeleted", "FailedLoginCount") '
                                'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                                (user_id, first_name, last_name, fake_email, fake_username, default_password_hash, "Student", True, datetime.datetime.utcnow(), False, 0)
                            )
                        print(f"      [+] Yeni Öğrenci oluşturulacak: {std_name} (Email: {fake_email})")
                        users_by_name[norm_name] = user_id
                        user_id_to_name[user_id] = std_name
                        users_created += 1
                    else:
                        print(f"      ⚠️ Öğrenci MURO'da bulunamadı: {std_name}")
                        students_not_found += 1
                        continue
                    
                target_user_ids.add(user_id)

            # Get current active members of this group in MURO
            cur.execute('SELECT "UserId" FROM "GroupMembers" WHERE "GroupId" = %s AND "Status" = \'active\';', (group_id,))
            current_user_ids = {r[0] for r in cur.fetchall()}

            # If sync option is selected, remove members that are in MURO but not in Okinar
            if args.sync:
                users_to_remove = current_user_ids - target_user_ids
                for r_uid in users_to_remove:
                    r_name = user_id_to_name.get(r_uid, f"Bilinmeyen (ID: {r_uid})")
                    if args.execute:
                        cur.execute('DELETE FROM "GroupMembers" WHERE "GroupId" = %s AND "UserId" = %s;', (group_id, r_uid))
                    print(f"      [-] Öğrenci gruptan çıkarılacak: {r_name}")
                    members_deleted += 1

            # Add missing members to MURO group
            users_to_add = target_user_ids - current_user_ids
            for a_uid in users_to_add:
                if args.execute:
                    cur.execute(
                        'INSERT INTO "GroupMembers" ("Id", "GroupId", "UserId", "Role", "Status", "AddedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s)',
                        (str(uuid.uuid4()), group_id, a_uid, 2, "active", datetime.datetime.utcnow())
                    )
                members_created += 1

            members_skipped += len(target_user_ids & current_user_ids)

        print("\n" + "=" * 50)
        print("                 MIGRATION SUMMARY")
        print("=" * 50)
        print(f" - Groups created in DB: {groups_created}")
        print(f" - Student users created in DB: {users_created}")
        print(f" - Group assignments created: {members_created}")
        print(f" - Group assignments removed (clean-sync): {members_deleted}")
        print(f" - Group assignments skipped (already exist): {members_skipped}")
        print(f" - Students not matched/created in MURO: {students_not_found}")

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
