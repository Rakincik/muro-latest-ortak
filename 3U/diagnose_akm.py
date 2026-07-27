import os
import sys
import psycopg2

def main():
    conn_params = {
        'host': '192.168.32.5',
        'port': 5432,
        'dbname': 'muro_demo',
        'user': 'muro_user',
        'password': 'MuroDem0_2026!Str0ng'
    }

    try:
        conn = psycopg2.connect(**conn_params)
        cur = conn.cursor()
    except Exception as e:
        print(f"Connection failed: {e}")
        sys.exit(1)

    print("=== DATABASE DIAGNOSTIC ===")
    
    # 1. Total users
    cur.execute('SELECT COUNT(*) FROM "Users";')
    print(f"Total Users: {cur.fetchone()[0]}")
    
    # 2. Roles in DB
    cur.execute('SELECT "Role", COUNT(*) FROM "Users" GROUP BY "Role";')
    print("\nRoles in DB:")
    for r, count in cur.fetchall():
        print(f"  - {r}: {count}")
        
    # 3. Sample phone numbers and usernames
    cur.execute('SELECT "FirstName", "LastName", "Phone", "Username", "Role" FROM "Users" WHERE "Phone" IS NOT NULL LIMIT 10;')
    print("\nSample Phone Numbers in DB:")
    for fn, ln, phone, username, role in cur.fetchall():
        print(f"  * Name: {fn} {ln} | Phone: {phone!r} | Username: {username!r} | Role: {role}")
        
    # 4. Check if a specific phone number exists
    test_phones = ['5384295659', '5340199271', '5345412253']
    print("\nTesting specific phone numbers:")
    for tp in test_phones:
        cur.execute('SELECT "Id", "FirstName", "LastName", "Phone", "Role" FROM "Users" WHERE "Phone" LIKE %s;', (f'%{tp}%',))
        res = cur.fetchall()
        print(f"  Looking for {tp}: Found {len(res)} matches")
        for r in res:
            print(f"    -> ID: {r[0]} | Name: {r[1]} {r[2]} | Phone: {r[3]!r} | Role: {r[4]}")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
