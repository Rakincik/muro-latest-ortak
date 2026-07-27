import psycopg2
import subprocess

def list_dbs():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        # Connect to default postgres db
        conn = psycopg2.connect(host=ip, port=5432, dbname='postgres', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        cur.execute("SELECT datname FROM pg_database WHERE datistemplate = false;")
        dbs = cur.fetchall()
        print("=== VERİTABANLARI ===")
        for db in dbs:
            print(db[0])
            
        cur.close()
        conn.close()

    except Exception as e:
        print(f"Hata: {e}")

if __name__ == "__main__":
    list_dbs()
