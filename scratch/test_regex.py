import psycopg2

def test_regex():
    try:
        conn = psycopg2.connect(host='127.0.0.1', port=5440, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # Test string
        test_str = "016. DİL BİLGİSİ / PAZAR 10.00 - 14.00 2021/03/28 11:01 İzle İzle İzlenme 0 147 dk"
        cur.execute("SELECT regexp_replace(%s, '\\s*[İi]zle\\s+[İi]zle\\s+[İi]zlenme.*$', '', 'g');", (test_str,))
        result = cur.fetchone()[0]
        print(f"Test Original: {test_str}")
        print(f"Test Cleaned : {result}")
        
        # Try to find tables with this text in akademikmasa_db
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public';")
        tables = [t[0] for t in cur.fetchall()]
        print(f"Available tables: {tables}")
        
        for table in ["Sessions", "CourseMedias", "MediaAssets"]:
            if table in tables:
                col = "SessionTitle" if table == "CourseMedias" else "Title"
                cur.execute(f'SELECT "{col}" FROM "{table}" WHERE "{col}" ~* \'[İi]zle\\s+[İi]zle\\s+[İi]zlenme\' LIMIT 3;')
                rows = cur.fetchall()
                print(f"\nMatches in {table}:")
                for r in rows:
                    print(r[0])
                    
        cur.close()
        conn.close()
    except Exception as e:
        print("Error:", e)

if __name__ == '__main__':
    test_regex()
