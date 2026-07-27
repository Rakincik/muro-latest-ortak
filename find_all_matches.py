import re
import html
import openpyxl
import csv

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
    text = re.sub(r'\bete\b', 'eski turk edebiyati', text)
    text = re.sub(r'\byte\b', 'yeni turk edebiyati', text)
    text = re.sub(r'\betd\b', 'eski turk dili', text)
    text = re.sub(r'\bytd\b', 'yeni turk dili', text)
    return text

def get_words(text):
    text_norm = expand_abbr(text)
    text_clean = re.sub(r'[^a-z0-9\s]', ' ', text_norm)
    return [w for w in text_clean.split() if len(w) > 1 or w.isdigit()]

# Parse TXT files
def parse_txt_file(file_path, server_name):
    recordings = {}
    pattern = re.compile(r'/var/bigbluebutton/published/presentation/([^/]+)/metadata.xml:(.*)')
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = pattern.search(line)
            if match:
                folder_id = match.group(1).strip()
                content = match.group(2).strip()
                if folder_id not in recordings:
                    recordings[folder_id] = {
                        'server': server_name,
                        'folder_id': folder_id,
                        'meeting_name': ''
                    }
                if '<meetingName>' in content:
                    mn_match = re.search(r'<meetingName>(.*?)</meetingName>', content)
                    if mn_match:
                        raw_name = mn_match.group(1).strip()
                        recordings[folder_id]['meeting_name'] = html.unescape(raw_name)
    return list(recordings.values())

print("Parsing files...")
s4_recs = parse_txt_file('mng/s4_videolar_listesi.txt', 's4')
s7_recs = parse_txt_file('mng/s7_videolar.txt', 's7')
all_recs = s4_recs + s7_recs
print(f"Loaded {len(all_recs)} unique recordings.")

# Let's inspect the best match for each Muro course
muro_best_matches = []

for mc, mc_id in muro_courses.items():
    mc_words = set(get_words(mc))
    mc_years = {w for w in mc_words if w.isdigit() and len(w) == 4}
    
    # Check if soru cozumu or konu anlatimi
    mc_is_soru = any(w in mc_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
    mc_is_konu = any(w in mc_words for w in ['konu', 'anlatimi', 'anlatim'])
    
    stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'anlatim', 'soru', 'cozumu', 'cozum', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video', 'sorular', 'cozumleri'}
    mc_char = mc_words - stop_words
    
    best_rec = None
    best_score = -999
    
    for rec in all_recs:
        title = rec['meeting_name']
        if not title:
            continue
        rec_words = set(get_words(title))
        rec_years = {w for w in rec_words if w.isdigit() and len(w) == 4}
        rec_is_soru = any(w in rec_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
        rec_is_konu = any(w in rec_words for w in ['konu', 'anlatimi', 'anlatim'])
        
        # 1. Year matching (strict penalty if mismatch, but allowed if no other match)
        year_penalty = 0
        if mc_years and rec_years and mc_years != rec_years:
            year_penalty = -30
            
        rec_char = rec_words - stop_words
        intersection = mc_char.intersection(rec_char)
        if not intersection:
            continue
            
        score = len(intersection) * 10 + year_penalty
        
        # Soru vs Konu alignment
        if rec_is_soru == mc_is_soru:
            score += 8
        if rec_is_konu == mc_is_konu:
            score += 8
            
        if score > best_score:
            best_score = score
            best_rec = rec
            
    muro_best_matches.append({
        'muro_course': mc,
        'muro_id': mc_id,
        'best_match_title': best_rec['meeting_name'] if best_rec else "NO MATCH",
        'best_match_server': best_rec['server'] if best_rec else "",
        'best_match_folder': best_rec['folder_id'] if best_rec else "",
        'score': best_score
    })

# Print all courses and their best match
print("\n--- ALL 127 MURO COURSES AND THEIR BEST MATCH ---")
matched_count = 0
for item in sorted(muro_best_matches, key=lambda x: x['score'], reverse=True):
    is_match = item['score'] >= 5 # Lowered threshold to 5 (at least 1 overlapping word)
    status = "MATCHED" if is_match else "UNMATCHED"
    if is_match:
        matched_count += 1
    print(f"[{status}] Score: {item['score']} | Muro: \"{item['muro_course']}\" ==> Best Match: \"{item['best_match_title']}\" ({item['best_match_server']} / {item['best_match_folder'][:10]})")

print(f"\nTotal Matched (Threshold >= 5): {matched_count} / {len(muro_courses)}")
