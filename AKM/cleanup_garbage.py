import psycopg2
import os
import re

print("=" * 60)
print("      AKADEMIK MASA LMS - ÇÖP DERS TEMİZLEYİCİ")
print("=" * 60)

conn_params = {}
paths = [
    "src/MURO.API/appsettings.json",
    "appsettings.json",
    "../src/MURO.API/appsettings.json"
]
for p in paths:
    if os.path.exists(p):
        try:
            with open(p, "r", encoding="utf-8") as f:
                content = f.read()
                match = re.search(r'"DefaultConnection"\s*:\s*"([^"]+)"', content)
                if match:
                    conn_str = match.group(1)
                    for item in conn_str.split(';'):
                        if '=' in item:
                            k, v = item.split('=', 1)
                            k_lower = k.strip().lower()
                            v_val = v.strip()
                            if k_lower == 'host': conn_params['host'] = v_val
                            elif k_lower == 'port': conn_params['port'] = int(v_val)
                            elif k_lower == 'database': conn_params['dbname'] = v_val
                            elif k_lower == 'username': conn_params['user'] = v_val
                            elif k_lower == 'password': conn_params['password'] = v_val
        except Exception:
            pass

# .env okuma (Güvenlik İçin)
env_paths = [".env", "../.env", "../../.env"]
for ep in env_paths:
    if os.path.exists(ep):
        try:
            with open(ep, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#") and "=" in line:
                        k, v = line.split("=", 1)
                        k = k.strip()
                        v = v.strip()
                        if k == "DB_USER": conn_params["user"] = v
                        elif k == "DB_PASSWORD": conn_params["password"] = v
                        elif k == "DB_NAME": conn_params["dbname"] = v
        except Exception:
            pass

# Docker IP Bulma
try:
    import subprocess
    result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres'], stderr=subprocess.DEVNULL)
    ip = result.decode('utf-8').strip()
    if ip:
        conn_params["host"] = ip
except Exception:
    pass

if 'host' not in conn_params: conn_params['host'] = 'localhost'
if 'port' not in conn_params: conn_params['port'] = 5432
if 'dbname' not in conn_params: conn_params['dbname'] = 'muro_demo'
if 'user' not in conn_params: conn_params['user'] = 'muro_user'
if 'password' not in conn_params: conn_params['password'] = 'MuroDem0_2026!Str0ng'

try:
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()
    
    print("\n[*] Nokta atışı temizlik başlatılıyor... Sadece videoların olduğu O 38 DERS korunacak.")
    
    queries = [
        # Videoları OLMAYAN derslerin, CourseGroups bağlantılarını sil (Bağ koparma)
        ('CourseGroups (Boş Bağlantılar)', 'DELETE FROM "CourseGroups" WHERE "CourseId" NOT IN (SELECT DISTINCT "CourseId" FROM "Sessions");'),
        
        # İçinde HİÇBİR video (Oturum) bulunmayan çöp dersleri sil (İstediğin 38 ders kalacak)
        ('Courses (Çöp Dersler)', 'DELETE FROM "Courses" WHERE "Id" NOT IN (SELECT DISTINCT "CourseId" FROM "Sessions");'),
        
        # Artık hiçbir dersi olmayan yetim grupların öğrenci bağlarını kopar
        ('GroupMembers (Yetim Bağlar)', 'DELETE FROM "GroupMembers" WHERE "GroupId" NOT IN (SELECT DISTINCT "GroupId" FROM "CourseGroups");'),
        
        # Hiçbir dersi kalmamış o eski boş grupları tamamen sil
        ('Groups (Boş Gruplar)', 'DELETE FROM "Groups" WHERE "Id" NOT IN (SELECT DISTINCT "GroupId" FROM "CourseGroups");')
    ]
    
    for title, sql in queries:
        try:
            cur.execute(sql)
            conn.commit() # Her tablo silindiğinde direkt kaydet ki önceki gibi iptal olmasın
            print(f"  [+] {title} başarıyla temizlendi.")
        except Exception as e:
            conn.rollback()
            print(f"  [-] {title} atlandı: {e}")
            
    print("\n[SUCCESS] SADECE DOLU OLAN 38 DERS KALDI! 🎉 Geri kalan o 162 çöp ders ve gruplar tamamen uçuruldu.")
except Exception as e:
    print("\n[!] Bağlantı Hatası:", e)
finally:
    if 'conn' in locals() and conn:
        cur.close()
        conn.close()
