import psycopg2
import os
import re

print("=" * 60)
print("      AKADEMIK MASA LMS - VERİTABANI TEMİZLİK ARACI")
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

# Try reading from .env files
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

# Try resolving docker container IP just in case localhost is mapped to another Postgres
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
    
    print("\n[*] Temizlik başlatılıyor... (Lütfen bekleyin)")
    
    # Admin kullanıcılarını veya diğer rolleri bozmamak için sadece "Student" rolündekileri siliyoruz.
    # Dersler, Gruplar, Session'lar tamamen sıfırlanıyor.
    queries = [
        ('CourseGroups', 'DELETE FROM "CourseGroups";'),
        ('GroupMembers', 'DELETE FROM "GroupMembers";'),
        ('Sessions', 'DELETE FROM "Sessions";'),
        ('Courses', 'DELETE FROM "Courses";'),
        ('Groups', 'DELETE FROM "Groups";'),
        ('TenantMemberships', 'DELETE FROM "TenantMemberships" WHERE "Role" = \'Student\';'),
        ('Users', 'DELETE FROM "Users" WHERE "Role" = \'Student\';')
    ]
    
    for table_name, sql in queries:
        try:
            cur.execute(sql)
            print(f"  [+] {table_name} tablosu temizlendi.")
        except Exception as e:
            conn.rollback() # Eğer bir tablo yoksa işlemi geri al ve diğerine geç
            print(f"  [-] {table_name} temizlenemedi (Muhtemelen tablo yok): {e}")
            
    conn.commit()
    print("\n[SUCCESS] Tüm eski dersler, gruplar ve öğrenci kayıtları başarıyla SIFIRLANDI! 🧹")
    print("Muro artık tertemiz bir sayfa. Yeni filtreli sistemi yüklemek için hazırsınız:")
    print(">> python AKM/import_akm.py --execute")
except Exception as e:
    print("\n[!] Bağlantı Hatası:", e)
finally:
    if 'conn' in locals() and conn:
        cur.close()
        conn.close()
