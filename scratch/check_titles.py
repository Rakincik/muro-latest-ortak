import psycopg2
import subprocess

def check_titles():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        cur = conn.cursor()
        
        # Check Sessions table
        try:
            cur.execute('SELECT "Id", "Title" FROM "Sessions" WHERE "Title" LIKE \'%İzle İzle%\' LIMIT 3;')
            print("Sessions Sample:")
            for r in cur.fetchall():
                print(r)
        except Exception as e:
            print("Sessions check error:", e)
            conn.rollback()

        # Check CourseMedias table
        try:
            cur.execute('SELECT "Id", "SessionTitle" FROM "CourseMedias" WHERE "SessionTitle" LIKE \'%İzle İzle%\' LIMIT 3;')
            print("\nCourseMedias Sample:")
            for r in cur.fetchall():
                print(r)
        except Exception as e:
            print("CourseMedias check error:", e)
            conn.rollback()

        # Check MediaAssets table
        try:
            cur.execute('SELECT "Id", "Title" FROM "MediaAssets" WHERE "Title" LIKE \'%İzle İzle%\' LIMIT 3;')
            print("\nMediaAssets Sample:")
            for r in cur.fetchall():
                print(r)
        except Exception as e:
            print("MediaAssets check error:", e)
            conn.rollback()

        cur.close()
        conn.close()
    except Exception as e:
        print("Connection/Execution error:", e)

if __name__ == '__main__':
    check_titles()
