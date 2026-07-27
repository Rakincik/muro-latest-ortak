import psycopg2
import json

def main():
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Fetch all active courses
    cur.execute('SELECT "Title" FROM "Courses" WHERE "IsDeleted" = False;')
    courses = [r[0].strip() for r in cur.fetchall()]

    print("\n--- OMR VERİTABANINDAKİ DERSLERİN JS DİZİSİ ---")
    print(json.dumps(courses, ensure_ascii=False, indent=2))
    print("\n----------------------------------------------")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
