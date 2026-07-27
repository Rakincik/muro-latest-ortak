import psycopg2
import subprocess
import sys

def main():
    try:
        # Get IP of muro_ens_postgres container
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_ens_postgres']).decode('utf-8').strip()
    except Exception as e:
        print("[❌] HATA: 'muro_ens_postgres' konteyneri çalışmıyor veya bulunamadı!")
        print("Detay:", e)
        sys.exit(1)

    print(f"[*] Konteyner IP adresi tespit edildi: {ip}")
    print("[*] Veritabanına bağlanılıyor...")
    
    try:
        conn = psycopg2.connect(
            host=ip,
            port=5432,
            dbname="muro_demo",
            user="muro_user",
            password="MuroDem0_2026!Str0ng"
        )
        cur = conn.cursor()
        
        cur.execute('SELECT COUNT(*) FROM "Users" WHERE "Role" = \'Student\';')
        print("Total Students:", cur.fetchone()[0])
        
        cur.execute('SELECT COUNT(*) FROM "Groups";')
        print("Total Groups:", cur.fetchone()[0])
        
        cur.execute('SELECT COUNT(*) FROM "Courses";')
        print("Total Courses:", cur.fetchone()[0])
        
        cur.execute('SELECT COUNT(*) FROM "Sessions";')
        print("Total Sessions:", cur.fetchone()[0])
        
        conn.close()
    except Exception as e:
        print("[❌] Veritabanı bağlantı hatası:")
        print(e)

if __name__ == '__main__':
    main()
