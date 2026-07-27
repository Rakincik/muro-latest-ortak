import psycopg2

ports = {
    5432: ("postgres", "postgres"),
    5433: ("postgres", "postgres"),
    5434: ("4takademi", "secret"),
    5436: ("postgres", "postgres_password")
}

for port, (user, password) in ports.items():
    print(f"\nChecking port {port} with user {user}...")
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=port,
            database="postgres",
            user=user,
            password=password,
            connect_timeout=3
        )
        cursor = conn.cursor()
        cursor.execute("SELECT datname FROM pg_database WHERE datistemplate = false;")
        dbs = [r[0] for r in cursor.fetchall()]
        print(f"Databases: {dbs}")
        
        # Check tables in each database
        for db in dbs:
            if db in ['postgres', 'rdsadmin']: continue
            try:
                db_conn = psycopg2.connect(
                    host="localhost",
                    port=port,
                    database=db,
                    user=user,
                    password=password
                )
                db_cursor = db_conn.cursor()
                db_cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public';")
                tables = [r[0] for r in db_cursor.fetchall()]
                print(f"  DB: {db} -> Tables (first 10): {tables[:10]}")
                db_cursor.close()
                db_conn.close()
            except Exception as dbe:
                print(f"  DB: {db} -> Failed: {dbe}")
                
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Failed to check port {port}: {e}")
