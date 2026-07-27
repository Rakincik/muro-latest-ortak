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

# Find unmatched courses from s7
# First read dereceuzem s7.xlsx unique courses
import openpyxl
wb = openpyxl.load_workbook('mng/dereceuzem s7.xlsx')
sheet = wb.active
s7_excel_courses = set()
for row in list(sheet.iter_rows(values_only=True))[1:]:
    if len(row) > 4 and row[1] == 'Dereceuzem' and row[4]:
        s7_excel_courses.add(row[4].strip())

def normalize(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    return ' '.join(text.split())

# Matched from s7
matched_muro_s7 = set()
for ec in s7_excel_courses:
    norm_ec = normalize(ec)
    for mc, mc_id in muro_courses.items():
        if normalize(mc) == norm_ec or norm_ec in normalize(mc) or normalize(mc) in norm_ec:
            matched_muro_s7.add(mc)
            break

# Unmatched from s7
unmatched_muro = set(muro_courses.keys()) - matched_muro_s7

print(f"Total Muro Courses: {len(muro_courses)}")
print(f"Matched from s7: {len(matched_muro_s7)}")
print(f"Remaining unmatched: {len(unmatched_muro)}")

# Now load s4_videolar_listesi_analiz.csv
s4_records = []
s4_csv_path = 'mng/s4_videolar_listesi_analiz.csv'
with open(s4_csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader)
    for row in reader:
        if len(row) >= 2:
            s4_records.append((row[0].strip(), row[1].strip()))

print(f"\nLoaded {len(s4_records)} records from s4_videolar_listesi_analiz.csv.")

# Match remaining unmatched Muro courses with s4 records
matches_s4 = []
matched_muro_s4_set = set()

for mc in unmatched_muro:
    norm_mc = normalize(mc)
    # Exclude year/numbers if they mismatch
    mc_years = {w for w in norm_mc.split() if w.isdigit() and len(w) == 4}
    
    for folder_id, s4_title in s4_records:
        norm_s4 = normalize(s4_title)
        s4_years = {w for w in norm_s4.split() if w.isdigit() and len(w) == 4}
        
        if mc_years and s4_years and mc_years != s4_years:
            continue
            
        # Check if the words are highly intersecting
        mc_words = set(norm_mc.split())
        s4_words = set(norm_s4.split())
        stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'soru', 'cozumu', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video'}
        mc_char = mc_words - stop_words
        s4_char = s4_words - stop_words
        
        intersection = mc_char.intersection(s4_char)
        if len(intersection) >= 2 or (len(intersection) >= 1 and len(mc_char) <= 2):
            matches_s4.append((mc, s4_title, folder_id))
            matched_muro_s4_set.add(mc)

print(f"\nMatched from s4: {len(matched_muro_s4_set)} Muro courses!")
print("\nSample matches from s4:")
for mc, s4_title, folder_id in matches_s4[:20]:
    print(f"- Muro: \"{mc}\"  ==>  s4: \"{s4_title}\" (Folder: {folder_id})")
