import psycopg2
import subprocess
import sys

def main():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_ens_postgres']).decode('utf-8').strip()
    except Exception as e:
        print("[❌] HATA: 'muro_ens_postgres' konteyneri çalışmıyor veya bulunamadı!")
        sys.exit(1)

    try:
        conn = psycopg2.connect(
            host=ip,
            port=5432,
            dbname="muro_demo",
            user="muro_user",
            password="MuroDem0_2026!Str0ng"
        )
        cur = conn.cursor()
        
        # Check users created after June 1st, 2026
        cur.execute('SELECT "CreatedAt", COUNT(*) FROM "Users" WHERE "CreatedAt" >= \'2026-06-01\' GROUP BY "CreatedAt" ORDER BY "CreatedAt" DESC;')
        rows = cur.fetchall()
        print("Users created after June 1st, 2026 in Database:")
        total_recent = 0
        for row in rows:
            print(f"Date: {row[0]}, Count: {row[1]}")
            total_recent += row[1]
        print(f"Total users created since June 1st: {total_recent}")
            
        conn.close()
    except Exception as e:
        print("[❌] HATA:")
        print(e)

if __name__ == '__main__':
    main()
