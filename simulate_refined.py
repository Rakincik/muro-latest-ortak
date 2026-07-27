import re
import html

def clean_title(title):
    if not title:
        return ""
    title = html.unescape(title)
    title = re.sub(r'^BBB Kayıtları\s*\((.*?)\)$', r'\1', title, flags=re.IGNORECASE)
    title = re.sub(r'\d{2}[./]\d{2}[./]\d{4}', '', title)
    return title.strip()

def normalize_to_words(text):
    text = text.lower().strip()
    replacements = {
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c',
        'İ': 'i', 'Ğ': 'g', 'Ü': 'u', 'Ş': 's', 'Ö': 'o', 'Ç': 'c',
        'ı': 'i', 'ğ': 'g', 'ü': 'u', 'ş': 's', 'ö': 'o', 'ç': 'c'
    }
    for k, v in replacements.items():
        text = text.replace(k, v)
    
    # Replace common abbreviations
    text = text.replace('cbk', 'cumhurbaskanligi kararnamesi')
    text = text.replace('cb', 'cumhurbaskanligi')
    text = text.replace('dmk', 'devlet memurları kanunu')
    text = text.replace('dik', 'devlet ihale kanunu')
    text = text.replace('hmk', 'hukuk muhakemeleri kanunu')
    text = text.replace('iyuk', 'idari yargılama usulü kanunu')
    text = text.replace('gys', 'gorevde yukselme sinavi')
    
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    words = [w for w in text.split() if len(w) > 1 or w.isdigit()]
    return set(words)

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

for db_id, db_orig_title in muro_sessions:
    db_clean = clean_title(db_orig_title)
    db_words = normalize_to_words(db_clean)
    db_nums = set(re.findall(r'\d+', db_orig_title))
    
    candidates = []
    
    for folder, bbb_orig_title in bbb_videos:
        bbb_clean = clean_title(bbb_orig_title)
        bbb_words = normalize_to_words(bbb_clean)
        bbb_nums = set(re.findall(r'\d+', bbb_orig_title))
        
        # Rule: If both have numbers (e.g. kanun numbers like 657, 4734), they must match!
        if db_nums and bbb_nums:
            # Check if there is any intersection in numbers
            intersect_nums = db_nums & bbb_nums
            if not intersect_nums:
                continue # number mismatch
                
        # Calculate Jaccard similarity of words
        intersection = db_words & bbb_words
        union = db_words | bbb_words
        
        score = len(intersection) / len(union) if union else 0.0
        
        # If numbers match, boost the score significantly
        if db_nums and bbb_nums and (db_nums & bbb_nums):
            score += 1.0
            
        # Substring bonus
        db_phrase = " ".join(sorted(list(db_words)))
        bbb_phrase = " ".join(sorted(list(bbb_words)))
        if db_phrase in bbb_phrase or bbb_phrase in db_phrase:
            score += 0.3
            
        if score > 0.0:
            candidates.append((score, folder, bbb_orig_title))
            
    candidates.sort(reverse=True)
    if candidates:
        mapped_results.append({
            'db_id': db_id,
            'db_title': db_orig_title,
            'bbb_folder': candidates[0][1],
            'bbb_title': candidates[0][2],
            'score': candidates[0][0],
            'candidates': candidates[:3]
        })
    else:
        mapped_results.append({
            'db_id': db_id,
            'db_title': db_orig_title,
            'bbb_folder': None,
            'bbb_title': 'NO MATCH',
            'score': 0.0,
            'candidates': []
        })

print("--- DETAILED CANDIDATES ---")
for r in mapped_results:
    print(f"DB: {r['db_title']}")
    print(f"  Mapped to: {r['bbb_title']} (score: {r['score']:.2f})")
    print(f"  Top Candidates:")
    for score, folder, title in r['candidates']:
        print(f"    - {score:.2f}: {title} ({folder[:8]}...)")
    print("-" * 50)
