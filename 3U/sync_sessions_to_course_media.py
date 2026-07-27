import psycopg2
import os
import json
import uuid

def load_env():
    config = {}
    env_paths = [".env.3u", ".env"]
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
    env = load_env()
    db_host = "localhost"
    db_port = "5432"
    db_name = env.get("DB_NAME", "muro_demo")
    db_user = env.get("DB_USER", "muro_user")
    db_pass = env.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")
    
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    # Read Okinar recordings JSON to get all valid recordIDs
    json_path = 'okinar dersler/4tuzem.okinar.com_recordings.json'
    if not os.path.exists(json_path):
        json_path = '4tuzem.okinar.com_recordings.json'
        if not os.path.exists(json_path):
            json_path = '../okinar dersler/4tuzem.okinar.com_recordings.json'
            if not os.path.exists(json_path):
                print("[❌] HATA: JSON dosyası bulunamadı!")
                return

    with open(json_path, 'r', encoding='utf-8') as f:
        recordings = json.load(f)
    
    # Extract all recordIDs from JSON
    valid_record_ids = {r.get('recordID') for r in recordings if r.get('recordID')}
    print(f"[*] JSON dosyasında {len(valid_record_ids)} adet kayıt (recordID) tespit edildi.")

    try:
        conn = psycopg2.connect(host=db_host, port=db_port, database=db_name, user=db_user, password=db_pass)
        cursor = conn.cursor()
    except Exception as e:
        print(f"Connection failed: {e}")
        return

    # Find sessions without CourseMedias whose BbbMeetingId matches a recordID in the JSON
    query = """
        SELECT s."Id", s."CourseId", s."Title", s."BbbMeetingId" 
        FROM "Sessions" s 
        LEFT JOIN "CourseMedias" cm ON s."Id" = cm."SessionId" 
        WHERE cm."Id" IS NULL 
          AND s."IsDeleted" = False
          AND s."BbbMeetingId" IS NOT NULL;
    """
    cursor.execute(query)
    all_unmapped = cursor.fetchall()
    
    # Filter ONLY sessions that exist in the Okinar recordings JSON
    missing = [row for row in all_unmapped if row[3] in valid_record_ids]
    print(f"Sadece Okinar JSON dosyasında karşılığı olan ve henüz eşleşmemiş {len(missing)} oturum bulundu.")

    if not missing:
        print("Eşleşecek yeni oturum bulunamadı.")
        cursor.close()
        conn.close()
        return

    sql_inserts = []
    for sid, cid, stitle, bbb_id in missing:
        cm_id = str(uuid.uuid4())
        sql = f"INSERT INTO \"CourseMedias\" (\"Id\", \"CourseId\", \"SessionId\", \"OrderIndex\", \"CreatedAt\") VALUES ('{cm_id}', '{cid}', '{sid}', -1, NOW());"
        sql_inserts.append(sql)

    # Write target SQL file
    with open('insert_course_medias.sql', 'w', encoding='utf-8') as f:
        f.write("BEGIN;\n" + "\n".join(sql_inserts) + "\nCOMMIT;\n")

    print(f"Sadece JSON kayıtları için '{len(sql_inserts)}' adet eşleştirme SQL'i üretildi: 'insert_course_medias.sql'")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
