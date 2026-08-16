import psycopg2

def find_course():
    # Try connecting to AKM postgres port (or via docker container)
    hosts = ["localhost", "127.0.0.1"]
    ports = [5437, 5432, 5433, 5434, 5435, 5436]
    
    conn = None
    for port in ports:
        try:
            conn = psycopg2.connect(host="127.0.0.1", port=port, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng", connect_timeout=2)
            cur = conn.cursor()
            cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" ILIKE \'%Halk Edebiyat%\" OR "Title" ILIKE \'%850%\'')
            rows = cur.fetchall()
            if rows:
                print(f"FOUND ON PORT {port}:")
                for r in rows:
                    print(f"  ID: {r[0]} | Title: {r[1]}")
                conn.close()
                return
            conn.close()
        except Exception as e:
            pass
            
    print("Could not find course on local ports directly. Checking all courses on available ports...")
    for port in [5432, 5433, 5434, 5435, 5436, 5437, 5438]:
        try:
            conn = psycopg2.connect(host="127.0.0.1", port=port, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng", connect_timeout=2)
            cur = conn.cursor()
            cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = false LIMIT 10')
            rows = cur.fetchall()
            print(f"\nPort {port} has {len(rows)} courses:")
            for r in rows:
                print(f"  ID: {r[0]} | Title: {r[1]}")
            conn.close()
        except Exception as e:
            pass

if __name__ == "__main__":
    find_course()
