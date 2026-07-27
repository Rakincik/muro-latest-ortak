import json
import re
import html
import csv
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
    replacements = {
        'İ': 'i', 'I': 'i', 'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c'
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
        
    text = text.lower().strip()
    
    # Repeat just in case
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

def get_consonants(text):
    text = html.unescape(text).lower()
    replacements = {
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'İ': 'i', 'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c',
        '\u0307': ''
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
    text = re.sub(r'[^a-z]', '', text)
    vowels = set('aeiou')
    return "".join([c for c in text if c not in vowels])

# Step 1: Parse s7_kesin_MevzuatAdam.csv (Layer 1)
csv_recordings = []
with open('C:/Users/Rüstem/Desktop/okideolar/s7_kesin_MevzuatAdam.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader, None) # skip header
    for row in reader:
        if len(row) >= 3:
            folder_id = row[0].strip()
            title = row[1].strip()
            inst = row[2].strip()
            
            if "Mevzuat Adam" in inst:
                clean_t = clean_title(title)
                if clean_t:
                    csv_recordings.append((folder_id, clean_t))

print(f"Loaded {len(csv_recordings)} valid Mevzuat Adam recordings from CSV.")

# Step 2: Parse s7.csv (Source server all folders dump) for fallback matching
s7_all_folders = []
with open('C:/Users/Rüstem/Desktop/okideolar/s7.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader, None) # skip header
    for row in reader:
        if len(row) >= 2:
            folder = row[0].strip()
            title = row[1].strip()
            folder_ts = None
            if '-' in folder:
                ts_str = folder.split('-')[-1]
                if ts_str.isdigit():
                    folder_ts = int(ts_str)
            s7_all_folders.append({
                'folder': folder,
                'title': title,
                'ts': folder_ts
            })

print(f"Loaded {len(s7_all_folders)} all folders from s7.csv.")

# Step 3: Parse okinar json recordings (Layer 2)
with open('okinar dersler/mevzuatadam.okinar.com_recordings.json', 'r', encoding='utf-8') as f:
    json_recordings = json.load(f)

print(f"Loaded {len(json_recordings)} recordings from Okinar JSON.")

# Step 4: Parse bbb_videos.txt (actual server folders on muv)
bbb_server_videos = []
with open('bbb_videos.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        title = parts[1].strip()
        
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
bbb_server_folders_set = set(v['folder'] for v in bbb_server_videos)

# Step 5: Parse muro_db_dump.txt (actual Muro Sessions)
muro_sessions = []
with open('muro_db_dump.txt', 'r', encoding='iso-8859-9', errors='ignore') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36:
            muro_sessions.append((parts[0], parts[1]))

print(f"Loaded {len(muro_sessions)} Muro sessions.")

sql_statements = []
mapped_live = 0
mapped_prepared = 0
failed_count = 0
log_lines = []

for db_id, db_orig_title in muro_sessions:
    db_clean = clean_title(db_orig_title)
    db_words = normalize_to_words(db_clean)
    db_nums = set(re.findall(r'\d+', db_clean))
    db_date = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', db_orig_title)
    
    matched_folder_id = None
    best_method = ""
    
    # ------------------ LAYER 1: DIRECT CSV MATCH ------------------
    best_csv_folder = None
    best_csv_title = None
    best_csv_score = -1
    
    for folder_id, csv_title in csv_recordings:
        csv_words = normalize_to_words(csv_title)
        csv_nums = set(re.findall(r'\d+', csv_title))
        
        # Date constraint
        csv_date = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', csv_title)
        if db_date and csv_date:
            if db_date.groups() != csv_date.groups():
                continue
        elif db_nums and csv_nums:
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
            
        # Substring
        if db_words and csv_words:
            db_phrase = " ".join(sorted(list(db_words)))
            csv_phrase = " ".join(sorted(list(csv_words)))
            if db_phrase in csv_phrase or csv_phrase in db_phrase:
                score += 0.5
                
        if score > best_csv_score:
            best_csv_score = score
            best_csv_folder = folder_id
            best_csv_title = csv_title
            
    if best_csv_folder and best_csv_score > 0.35:
        # Check if the folder is on the live server
        prefix = best_csv_folder.split('-')[0]
        live_found = False
        for server_video in bbb_server_videos:
            if server_video['folder'].startswith(prefix):
                matched_folder_id = server_video['folder']
                best_method = f"CSV Live Match ('{best_csv_title}', Score: {best_csv_score:.2f})"
                mapped_live += 1
                live_found = True
                break
        
        if not live_found:
            # Not on live server, but we can prepare it from source CSV
            matched_folder_id = best_csv_folder
            best_method = f"CSV Prepared Match ('{best_csv_title}', Score: {best_csv_score:.2f})"
            mapped_prepared += 1
                
    # ------------------ LAYER 2: TIMELINE JSON BRIDGE MATCH ------------------
    if not matched_folder_id:
        best_json_rec = None
        best_json_score = -1
        
        db_consonants = get_consonants(db_clean)
        
        for rec in json_recordings:
            json_clean = clean_title(rec['ders'])
            json_nums = set(re.findall(r'\d+', json_clean))
            
            if db_nums and json_nums and not (db_nums & json_nums):
                continue
                
            json_consonants = get_consonants(json_clean)
            
            if db_consonants and json_consonants:
                if db_consonants in json_consonants or json_consonants in db_consonants:
                    score = 0.8
                else:
                    db_bigrams = set(db_consonants[i:i+2] for i in range(len(db_consonants)-1))
                    json_bigrams = set(json_consonants[i:i+2] for i in range(len(json_consonants)-1))
                    inter = db_bigrams & json_bigrams
                    uni = db_bigrams | json_bigrams
                    score = len(inter) / len(uni) if uni else 0.0
            else:
                score = 0.0
                
            if db_nums and json_nums and (db_nums & json_nums):
                score += 1.0
                
            if score > best_json_score:
                best_json_score = score
                best_json_rec = rec
                
        if best_json_rec and best_json_score > 0.30:
            json_tarih_str = best_json_rec['tarih']
            json_dt = datetime.datetime.strptime(json_tarih_str, '%Y-%m-%d %H:%M:%S')
            json_ts = int(json_dt.timestamp() * 1000)
            
            # Match against live server folders first
            best_time_diff = float('inf')
            best_time_folder = None
            
            for server_video in bbb_server_videos:
                folder = server_video['folder']
                server_ts = server_video['ts']
                server_title = server_video['title']
                
                # Check A: calendar date match
                date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', server_title)
                if date_match:
                    d, m, y = date_match.groups()
                    try:
                        server_dt = datetime.datetime(int(y), int(m), int(d))
                        days_diff = abs((server_dt - json_dt).days)
                        if days_diff <= 2:
                            time_diff = days_diff * 24 * 3600 * 1000
                            if time_diff < best_time_diff:
                                best_time_diff = time_diff
                                best_time_folder = folder
                    except ValueError:
                        pass
                        
                # Check B: timestamp distance
                if server_ts:
                    time_diff = abs(server_ts - json_ts)
                    if time_diff <= 36 * 3600 * 1000:
                        if time_diff < best_time_diff:
                            best_time_diff = time_diff
                            best_time_folder = folder
                            
            if best_time_folder:
                matched_folder_id = best_time_folder
                best_method = f"Timeline Live Bridge ('{best_json_rec['ders']}', Time Diff: {best_time_diff/3600000:.2f} hours)"
                mapped_live += 1
            else:
                # If not found on live server, look up in s7_all_folders (Source Server Fallback)
                best_s7_diff = float('inf')
                best_s7_folder = None
                
                for s7_video in s7_all_folders:
                    folder = s7_video['folder']
                    server_ts = s7_video['ts']
                    server_title = s7_video['title']
                    
                    date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', server_title)
                    if date_match:
                        d, m, y = date_match.groups()
                        try:
                            server_dt = datetime.datetime(int(y), int(m), int(d))
                            days_diff = abs((server_dt - json_dt).days)
                            if days_diff <= 2:
                                time_diff = days_diff * 24 * 3600 * 1000
                                if time_diff < best_s7_diff:
                                    best_s7_diff = time_diff
                                    best_s7_folder = folder
                        except ValueError:
                            pass
                            
                    if server_ts:
                        time_diff = abs(server_ts - json_ts)
                        if time_diff <= 36 * 3600 * 1000:
                            if time_diff < best_s7_diff:
                                best_s7_diff = time_diff
                                best_s7_folder = folder
                                
                if best_s7_folder:
                    matched_folder_id = best_s7_folder
                    best_method = f"Timeline Prepared Bridge ('{best_json_rec['ders']}', Time Diff: {best_s7_diff/3600000:.2f} hours)"
                    mapped_prepared += 1
                
    # ------------------ LAYER 3: DIRECT SERVER TITLE MATCH ------------------
    if not matched_folder_id:
        best_server_folder = None
        best_server_title = None
        best_server_score = -1
        
        for server_video in bbb_server_videos:
            folder = server_video['folder']
            server_title = server_video['title']
            
            server_clean = clean_title(server_title)
            server_words = normalize_to_words(server_clean)
            server_nums = set(re.findall(r'\d+', server_clean))
            
            if db_nums and server_nums and not (db_nums & server_nums):
                continue
                
            intersection = db_words & server_words
            union = db_words | server_words
            score = len(intersection) / len(union) if union else 0.0
            
            if db_nums and server_nums and (db_nums & server_nums):
                score += 1.0
            if db_date:
                date_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', server_title)
                if date_match and db_date.groups() == date_match.groups():
                    score += 2.0
                    
            if score > best_server_score:
                best_server_score = score
                best_server_folder = folder
                best_server_title = server_title
                
        if best_server_folder and best_server_score > 0.45:
            matched_folder_id = best_server_folder
            best_method = f"Direct Server Live Match ('{best_server_title}', Score: {best_server_score:.2f})"
            mapped_live += 1
            
    if matched_folder_id:
        log_lines.append(f"SUCCESS: Muro '{db_orig_title}' ==> {best_method} ==> Folder '{matched_folder_id}'")
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={matched_folder_id}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{matched_folder_id}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
        sql_statements.append(sql)
    else:
        failed_count += 1
        log_lines.append(f"FAILED: Muro '{db_orig_title}'")

with open('perfect_mvz_restore.sql', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(sql_statements))

with open('mapping_log.txt', 'w', encoding='iso-8859-9') as f:
    f.write("\n".join(log_lines))

print(f"\n--- TIMELINE + CSV + DIRECT MATCHING RESULTS ---")
print(f"Mapped Live on Server:   {mapped_live}")
print(f"Mapped Prepared (s7):    {mapped_prepared}")
print(f"Total Mapped:            {mapped_live + mapped_prepared}")
print(f"Failed to Map:           {failed_count}")
print(f"Saved {len(sql_statements)} statements to perfect_mvz_restore.sql")
print("See mapping_log.txt for details.")
