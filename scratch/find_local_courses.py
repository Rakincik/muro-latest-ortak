import psycopg2

connections = {
    "ataniyorum_postgres (5432)": {"port": 5432, "database": "muro_demo", "user": "muro_user", "password": "MuroDem0_2026!Str0ng"},
    "beautysync-postgres (5433)": {"port": 5433, "database": "muro_demo", "user": "muro_user", "password": "MuroDem0_2026!Str0ng"},
    "4t-postgres (5434)": {"port": 5434, "database": "muro_demo", "user": "muro_user", "password": "MuroDem0_2026!Str0ng"},
    "turkceoabtdeyiz-db (5436)": {"port": 5436, "database": "muro_demo", "user": "muro_user", "password": "MuroDem0_2026!Str0ng"}
}

for name, params in connections.items():
    print(f"\nTrying {name}...")
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=params["port"],
            database=params["database"],
            user=params["user"],
            password=params["password"],
            connect_timeout=3
        )
        cursor = conn.cursor()
        cursor.execute('SELECT "Title" FROM "Courses" WHERE "IsDeleted" = False ORDER BY "Title" LIMIT 15;')
        rows = cursor.fetchall()
        print(f"Success! Active courses in {name}:")
        for idx, r in enumerate(rows):
            print(f"  {idx+1}. {r[0]}")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Failed to connect to {name}: {e}")
