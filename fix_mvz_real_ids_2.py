import csv
import html
import re

def normalize(text):
    if not text:
        return ""
    text = html.unescape(text)
    text = text.replace("I", "ı").replace("İ", "i")
    return text.lower().strip()

print("Reading s7_kesin_MevzuatAdam.csv...")
lines = open('C:/Users/Rüstem/Desktop/okideolar/s7_kesin_MevzuatAdam.csv', 'r', encoding='utf-8').read().splitlines()
real_videos = {}

for line in lines[1:]:
    if not line.strip():
        continue
    parts = line.split(";")
    if len(parts) >= 2:
        folder = parts[0].strip()
        title = html.unescape(parts[1].strip().replace('"', ''))
        norm_title = normalize(title)
        real_videos[norm_title] = folder

print(f"Loaded {len(real_videos)} unique titles from CSV.")

print("Reading generate_sessions_sql.py to get the 90 MVZ titles...")
gen_data = open('generate_sessions_sql.py', 'r', encoding='utf-8').read()
matches = re.findall(r'(.*?)\s*\|\|\|\s*([a-f0-9]{40})', gen_data)

sql_statements = []
matched_count = 0
unmatched_count = 0

for title, fake_id in matches:
    title = title.strip()
    if not title: continue
    
    norm_title = normalize(title)
    
    found_folder = None
    if norm_title in real_videos:
        found_folder = real_videos[norm_title]
    else:
        for csv_title, folder in real_videos.items():
            if csv_title in norm_title or norm_title in csv_title:
                found_folder = folder
                break
                
    if found_folder:
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={found_folder}"
        safe_title = title.replace("'", "''")
        # In the Muro DB, the title might have 'BBB Kayıtları (' prefix. Let's just match using ILIKE
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{found_folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{safe_title}%' AND "IsDeleted" = false;"""
        sql_statements.append(sql)
        matched_count += 1
    else:
        print(f"NO MATCH FOR: {title}")
        unmatched_count += 1

print(f"Generated {matched_count} SQL UPDATE statements.")
print(f"Failed to match: {unmatched_count}")

with open("apply_mvz_fix.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_statements))
print("Saved to apply_mvz_fix.sql")
