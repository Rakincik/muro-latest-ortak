import psycopg2
import subprocess

def inspect_real_session():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # Orijinal (gerçek) session'ı bul
        cur.execute('SELECT * FROM "Sessions" WHERE "Status" = \'Scheduled\' LIMIT 1;')
        real_session = cur.fetchone()
        
        # Bizim eklediğimiz bir session'ı bul
        cur.execute('SELECT * FROM "Sessions" WHERE "Status" = \'Completed\' LIMIT 1;')
        our_session = cur.fetchone()
        
        # Sütun isimlerini al
        col_names = [desc[0] for desc in cur.description]
        
        print("=== SÜTUN İSİMLERİ ===")
        print(col_names)
        
        print("\n=== GERÇEK PANEL SESSION (Status='Scheduled') ===")
        if real_session:
            for col, val in zip(col_names, real_session):
                print(f"{col}: {repr(val)}")
        else:
            print("Bulunamadı!")
            
        print("\n=== BİZİM EKLEDİĞİMİZ SESSION (Status='Completed') ===")
        if our_session:
            for col, val in zip(col_names, our_session):
                print(f"{col}: {repr(val)}")
        else:
            print("Bulunamadı!")
            
        cur.close()
        conn.close()

    except Exception as e:
        print(f"Hata: {e}")

if __name__ == "__main__":
    inspect_real_session()
