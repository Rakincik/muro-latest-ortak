import psycopg2
import subprocess

def fix_course_ids():
    try:
        print("[*] Veritabanına bağlanılıyor...")
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # 1. Akademik Masa'nın TenantId'sini bul
        cur.execute('SELECT "Id" FROM "Tenants" WHERE "Name" ILIKE \'%akademik%\' OR "Host" ILIKE \'%akm%\' LIMIT 1;')
        tenant_row = cur.fetchone()
        if not tenant_row:
            print("[-] Akademik Masa tenant'ı bulunamadı!")
            return
        tenant_id = tenant_row[0]
        print(f"[+] Akademik Masa Tenant ID: {tenant_id}")
        
        # 2. BbbMeetingId dolu olan (bizim eklediğimiz) oturumları ve bağlandıkları hatalı derslerin başlıklarını al
        cur.execute('''
            SELECT s."Id", s."Title", c."Title", s."CourseId"
            FROM "Sessions" s
            JOIN "Courses" c ON s."CourseId" = c."Id"
            WHERE s."BbbMeetingId" IS NOT NULL AND s."BbbMeetingId" != ''
        ''')
        sessions = cur.fetchall()
        
        updated_count = 0
        failed_count = 0
        
        for s_id, s_title, c_title, old_c_id in sessions:
            # 3. Bu başlığa sahip ve Akademik Masa'ya ait olan DOĞRU dersi bul
            cur.execute('SELECT "Id" FROM "Courses" WHERE "Title" = %s AND "TenantId" = %s LIMIT 1;', (c_title, tenant_id))
            correct_course = cur.fetchone()
            
            if correct_course:
                correct_c_id = correct_course[0]
                if old_c_id != correct_c_id:
                    # Yanlış şubenin dersine bağlanmış, düzelt!
                    cur.execute('UPDATE "Sessions" SET "CourseId" = %s WHERE "Id" = %s;', (correct_c_id, s_id))
                    updated_count += 1
            else:
                # Akademik Masa'da bu isimde ders yok
                failed_count += 1
                
        conn.commit()
        print(f"\n[+] ZAFER! {updated_count} adet videonun Ders eşleşmesi DOĞRU şube (Akademik Masa) ile düzeltildi!")
        print(f"[*] Hata (Bu isimde AKM dersi bulunamadı): {failed_count}")
        
        cur.close()
        conn.close()

    except Exception as e:
        print(f"[-] Hata oluştu: {e}")

if __name__ == "__main__":
    fix_course_ids()
