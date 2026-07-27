import psycopg2
import subprocess
import uuid
from datetime import datetime

def fix_course_medias():
    try:
        print("[*] Veritabanına bağlanılıyor...")
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # 1. Bizim eklediğimiz (BbbMeetingId'si olan) oturumları al
        cur.execute('SELECT "Id", "CourseId", "Order" FROM "Sessions" WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != \'\';')
        sessions = cur.fetchall()
        
        inserted_count = 0
        skipped_count = 0
        
        print(f"[*] Toplam {len(sessions)} adet video tespit edildi. CourseMedia bağlantıları yapılıyor...")
        
        for s_id, c_id, order in sessions:
            # 2. Bu SessionId zaten CourseMedia'da var mı kontrol et
            cur.execute('SELECT 1 FROM "CourseMedias" WHERE "SessionId" = %s;', (s_id,))
            exists = cur.fetchone()
            
            if not exists:
                # 3. Yoksa yeni bir CourseMedia kaydı oluştur
                cm_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt") VALUES (%s, %s, %s, %s, %s);',
                    (cm_id, c_id, s_id, order or 0, datetime.utcnow())
                )
                inserted_count += 1
            else:
                skipped_count += 1
                
        conn.commit()
        print(f"\n[+] ZAFER! {inserted_count} adet videonun Medya Kütüphanesi bağlantısı başarıyla oluşturuldu!")
        if skipped_count > 0:
            print(f"[*] {skipped_count} adet video zaten bağlı olduğu için atlandı.")
            
        cur.close()
        conn.close()

    except Exception as e:
        print(f"[-] Hata oluştu: {e}")

if __name__ == "__main__":
    fix_course_medias()
