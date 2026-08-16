import os
import re
import sys
import subprocess

# Configurations
SOURCE_DIR = "/mnt/storage/muro/hls/11111111-1111-1111-1111-111111111111"
DEST_VOLUME_PATH = "/var/lib/docker/volumes/muro_muro_mng_hls/_data/monopol"
ENV_FILE = "/opt/mng/.env"

def get_db_credentials():
    env_paths = [ENV_FILE, ".env.mng", "/opt/mng/.env", ".env"]
    for path in env_paths:
        if os.path.exists(path):
            print(f"Reading configuration from: {path}")
            db_name, db_user, db_pass = None, None, None
            with open(path, "r") as f:
                for line in f:
                    if line.startswith("DB_NAME="):
                        db_name = line.split("=")[1].strip()
                    elif line.startswith("DB_USER="):
                        db_user = line.split("=")[1].strip()
                    elif line.startswith("DB_PASSWORD="):
                        db_pass = line.split("=")[1].strip()
            if db_name and db_user and db_pass:
                return db_name, db_user, db_pass
    return "muro_demo", "muro_user", "MuroDem0_2026!Str0ng"

def main():
    if not os.path.exists(SOURCE_DIR):
        print(f"Error: Source directory '{SOURCE_DIR}' does not exist!")
        sys.exit(1)

    db_name, db_user, db_pass = get_db_credentials()
    print(f"Target DB: {db_name} | DB User: {db_user}")

    # 1. Create target folder
    print("Step 1: Creating target HLS directory inside docker volume...")
    os.makedirs(DEST_VOLUME_PATH, exist_ok=True)
    
    # Scan UUID folders
    uuid_pattern = re.compile(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", re.IGNORECASE)
    items = os.listdir(SOURCE_DIR)
    uuids = [item for item in items if uuid_pattern.match(item) and os.path.isdir(os.path.join(SOURCE_DIR, item))]

    if not uuids:
        print("No HLS video folders (UUID format) found in source directory.")
        sys.exit(0)

    print(f"Found {len(uuids)} video folders to copy and import.")

    # Copy files
    for uid in uuids:
        src_path = os.path.join(SOURCE_DIR, uid)
        dest_path = os.path.join(DEST_VOLUME_PATH, uid)
        if not os.path.exists(dest_path):
            print(f"Copying HLS folder {uid}...")
            subprocess.run(["cp", "-r", src_path, DEST_VOLUME_PATH], check=True)
        else:
            print(f"Skipping copy for {uid} (already exists in destination)")

    # Fix permissions
    print("Fixing permissions for docker volume files...")
    subprocess.run(["chown", "-R", "root:root", DEST_VOLUME_PATH], check=True)

    # 2. Build SQL insertions (with a dedicated folder)
    folder_id = "f001d00d-cafe-4b0b-8a0b-1c2d3e4f5a6b"
    folder_name = "Dışarıdan Aktarılan Videolar"
    
    sql_statements = [
        f"""
        INSERT INTO "MediaFolders" ("Id", "Name", "ParentFolderId", "CreatedAt")
        SELECT '{folder_id}', '{folder_name}', NULL, NOW()
        WHERE NOT EXISTS (SELECT 1 FROM "MediaFolders" WHERE "Id" = '{folder_id}');
        """.strip()
    ]
    
    for uid in uuids:
        title = f"Medya Kitaplığı Videosu ({uid[:8]})"
        hls_path = f"/hls/monopol/{uid}/master.m3u8"
        thumb_path = f"/hls/monopol/{uid}/thumbnail.jpg"
        
        has_thumb = os.path.exists(os.path.join(DEST_VOLUME_PATH, uid, "thumbnail.jpg"))
        thumb_val = f"'{thumb_path}'" if has_thumb else "NULL"

        sql = f"""
        INSERT INTO "MediaAssets" ("Id", "Title", "FilePath", "HlsPath", "ThumbnailPath", "DurationSeconds", "Status", "FolderId", "CreatedAt")
        SELECT '{uid}', '{title}', NULL, '{hls_path}', {thumb_val}, NULL, 2, '{folder_id}', NOW()
        WHERE NOT EXISTS (SELECT 1 FROM "MediaAssets" WHERE "Id" = '{uid}');
        """
        sql_statements.append(sql.strip())

    sql_script = "\n".join(sql_statements)
    
    temp_sql_path = "/tmp/import_media.sql"
    with open(temp_sql_path, "w") as f:
        f.write(sql_script)

    # 3. Execute SQL in docker container
    print("Step 2: Executing database mapping commands inside container 'muro_mng_postgres'...")
    try:
        cmd = [
            "docker", "exec", "-e", f"PGPASSWORD={db_pass}", "-i", "muro_mng_postgres",
            "psql", "-U", db_user, "-d", db_name
        ]
        
        with open(temp_sql_path, "r") as sql_file:
            result = subprocess.run(cmd, stdin=sql_file, capture_output=True, text=True)
            
        print("Database command completed. Output:")
        print(result.stdout)
        if result.stderr:
            print("Errors/Warnings:")
            print(result.stderr)
            
        print("🎉 Import and file copying completed successfully!")
    except Exception as ex:
        print(f"Error executing database command: {ex}")
    finally:
        if os.path.exists(temp_sql_path):
            os.remove(temp_sql_path)

if __name__ == "__main__":
    main()
