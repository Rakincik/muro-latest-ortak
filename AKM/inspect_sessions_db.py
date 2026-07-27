import psycopg2
import subprocess

def inspect_sessions():
    try:
        ip = subprocess.check_output(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres']).decode('utf-8').strip()
        conn = psycopg2.connect(host=ip, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
        c = conn.cursor()
        c.execute('SELECT count(*) FROM "Sessions"')
        print("Total Sessions:", c.fetchone()[0])

        try:
            c.execute('SELECT "Status", count(*) FROM "Sessions" GROUP BY "Status"')
            print("Statuses:", c.fetchall())
        except Exception as e:
            print("Status error:", e)
            conn.rollback()

        try:
            c.execute('SELECT "TenantId", count(*) FROM "Sessions" GROUP BY "TenantId"')
            print("Tenants:", c.fetchall())
        except Exception as e:
            print("Tenant error:", e)
            conn.rollback()
            
        # Check if they are connected to a Course
        try:
            c.execute('SELECT "CourseId" IS NULL, count(*) FROM "Sessions" GROUP BY "CourseId" IS NULL')
            print("Null CourseIds:", c.fetchall())
        except Exception as e:
            print("CourseId error:", e)

    except Exception as e:
        print(f"Connection error: {e}")

if __name__ == "__main__":
    inspect_sessions()
