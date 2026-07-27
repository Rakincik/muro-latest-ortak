import json
import re
import html

# 1. Load Muro courses
muro_courses = {}
with open('muro_mng_courses.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if '|' in line:
            cid, title = line.split('|', 1)
            muro_courses[title.strip()] = cid.strip()

# 2. Load allowed record IDs from dereceuzem and turkceoabtdeyiz JSONs
allowed_record_ids = set()

with open('okinar dersler/dereceuzem.okinar.com_recordings.json', 'r', encoding='utf-8') as f:
    for item in json.load(f):
        if 'recordID' in item:
            allowed_record_ids.add(item['recordID'].strip())

with open('okinar dersler/turkceoabtdeyiz.okinar.com_recordings.json', 'r', encoding='utf-8') as f:
    for item in json.load(f):
        if 'recordID' in item:
            allowed_record_ids.add(item['recordID'].strip())

print(f"Total allowed MNG record IDs: {len(allowed_record_ids)}")

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
                
                # STRICT FILTER: Only allow if present in MNG JSONs!
                if folder_id not in allowed_record_ids:
                    continue
                    
                if folder_id not in recordings:
                    recordings[folder_id] = {
                        'server': server_name,
                        'folder_id': folder_id,
                        'meeting_id': '',
                        'meeting_name': ''
                    }
                if '<meetingId>' in content:
                    m_match = re.search(r'<meetingId>(.*?)</meetingId>', content)
                    if m_match:
                        recordings[folder_id]['meeting_id'] = m_match.group(1).strip()
                elif '<meetingName>' in content:
                    mn_match = re.search(r'<meetingName>(.*?)</meetingName>', content)
                    if mn_match:
                        raw_name = mn_match.group(1).strip()
                        recordings[folder_id]['meeting_name'] = html.unescape(raw_name)
    return list(recordings.values())

print("Parsing s4_videolar_listesi.txt with strict filter...")
s4_recs = parse_txt_file('mng/s4_videolar_listesi.txt', 's4')
print("Parsing s7_videolar.txt with strict filter...")
s7_recs = parse_txt_file('mng/s7_videolar.txt', 's7')

print(f"Strictly matched recordings physically on s4: {len(s4_recs)}")
print(f"Strictly matched recordings physically on s7: {len(s7_recs)}")

all_recs = s4_recs + s7_recs
print(f"Total unique MNG recordings physically present: {len(all_recs)}")

muro_parsed = {}
for mc, mc_id in muro_courses.items():
    muro_parsed[mc] = {
        'id': mc_id,
        'words': set(get_words(mc))
    }

matched_courses = set()

for rec in all_recs:
    title = rec['meeting_name']
    if not title:
        continue
        
    m_id_lower = rec['meeting_id'].lower()
    m_name_lower = title.lower()
    f_id = rec['folder_id']
    
    # Check overrides
    override_mc = None
    if 'fatih-omur' in m_id_lower:
        override_mc = 'Fatih Ömür Soru Çözümü'
    elif 'ayt coğrafya' in m_name_lower or 'ayt cografya' in m_name_lower or 'ea sözel' in m_name_lower or 'ea sozel' in m_name_lower:
        override_mc = 'EA Sözel Kampı'
    elif f_id.startswith('7cb3073bedc11616f7b35feb2295f539577f60e5'):
        override_mc = 'EKYS Anayasa ve Mevzuatlar Konu Anlatım Videoları'
    elif 'dev paragraf' in m_name_lower:
        override_mc = 'Paragraf Konu+Soru'
        
    if override_mc:
        matched_courses.add(override_mc)
        continue
        
    # Standard NLP
    rec_words = set(get_words(title))
    rec_years = {w for w in rec_words if w.isdigit() and len(w) == 4}
    rec_is_soru = any(w in rec_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
    rec_is_konu = any(w in rec_words for w in ['konu', 'anlatimi', 'anlatim'])
    
    stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'anlatim', 'soru', 'cozumu', 'cozum', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video', 'sorular', 'cozumleri'}
    rec_char = rec_words - stop_words
    
    best_mc = None
    best_score = -999
    
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
            
        if score > best_score:
            best_score = score
            best_mc = mc
            
    # We use score >= 18 or (best_score - score <= 5) for multi-match
    if best_mc and best_score >= 5:
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
            if score >= 26 or (best_score - score) <= 5:
                matched_courses.add(mc)

print(f"\nMatched Muro courses under strict filter: {len(matched_courses)} / {len(muro_courses)}")
print(f"Unmatched courses: {sorted(set(muro_courses.keys()) - matched_courses)}")
