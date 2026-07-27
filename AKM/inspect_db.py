import psycopg2

conn_params = {
    'host': 'localhost',
    'port': 5432,
    'dbname': 'muro_demo',
    'user': 'muro_user',
    'password': 'MuroDem0_2026!Str0ng'
}

try:
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()
    cur.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'Sessions';")
    cols = cur.fetchall()
    print('Sessions table columns:')
    for c in cols:
        print(f' - {c[0]} ({c[1]})')
    cur.close()
    conn.close()
except Exception as e:
    print('Error:', e)
