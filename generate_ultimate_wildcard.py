import html
import re
import glob

def create_wildcard_title(text):
    if not text:
        return ""
    text = html.unescape(text)
    
    wildcard_parts = []
    for char in text:
        if char.isalnum() and ord(char) < 128:
            wildcard_parts.append(char)
        elif char.isspace():
            wildcard_parts.append(' ')
        else:
            if not wildcard_parts or wildcard_parts[-1] != '%':
                wildcard_parts.append('%')
                
    safe = "".join(wildcard_parts)
    safe = re.sub(r'%+', '%', safe)
    safe = safe.strip('%').strip()
    return safe

csv_files = glob.glob('C:/Users/Rüstem/Desktop/okideolar/*.csv') + glob.glob('C:/Users/Rüstem/Desktop/okideolar/*.txt')
id_to_title = {}

for file_path in csv_files:
    try:
        content = open(file_path, 'r', encoding='utf-8-sig', errors='ignore').read()
    except:
        continue
        
    for line in content.split('\n'):
        line = line.strip()
        if not line: continue
        parts = line.split(';')
        if len(parts) >= 9:
            folder = parts[8].strip()
            title = parts[4].strip()
            
            if not title or len(title) < 2:
                for p in parts:
                    if 'say' in p or 'TANZ' in p or len(p) > 5:
                        title = p
                        break
            
            if title and len(title) > 2:
                id_to_title[folder] = title

sql_statements = []
for folder, original_title in id_to_title.items():
    wildcard_title = create_wildcard_title(original_title)
    
    if len(wildcard_title.replace('%', '').strip()) < 3:
        continue
        
    video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
    sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{wildcard_title}%' AND "IsDeleted" = false;"""
    sql_statements.append(sql)

fix_urls_sql = """
UPDATE "Sessions" 
SET "VideoUrl" = 'https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId=' || "BbbMeetingId"
WHERE "VideoUrl" NOT LIKE '%playback.html%' AND "BbbMeetingId" IS NOT NULL AND LENGTH("BbbMeetingId") > 30 AND "IsDeleted" = false;
"""
sql_statements.append(fix_urls_sql)

with open('ultimate_wildcard_fix.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"Saved {len(sql_statements)} wildcard statements to ultimate_wildcard_fix.sql")
