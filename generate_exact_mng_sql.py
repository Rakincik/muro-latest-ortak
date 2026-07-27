import json
import re
import datetime
import csv
import html

# 1. Load Muro courses
muro_courses = {}
with open('muro_mng_courses.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if '|' in line:
            cid, title = line.split('|', 1)
            muro_courses[title.strip()] = cid.strip()

# Helper function to expand abbreviations and normalize Turkish text
def normalize_text(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    text = text.replace('ete', 'eski turk edebiyati')
    text = text.replace('yte', 'yeni turk edebiyati')
    text = text.replace('etd', 'eski turk dili')
    text = text.replace('ytd', 'yeni turk dili')
    return text

def get_words(text):
    text_norm = normalize_text(text)
    text_clean = re.sub(r'[^a-z0-9\s]', ' ', text_norm)
    return [w for w in text_clean.split() if len(w) > 1 or w.isdigit()]

# Parse Muro courses for similarity match
muro_parsed = {}
for mc, mc_id in muro_courses.items():
    muro_parsed[mc] = {
        'id': mc_id,
        'words': set(get_words(mc)),
        'norm': normalize_text(mc)
    }

# 2. Parse Server TXT Metadata files (only for YKS & Overrides)
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
                        'start_time': '',
                        'meeting_id': '',
                        'meeting_name': ''
                    }
                
                if '<start_time>' in content:
                    st_match = re.search(r'<start_time>(.*?)</start_time>', content)
                    if st_match:
                        recordings[folder_id]['start_time'] = st_match.group(1).strip()
                elif '<meetingId>' in content:
                    m_match = re.search(r'<meetingId>(.*?)</meetingId>', content)
                    if m_match:
                        recordings[folder_id]['meeting_id'] = m_match.group(1).strip()
                elif '<meetingName>' in content:
                    mn_match = re.search(r'<meetingName>(.*?)</meetingName>', content)
                    if mn_match:
                        raw_name = mn_match.group(1).strip()
                        recordings[folder_id]['meeting_name'] = html.unescape(raw_name)
    return list(recordings.values())

print("Parsing s4_videolar_listesi.txt for YKS & Overrides...")
s4_recs = parse_txt_file('mng/s4_videolar_listesi.txt', 's4')
print("Parsing s7_videolar.txt for YKS & Overrides...")
s7_recs = parse_txt_file('mng/s7_videolar.txt', 's7')
all_server_recs = s4_recs + s7_recs
server_rec_map = {r['folder_id']: r for r in all_server_recs}

# Helper to format BBB timestamp to date
def get_date_from_folder_id(folder_id):
    parts = folder_id.split('-')
    if len(parts) >= 2 and parts[-1].isdigit() and len(parts[-1]) == 13:
        try:
            ts = int(parts[-1])
            dt = datetime.datetime.fromtimestamp(ts / 1000.0)
            return dt.strftime('%Y-%m-%d %H:%M:%S')
        except:
            pass
    return "NOW()"

# 3. Match scraped JSON courses exactly (ÖABT & EKYS)
with open('dereceuzem_guncel_kayitlar (2).json', 'r', encoding='utf-8') as f:
    scraped_data = json.load(f)

matched_records = []
matched_courses_set = set()

# Process JSON recordings (ÖABT/EKYS)
for item in scraped_data:
    oc_name = item.get('courseName')
    if not oc_name or oc_name == 'Düzenle':
        continue
    
    recordings = item.get('recordings', [])
    if not recordings:
        continue
    
    oc_norm = normalize_text(oc_name)
    oc_words = set(get_words(oc_name))
    
    # 1. EKYS rule check (takes precedence to map normal & library courses)
    is_ekys = 'ekys' in oc_words
    ekys_subjects = {'tarih', 'cografya', 'coğrafya', 'maarif', 'egitim', 'eğitim', 'mevzuat', 'mevzuatlar', 'anayasa'}
    oc_ekys_sub = oc_words.intersection(ekys_subjects)
    
    ekys_matches = []
    if is_ekys and oc_ekys_sub:
        for mc, mc_data in muro_parsed.items():
            if 'ekys' in mc_data['words']:
                mc_ekys_sub = mc_data['words'].intersection(ekys_subjects)
                if oc_ekys_sub.intersection(mc_ekys_sub):
                    ekys_matches.append((mc, mc_data['id']))
                    
    if ekys_matches:
        matched_muros = ekys_matches
    else:
        # 2. Exact match check
        exact_matches = []
        for mc, mc_data in muro_parsed.items():
            if mc_data['norm'] == oc_norm:
                exact_matches.append((mc, mc_data['id']))
                
        if exact_matches:
            matched_muros = exact_matches
        else:
            # 3. Fuzzy match check
            oc_years = {w for w in oc_words if w.isdigit() and len(w) == 4}
            oc_is_soru = any(w in oc_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
            oc_is_konu = any(w in oc_words for w in ['konu', 'anlatimi', 'anlatim'])
            
            stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'anlatim', 'soru', 'cozumu', 'cozum', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video', 'sorular', 'cozumleri'}
            oc_char = oc_words - stop_words
            
            scores = []
            for mc, mc_data in muro_parsed.items():
                mc_words = mc_data['words']
                mc_years = {w for w in mc_words if w.isdigit() and len(w) == 4}
                mc_is_soru = any(w in mc_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
                mc_is_konu = any(w in mc_words for w in ['konu', 'anlatimi', 'anlatim'])
                
                # Cross YKS protection
                if any(w in mc_words for w in ['tyt', 'ayt', 'yks']):
                    continue
                    
                year_penalty = 0
                if mc_years and oc_years and mc_years != oc_years:
                    year_penalty = -35
                    
                mc_char = mc_words - stop_words
                intersection = oc_char.intersection(mc_char)
                if not intersection:
                    continue
                    
                score = len(intersection) * 10 + year_penalty
                if oc_is_soru == mc_is_soru:
                    score += 10
                if oc_is_konu == mc_is_konu:
                    score += 10
                    
                scores.append((mc, score, mc_data['id']))
                
            if not scores:
                print(f"WARNING: Could not match Okinar course: {oc_name}")
                continue
                
            best_mc, best_score, _ = max(scores, key=lambda x: x[1])
            
            matched_muros = []
            for mc, score, mc_id in scores:
                if (best_score - score) <= 2 and best_score >= 12:
                    matched_muros.append((mc, mc_id))
                    
    if not matched_muros:
        print(f"WARNING: No strong match for Okinar course: {oc_name}")
        continue
        
    # Map all recordings to all matched Muro courses
    for mc_name, mc_id in matched_muros:
        matched_courses_set.add(mc_name)
        for idx, rec in enumerate(recordings):
            f_id = rec['recordID'].strip()
            video_name = rec['videoName']
            server = rec['server']
            
            # Date
            date_str = get_date_from_folder_id(f_id)
            
            matched_records.append({
                'server': server,
                'folder_id': f_id,
                'title': video_name,
                'date': date_str,
                'course_id': mc_id,
                'course_title': mc_name,
                'source': 'JSON'
            })

# 4. YKS & Overrides (Processed from server logs)
for rec in all_server_recs:
    f_id = rec['folder_id']
    title = rec['meeting_name']
    if not title:
        continue
        
    m_id_lower = rec['meeting_id'].lower()
    m_name_lower = title.lower()
    
    # Check if already mapped via JSON
    # (If it's already mapped via JSON, we skip to avoid duplicating ÖABT/EKYS)
    if any(r['folder_id'] == f_id for r in matched_records if r['source'] == 'JSON'):
        continue
        
    # Date
    date_str = "NOW()"
    if rec['start_time']:
        try:
            ts = int(rec['start_time'])
            dt = datetime.datetime.fromtimestamp(ts / 1000.0)
            date_str = dt.strftime('%Y-%m-%d %H:%M:%S')
        except:
            date_str = get_date_from_folder_id(f_id)
            
    # 4.1 Custom Overrides
    if 'fatih-omur' in m_id_lower:
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': 'afc5d1c4-ef09-416a-922b-664ae53a4a6f',
            'course_title': 'Fatih Ömür Soru Çözümü',
            'source': 'Override'
        })
        matched_courses_set.add('Fatih Ömür Soru Çözümü')
        continue
    elif 'ea sözel' in m_name_lower or 'ea sozel' in m_name_lower or 'dev paragraf' in m_name_lower:
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': '5a6b02df-690f-46af-91ed-f1cd89f8d166',
            'course_title': 'EA Sözel Kampı',
            'source': 'Override'
        })
        matched_courses_set.add('EA Sözel Kampı')
        continue
    elif f_id.startswith('7cb3073bedc11616f7b35feb2295f539577f60e5'):
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': '99ffa664-2166-484c-aacd-98d8a49346cd',
            'course_title': 'EKYS Anayasa ve Mevzuatlar Konu Anlatım Videoları',
            'source': 'Override'
        })
        matched_courses_set.add('EKYS Anayasa ve Mevzuatlar Konu Anlatım Videoları')
        continue
        
    # 4.2 YKS strict mapping
    yks_target = None
    if 'tyt' in m_name_lower or 'ayt' in m_name_lower or 'yks' in m_name_lower:
        if 'fizik' in m_name_lower:
            yks_target = 'TYT Fizik' if 'tyt' in m_name_lower else 'AYT Fizik'
        elif 'biyoloji' in m_name_lower:
            yks_target = 'TYT Biyoloji' if 'tyt' in m_name_lower else 'AYT Biyoloji'
        elif 'kimya' in m_name_lower:
            yks_target = 'TYT Kimya' if 'tyt' in m_name_lower else 'AYT Kimya'
        elif 'matematik' in m_name_lower:
            yks_target = 'AYT Matematik'
        elif 'coğrafya' in m_name_lower or 'cografya' in m_name_lower:
            yks_target = 'TYT Coğrafya' if 'tyt' in m_name_lower else 'AYT Coğrafya'
        elif 'geometri' in m_name_lower:
            yks_target = 'TYT-AYT geometri'
        elif 'tarih' in m_name_lower:
            yks_target = 'YKS Tarih' if 'yks tarih' in m_name_lower else 'TYT-AYT Tarih'
        elif 'felsefe' in m_name_lower:
            yks_target = 'TYT Felsefe' if 'tyt' in m_name_lower else 'AYT Felsefe'
        elif 'din' in m_name_lower or 'kultur' in m_name_lower:
            yks_target = 'TYT Din Kültürü' if 'tyt' in m_name_lower else 'AYT Din Kültürü'
        elif 'edebiyat' in m_name_lower:
            yks_target = 'AYT Edebiyat'
            
    if yks_target and yks_target in muro_courses:
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': muro_courses[yks_target],
            'course_title': yks_target,
            'source': 'YKS'
        })
        matched_courses_set.add(yks_target)

