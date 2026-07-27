import os
import sys
import argparse
import pg8000

def main():
    parser = argparse.ArgumentParser(description="Merge two groups in MURO ENS database")
    parser.add_argument("--host", default="postgres", help="PostgreSQL host")
    parser.add_argument("--port", type=int, default=5432, help="PostgreSQL port")
    parser.add_argument("--dbname", default="muro_demo", help="PostgreSQL database name")
    parser.add_argument("--user", default="muro_user", help="PostgreSQL username")
    parser.add_argument("--password", default="MuroDem0_2026!Str0ng", help="PostgreSQL password")
    parser.add_argument("--source", default="CANLI", help="Source group name (students will be moved FROM this group)")
    parser.add_argument("--target", default="2026 CANLI", help="Target group name (students will be moved TO this group)")
    parser.add_argument("--execute", action="store_true", help="Execute the database merge (defaults to dry-run)")
    args = parser.parse_args()

    print("=" * 60)
    print("      ENS GROUP MERGE TOOL")
    print("=" * 60)
    print(f"Source Group (Move FROM): '{args.source}'")
    print(f"Target Group (Move TO):   '{args.target}'")
    print("=" * 60)

    try:
        conn = pg8000.connect(
            host=args.host,
            port=args.port,
            database=args.dbname,
            user=args.user,
            password=args.password
        )
        cur = conn.cursor()
        print("[+] Connected to PostgreSQL successfully!")
    except Exception as e:
        print(f"[!] Connection failed: {e}")
        sys.exit(1)

    try:
        # 1. Find source group
        cur.execute('SELECT "Id", "Name" FROM "Groups" WHERE LOWER(TRIM("Name")) = LOWER(TRIM(%s)) AND "IsDeleted" = False;', (args.source,))
        source_row = cur.fetchone()
        if not source_row:
            print(f"[!] Error: Source group '{args.source}' not found in active groups.")
            sys.exit(1)
        source_id, source_name = source_row[0], source_row[1]

        # 2. Find target group
        cur.execute('SELECT "Id", "Name" FROM "Groups" WHERE LOWER(TRIM("Name")) = LOWER(TRIM(%s)) AND "IsDeleted" = False;', (args.target,))
        target_row = cur.fetchone()
        if not target_row:
            print(f"[!] Error: Target group '{args.target}' not found in active groups.")
            sys.exit(1)
        target_id, target_name = target_row[0], target_row[1]

        print(f"[+] Found Source Group: '{source_name}' (ID: {source_id})")
        print(f"[+] Found Target Group: '{target_name}' (ID: {target_id})")

        # Get initial counts
        cur.execute('SELECT COUNT(*) FROM "GroupMembers" WHERE "GroupId" = %s AND "Status" = \'active\';', (source_id,))
        source_members = cur.fetchone()[0]
        cur.execute('SELECT COUNT(*) FROM "GroupMembers" WHERE "GroupId" = %s AND "Status" = \'active\';', (target_id,))
        target_members = cur.fetchone()[0]

        cur.execute('SELECT COUNT(*) FROM "CourseGroups" WHERE "GroupId" = %s;', (source_id,))
        source_courses = cur.fetchone()[0]
        cur.execute('SELECT COUNT(*) FROM "CourseGroups" WHERE "GroupId" = %s;', (target_id,))
        target_courses = cur.fetchone()[0]

        print(f"\nCurrent Status:")
        print(f" - '{source_name}': {source_members} students, {source_courses} assigned courses")
        print(f" - '{target_name}': {target_members} students, {target_courses} assigned courses")

        if args.execute:
            print("\n[*] Executing merge operations...")

            # A. Delete duplicate student memberships in target group to prevent unique constraint failures
            cur.execute(
                'DELETE FROM "GroupMembers" WHERE "GroupId" = %s AND "UserId" IN ('
                '  SELECT "UserId" FROM "GroupMembers" WHERE "GroupId" = %s'
                ');',
                (source_id, target_id)
            )
            deleted_dupes = cur.rowcount
            print(f"   -> Removed {deleted_dupes} duplicate student memberships from source group.")

            # B. Move remaining members to target group
            cur.execute('UPDATE "GroupMembers" SET "GroupId" = %s WHERE "GroupId" = %s;', (target_id, source_id))
            moved_members = cur.rowcount
            print(f"   -> Successfully moved {moved_members} student memberships to '{target_name}'.")

            # C. Move announcements
            cur.execute('UPDATE "Announcements" SET "GroupId" = %s WHERE "GroupId" = %s;', (target_id, source_id))
            moved_announcements = cur.rowcount
            if moved_announcements > 0:
                print(f"   -> Moved {moved_announcements} announcements.")

            # D. Move calendar events
            cur.execute('UPDATE "CalendarEvents" SET "GroupId" = %s WHERE "GroupId" = %s;', (target_id, source_id))
            moved_events = cur.rowcount
            if moved_events > 0:
                print(f"   -> Moved {moved_events} calendar events.")

            # E. Soft-delete the source group
            import datetime
            cur.execute('UPDATE "Groups" SET "IsDeleted" = True, "DeletedAt" = %s WHERE "Id" = %s;', (datetime.datetime.utcnow(), source_id))
            print(f"   -> Soft-deleted source group '{source_name}'.")

            conn.commit()
            print("\n[+] Merge successfully completed and committed!")

            # Verify final state
            cur.execute('SELECT COUNT(*) FROM "GroupMembers" WHERE "GroupId" = %s AND "Status" = \'active\';', (target_id,))
            final_members = cur.fetchone()[0]
            print(f"\nFinal State:")
            print(f" - '{target_name}': {final_members} students, {target_courses} assigned courses.")
        else:
            # Dry-run calculation
            cur.execute(
                'SELECT COUNT(*) FROM "GroupMembers" WHERE "GroupId" = %s AND "UserId" IN ('
                '  SELECT "UserId" FROM "GroupMembers" WHERE "GroupId" = %s'
                ');',
                (source_id, target_id)
            )
            dupes = cur.fetchone()[0]
            to_move = source_members - dupes
            print(f"\n[!] DRY RUN ONLY. If executed:")
            print(f"   -> {dupes} duplicate members will be removed.")
            print(f"   -> {to_move} members will be moved from '{source_name}' to '{target_name}'.")
            print(f"   -> '{source_name}' group will be soft-deleted.")
            print(f"   -> '{target_name}' will have a total of {target_members + to_move} members.")
            print("\nRun with --execute to commit these changes.")

    except Exception as e:
        conn.rollback()
        print(f"\n[!] Error during group merge: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
