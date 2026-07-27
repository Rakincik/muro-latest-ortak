import psycopg2
import os

def load_env():
    config = {}
    env_paths = [
        ".env.3u", "../.env.3u", "../../.env.3u",
        ".env", "../.env", "../../.env"
    ]
    for ep in env_paths:
        if os.path.exists(ep):
            try:
                with open(ep, "r", encoding="utf-8") as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith("#") and "=" in line:
                            k, v = line.split("=", 1)
                            config[k.strip()] = v.strip()
                break
            except Exception:
                pass
    return config

def main():
    env_config = load_env()
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    db_port = 5434
    db_host = "localhost"

    print(f"Connecting to {db_host}:{db_port} / {db_name}...")
    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
    except Exception as e:
        print(f"Connection failed: {e}")
        return

    # Check for "REHBERLİK 4" in Courses table
    print("\n--- Search courses with 'rehber' in title ---")
    cur.execute('SELECT "Id", "Title", "IsPublished", "IsDeleted" FROM "Courses" WHERE LOWER("Title") LIKE LOWER(\'%rehber%\');')
    rows = cur.fetchall()
    for row in rows:
        print(f"Course: {row[1]} | ID: {row[0]} | Published: {row[2]} | Deleted: {row[3]}")

    # Check for specific recordIDs
    print("\n--- Search specific record IDs ---")
    ids = ['a6ccbe16ae8042d7ccaf615b1894ba74a13836ae-1750272872689', 'a6ccbe16ae8042d7ccaf615b1894ba74a13836ae-1754244961699']
    for rid in ids:
        cur.execute('SELECT s."Title", s."VideoUrl", s."BbbMeetingId", c."Title", s."IsDeleted" FROM "Sessions" s LEFT JOIN "Courses" c ON s."CourseId" = c."Id" WHERE s."BbbMeetingId" = %s;', (rid,))
        s_row = cur.fetchone()
        if s_row:
            print(f"Session found: {s_row[0]} | URL: {s_row[1]} | MeetingID: {s_row[2]} | Course: {s_row[3]} | Deleted: {s_row[4]}")
        else:
            print(f"Session NOT found for MeetingID: {rid}")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