# 5. Generate Output files
sql_blocks = []
current_block_stmts = []

# Gather all folder IDs to delete first (for clean reset)
all_folder_ids = sorted(list(set(r['folder_id'] for r in matched_records)))
folder_ids_sql_list = ", ".join(f"'{f}'" for f in all_folder_ids)

csv_rows = []
csv_header = ['Sunucu', 'Kurum', 'Oda Adı', 'Muro Ders Adı', 'BBB Gerçek Saat', 'Kaynak', 'Fiziksel Dosya Yolu', 'Folder ID', 'Link']

for idx, rec in enumerate(matched_records, 1):
    # CSV
    csv_rows.append([
        rec['server'],
        'Dereceuzem',
        rec['title'],
        rec['course_title'],
        rec['date'],
        rec['source'],
        f"/var/bigbluebutton/published/presentation/{rec['folder_id']}",
        rec['folder_id'],
        f"https://{rec['server']}.okinar.com/playback/presentation/2.3/{rec['folder_id']}"
    ])
    
    # SQL
    clean_room_title = rec['title'].replace("'", "''")
    video_url = f"https://canli.mng.muro.click/playback/presentation/2.3/{rec['folder_id']}"
    date_val_sql = f"'{rec['date']}'" if rec['date'] != "NOW()" else "NOW()"
    
    sql_stmt = f"""    sid := gen_random_uuid();
    IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = '{rec['course_id']}' AND "BbbMeetingId" = '{rec['folder_id']}') THEN
        INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "VideoUrl", "ScheduledStart", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
        VALUES (sid, '{rec['course_id']}', '{clean_room_title}', '{rec['folder_id']}', '{video_url}', {date_val_sql}, false, NOW(), 3, 0, true, false);
        
        INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt")
        VALUES (gen_random_uuid(), '{rec['course_id']}', sid, -1, NOW());
    END IF;"""
    current_block_stmts.append(sql_stmt)
    
    # Group every 1000 statements
    if len(current_block_stmts) >= 1000 or idx == len(matched_records):
        sql_block = f"""DO $$ 
DECLARE
    sid uuid;
BEGIN
{chr(10).join(current_block_stmts)}
END $$;"""
        sql_blocks.append(sql_block)
        current_block_stmts = []

