import psycopg2
import subprocess

def make_sessions_completed():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # BbbMeetingId'si olan (yani bizim eklediğimiz) TÜM videoların Status'ünü 'Completed' yap
        cur.execute('UPDATE "Sessions" SET "Status" = \'Completed\' WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != \'\';')
        updated = cur.rowcount
        conn.commit()
        
        print(f"\n[+] ZAFER! Tam {updated} adet videonun durumu Muro'nun anlayacağı orijinal 'Completed' (Tamamlandı) formatına dönüştürüldü!")
        
        cur.close()
        conn.close()

    except Exception as e:
        print(f"Hata: {e}")

if __name__ == "__main__":
    make_sessions_completed()
