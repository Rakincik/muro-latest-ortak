import psycopg2
import subprocess

def fix_video_urls():
    try:
        print("[*] Veritabanına bağlanılıyor...")
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # Muro'nun oynatabilmesi için VideoUrl alanını BBB linkiyle dolduruyoruz
        query = """
            UPDATE "Sessions"
            SET "VideoUrl" = 'https://canli.akm.muro.click/playback/presentation/2.3/playback.html?meetingId=' || "BbbMeetingId"
            WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != '' AND ("VideoUrl" IS NULL OR "VideoUrl" = '');
        """
        cur.execute(query)
        updated_count = cur.rowcount
        conn.commit()
        
        print(f"\n[+] ZAFER! {updated_count} adet videonun OYNATMA LİNKİ (VideoUrl) sisteme işlendi!")
        cur.close()
        conn.close()

    except Exception as e:
        print(f"[-] Hata oluştu: {e}")

if __name__ == "__main__":
    fix_video_urls()
