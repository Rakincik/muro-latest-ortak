import json
import re
import html
import datetime

def clean_title(title):
    if not title:
        return ""
    title = html.unescape(title)
    title = re.sub(r'^BBB Kayıtları\s*\((.*?)\)$', r'\1', title, flags=re.IGNORECASE)
    title = re.sub(r'data\s*=\s*\"\"\"', '', title, flags=re.IGNORECASE)
    title = title.replace('"', '').strip()
    return title

def normalize_to_words(text):
    text = text.lower().strip()
    replacements = {
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'İ': 'i', 'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c'
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
    
    text = text.replace('cbk', 'cumhurbaskanligi kararnamesi')
    text = text.replace('cb', 'cumhurbaskanligi')
    text = text.replace('dmk', 'devlet memurlari kanunu')
    text = text.replace('dik', 'devlet ihale kanunu')
    text = text.replace('hmk', 'hukuk muhakemeleri kanunu')
    text = text.replace('iyuk', 'idari yargilama usulu kanunu')
    
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    words = [w for w in text.split() if len(w) > 1 or w.isdigit()]
    return set(words)

# Step 1: Parse okinar json recordings
with open('okinar dersler/mevzuatadam.okinar.com_recordings.json', 'r', encoding='utf-8') as f:
    json_recordings = json.load(f)

print(f"Loaded {len(json_recordings)} recordings from Okinar JSON.")

# Step 2: Parse bbb_videos.txt (actual server folders)
bbb_server_videos = []
with open('bbb_videos.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        title = parts[1].strip()
        
        # Parse timestamp from folder name
        folder_ts = None
        if '-' in folder:
            ts_str = folder.split('-')[-1]
            if ts_str.isdigit():
                folder_ts = int(ts_str)
                
        bbb_server_videos.append({
            'folder': folder,
            'title': title,
            'ts': folder_ts
        })

print(f"Loaded {len(bbb_server_videos)} server folders.")

# Step 3: Parse muro_db_dump.txt (actual Muro Sessions)
muro_sessions = []
with open('muro_db_dump.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36:
            muro_sessions.append((parts[0], parts[1]))

print(f"Loaded {len(muro_sessions)} Muro sessions.")

sql_statements = []
mapped_count = 0
failed_count = 0
log_lines = []

for db_id, db_orig_title in muro_sessions:
    db_clean = clean_title(db_orig_title)
    db_words = normalize_to_words(db_clean)
    db_nums = set(re.findall(r'\d+', db_clean))
    
    # 1. Match Muro DB title to Okinar JSON 'ders'
    best_json_rec = None
    best_json_score = -1
    
    for rec in json_recordings:
        json_clean = clean_title(rec['ders'])
        json_words = normalize_to_words(json_clean)
        json_nums = set(re.findall(r'\d+', json_clean))
        
        # Num checks
        if db_nums and json_nums and not (db_nums & json_nums):
            continue
            
        intersection = db_words & json_words
        union = db_words | json_words
        score = len(intersection) / len(union) if union else 0.0
        
        # Substring bonus
        if db_words and json_words:
            db_phrase = " ".join(sorted(list(db_words)))
            json_phrase = " ".join(sorted(list(json_words)))
            if db_phrase in json_phrase or json_phrase in db_phrase:
                score += 0.5
                
        if score > best_json_score:
            best_json_score = score
            best_json_rec = rec
            
    matched_server_folder = None
    
    # 2. Match the Okinar JSON date/time to a BBB Server Folder
    if best_json_rec and best_json_score > 0.35:
        json_tarih_str = best_json_rec['tarih']
        # Convert date to datetime object
        json_dt = datetime.datetime.strptime(json_tarih_str, '%Y-%m-%d %H:%M:%S')
        json_date_str = json_dt.strftime('%Y-%m-%d')
        json_ts = int(json_dt.timestamp() * 1000)
        
        best_folder_score = -1
        
        for server_video in bbb_server_videos:
            folder = server_video['folder']
            server_title = server_video['title']
            server_ts = server_video['ts']
            
            # Match method A: Check if the server title is a date matching the json date
            # e.g., server_title is "10.07.2025" and json_date is "2025-07-10"
            date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', server_title)
            if date_match:
                d, m, y = date_match.groups()
                server_date_str = f"{y}-{m}-{d}"
                if server_date_str == json_date_str:
                    matched_server_folder = folder
                    break
                    
            # Match method B: Match by Unix timestamps (within 4 hours difference)
            if server_ts:
                time_diff = abs(server_ts - json_ts)
                if time_diff <= 4 * 3600 * 1000: # 4 hours limit
                    # Higher score for closer time
                    folder_score = 1.0 - (time_diff / (4 * 3600 * 1000))
                    if folder_score > best_folder_score:
                        best_folder_score = folder_score
                        matched_server_folder = folder
                        
    if matched_server_folder:
        mapped_count += 1
        log_lines.append(f"SUCCESS: Muro '{db_orig_title}' ==> JSON '{best_json_rec['ders']}' ==> Server '{matched_server_folder}'")
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={matched_server_folder}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{matched_server_folder}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
        sql_statements.append(sql)
    else:
        failed_count += 1
        log_lines.append(f"FAILED: Muro '{db_orig_title}' (Best JSON guess was '{best_json_rec['ders'] if best_json_rec else 'None'}' with score {best_json_score:.2f})")

with open('perfect_mvz_restore.sql', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(sql_statements))

with open('mapping_log.txt', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(log_lines))

print(f"\n--- TIME-BASED MATCHING RESULTS ---")
print(f"Mapped:        {mapped_count}")
print(f"Failed to Map: {failed_count}")
print(f"Saved {len(sql_statements)} statements to perfect_mvz_restore.sql")
print("See mapping_log.txt for details.")
