import psycopg2
import os

# MURO DB Bilgileri (import_akm.py içindeki ile aynı)
DB_CONFIG = {
    'host': '127.0.0.1',
    'port': 5432,
    'dbname': 'muro_demo',
    'user': 'muro_user',
    'password': 'MuroDem0_2026!Str0ng'
}
import subprocess
try:
    ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
    if ip:
        DB_CONFIG['host'] = ip
except Exception:
    pass

def export_videos():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        c = conn.cursor()
        
        # Muro veritabanındaki TÜM kayıtların klasör isimlerini çekiyoruz
        c.execute('SELECT "BbbMeetingId" FROM "Sessions" WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != \'\'')
        rows = c.fetchall()
        
        if not rows:
            print("Veritabanında hiç video (session) bulunamadı!")
            return
        
        # Benzersiz ID'leri topla
        video_ids = set()
        for row in rows:
            rec_id = row[0].strip()
            video_ids.add(rec_id)
        
        # Rsync için özel filtre dosyası oluştur (SADECE bu klasörleri alması için)
        file_path = "valid_bbb_ids.txt"
        with open(file_path, "w", encoding="utf-8") as f:
            for vid in video_ids:
                # Rsync include formatı: her klasör için klasör adını ve içindekileri al
                f.write(f"+ {vid}/***\n")
            
            # Diğer tüm klasörleri reddet
            f.write("- *\n")
            
        print(f"BAŞARILI! Toplam {len(video_ids)} adet benzersiz video ID'si çıkarıldı.")
        print(f"Rsync filtre dosyası '{file_path}' başarıyla oluşturuldu!")
        
        c.close()
        conn.close()
        
    except Exception as e:
        print(f"Hata oluştu: {e}")

if __name__ == "__main__":
    export_videos()
