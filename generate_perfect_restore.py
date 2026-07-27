import re

# Step 1: Parse muro_sessions_update.sql to get original Title -> Short BbbMeetingId mapping
title_to_short_id = {}
with open('muro_sessions_update.sql', 'r', encoding='utf-8') as f:
    content = f.read()
    # Match INSERT statement values pattern
    pattern = r"VALUES\s*\(\s*gen_random_uuid\(\)\s*,\s*cid\s*,\s*'(.*?)'\s*,\s*'(.*?)'"
    matches = re.findall(pattern, content)
    for title, short_id in matches:
        title_to_short_id[title.strip()] = short_id.strip()

print(f"Parsed {len(title_to_short_id)} original title-to-short-id mappings from SQL insert script.")

# Step 2: Parse bbb_videos.txt (server folders)
bbb_long_ids = []
with open('bbb_videos.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        bbb_long_ids.append(folder)

print(f"Loaded {len(bbb_long_ids)} long folder IDs from BBB server.")

# Step 3: Parse current muro_db_dump.txt to get Muro Session UUID -> Title mapping
db_sessions = []
with open('muro_db_dump.txt', 'r', encoding='utf-8') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36:
            db_id = parts[0]
            db_title = parts[1]
            db_sessions.append((db_id, db_title))

print(f"Loaded {len(db_sessions)} active sessions from Muro DB dump.")

# Step 4: Map Muro Sessions to Long IDs using the Short ID prefix
sql_statements = []
mapped_count = 0

for db_id, db_title in db_sessions:
    if db_title in title_to_short_id:
        short_id = title_to_short_id[db_title]
        
        # Search for long ID starting with this short ID
        matching_long_id = None
        for long_id in bbb_long_ids:
            if long_id.startswith(short_id):
                matching_long_id = long_id
                break
        
        if matching_long_id:
            video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={matching_long_id}"
            sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{matching_long_id}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
            sql_statements.append(sql)
            mapped_count += 1
            print(f"MAPPED: '{db_title}' ==> {matching_long_id}")
        else:
            # Maybe the short ID is already a long ID in some cases, or we can't find it on the server
            print(f"NOT FOUND ON SERVER: '{db_title}' (Short ID: {short_id})")
    else:
        print(f"NO ORIGINAL IMPORT MAPPING FOR: '{db_title}'")

with open('perfect_restore_fix.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"\nSUCCESS: Generated {len(sql_statements)} perfect prefix-based updates out of {len(db_sessions)} sessions.")
