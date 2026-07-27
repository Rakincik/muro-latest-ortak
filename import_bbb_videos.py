import psycopg2
import csv
import uuid
from datetime import datetime

# Muro .NET appsettings.json veritabanı bilgileri
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "muro_dev"
DB_USER = "muro_user"
DB_PASS = "muro_pass_2024"

# Masaüstündeki CSV dosyasının yolu
CSV_PATH = r"C:\Users\Rüstem\Desktop\okideolar\do.csv"

def main():
    print("Veritabanına bağlanılıyor...")
    try:
        conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASS)
        cursor = conn.cursor()
    except Exception as e:
        print(f"Veritabanı bağlantı hatası: {e}")
        return

    success_count = 0
    not_found_count = 0
    skipped_count = 0

    try:
        with open(CSV_PATH, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter=';')
            
            for row in reader:
                folder_id = row.get("ID")
                course_name = row.get("LMS Ders Adı")
                session_title = row.get("Oda Adı (BBB)")
                kurum_lms = row.get("Kurum (LMS)", "").lower()
                video_url = row.get("Link")
                
                if not folder_id or not course_name or not video_url:
                    continue
                    
                # Sadece Dershane Online (HLL) kurumuna ait olanları ekle
                if "dershane" not in kurum_lms:
                    continue

                # 1. Muro Veritabanından (Courses tablosu) Dersi Bul
                cursor.execute('SELECT "Id" FROM "Courses" WHERE "Title" = %s LIMIT 1', (course_name,))
                result = cursor.fetchone()
                
                if not result:
                    print(f"[!] HATA: Sistemde '{course_name}' isimli bir ders bulunamadı.")
                    not_found_count += 1
                    continue
                    
                course_id = result[0]
                
                # 2. Bu video daha önce eklenmiş mi kontrol et (Tekrar eklememek için)
                cursor.execute('SELECT "Id" FROM "Sessions" WHERE "BbbMeetingId" = %s', (folder_id,))
                if cursor.fetchone():
                    print(f"[-] ATLANDI (Zaten Ekli): {session_title}")
                    skipped_count += 1
                    continue
                    
                # 3. Bulunan derse video (Session) olarak kaydet
                session_id = str(uuid.uuid4())
                
                # BBB Video Oynatıcı Linki (HLL Domaini)
                video_url = f"https://canli.hll.muro.click/playback/presentation/2.3/{folder_id}"

                
                now = datetime.utcnow()
                
                # Insert Query
                insert_query = """
                INSERT INTO "Sessions" 
                ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
                VALUES (%s, %s, %s, false, 0, %s, false, 2, true, %s, %s)
                """
                
                cursor.execute(insert_query, (session_id, course_id, session_title, video_url, now, folder_id))
                success_count += 1
                print(f"[+] BAŞARILI: {course_name} -> {session_title} eklendi.")
                
        # Değişiklikleri kaydet
        conn.commit()
        
    except FileNotFoundError:
        print(f"HATA: {CSV_PATH} bulunamadı! Dosya adının doğruluğunu kontrol et.")
    except Exception as e:
        print(f"Bir hata oluştu: {e}")
    finally:
        cursor.close()
        conn.close()
        
    print("\n" + "="*30)
    print("      İŞLEM SONUCU      ")
    print("="*30)
    print(f"Başarıyla Veritabanına İşlenen : {success_count}")
    print(f"Zaten Ekli Olan (Atlanan)      : {skipped_count}")
    print(f"Ders Adı Uyuşmayanlar          : {not_found_count}")
    print("="*30)
    print("\nEğer Başarılı sayısı arttıysa, Muro Admin paneline girip Oturumlar sayfasını yenileyebilirsin!")

if __name__ == "__main__":
    main()
