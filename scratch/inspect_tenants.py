import psycopg2

def main():
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Get Tenants columns
    cur.execute('''
        SELECT column_name FROM information_schema.columns WHERE table_name = 'Tenants';
    ''')
    cols = [r[0] for r in cur.fetchall()]
    print("Tenants Columns:", cols)

    # Select all tenants
    cur.execute('SELECT "Id", "Name", "Domain", "Status" FROM "Tenants";')
    for r in cur.fetchall():
        print(f" ID: {r[0]} | Name: {r[1]} | Domain: {r[2]} | Status: {r[3]}")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
