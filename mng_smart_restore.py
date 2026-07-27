import csv
import re
import html
import datetime
import json

# 1. Load Muro courses
muro_courses = {}
with open('muro_mng_courses.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if '|' in line:
            cid, title = line.split('|', 1)
            muro_courses[title.strip()] = cid.strip()

# 2. Load allowed record IDs from dereceuzem ONLY (EKYS/ÖABT 2025/2026)
allowed_record_ids = set()
with open('okinar dersler/dereceuzem.okinar.com_recordings.json', 'r', encoding='utf-8') as f:
    for item in json.load(f):
        if 'recordID' in item:
            allowed_record_ids.add(item['recordID'].strip())

print(f"Total allowed MNG record IDs (Dereceuzem json): {len(allowed_record_ids)}")

# 3. Text Normalization and Abbreviations Expansion
def expand_abbr(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    # Abbreviations common in Turkish ÖABT
    text = text.replace('ete', 'eski turk edebiyati')
    text = text.replace('yte', 'yeni turk edebiyati')
    text = text.replace('etd', 'eski turk dili')
    text = text.replace('ytd', 'yeni turk dili')
    return text

def get_words(text):
    text_norm = expand_abbr(text)
    text_clean = re.sub(r'[^a-z0-9\s]', ' ', text_norm)
    return [w for w in text_clean.split() if len(w) > 1 or w.isdigit()]

# Parse Muro courses
muro_parsed = {}
for mc, mc_id in muro_courses.items():
    muro_parsed[mc] = {
        'id': mc_id,
        'words': set(get_words(mc))
    }

# 4. Parse TXT files function with MNG Strict filters
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
                        
    # Filter
    filtered = []
    for r in recordings.values():
        f_id = r['folder_id']
        m_id_lower = r['meeting_id'].lower()
        title_lower = r['meeting_name'].lower() if r['meeting_name'] else ''
        
        is_mng = False
        
        # 1. Dereceuzem JSON
        if f_id in allowed_record_ids:
            is_mng = True
        # 2. YKS
        elif 'tyt' in title_lower or 'ayt' in title_lower or 'yks' in title_lower:
            is_mng = True
        # 3. Overrides
        elif 'fatih-omur' in m_id_lower:
            is_mng = True
        elif 'ea sözel' in title_lower or 'ea sozel' in title_lower or 'dev paragraf' in title_lower:
            is_mng = True
        elif f_id.startswith('7cb3073bedc11616f7b35feb2295f539577f60e5'):
            is_mng = True
            
        if is_mng:
            filtered.append(r)
            
    return filtered

print("Parsing s4_videolar_listesi.txt with MNG STRICT filter...")
s4_recs = parse_txt_file('mng/s4_videolar_listesi.txt', 's4')
print("Parsing s7_videolar.txt with MNG STRICT filter...")
s7_recs = parse_txt_file('mng/s7_videolar.txt', 's7')

print(f"Loaded {len(s4_recs)} unique recordings from s4.")
print(f"Loaded {len(s7_recs)} unique recordings from s7.")

# Combine both
all_recs = s4_recs + s7_recs

matched_records = []
matched_courses_set = set()

# 5. Perform Matching with 5 points tolerance to allow multi-course mapping within MNG
for rec in all_recs:
    title = rec['meeting_name']
    if not title:
        continue
        
    # Date conversion
    date_str = "NOW()"
    if rec['start_time']:
        try:
            ts = int(rec['start_time'])
            dt = datetime.datetime.fromtimestamp(ts / 1000.0)
            date_str = dt.strftime('%Y-%m-%d %H:%M:%S')
        except:
            pass
            
    m_id_lower = rec['meeting_id'].lower()
    m_name_lower = title.lower()
    f_id = rec['folder_id']
    
    # 5.1 Custom Overrides
    override_mapped = False
    if 'fatih-omur' in m_id_lower:
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': 'afc5d1c4-ef09-416a-922b-664ae53a4a6f',
            'course_title': 'Fatih Ömür Soru Çözümü'
        })
        matched_courses_set.add('Fatih Ömür Soru Çözümü')
        override_mapped = True
    elif 'ea sözel' in m_name_lower or 'ea sozel' in m_name_lower or 'dev paragraf' in m_name_lower:
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': '5a6b02df-690f-46af-91ed-f1cd89f8d166',
            'course_title': 'EA Sözel Kampı'
        })
        matched_courses_set.add('EA Sözel Kampı')
        override_mapped = True
    elif f_id.startswith('7cb3073bedc11616f7b35feb2295f539577f60e5'):
        matched_records.append({
            'server': rec['server'],
            'folder_id': f_id,
            'title': title,
            'date': date_str,
            'course_id': '99ffa664-2166-484c-aacd-98d8a49346cd',
            'course_title': 'EKYS Anayasa ve Mevzuatlar Konu Anlatım Videoları'
        })
        matched_courses_set.add('EKYS Anayasa ve Mevzuatlar Konu Anlatım Videoları')
        override_mapped = True
        
    if override_mapped:
        continue
        
    # 5.2 YKS Subject Matching (Strict subject checking to prevent YKS cross-pollination)
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
            'course_title': yks_target
        })
        matched_courses_set.add(yks_target)
        continue
        
    # 5.3 Standard NLP matching for ÖABT/EKYS to allow multi-course mapping
    rec_words = set(get_words(title))
    rec_years = {w for w in rec_words if w.isdigit() and len(w) == 4}
    rec_is_soru = any(w in rec_words for w in ['soru', 'sorular', 'cozumu', 'cozum', 'cozumleri', 'kamp', 'kampi', 'deneme', 'sinavi'])
    rec_is_konu = any(w in rec_words for w in ['konu', 'anlatimi', 'anlatim'])
    
    stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'anlatim', 'soru', 'cozumu', 'cozum', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video', 'sorular', 'cozumleri'}
    rec_char = rec_words - stop_words
    
    # Calculate score for every Muro course
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
            
        scores.append((mc, score, mc_data['id']))
        
    if not scores:
        continue
        
    # Get highest score for this recording
    best_mc, best_score, _ = max(scores, key=lambda x: x[1])
    
    if best_score >= 15:
        # Link recording to all courses that are good matches (tolerance of 5)
        for mc, score, mc_id in scores:
            if (best_score - score) <= 5:
                matched_records.append({
                    'server': rec['server'],
                    'folder_id': rec['folder_id'],
                    'title': title,
                    'date': date_str,
                    'course_id': mc_id,
                    'course_title': mc
                })
                matched_courses_set.add(mc)

