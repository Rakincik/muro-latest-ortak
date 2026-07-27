import psycopg2
from datetime import datetime, timedelta

# Muro .NET appsettings.json veritabanı bilgileri
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "muro_dev"
DB_USER = "muro_user"
DB_PASS = "muro_pass_2024"

def main():
    print("Veritabanına bağlanılıyor ve az önce eklenen kayıtlar siliniyor...")
    try:
        conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASS)
        cursor = conn.cursor()
    except Exception as e:
        print(f"Veritabanı bağlantı hatası: {e}")
        return

    try:
        # Son 1 saat içinde eklenen ve bizim formatımızdaki (canli.monopoluzem.com.tr) VideoUrl'ye sahip kayıtları sil.
        delete_query = """
        DELETE FROM "Sessions" 
        WHERE "VideoUrl" LIKE 'https://canli.hll.muro.click/playback/presentation/2.3/%%'
        AND "CreatedAt" >= NOW() - INTERVAL '1 hour'
        """
        
        cursor.execute(delete_query)
        deleted_count = cursor.rowcount
        conn.commit()
        
        print(f"\n[+] BAŞARILI: Az önce yanlışlıkla eklenen {deleted_count} adet oturum kaydı veritabanından başarıyla silindi!")
        
    except Exception as e:
        print(f"Bir hata oluştu: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    main()
