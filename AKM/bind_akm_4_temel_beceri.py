import sys
import uuid
import datetime
import psycopg2
import subprocess

# Course ID provided by the user
COURSE_ID = "c4fd94df-fe6e-472a-9bc4-fcb0db373df9"
DOMAIN = "canli.akm.muro.click"

# 20 recordings sorted chronologically by timestamp
RECORDINGS = [
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1780912347731",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1780915511467",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781334023016",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781337112796",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781340809936",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781780436642",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781784515969",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781938500859",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1781942488683",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782543110045",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782546446822",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782550368332",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782553663303",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782630639159",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782633800465",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782637480861",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782802733471",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782805659535",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782809111991",
    "dd09de35f0f756b12803cf7d3fb23e09f44349e28-1782812501215"
]

def check_column_exists(cur, table_name, column_name):
    cur.execute("""
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_name = %s AND column_name = %s
        );
    """, (table_name, column_name))
    return cur.fetchone()[0]

def main():
    execute = "--execute" in sys.argv

    # Find Docker Postgres IP
    db_host = "localhost"
    try:
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    print(f"[*] Connecting to database at {db_host}...")
    try:
        conn = psycopg2.connect(host=db_host, port=5432, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng")
        cur = conn.cursor()
    except Exception as e:
        print(f"[-] Database connection error: {e}")
        return

    try:
        # Check course exists
        cur.execute('SELECT "Title" FROM "Courses" WHERE "Id" = %s AND "IsDeleted" = False;', (COURSE_ID,))
        course_row = cur.fetchone()
        if not course_row:
            print(f"[-] Course with ID {COURSE_ID} not found in database or is deleted!")
            return
        
        course_title = course_row[0]
        print(f"[+] Found course: {course_title}")

        # Check for TenantId on Sessions table
        has_tenant_id = check_column_exists(cur, "Sessions", "TenantId")
        print(f"[*] Sessions table has 'TenantId' column: {has_tenant_id}")

        tenant_id = None
        if has_tenant_id:
            # Try to get TenantId from Course if column exists, otherwise get from Tenants table
            has_course_tenant = check_column_exists(cur, "Courses", "TenantId")
            if has_course_tenant:
                cur.execute('SELECT "TenantId" FROM "Courses" WHERE "Id" = %s;', (COURSE_ID,))
                tenant_id = cur.fetchone()[0]
            if not tenant_id:
                cur.execute('SELECT "Id" FROM "Tenants" WHERE "Name" ILIKE \'%akademik%\' OR "Host" ILIKE \'%akm%\' LIMIT 1;')
                tenant_row = cur.fetchone()
                if tenant_row:
                    tenant_id = tenant_row[0]
            print(f"[*] Tenant ID determined as: {tenant_id}")

        # Get max order from Sessions table for this course
        cur.execute('SELECT MAX("Order") FROM "Sessions" WHERE "CourseId" = %s AND "IsDeleted" = False;', (COURSE_ID,))
        max_order = cur.fetchone()[0] or 0
        print(f"[*] Current max Order in this course: {max_order}")

        # Determine the session status. Check if status column contains text or integer
        cur.execute('SELECT "Status" FROM "Sessions" LIMIT 1;')
        status_row = cur.fetchone()
        status_value = "Completed" # Default text status
        if status_row is not None:
            if isinstance(status_row[0], int):
                status_value = 2 # Completed as integer
        print(f"[*] Using session status value: {repr(status_value)} (Type: {type(status_value).__name__})")

        print(f"\n[*] Preparing to bind {len(RECORDINGS)} recordings (Execute: {execute}):")
        
        for idx, folder_name in enumerate(RECORDINGS, start=1):
            order = max_order + idx
            video_title = f"850 Soru Çözüm Kampı - 4 Temel Beceri - Ders {idx}"
            playback_url = f"https://{DOMAIN}/playback/presentation/2.3/{folder_name}"
            hls_url = f"https://{DOMAIN}/playback/presentation/2.3/{folder_name}/master.m3u8"
            
            session_id = str(uuid.uuid4())
            media_asset_id = str(uuid.uuid4())
            course_media_id = str(uuid.uuid4())

            print(f"  [{idx}/{len(RECORDINGS)}] Order {order} | {video_title}")
            print(f"      MeetingId : {folder_name}")
            print(f"      VideoUrl  : {playback_url}")
            
            if execute:
                # 1. Insert into MediaAssets
                cur.execute("""
                    INSERT INTO "MediaAssets" ("Id", "Title", "HlsPath", "Status", "CreatedAt", "DurationSeconds", "IsDeleted")
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (media_asset_id, video_title, hls_url, 2, datetime.datetime.utcnow(), 0, False))

                # 2. Insert into Sessions
                if has_tenant_id and tenant_id:
                    cur.execute("""
                        INSERT INTO "Sessions" ("Id", "CourseId", "Title", "MediaAssetId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "VideoUrl", "BbbMeetingId", "TenantId")
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (session_id, COURSE_ID, video_title, media_asset_id, False, datetime.datetime.utcnow(), status_value, order, True, False, playback_url, folder_name, tenant_id))
                else:
                    cur.execute("""
                        INSERT INTO "Sessions" ("Id", "CourseId", "Title", "MediaAssetId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "VideoUrl", "BbbMeetingId")
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (session_id, COURSE_ID, video_title, media_asset_id, False, datetime.datetime.utcnow(), status_value, order, True, False, playback_url, folder_name))

                # 3. Insert into CourseMedias
                cur.execute("""
                    INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt")
                    VALUES (%s, %s, %s, %s, %s)
                """, (course_media_id, COURSE_ID, session_id, order, datetime.datetime.utcnow()))

        if execute:
            conn.commit()
            print(f"\n[+] SUCCESS! All {len(RECORDINGS)} lessons successfully bound to course '{course_title}'!")
        else:
            print("\n[i] DRY-RUN complete. To actually write to database, execute with --execute:")
            print(f"    python3 bind_akm_4_temel_beceri.py --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n[-] Error occurred: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()
