import sys
import argparse
import openpyxl
import psycopg2

def main():
    parser = argparse.ArgumentParser(description="Manage Inactive Users")
    parser.add_argument('--host', default='localhost')
    parser.add_argument('--port', default='5432')
    parser.add_argument('--dbname', default='muro_demo')
    parser.add_argument('--user', default='muro_user')
    parser.add_argument('--password', default='MuroDem0_2026!Str0ng')
    parser.add_argument('--export', action='store_true', help='Export inactive users to excel')
    parser.add_argument('--activate', action='store_true', help='Set IsActive=True for all inactive students')
    parser.add_argument('--deactivate', action='store_true', help='Set IsActive=False for the activated students')
    
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

    if args.export:
        print("[*] Debugging inactive students query...")
        cur.execute('SELECT COUNT(*) FROM "Users" WHERE "IsActive" = False;')
        total_inactive = cur.fetchone()[0]
        print(f"    - Total inactive users in DB (any role): {total_inactive}")
        
        cur.execute('SELECT COUNT(*) FROM "Users" WHERE "IsActive" = False AND "Role" = \'Student\';')
        total_inactive_students = cur.fetchone()[0]
        print(f"    - Total inactive Students in DB: {total_inactive_students}")

        print("[*] Fetching inactive students...")
        cur.execute('SELECT "FirstName", "LastName", "Email", "Phone", "CreatedAt" FROM "Users" WHERE "IsActive" = False AND "Role" = \'Student\';')
        rows = cur.fetchall()
        
        wb = openpyxl.Workbook()
        ws = wb.active
        ws.title = "Pasif Ogrenciler"
        ws.append(["Ad", "Soyad", "Email", "Telefon", "Kayit Tarihi"])
        
        for r in rows:
            ws.append([r[0], r[1], r[2], r[3], str(r[4])])
            
        filename = "pasif_ogrenciler.xlsx"
        wb.save(filename)
        print(f"[+] Saved {len(rows)} inactive students to '{filename}' successfully!")

    elif args.activate:
        print("[*] Activating inactive students (setting IsActive=True)...")
        cur.execute('SELECT "Id" FROM "Users" WHERE "IsActive" = False AND "Role" = \'Student\';')
        ids = [r[0] for r in cur.fetchall()]
        
        if not ids:
            print("[!] No inactive students found to activate.")
            sys.exit(0)
            
        with open("activated_ids.txt", "w") as f:
            for uid in ids:
                f.write(f"{uid}\n")
                
        cur.execute('UPDATE "Users" SET "IsActive" = True WHERE "IsActive" = False AND "Role" = \'Student\';')
        conn.commit()
        print(f"[+] Activated {len(ids)} students successfully! Saved original IDs to 'activated_ids.txt'.")

    elif args.deactivate:
        import os
        if not os.path.exists("activated_ids.txt"):
            print("[!] Error: 'activated_ids.txt' file not found. Cannot revert activation.")
            sys.exit(1)
            
        with open("activated_ids.txt", "r") as f:
            ids = [line.strip() for line in f if line.strip()]
            
        if not ids:
            print("[!] No IDs found in 'activated_ids.txt'.")
            sys.exit(0)
            
        print(f"[*] Reverting activation for {len(ids)} students (setting IsActive=False)...")
        # Fixed UUID array type casting
        cur.execute('UPDATE "Users" SET "IsActive" = False WHERE "Id" = ANY(%s::uuid[]);', (ids,))
        conn.commit()
        print("[+] Reverted activation successfully!")
        
    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
