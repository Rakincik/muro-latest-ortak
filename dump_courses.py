import psycopg2
try:
    conn = psycopg2.connect("host=31.214.152.143 port=5434 dbname=muro_prod user=muro_user password=MuroDb2026!Pr0d")
    cur = conn.cursor()
    cur.execute('SELECT "Id", "Title" FROM "Courses" ORDER BY "Title";')
    rows = cur.fetchall()
    
    with open('courses_list.md', 'w', encoding='utf-8') as f:
        f.write("# Tüm Dersler Listesi\n\n")
        for row in rows:
            f.write(f"- {row[0]} : **{row[1]}**\n")
            
    cur.close()
    conn.close()
except Exception as e:
    print(e)
