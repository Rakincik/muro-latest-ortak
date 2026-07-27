import os
import glob
import html
import re

def normalize(text):
    if not text:
        return ""
    text = html.unescape(text)
    text = text.replace("I", "ı").replace("İ", "i")
    return text.lower().strip()

folder_regex = re.compile(r'([a-f0-9]{40}-\d{13})')

all_videos = {}

csv_files = glob.glob('C:/Users/Rüstem/Desktop/okideolar/*.csv') + glob.glob('C:/Users/Rüstem/Desktop/okideolar/*.txt')

for file_path in csv_files:
    try:
        content = open(file_path, 'r', encoding='utf-8', errors='ignore').read()
    except Exception:
        continue
    
    for line in content.split('\n'):
        line = line.strip()
        if not line: continue
        
        # Try to find a folder hash
        match = folder_regex.search(line)
        if not match:
            continue
        folder = match.group(1)
        
        # Try to find title. Usually the part after the folder, or separated by ;
        parts = line.split(';')
        title = ""
        if len(parts) >= 2:
            # check which part is the title
            for p in parts:
                p = p.strip()
                if p and p != folder and p != 's7' and p != 'dershaneonline' and p != 'GYS' and 'http' not in p and '/var/bigbluebutton' not in p and p != 'Normal' and p != 'Kurum Girilecek':
                    # Might be the title
                    # Date formats like '2.11.2025 18:52'
                    if not re.match(r'^\d{1,2}\.\d{1,2}\.\d{4}', p):
                        if len(p) > 3:
                            title = p
                            break
                            
        if not title:
            # Fallback for txt files or weird formats
            # e.g. "hash-time ||| title"
            if '|||' in line:
                parts = line.split('|||')
                for p in parts:
                    if folder not in p:
                        title = p.strip()
                        
        if title:
            title = html.unescape(title.replace('"', ''))
            norm_title = normalize(title)
            if len(norm_title) > 3:
                all_videos[norm_title] = (title, folder)

sql_statements = []

for norm_title, (original_title, folder) in all_videos.items():
    video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
    safe_title = original_title.replace("'", "''")
    # Generate an update statement using ILIKE
    sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{safe_title}%' AND "IsDeleted" = false;"""
    sql_statements.append(sql)

# Also generate a special update for the 404 Nginx issue - we need to make sure ALL VideoUrls use the playback.html format!
# If there are any VideoUrls that do NOT have playback.html, we should fix them (if they already have the right BBB ID)
fix_urls_sql = """
UPDATE "Sessions" 
SET "VideoUrl" = 'https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId=' || "BbbMeetingId"
WHERE "VideoUrl" NOT LIKE '%playback.html%' AND "BbbMeetingId" IS NOT NULL AND LENGTH("BbbMeetingId") > 30 AND "IsDeleted" = false;
"""
sql_statements.append(fix_urls_sql)

print(f"Generated {len(sql_statements)} SQL UPDATE statements from {len(all_videos)} unique videos across all files.")

with open("ultimate_mvz_fix.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_statements))
print("Saved to ultimate_mvz_fix.sql")
