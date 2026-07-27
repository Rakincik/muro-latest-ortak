import sys
import argparse
import psycopg2

def main():
    parser = argparse.ArgumentParser(description="Inspect Users in DB")
    parser.add_argument('--host', default='localhost')
    parser.add_argument('--port', default='5432')
    parser.add_argument('--dbname', default='muro_demo')
    parser.add_argument('--user', default='muro_user')
    parser.add_argument('--password', default='MuroDem0_2026!Str0ng')
    args = parser.parse_args()

    conn_params = {
        'host': args.host,
        'port': args.port,
        'dbname': args.dbname,
        'user': args.user,
        'password': args.password
    }

    try:
        conn = psycopg2.connect(**conn_params)
        cur = conn.cursor()
    except Exception as e:
        print(f"Connection failed: {e}")
        sys.exit(1)

    print("=== Database Users Statistics ===")
    
    # 1. Total Rows
    cur.execute('SELECT COUNT(*) FROM "Users";')
    print(f"Total Rows in 'Users' table: {cur.fetchone()[0]}")

    # 2. Roles
    cur.execute('SELECT "Role", COUNT(*) FROM "Users" GROUP BY "Role";')
    print("\nBreakdown by Role:")
    for role, count in cur.fetchall():
        print(f"  - {role or 'NULL'}: {count}")

    # 3. Deletion Status
    try:
        cur.execute('SELECT "IsDeleted", COUNT(*) FROM "Users" GROUP BY "IsDeleted";')
        print("\nBreakdown by IsDeleted:")
        for status, count in cur.fetchall():
            print(f"  - IsDeleted={status}: {count}")
    except Exception:
        conn.rollback()
        print("\n'IsDeleted' column not found or error occurred.")

    # 4. Activity Status
    try:
        cur.execute('SELECT "IsActive", COUNT(*) FROM "Users" GROUP BY "IsActive";')
        print("\nBreakdown by IsActive:")
        for status, count in cur.fetchall():
            print(f"  - IsActive={status}: {count}")
    except Exception:
        conn.rollback()
        print("\n'IsActive' column not found or error occurred.")

    # 5. Student Type
    try:
        cur.execute('SELECT "StudentType", COUNT(*) FROM "Users" GROUP BY "StudentType";')
        print("\nBreakdown by StudentType:")
        for stype, count in cur.fetchall():
            print(f"  - StudentType={stype or 'NULL'}: {count}")
    except Exception:
        conn.rollback()
        print("\n'StudentType' column not found or error occurred.")

    # 6. Tenant Memberships count if table exists
    try:
        cur.execute('SELECT COUNT(*) FROM "TenantMemberships";')
        print(f"\nTotal rows in 'TenantMemberships': {cur.fetchone()[0]}")
    except Exception:
        conn.rollback()
        print("\n'TenantMemberships' table does not exist or error occurred.")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
