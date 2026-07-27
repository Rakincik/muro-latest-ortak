import html

def normalize(text):
    if not text:
        return ""
    text = html.unescape(text)
    text = text.replace("I", "ı").replace("İ", "i")
    return text.lower().strip()

# Read the 231 IDs
with open('132_videos.txt', 'r', encoding='utf-8') as f:
    target_ids = set(f.read().splitlines())

# Parse do.csv to map folder -> title using utf-8-sig
id_to_title = {}
with open('C:/Users/Rüstem/Desktop/okideolar/do.csv', 'r', encoding='utf-8-sig', errors='ignore') as f:
    for line in f:
        line = line.strip()
        if not line: continue
        parts = line.split(';')
        if len(parts) >= 9:
            folder = parts[8].strip()
            title = parts[4].strip()
            
            # If title is empty, try to get it from parts[1] (sometimes Title is in different column)
            if not title or len(title) < 2:
                for p in parts:
                    if 'sayılı' in p or 'TANZ' in p or len(p) > 5:
                        title = p
                        break
            
            if folder in target_ids and title and len(title) > 2:
                id_to_title[folder] = title

sql_statements = []
for folder in target_ids:
    if folder in id_to_title:
        original_title = id_to_title[folder]
        safe_title = original_title.replace("'", "''")
        
        # VERY IMPORTANT: NEVER match empty strings!
        if len(safe_title) < 3:
            continue
            
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{safe_title}%' AND "IsDeleted" = false;"""
        sql_statements.append(sql)

# Also fix format for these specific IDs if missed by ILIKE (if their ID was already set but URL was wrong)
for folder in target_ids:
    fix_sql = f"""UPDATE "Sessions" SET "VideoUrl" = 'https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}' WHERE "BbbMeetingId" = '{folder}' AND "VideoUrl" NOT LIKE '%playback.html%';"""
    sql_statements.append(fix_sql)

with open('mvz_safe_fix.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"Saved {len(sql_statements)} safe statements to mvz_safe_fix.sql")
