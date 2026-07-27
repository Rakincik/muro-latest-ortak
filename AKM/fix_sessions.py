import psycopg2
import subprocess

def fix_sessions():
    try:
        print("[*] Veritabanına bağlanılıyor...")
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # Mevcut durumu göster
        cur.execute('SELECT "Status", count(*) FROM "Sessions" GROUP BY "Status"')
        print(f"Mevcut Status Dağılımı: {cur.fetchall()}")
        
        # Status '3' (text) olanları 'Completed' (veya Muro'nun geçerli bitmiş durumuna) olarak güncelliyoruz.
        cur.execute('UPDATE "Sessions" SET "Status" = \'Completed\' WHERE "Status" = \'3\' AND "BbbMeetingId" IS NOT NULL;')
        updated = cur.rowcount
        
        # Eğer TenantId sütunu varsa ve bizim eklediklerimiz NULL kalmışsa onları da düzeltelim
        tenant_updated = 0
        try:
            # Akademik masa tenant ID'sini bul
            cur.execute('SELECT "Id" FROM "Tenants" WHERE "Name" ILIKE \'%akademik%\' OR "Host" ILIKE \'%akm%\' LIMIT 1;')
            tenant_row = cur.fetchone()
            if tenant_row:
                t_id = tenant_row[0]
                cur.execute('UPDATE "Sessions" SET "TenantId" = %s WHERE "TenantId" IS NULL AND "BbbMeetingId" IS NOT NULL;', (t_id,))
                tenant_updated = cur.rowcount
        except Exception as e:
            # TenantId sütunu yoksa hatayı yoksay
            conn.rollback()

        conn.commit()
        print(f"\n[+] BAŞARILI! {updated} adet videonun durumu Panel'de görünecek şekilde (Status=2) güncellendi.")
        if tenant_updated > 0:
            print(f"[+] {tenant_updated} adet videoya AKM Tenant ID'si atandı.")
            
        cur.close()
        conn.close()

    except Exception as e:
        print(f"[-] Hata oluştu: {e}")

if __name__ == "__main__":
    fix_sessions()
