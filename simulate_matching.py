import re
import html
from difflib import SequenceMatcher

def clean_title(title):
    if not title:
        return ""
    title = html.unescape(title)
    # Remove 'BBB Kayıtları (' and trailing ')'
    title = re.sub(r'^BBB Kayıtları\s*\((.*?)\)$', r'\1', title, flags=re.IGNORECASE)
    # Remove dates like DD.MM.YYYY or DD/MM/YYYY
    title = re.sub(r'\d{2}[./]\d{2}[./]\d{4}', '', title)
    return title.strip()

def normalize(text):
    text = text.lower().strip()
    # Replace Turkish chars
    replacements = {
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'İ': 'i', 'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c'
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
    text = re.sub(r'[^a-z0-9\s]', '', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def extract_numbers(text):
    return set(re.findall(r'\d+', text))

# Read Muro DB Sessions
muro_sessions = []
with open('muro_db_dump.txt', 'r', encoding='utf-8') as f:
    for line in f:
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3 and len(parts[0]) == 36:
            db_id = parts[0]
            db_title = parts[1]
            muro_sessions.append((db_id, db_title))

# Read BBB Videos
bbb_videos = []
with open('bbb_videos.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if not line or ';' not in line:
            continue
        parts = line.split(';', 1)
        folder = parts[0].strip()
        title = parts[1].strip()
        bbb_videos.append((folder, title))

mapped_results = []
unmapped = []

for db_id, db_orig_title in muro_sessions:
    db_clean = clean_title(db_orig_title)
    db_norm = normalize(db_clean)
    db_nums = extract_numbers(db_clean)
    
    best_folder = None
    best_title = None
    best_score = -1
    
    for folder, bbb_orig_title in bbb_videos:
        bbb_clean = clean_title(bbb_orig_title)
        bbb_norm = normalize(bbb_clean)
        bbb_nums = extract_numbers(bbb_clean)
        
        # Rule 1: If both have numbers, they must have at least one common number
        if db_nums and bbb_nums:
            if not (db_nums & bbb_nums):
                continue # Number mismatch (e.g. 657 vs 4734)
                
        # Calculate similarity
        # Check if one is substring of another
        if db_norm and bbb_norm:
            if db_norm in bbb_norm or bbb_norm in db_norm:
                score = 1.0
            else:
                score = SequenceMatcher(None, db_norm, bbb_norm).ratio()
        else:
            score = 0
            
        # Prioritize matching numbers
        if db_nums and bbb_nums and (db_nums & bbb_nums):
            score += 0.5 # Boost matching numbers
            
        if score > best_score:
            best_score = score
            best_folder = folder
            best_title = bbb_orig_title
            
    if best_folder and best_score > 0.3:
        mapped_results.append({
            'db_id': db_id,
            'db_title': db_orig_title,
            'bbb_folder': best_folder,
            'bbb_title': best_title,
            'score': best_score
        })
    else:
        unmapped.append((db_id, db_orig_title))

# Print mapped results
print(f"--- MAPPED {len(mapped_results)} / {len(muro_sessions)} ---")
for r in sorted(mapped_results, key=lambda x: x['score'], reverse=True):
    print(f"SCORE: {r['score']:.2f} | DB: {r['db_title']} ==> BBB: {r['bbb_title']} ({r['bbb_folder'][:10]}...)")
    
print(f"\n--- UNMAPPED {len(unmapped)} ---")
for db_id, db_title in unmapped:
    print(f"DB: {db_title} ({db_id})")
