import re
import html

def clean_title(title):
    if not title:
        return ""
    title = html.unescape(title)
    title = re.sub(r'^BBB Kayıtları\s*\((.*?)\)$', r'\1', title, flags=re.IGNORECASE)
    title = re.sub(r'data\s*=\s*\"\"\"', '', title, flags=re.IGNORECASE)
    title = title.replace('"', '').strip()
    return title

def normalize_to_words(text):
    # Fix Turkish capital character bug by replacing BEFORE lower()
    replacements = {
        'İ': 'i', 'I': 'i', 'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c'
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
        
    text = text.lower().strip()
    
    # Replace lowercase again just in case
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

# Step 1: Parse s7_kesin_MevzuatAdam.csv
csv_recordings = []
with open('C:/Users/Rüstem/Desktop/okideolar/s7_kesin_MevzuatAdam.csv', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line or 'Mevzuat Adam' not in line:
            continue
        parts = line.split(';')
        if len(parts) >= 2:
            folder_id = parts[0].strip()
            title = parts[1].strip()
            clean_t = clean_title(title)
            if clean_t:
                csv_recordings.append((folder_id, clean_t))

print(f"Loaded {len(csv_recordings)} Mevzuat Adam recordings from CSV.")

# Step 2: Parse bbb_videos.txt (actual server folders)
bbb_server_videos = []
with open('bbb_videos.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        bbb_server_videos.append(folder)

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
    
    db_date = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', db_orig_title)
    
    best_csv_folder = None
    best_csv_title = None
    best_score = -1
    
    for folder_id, csv_title in csv_recordings:
        csv_words = normalize_to_words(csv_title)
        csv_nums = set(re.findall(r'\d+', csv_title))
        
        # Date constraint
        csv_date = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', csv_title)
        if db_date and csv_date:
            if db_date.groups() != csv_date.groups():
                continue
        elif db_nums and csv_nums:
            # Kanun number constraint
            if not (db_nums & csv_nums):
                continue
                
        # Jaccard
        intersection = db_words & csv_words
        union = db_words | csv_words
        score = len(intersection) / len(union) if union else 0.0
        
        # Boosts
        if db_nums and csv_nums and (db_nums & csv_nums):
            score += 1.0
        if db_date and csv_date and db_date.groups() == csv_date.groups():
            score += 2.0
            
        # Safe substring check
        if db_words and csv_words:
            db_phrase = " ".join(sorted(list(db_words)))
            csv_phrase = " ".join(sorted(list(csv_words)))
            if db_phrase in csv_phrase or csv_phrase in db_phrase:
                score += 0.5
            
        if score > best_score:
            best_score = score
            best_csv_folder = folder_id
            best_csv_title = csv_title
            
    # Resolve the prefix in bbb_videos.txt
    matched_server_id = None
    if best_csv_folder and best_score > 0.35:
        prefix = best_csv_folder.split('-')[0]
        for server_folder in bbb_server_videos:
            if server_folder.startswith(prefix):
                matched_server_id = server_folder
                break
                
    if matched_server_id:
        mapped_count += 1
        log_lines.append(f"SUCCESS: Muro '{db_orig_title}' ==> CSV '{best_csv_title}' (Score: {best_score:.2f}, Server Folder: {matched_server_id})")
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={matched_server_id}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{matched_server_id}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
        sql_statements.append(sql)
    else:
        failed_count += 1
        log_lines.append(f"FAILED: Muro '{db_orig_title}' (Best CSV guess was '{best_csv_title}' with score {best_score:.2f})")

with open('perfect_mvz_restore.sql', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(sql_statements))

with open('mapping_log.txt', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(log_lines))

print(f"\n--- CSV-BASED MATCHING RESULTS ---")
print(f"Mapped:        {mapped_count}")
print(f"Failed to Map: {failed_count}")
print(f"Saved {len(sql_statements)} statements to perfect_mvz_restore.sql")
print("See mapping_log.txt for details.")