# 6. Generate SQL and CSV Outputs
sql_blocks = []
current_block_stmts = []

# Gather all folder IDs to delete first (for clean reset)
all_folder_ids = sorted(list(set(r['folder_id'] for r in all_recs)))
folder_ids_sql_list = ", ".join(f"'{f}'" for f in all_folder_ids)

csv_rows = []
csv_header = ['Sunucu', 'Kurum (LMS)', 'Kurum (Tahmin)', 'Oda Adı (BBB)', 'LMS Ders Adı', 'BBB Gerçek Saat', 'Ders Durumu', 'Fiziksel Dosya Yolu', 'ID', 'Link']

for idx, rec in enumerate(matched_records, 1):
    # 6.1 CSV Row
    csv_rows.append([
        rec['server'],
        'Dereceuzem',
        'Dereceuzem',
        rec['title'],
        rec['course_title'],
        rec['date'],
        'Kopyalanacak',
        f"/var/bigbluebutton/published/presentation/{rec['folder_id']}",
        rec['folder_id'],
        f"https://{rec['server']}.okinar.com/playback/presentation/2.3/{rec['folder_id']}"
    ])
    
    # 6.2 SQL insert
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
    
    # Group every 1000 statements into a single DO $$ block
    if len(current_block_stmts) >= 1000 or idx == len(matched_records):
        sql_block = f"""DO $$ 
DECLARE
    sid uuid;
BEGIN
{chr(10).join(current_block_stmts)}
END $$;"""
        sql_blocks.append(sql_block)
        current_block_stmts = []

# Write SQL
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
    f.write(f"    DELETE FROM \"CourseMedias\" WHERE \"SessionId\" IN (SELECT \"Id\" FROM \"Sessions\" WHERE \"BbbMeetingId\" IN ({folder_ids_sql_list}));\n")
    f.write(f"    DELETE FROM \"Sessions\" WHERE \"BbbMeetingId\" IN ({folder_ids_sql_list});\n")
    f.write("END $$;\n\n")
    
    f.write('\n\n'.join(sql_blocks))

# Write CSV
with open('kesin_video_analiz_raporu_mng.csv', 'w', encoding='utf-8-sig', newline='') as f:
    writer = csv.writer(f, delimiter=';')
    writer.writerow(csv_header)
    writer.writerows(csv_rows)

# 7. Write Markdown Report
unmatched_courses = set(muro_courses.keys()) - matched_courses_set
report_path = 'C:/Users/Rüstem/.gemini/antigravity-ide/brain/cfe5ed74-7284-4938-939e-107335b0fb17/mng_s4_s7_smart_mapping_report.md'

with open(report_path, 'w', encoding='utf-8') as f:
    f.write("# Derece Uzem (mng) - Sunucu Temiz Listeleri Eşleşme Raporu\n\n")
    f.write(f"Bu analiz, Muro'daki **{len(muro_courses)}** dersi kullanıcının sağladığı temiz sunucu listeleri (`s4_videolar_listesi.txt` ve `s7_videolar.txt`) ile akıllı NLP yöntemini kullanarak birleştirmiştir.\n\n")
    f.write(f"- **Eşleşen Muro Ders Sayısı:** {len(matched_courses_set)}\n")
    f.write(f"- **Toplam Eşleşen Video Kaydı (Sessions):** {len(matched_records)}\n")
    f.write(f"- **Hala Eşleşmeyen Ders Sayısı:** {len(unmatched_courses)}\n\n")
    
    f.write("## Eşleşen Derslerin Özeti (Sunucu Dağılımı)\n")
    s4_count = sum(1 for r in matched_records if r['server'] == 's4')
    s7_count = sum(1 for r in matched_records if r['server'] == 's7')
    f.write(f"- **s4 Sunucusundan Gelen Temiz Video Sayısı:** {s4_count}\n")
    f.write(f"- **s7 Sunucusundan Gelen Temiz Video Sayısı:** {s7_count}\n\n")
    
    f.write("## Hala Eşleşmeyen Dersler Listesi\n")
    for umc in sorted(unmatched_courses):
        f.write(f"- {umc} (`{muro_courses[umc]}`)\n")

print(f"\nAnalysis completed successfully!")
print(f"Matched Courses: {len(matched_courses_set)}")
print(f"Total Video Records: {len(matched_records)}")
print(f"Unmatched Courses: {len(unmatched_courses)}")
print(f"Unique matching folders on s4: {len(s4_recs)}")
print(f"Unique matching folders on s7: {len(s7_recs)}")
