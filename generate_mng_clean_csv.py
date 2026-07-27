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

def normalize_words(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    words = [w for w in text.split() if len(w) > 1 or w.isdigit()]
    return set(words)

# Custom matching function
def find_best_course_id(excel_course):
    excel_words = normalize_words(excel_course)
    if not excel_words:
        return None, None
        
    excel_years = {w for w in excel_words if w.isdigit() and len(w) == 4}
    
    best_mc = None
    best_score = 0
    
    for mc, mc_id in muro_courses.items():
        mc_words = normalize_words(mc)
        mc_years = {w for w in mc_words if w.isdigit() and len(w) == 4}
        
        # Years must match if specified
        if excel_years and mc_years and excel_years != mc_years:
            continue
            
        # Ignore common non-characteristic words for intersection count
        stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'soru', 'cozumu', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video'}
        excel_char_words = excel_words - stop_words
        mc_char_words = mc_words - stop_words
        
        intersection = excel_char_words.intersection(mc_char_words)
        score = len(intersection)
        
        if score > best_score:
            best_score = score
            best_mc = mc
            
    # We require at least 2 characteristic words matching (or 1 if it's very short)
    if best_score >= 2 or (best_score >= 1 and len(normalize_words(excel_course)) <= 3):
        return muro_courses[best_mc], best_mc
        
    return None, None

master_csv_path = 'C:/Users/Rüstem/Desktop/okideolar/video-kurum listesi DereceUzem.csv'
output_csv_path = 'kesin_video_analiz_raporu_mng.csv'
output_sql_path = 'mng_sessions_insert.sql'

results_csv_rows = []
sql_statements = []

mapped_records = 0
skipped_records = 0
course_matches_count = {}

with open(master_csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    # Read with semicolon delimiter
    reader = csv.reader(f, delimiter=';')
    header = next(reader)
    
    for idx, row in enumerate(reader, 1):
        if len(row) < 10:
            continue
            
        excel_course_name = row[4].strip() if row[4] else ""
        if not excel_course_name:
            continue
            
        course_id, matched_muro_title = find_best_course_id(excel_course_name)
        
        if course_id:
            # We map it to Dereceuzem for ot.py
            new_row = list(row)
            new_row[1] = 'Dereceuzem'  # Kurum (LMS)
            new_row[2] = 'Dereceuzem'  # Kurum (Tahmin)
            results_csv_rows.append(new_row)
            mapped_records += 1
            
            # Generate SQL insert
            bbb_room_name = row[3].strip() if row[3] else "Canlı Ders Kaydı"
            date_val = row[5].strip() if row[5] else ""
            folder_id = row[8].strip() if row[8] else ""
            
            # Format date: '30.03.2026 20:41' -> '2026-03-30 20:41:00'
            date_str = "NOW()"
            if date_val:
                try:
                    # Try parsing DD.MM.YYYY HH:MM
                    dt = re.findall(r'(\d+)\.(\d+)\.(\d+)\s+(\d+):(\d+)', date_val)
                    if dt:
                        d, m, y, h, mn = dt[0]
                        date_str = f"'{y}-{m.zfill(2)}-{d.zfill(2)} {h.zfill(2)}:{mn.zfill(2)}:00'"
                except Exception as e:
                    pass
            
            clean_room_title = bbb_room_name.replace("'", "''")
            video_url = f"https://canli.mng.muro.click/playback/presentation/2.3/{folder_id}"
            
            sql = f"""DO $$ 
DECLARE
    sid uuid;
BEGIN
    sid := gen_random_uuid();
    IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = '{course_id}' AND "BbbMeetingId" = '{folder_id}') THEN
        INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "VideoUrl", "ScheduledStart", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
        VALUES (sid, '{course_id}', '{clean_room_title}', '{folder_id}', '{video_url}', {date_str}, false, NOW(), 3, 0, true, false);
        
        INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt")
        VALUES (gen_random_uuid(), '{course_id}', sid, -1, NOW());
    END IF;
END $$;"""
            sql_statements.append(sql)
            course_matches_count[matched_muro_title] = course_matches_count.get(matched_muro_title, 0) + 1
        else:
            skipped_records += 1

# Write CSV
with open(output_csv_path, 'w', encoding='utf-8-sig', newline='') as f:
    writer = csv.writer(f, delimiter=';')
    writer.writerow(header)
    writer.writerows(results_csv_rows)

# Write SQL
with open(output_sql_path, 'w', encoding='utf-8') as f:
    f.write("-- ==================================================\n")
    f.write("-- DERECE UZEM (mng) - FULL PARITY SESSIONS IMPORT\n")
    f.write(f"-- Total Sessions: {len(sql_statements)}\n")
    f.write("-- ==================================================\n\n")
    f.write('\n\n'.join(sql_statements))

print(f"Total rows scanned in master CSV: {idx}")
print(f"Successfully mapped: {mapped_records} records.")
print(f"Skipped (not belonging to MNG): {skipped_records} records.")
print(f"Mapped Muro courses count: {len(course_matches_count)}")
print(f"Generated CSV '{output_csv_path}' and SQL '{output_sql_path}'.")
