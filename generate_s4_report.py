import csv
import re
import openpyxl

# Load Muro courses
muro_courses = {}
with open('muro_mng_courses.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if '|' in line:
            cid, title = line.split('|', 1)
            muro_courses[title.strip()] = cid.strip()

# Load s7 matched courses
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

matched_muro_s7 = set()
for ec in s7_excel_courses:
    norm_ec = normalize(ec)
    for mc, mc_id in muro_courses.items():
        if normalize(mc) == norm_ec or norm_ec in normalize(mc) or normalize(mc) in norm_ec:
            matched_muro_s7.add(mc)
            break

unmatched_muro = set(muro_courses.keys()) - matched_muro_s7

# Load s4 records
s4_records = []
s4_csv_path = 'mng/s4_videolar_listesi_analiz.csv'
with open(s4_csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader)
    for row in reader:
        if len(row) >= 2:
            s4_records.append((row[0].strip(), row[1].strip()))

# Match unmatched with s4
matched_muro_s4 = {}
for mc in unmatched_muro:
    norm_mc = normalize(mc)
    mc_years = {w for w in norm_mc.split() if w.isdigit() and len(w) == 4}
    
    best_s4_title = None
    best_score = 0
    
    for folder_id, s4_title in s4_records:
        norm_s4 = normalize(s4_title)
        s4_years = {w for w in norm_s4.split() if w.isdigit() and len(w) == 4}
        
        if mc_years and s4_years and mc_years != s4_years:
            continue
            
        mc_words = set(norm_mc.split())
        s4_words = set(norm_s4.split())
        stop_words = {'ve', 'ile', 'konu', 'anlatimi', 'soru', 'cozumu', 'kamp', 'kampi', 'ders', 'dersi', 'videolari', 'video'}
        mc_char = mc_words - stop_words
        s4_char = s4_words - stop_words
        
        intersection = mc_char.intersection(s4_char)
        score = len(intersection)
        if score > best_score:
            if score >= 2 or (score >= 1 and len(mc_char) <= 2):
                best_score = score
                best_s4_title = s4_title
                
    if best_s4_title:
        matched_muro_s4[mc] = best_s4_title

final_unmatched = unmatched_muro - set(matched_muro_s4.keys())

report_path = 'C:/Users/Rüstem/.gemini/antigravity-ide/brain/cfe5ed74-7284-4938-939e-107335b0fb17/mng_s4_matching_report.md'

with open(report_path, 'w', encoding='utf-8') as f:
    f.write("# Derece Uzem (mng) - s4 Sunucu Eşleşme Analiz Raporu\n\n")
    f.write(f"Muro'da `s7` ile eşleşmeyen **{len(unmatched_muro)}** dersin **{len(matched_muro_s4)}** tanesi `s4` sunucusundaki kayıtlarla başarıyla eşleşti!\n\n")
    
    f.write(f"## `s4` Sunucusu İle Eşleşen Dersler ({len(matched_muro_s4)})\n")
    f.write("| Muro Ders Adı | s4 Sunucusu Örnek Kayıt Adı | Ders ID (CourseId) |\n")
    f.write("|---|---|---|\n")
    for mc, s4_t in sorted(matched_muro_s4.items()):
        f.write(f"| {mc} | {s4_t} | `{muro_courses[mc]}` |\n")
        
    f.write(f"\n## Hala Eşleşmeyen Dersler ({len(final_unmatched)})\n")
    f.write("Bu derslerin ne `s7` ne de `s4` sunucularında video kayıtları bulunamamıştır (muhtemelen s5/s6 üzerindedir):\n\n")
    for umc in sorted(final_unmatched):
        f.write(f"- {umc} (`{muro_courses[umc]}`)\n")

print("Report generated successfully.")