# Write SQL file
with open('mng_sessions_insert.sql', 'w', encoding='utf-8') as f:
    f.write("-- ==================================================\n")
    f.write("-- DERECE UZEM (mng) - COMBINED CLEAN TXT SESSIONS IMPORT\n")
    f.write(f"-- Total Sessions: {len(matched_records)}\n")
    f.write("-- ==================================================\n\n")
    
    # Write RESET block
    f.write("-- ==================================================\n")
    f.write("-- RESET / CLEAN PREVIOUS MAPPINGS TO PREVENT DUPLICATES\n")
    f.write("-- ==================================================\n")
    f.write("DO $$ \n")
    f.write("BEGIN\n")
    f.write("    DELETE FROM \"CourseMedias\";\n")
    f.write("    DELETE FROM \"Sessions\";\n")
    f.write("END $$;\n\n")
    
    f.write('\n\n'.join(sql_blocks))

# Write CSV file
with open('kesin_video_analiz_raporu_mng.csv', 'w', encoding='utf-8-sig', newline='') as f:
    writer = csv.writer(f, delimiter=';')
    writer.writerow(csv_header)
    writer.writerows(csv_rows)

print("\nProcessing completed successfully!")
print(f"Matched Courses: {len(matched_courses_set)}")
print(f"Total Video Records: {len(matched_records)}")
print(f"Unmatched Muro Courses: {len(set(muro_courses.keys()) - matched_courses_set)}")
