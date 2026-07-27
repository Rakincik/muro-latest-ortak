import re
import html

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
    text = text.replace('ete', 'eski turk edebiyati').replace('yte', 'yeni turk edebiyati')
    text = text.replace('etd', 'eski turk dili').replace('ytd', 'yeni turk dili')
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

s4_recs = parse_txt_file('mng/s4_videolar_listesi.txt', 's4')
s7_recs = parse_txt_file('mng/s7_videolar.txt', 's7')
all_recs = s4_recs + s7_recs

muro_parsed = {}
for mc, mc_id in muro_courses.items():
    muro_parsed[mc] = {
        'id': mc_id,
        'words': set(get_words(mc))
    }

matched_courses = set()
matched_records_count = 0

for rec in all_recs:
    title = rec['meeting_name']
    if not title:
        continue
    rec_words = set(get_words(title))
    rec_years = {w for w in rec_words if w.isdigit() and len(w) == 4}
    rec_is_soru = any(w in rec_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
    rec_is_konu = any(w in rec_words for w in ['konu', 'anlatimi', 'anlatim'])
    
    stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'anlatim', 'soru', 'cozumu', 'cozum', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video', 'sorular', 'cozumleri'}
    rec_char = rec_words - stop_words
    
    # Calculate scores for all courses
    scores = []
    for mc, mc_data in muro_parsed.items():
        mc_words = mc_data['words']
        mc_years = {w for w in mc_words if w.isdigit() and len(w) == 4}
        mc_is_soru = any(w in mc_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
        mc_is_konu = any(w in mc_words for w in ['konu', 'anlatimi', 'anlatim'])
        
        year_penalty = 0
        if mc_years and rec_years and mc_years != rec_years:
            year_penalty = -30
            
        mc_char = mc_words - stop_words
        intersection = rec_char.intersection(mc_char)
        if not intersection:
            continue
            
        score = len(intersection) * 10 + year_penalty
        if rec_is_soru == mc_is_soru:
            score += 8
        if rec_is_konu == mc_is_konu:
            score += 8
            
        scores.append((mc, score))
        
    if not scores:
        continue
        
    # Find best score
    best_mc, best_score = max(scores, key=lambda x: x[1])
    
    if best_score >= 5:
        # Match to the best course, and any other course that is within 5 points of the best score
        for mc, score in scores:
            if score >= 5 and (best_score - score) <= 5:
                matched_courses.add(mc)
                matched_records_count += 1

print(f"Total matched Muro courses (Multi-match): {len(matched_courses)} / {len(muro_courses)}")
print(f"Total mapped record entries: {matched_records_count}")
print(f"Unmatched Muro courses: {len(set(muro_courses.keys()) - matched_courses)}")
for c in sorted(set(muro_courses.keys()) - matched_courses):
    print("-", c)
