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
        
        # Check email domains
        cur.execute('SELECT SPLIT_PART("Email", \'@\', 2), COUNT(*) FROM "Users" GROUP BY SPLIT_PART("Email", \'@\', 2);')
        print("Email Domains in ENS Database:")
        for row in cur.fetchall():
            print(row)
            
        conn.close()
    except Exception as e:
        print("[❌] HATA:")
        print(e)

if __name__ == '__main__':
    main()
