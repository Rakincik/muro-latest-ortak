import psycopg2
import os

course_id = "31cb881c-fbdc-4b34-b38b-4877c5a09ede"

# Ports to try
ports = [5432, 5433, 5434, 5435, 5436]
passwords = ["MuroDem0_2026!Str0ng", "postgres", "root"]

for p in ports:
    for pwd in passwords:
        try:
            conn = psycopg2.connect(
                host="localhost",
                port=p,
                dbname="muro_demo",
                user="muro_user",
                password=pwd,
                connect_timeout=2
            )
            cur = conn.cursor()
            cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Id" = %s', (course_id,))
            row = cur.fetchone()
            if row:
                print(f"FOUND ON localhost:{p} (db: muro_demo):")
                print(f"  Course ID: {row[0]}")
                print(f"  Title: {row[1]}")
                
                cur.execute('SELECT "Id", "Title", "VideoUrl", "BbbMeetingId" FROM "Sessions" WHERE "CourseId" = %s', (course_id,))
                sessions = cur.fetchall()
                print(f"  Total Sessions: {len(sessions)}")
                for s in sessions:
                    print(f"    - Session ID: {s[0]} | Title: {s[1]} | BbbId: {s[3]} | VideoUrl: {s[2]}")
                conn.close()
                sys.exit(0)
            else:
                # Let's search all courses in this DB to see what's there
                cur.execute('SELECT "Id", "Title" FROM "Courses" LIMIT 5')
                courses = cur.fetchall()
                print(f"Connected to port {p}, but course not found. Sample courses: {courses}")
            conn.close()
        except Exception as e:
            pass
