import re
from difflib import SequenceMatcher

def clean_title(title):
    if not title:
        return ""
    # Strip "BBB Kayıtları (" and trailing ")"
    title = re.sub(r'^BBB Kayıtları\s*\((.*?)\)$', r'\1', title, flags=re.IGNORECASE)
    # Strip common prefixes
    title = re.sub(r'^\d{2}[./]\d{2}[./]\d{4}\s*', '', title) # dates
    title = re.sub(r'^DERS-\d+\s+test\s+\W+\s*', '', title, flags=re.IGNORECASE)
    return title.strip()

def normalize_to_words(text):
    text = text.lower().strip()
    replacements = {
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'İ': 'i', 'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c'
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
        
    # Replace abbreviations
    text = text.replace('cbk', 'cumhurbaskanligi kararnamesi')
    text = text.replace('cb', 'cumhurbaskanligi')
    text = text.replace('dmk', 'devlet memurları kanunu')
    text = text.replace('dik', 'devlet ihale kanunu')
    text = text.replace('hmk', 'hukuk muhakemeleri kanunu')
    text = text.replace('iyuk', 'idari yargılama usulü kanunu')
    
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    words = [w for w in text.split() if len(w) > 1 or w.isdigit()]
    return set(words)

# Step 1: Parse apply_mvz_fix.sql
title_to_original_id = {}
with open('apply_mvz_fix.sql', 'r', encoding='utf-8') as f:
    for line in f:
        # Matches: SET "BbbMeetingId" = '...' WHERE "Title" ILIKE '%...%';
        match = re.search(r"SET\s+\"BbbMeetingId\"\s*=\s*'([^']+)'\s+WHERE\s+\"Title\"\s+ILIKE\s+'%([^']+)%'", line)
        if match:
            folder_id = match.group(1).strip()
            title_query = match.group(2).strip()
            title_to_original_id[title_query] = folder_id

print(f"Parsed {len(title_to_original_id)} title mappings from apply_mvz_fix.sql")

# Step 2: Parse bbb_videos.txt (folders on server)
bbb_server_videos = []
with open('bbb_videos.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        title = parts[1].strip()
        bbb_server_videos.append((folder, title))

print(f"Loaded {len(bbb_server_videos)} folders from BBB server list.")

# Step 3: Parse muro_db_dump.txt (actual Muro Sessions)
muro_sessions = []
with open('muro_db_dump.txt', 'r', encoding='utf-8') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36:
            muro_sessions.append((parts[0], parts[1]))

print(f"Loaded {len(muro_sessions)} active sessions from Muro DB.")

sql_statements = []
mapped_by_prefix = 0
mapped_by_title = 0
not_mapped = 0

for db_id, db_orig_title in muro_sessions:
    db_clean = clean_title(db_orig_title)
    
    # Try finding the original folder ID mapping
    original_folder_id = None
    for sql_query_title, folder_id in title_to_original_id.items():
        if sql_query_title.lower() in db_orig_title.lower() or db_orig_title.lower() in sql_query_title.lower():
            original_folder_id = folder_id
            break
            
    matched_long_id = None
    
    # Method A: Match by 40-char prefix of original folder ID
    if original_folder_id:
        prefix = original_folder_id.split('-')[0]
        if len(prefix) >= 30: # Safe SHA-1 length check
            for folder, server_title in bbb_server_videos:
                if folder.startswith(prefix):
                    matched_long_id = folder
                    mapped_by_prefix += 1
                    print(f"PREFIX MATCH: '{db_orig_title}' ==> {folder} (Title on server: {server_title})")
                    break
                    
    # Method B: Match by Title similarity if Method A failed
    if not matched_long_id:
        db_words = normalize_to_words(db_clean)
        db_nums = set(re.findall(r'\d+', db_clean))
        
        best_folder = None
        best_score = -1
        best_title = None
        
        for folder, server_title in bbb_server_videos:
            server_clean = clean_title(server_title)
            server_words = normalize_to_words(server_clean)
            server_nums = set(re.findall(r'\d+', server_clean))
            
            # Strict number match (kanun numbers must match!)
            if db_nums and server_nums:
                if not (db_nums & server_nums):
                    continue
                    
            # Jaccard similarity
            intersection = db_words & server_words
            union = db_words | server_words
            score = len(intersection) / len(union) if union else 0.0
            
            # Boost matching numbers
            if db_nums and server_nums and (db_nums & server_nums):
                score += 1.0
                
            # Date prefix match bonus (e.g. if video is named after session date)
            db_date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', db_orig_title)
            server_date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', server_title)
            if db_date_match and server_date_match:
                if db_date_match.groups() == server_date_match.groups():
                    score += 2.0 # Huge boost for exact date match!
                    
            if score > best_score:
                best_score = score
                best_folder = folder
                best_title = server_title
                
        if best_folder and best_score > 0.45:
            matched_long_id = best_folder
            mapped_by_title += 1
            print(f"TITLE MATCH: '{db_orig_title}' ==> {best_folder} (Title on server: {best_title}, Score: {best_score:.2f})")
            
    if matched_long_id:
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={matched_long_id}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{matched_long_id}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
        sql_statements.append(sql)
    else:
        not_mapped += 1
        print(f"FAILED TO MATCH: '{db_orig_title}'")

with open('perfect_mvz_restore.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"\n--- SUMMARY ---")
print(f"Mapped by Prefix: {mapped_by_prefix}")
print(f"Mapped by Title:  {mapped_by_title}")
print(f"Failed to Map:   {not_mapped}")
print(f"Saved {len(sql_statements)} statements to perfect_mvz_restore.sql")
