import glob
import re
from difflib import SequenceMatcher

def extract_core_title(title):
    # Extract what's inside 'BBB Kayıtları ( ... )'
    match = re.search(r'BBB Kayıtları \((.*?)\)', title)
    if match:
        return match.group(1).strip()
    return title.strip()

def normalize_for_compare(text):
    text = text.lower().replace('i', 'ı').replace('ş', 's').replace('ğ', 'g').replace('ü', 'u').replace('ö', 'o').replace('ç', 'c')
    text = re.sub(r'[^a-z0-9]', '', text)
    return text

# Load all CSV and TXT data
csv_files = glob.glob('C:/Users/Rüstem/Desktop/okideolar/*.csv') + glob.glob('C:/Users/Rüstem/Desktop/okideolar/*.txt')
csv_titles_to_id = {}

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
            if title and len(title) > 2 and folder:
                csv_titles_to_id[title] = folder

# Parse DB dump
db_rows = []
with open('muro_db_dump.txt', 'r', encoding='utf-8') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36: # valid UUID
            db_rows.append((parts[0], parts[1]))

sql_statements = []

for db_id, db_title in db_rows:
    core_title = extract_core_title(db_title)
    norm_core = normalize_for_compare(core_title)
    
    best_match = None
    best_score = 0
    
    for csv_title, folder_id in csv_titles_to_id.items():
        norm_csv = normalize_for_compare(csv_title)
        
        # Check if one contains the other (very strong signal)
        if norm_core in norm_csv or norm_csv in norm_core:
            score = 1.0
        else:
            score = SequenceMatcher(None, norm_core, norm_csv).ratio()
            
        if score > best_score:
            best_score = score
            best_match = folder_id
            
    # If we found a reasonable match
    if best_match and best_score > 0.4:
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={best_match}"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{best_match}', "VideoUrl" = '{video_url}' WHERE "Id" = '{db_id}';"""
        sql_statements.append(sql)

with open('perfect_id_fix.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"Generated {len(sql_statements)} perfect ID-based updates.")
