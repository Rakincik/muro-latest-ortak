import sys
import uuid
import datetime
import psycopg2

RECORDINGS = [
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1781074310447", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 1"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1781079599936", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 2"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1781082855312", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 3"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1782398624940", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 4"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1782402506644", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 5"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1782406116175", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 6"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1782485032405", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 7"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1782489037585", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 8"),
    ("c580b68fb08daf0a1e5b1c091f8d3326caa91319-1782492370157", "850 Soru Çözüm Kampı - Halk Edebiyatı - Ders 9"),
]

def main():
    bbb_domain = "canli.muro.click"
    if len(sys.argv) > 1 and not sys.argv[1].startswith("--"):
        bbb_domain = sys.argv[1].strip()

    execute = "--execute" in sys.argv

    # Connect to PostgreSQL (try docker container IP or localhost)
    db_host = "localhost"
    try:
        import subprocess
        res = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres'], stderr=subprocess.DEVNULL)
        ip = res.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    print(f"Connecting to AKM PostgreSQL at {db_host}...")
    try:
        conn = psycopg2.connect(host=db_host, port=5432, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng")
        cur = conn.cursor()
    except Exception as e:
        print(f"PostgreSQL connection error: {e}")
        return

    # Find the Course
    cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE ("Title" ILIKE \'%Halk Edebiyat%\' OR "Title" ILIKE \'%850%\') AND "IsDeleted" = false')
    courses = cur.fetchall()

    if not courses:
        print("Course not found! Listing all courses:")
        cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = false')
        for c in cur.fetchall():
            print(f"  [{c[0]}] {c[1]}")
        return

    course_id = courses[0][0]
    course_title = courses[0][1]
    print(f"Target Course: [{course_id}] {course_title}")

    # Current max order
    cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = false', (course_id,))
    max_order = cur.fetchone()[0] or 0

    now = datetime.datetime.utcnow()

    print(f"\nProcessing {len(RECORDINGS)} lessons (Execute mode: {execute}):")
    for idx, (folder_name, lesson_title) in enumerate(RECORDINGS, start=1):
        order = max_order + idx
        hls_url = f"https://{bbb_domain}/playback/presentation/2.3/{folder_name}/master.m3u8"
        playback_url = f"https://{bbb_domain}/playback/presentation/2.3/playback.html?meetingId={folder_name}"
        
        session_id = str(uuid.uuid4())
        media_asset_id = str(uuid.uuid4())

        print(f" [{idx}/9] Order {order}: {lesson_title}")
        print(f"       Folder: {folder_name}")
        print(f"       Playback: {playback_url}")

        if execute:
            # 1. Insert MediaAsset
            cur.execute("""
                INSERT INTO "MediaAssets" ("Id", "Title", "HlsPath", "Status", "CreatedAt", "DurationSeconds", "IsDeleted")
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (media_asset_id, lesson_title, hls_url, 2, now, 0, False))

            # 2. Insert Session
            cur.execute("""
                INSERT INTO "Sessions" ("Id", "CourseId", "Title", "MediaAssetId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "VideoUrl", "BbbMeetingId")
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (session_id, course_id, lesson_title, media_asset_id, False, now, 2, order, True, False, playback_url, folder_name))

    if execute:
        conn.commit()
        print("\n✅ SUCCESS! All 9 sessions inserted and bound to course!")
    else:
        print("\nℹ️ DRY-RUN complete. To write to DB, pass --execute flag.")

    conn.close()

if __name__ == "__main__":
    main()
