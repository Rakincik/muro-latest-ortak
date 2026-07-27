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
        SELECT c."Title", COUNT(m."Id") as doc_count 
        FROM "CourseMaterials" m
        JOIN "Courses" c ON m."CourseId" = c."Id"
        GROUP BY c."Title"
        ORDER BY doc_count DESC;
    ''')
    rows = cur.fetchall()

    print("--- DERSLERE GÖRE YÜKLENEN DOKÜMAN SAYILARI ---")
    for r in rows:
        print(f" * Ders: '{r[0]}' | Yüklü Doküman Sayısı: {r[1]}")

    print("\n--- SON EKLENEN 15 DOKÜMAN DETAYI ---")
    cur.execute('''
        SELECT c."Title", m."Title", m."FileName", m."CreatedAt"
        FROM "CourseMaterials" m
        JOIN "Courses" c ON m."CourseId" = c."Id"
        ORDER BY m."CreatedAt" DESC
        LIMIT 15;
    ''')
    for r in cur.fetchall():
        print(f" * Ders: '{r[0]}' | Doküman Adı: '{r[1]}' | Dosya: '{r[2]}' | Tarih: {r[3]}")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
