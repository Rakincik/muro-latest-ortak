import html
import re

def normalize(text):
    if not text:
        return ""
    text = html.unescape(text)
    text = text.replace("I", "ı").replace("İ", "i")
    return text.lower().strip()

# Read the 231 IDs
with open('132_videos.txt', 'r', encoding='utf-8') as f:
    target_ids = set(f.read().splitlines())

print(f"Target IDs to fix: {len(target_ids)}")

# Parse do.csv to map folder -> title
id_to_title = {}
with open('C:/Users/Rüstem/Desktop/okideolar/do.csv', 'r', encoding='utf-8', errors='ignore') as f:
    for line in f:
        line = line.strip()
        if not line: continue
        parts = line.split(';')
        # do.csv format: s7;dershaneonline;dershaneonline;GYS;492 sayılı HARÇLAR KANUNU;2.11.2025 18:52;Normal;/var/bigbluebutton/published/presentation/bee4a60aa7c180841a40a83e33af607047d8f687-1762098768040;bee4a60aa7c180841a40a83e33af607047d8f687-1762098768040;https...
        if len(parts) >= 9:
            folder = parts[8].strip()
            title = parts[4].strip()
            if folder in target_ids:
                id_to_title[folder] = title

print(f"Found titles for {len(id_to_title)} target IDs.")

sql_statements = []
for folder in target_ids:
    if folder in id_to_title:
        original_title = id_to_title[folder]
        safe_title = original_title.replace("'", "''")
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
        
        # we can't do exact match easily because Muro DB might prefix with BBB Kayıtları
        # But ILIKE with the full original title is very safe.
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{safe_title}%' AND "IsDeleted" = false;"""
        sql_statements.append(sql)

# Also fix format for these specific IDs if missed by ILIKE (if their ID was already set but URL was wrong)
for folder in target_ids:
    fix_sql = f"""UPDATE "Sessions" SET "VideoUrl" = 'https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}' WHERE "BbbMeetingId" = '{folder}' AND "VideoUrl" NOT LIKE '%playback.html%';"""
    sql_statements.append(fix_sql)

with open('exact_mvz_fix.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print("Saved to exact_mvz_fix.sql")
