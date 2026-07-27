import psycopg2

hosts = ["192.168.1.115", "localhost"]
ports = [5432, 5433, 5434, 5435, 5436]

for host in hosts:
    for port in ports:
        print(f"Trying connection to {host}:{port}...")
        try:
            conn = psycopg2.connect(
                host=host,
                port=port,
                database="muro_demo",
                user="muro_user",
                password="MuroDem0_2026!Str0ng",
                connect_timeout=2
            )
            cursor = conn.cursor()
            cursor.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False LIMIT 5;')
            rows = cursor.fetchall()
            print(f"  [SUCCESS] Found active courses:")
            for r in rows:
                print(f"    - {r[1]} (ID: {r[0]})")
            cursor.close()
            conn.close()
        except Exception as e:
            print(f"  [FAILED] {e}")
