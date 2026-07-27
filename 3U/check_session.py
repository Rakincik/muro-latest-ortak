import psycopg2

try:
    import subprocess
    result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
    db_host = result.decode('utf-8').strip() or "localhost"
except Exception:
    db_host = "localhost"

conn = psycopg2.connect(host=db_host, port=5432, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng")
cur = conn.cursor()

# Find course of a specific session meeting ID
meeting_id = '1864f64be7b8e5cde043f18487fcdf4685e7564a-1751994570908'
cur.execute('SELECT s."Title", c."Title", c."Id" FROM "Sessions" s JOIN "Courses" c ON s."CourseId" = c."Id" WHERE s."BbbMeetingId" = %s;', (meeting_id,))
row = cur.fetchone()
if row:
    print(f"\n[+] Session Title: {row[0]}")
    print(f"[+] Course Title in DB: {row[1]}")
    print(f"[+] Course ID in DB: {row[2]}\n")
else:
    print("\n[-] Session not found in DB!\n")

cur.close()
conn.close()
