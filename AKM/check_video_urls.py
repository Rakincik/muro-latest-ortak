import psycopg2
import subprocess

def check_video_urls():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        cur.execute('SELECT "Id", "VideoUrl" FROM "Sessions" WHERE "BbbMeetingId" IS NOT NULL LIMIT 5;')
        rows = cur.fetchall()
        
        for r in rows:
            print(f"Session: {r[0]} | VideoUrl: {r[1]}")
            
        cur.close()
        conn.close()

    except Exception as e:
        print(f"[-] Hata oluştu: {e}")

if __name__ == "__main__":
    check_video_urls()
