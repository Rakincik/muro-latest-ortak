import psycopg2
import subprocess
import traceback

def diagnostic_db():
    print("--- MURO VERİTABANI CHECK-UP BAŞLIYOR ---")
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        print(f"Postgres IP: {ip}")
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # 1. Toplam Session Sayısı
        cur.execute('SELECT count(*) FROM "Sessions"')
        print(f"Toplam Session: {cur.fetchone()[0]}")
        
        # 2. BbbMeetingId'si dolu olanlar (Bizimkiler)
        cur.execute('SELECT count(*) FROM "Sessions" WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != \'\'')
        bizimkiler = cur.fetchone()[0]
        print(f"Bizim Eklediğimiz Session Sayısı: {bizimkiler}")
        
        # 3. Bizimkilerin Status Dağılımı
        cur.execute('SELECT "Status", count(*) FROM "Sessions" WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != \'\' GROUP BY "Status"')
        print(f"Bizimkilerin Durum Dağılımı: {cur.fetchall()}")
        
        # 4. Bizimkilerin TenantId'si var mı?
        try:
            cur.execute('SELECT "TenantId" IS NULL, count(*) FROM "Sessions" WHERE "BbbMeetingId" IS NOT NULL AND "BbbMeetingId" != \'\' GROUP BY "TenantId" IS NULL')
            print(f"Bizimkilerin TenantId (Boş Mu?): {cur.fetchall()}")
        except Exception as e:
            print("TenantId sütunu yokmuş.")
            conn.rollback()

        # 5. Course Id Eşleşmesi Kontrolü
        cur.execute('''
            SELECT c."Title", count(s."Id") 
            FROM "Courses" c
            JOIN "Sessions" s ON c."Id" = s."CourseId"
            WHERE s."BbbMeetingId" IS NOT NULL AND s."BbbMeetingId" != ''
            GROUP BY c."Title"
            LIMIT 5;
        ''')
        print(f"Ders-Session Eşleşme Örneği (İlk 5): {cur.fetchall()}")

        cur.close()
        conn.close()
        print("--- CHECK-UP TAMAMLANDI ---")

    except Exception as e:
        print(f"HATA OLUŞTU: {e}")
        traceback.print_exc()

if __name__ == "__main__":
    diagnostic_db()
