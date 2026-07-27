import re
import html

def clean_title(title):
    if not title:
        return ""
    title = html.unescape(title)
    title = re.sub(r'^BBB Kayıtları\s*\((.*?)\)$', r'\1', title, flags=re.IGNORECASE)
    title = re.sub(r'data\s*=\s*\"\"\"', '', title, flags=re.IGNORECASE)
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
    text = text.replace('dmk', 'devlet memurlari kanunu')
    text = text.replace('dik', 'devlet ihale kanunu')
    text = text.replace('hmk', 'hukuk muhakemeleri kanunu')
    text = text.replace('iyuk', 'idari yargilama usulu kanunu')
    
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    words = [w for w in text.split() if len(w) > 1 or w.isdigit()]
    return set(words)

# Step 1: Parse bbb_videos.txt
bbb_server_videos = []
with open('bbb_videos.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        title = parts[1].strip()
        bbb_server_videos.append((folder, title))

print(f"Loaded {len(bbb_server_videos)} server folders.")

# Step 2: Parse muro_db_dump.txt
muro_sessions = []
with open('muro_db_dump.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36:
            muro_sessions.append((parts[0], parts[1]))

print(f"Loaded {len(muro_sessions)} Muro sessions.")

sql_statements = []
mapped_by_title = 0
failed_to_map = 0

log_lines = []

for db_id, db_orig_title in muro_sessions:
    db_clean = clean_title(db_orig_title)
    db_words = normalize_to_words(db_clean)
    
    # Extract numbers and dates from DB title
    db_nums = set(re.findall(r'\d+', db_clean))
    db_date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', db_orig_title)
    
    best_folder = None
    best_score = -1
    best_title = None
    
    for folder, server_title in bbb_server_videos:
        server_clean = clean_title(server_title)
        server_words = normalize_to_words(server_clean)
        server_nums = set(re.findall(r'\d+', server_clean))
        
        # Strict number constraint: if one has numbers and they don't match, skip
        # Exception: if both titles are just dates or contains the same date
        server_date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', server_title)
        
        if db_date_match and server_date_match:
            # If both have dates, they must be the same date
            if db_date_match.groups() != server_date_match.groups():
                continue
        elif db_nums and server_nums:
            # If they have other numbers (like 657, 4734), they must match!
            if not (db_nums & server_nums):
                continue
                
        # Jaccard similarity of words
        intersection = db_words & server_words
        union = db_words | server_words
        score = len(intersection) / len(union) if union else 0.0
        
        # Boosts
        if db_nums and server_nums and (db_nums & server_nums):
            score += 1.0
            
        if db_date_match and server_date_match and db_date_match.groups() == server_date_match.groups():
            score += 2.0
            
        if score > best_score:
            best_score = score
            best_folder = folder
            best_title = server_title
            
    if best_folder and best_score > 0.35:
        matched_long_id = best_folder
        mapped_by_title += 1
        log_lines.append(f"MATCH: '{db_orig_title}' ==> '{best_title}' (Score: {best_score:.2f})")
        
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={matched_long_id}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{matched_long_id}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
        sql_statements.append(sql)
    else:
        failed_to_map += 1
        log_lines.append(f"FAILED: '{db_orig_title}'")

with open('perfect_mvz_restore.sql', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(sql_statements))

with open('mapping_log.txt', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(log_lines))

print(f"\n--- MATCHING RESULTS ---")
print(f"Mapped:            {mapped_by_title}")
print(f"Failed to Map:     {failed_to_map}")
print(f"Saved {len(sql_statements)} statements to perfect_mvz_restore.sql")
print("See mapping_log.txt for detailed results.")
