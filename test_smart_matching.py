import csv
import re

# Load Muro courses
muro_courses = {}
with open('muro_mng_courses.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if '|' in line:
            cid, title = line.split('|', 1)
            muro_courses[title.strip()] = cid.strip()

# Abbreviations expansion
def expand_abbr(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    # Expand common Turkish ÖABT abbreviations
    text = re.sub(r'\bete\b', 'eski turk edebiyati', text)
    text = re.sub(r'\byte\b', 'yeni turk edebiyati', text)
    text = re.sub(r'\betd\b', 'eski turk dili', text)
    text = re.sub(r'\bytd\b', 'yeni turk dili', text)
    return text

def get_words_and_meta(title_raw):
    title_norm = expand_abbr(title_raw)
    title_clean = re.sub(r'[^a-z0-9\s]', ' ', title_norm)
    words = title_clean.split()
    
    # Extract years
    years = {w for w in words if w.isdigit() and len(w) == 4}
    
    # Check if soru cozumu or konu anlatimi
    is_soru = any(w in words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
    is_konu = any(w in words for w in ['konu', 'anlatimi', 'anlatim'])
    
    # Filter content words
    stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'anlatim', 'soru', 'cozumu', 'cozum', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video', 'sorular', 'cozumleri'}
    content_words = {w for w in words if w not in stop_words and not w.isdigit()}
    
    return {
        'raw': title_raw,
        'norm': title_norm,
        'words': set(words),
        'content_words': content_words,
        'years': years,
        'is_soru': is_soru,
        'is_konu': is_konu
    }

# Pre-parse Muro courses
muro_parsed = {}
for mc, mc_id in muro_courses.items():
    muro_parsed[mc] = {
        'id': mc_id,
        'meta': get_words_and_meta(mc)
    }

# Read s4 CSV
s4_records = []
s4_csv_path = 'mng/s4_videolar_listesi_analiz.csv'
with open(s4_csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader)
    for row in reader:
        if len(row) >= 2:
            s4_records.append((row[0].strip(), row[1].strip()))

# Smart matching algorithm
matches = {}  # course_title -> list of (folder_id, s4_title)
unmatched = set(muro_courses.keys())

for folder_id, s4_title in s4_records:
    s4_meta = get_words_and_meta(s4_title)
    
    best_mc = None
    best_score = -999
    
    for mc, mc_data in muro_parsed.items():
        mc_meta = mc_data['meta']
        
        # 1. Content words overlap
        common_content = s4_meta['content_words'].intersection(mc_meta['content_words'])
        if not common_content:
            continue
            
        score = len(common_content) * 10
        
        # 2. Year matching
        if s4_meta['years'] and mc_meta['years']:
            if s4_meta['years'] == mc_meta['years']:
                score += 15  # exact year match bonus
            else:
                score -= 15  # year mismatch penalty (still possible if content is identical and nothing else matches)
                
        # 3. Soru vs Konu alignment
        if s4_meta['is_soru'] == mc_meta['is_soru']:
            score += 8
        if s4_meta['is_konu'] == mc_meta['is_konu']:
            score += 8
            
        if score > best_score:
            best_score = score
            best_mc = mc
            
    # We require a minimum score to prevent false positives
    if best_mc and best_score >= 15:
        if best_mc not in matches:
            matches[best_mc] = []
        matches[best_mc].append((folder_id, s4_title))
        if best_mc in unmatched:
            unmatched.remove(best_mc)

print(f"Total Muro courses: {len(muro_courses)}")
print(f"Matched courses: {len(matches)}")
print(f"Unmatched courses: {len(unmatched)}")

print("\nSample matched courses and their record count:")
for mc in sorted(matches.keys())[:15]:
    print(f"- {mc}: {len(matches[mc])} videos")
    
# Specifically check '2026 1500 Soru ETE Soru Çözümü'
ete_course = '2026 1500 Soru ETE Soru Çözümü'
if ete_course in matches:
    print(f"\nETE course '{ete_course}' matches ({len(matches[ete_course])} videos):")
    for f_id, s4_t in matches[ete_course][:10]:
        print(f"  - {s4_t} ({f_id})")
else:
    print(f"\nETE course '{ete_course}' not matched.")
