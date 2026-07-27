import html
import re

def create_wildcard_title(text):
    if not text:
        return ""
    text = html.unescape(text)
    
    # Keep only ASCII letters, numbers, spaces. Replace everything else with %
    wildcard_parts = []
    for char in text:
        if char.isalnum() and ord(char) < 128:
            wildcard_parts.append(char)
        elif char.isspace():
            wildcard_parts.append(' ')
        else:
            # Replace non-ascii (like ğ, ş, ı, ) with %
            if not wildcard_parts or wildcard_parts[-1] != '%':
                wildcard_parts.append('%')
                
    safe = "".join(wildcard_parts)
    # Collapse multiple % into one
    safe = re.sub(r'%+', '%', safe)
    # Remove leading/trailing %
    safe = safe.strip('%').strip()
    return safe

with open('132_videos.txt', 'r', encoding='utf-8') as f:
    target_ids = set(f.read().splitlines())

id_to_title = {}
# Use utf-8-sig to handle BOM, ignore errors to skip bad bytes
with open('C:/Users/Rüstem/Desktop/okideolar/do.csv', 'r', encoding='utf-8-sig', errors='ignore') as f:
    for line in f:
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
            
            if folder in target_ids and title and len(title) > 2:
                id_to_title[folder] = title

sql_statements = []
for folder in target_ids:
    if folder in id_to_title:
        original_title = id_to_title[folder]
        wildcard_title = create_wildcard_title(original_title)
        
        # NEVER match empty strings or just a single wildcard
        if len(wildcard_title.replace('%', '').strip()) < 3:
            continue
            
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{wildcard_title}%' AND "IsDeleted" = false;"""
        sql_statements.append(sql)

with open('mvz_wildcard_fix.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"Saved {len(sql_statements)} wildcard statements to mvz_wildcard_fix.sql")
