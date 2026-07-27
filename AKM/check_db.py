import psycopg2
import subprocess

def check_db():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # 1. Kaç tane Session var?
        cur.execute('SELECT COUNT(*) FROM "Sessions";')
        print(f"Toplam Session sayısı: {cur.fetchone()[0]}")
        
        # 2. Kaç tane VideoUrl dolu?
        cur.execute('SELECT COUNT(*) FROM "Sessions" WHERE "VideoUrl" IS NOT NULL AND "VideoUrl" != \'\';')
        print(f"VideoUrl DOSTU olan Session sayısı: {cur.fetchone()[0]}")
        
        # 3. Örnek bir kayıt getirelim
        cur.execute('SELECT "Id", "Title", "VideoUrl" FROM "Sessions" WHERE "VideoUrl" IS NOT NULL LIMIT 2;')
        for r in cur.fetchall():
            print(f"ID: {r[0]} | Title: {r[1]} | VideoUrl: {r[2]}")
            
        cur.close()
        conn.close()

    except Exception as e:
        print(f"[-] Hata: {e}")

if __name__ == "__main__":
    check_db()
