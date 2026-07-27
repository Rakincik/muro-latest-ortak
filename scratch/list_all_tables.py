import psycopg2

def main():
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_mng_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    cur.execute('''
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        ORDER BY table_name;
    ''')
    tables = cur.fetchall()

    print("--- VERİTABANINDAKİ TÜM TABLOLAR ---")
    for t in tables:
        print(f" - {t[0]}")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
