import openpyxl
import re

# Load Muro courses
muro_courses = {}
with open('muro_mng_courses.txt', 'r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if '|' in line:
            cid, title = line.split('|', 1)
            muro_courses[title.strip()] = cid.strip()

def normalize(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    return ' '.join(text.split())

# Read Excel unique course names
wb = openpyxl.load_workbook('dereceuzem s7.xlsx')
sheet = wb.active
excel_courses = set()
for row in list(sheet.iter_rows(values_only=True))[1:]:
    if len(row) > 4 and row[1] == 'Dereceuzem' and row[4]:
        excel_courses.add(row[4].strip())

# Matching
matched_muro = {}
for ec in sorted(excel_courses):
    norm_ec = normalize(ec)
    for mc, mc_id in muro_courses.items():
        if normalize(mc) == norm_ec or norm_ec in normalize(mc) or normalize(mc) in norm_ec:
            matched_muro[mc] = ec
            break

unmatched_muro = set(muro_courses.keys()) - set(matched_muro.keys())

report_path = 'C:/Users/Rüstem/.gemini/antigravity-ide/brain/cfe5ed74-7284-4938-939e-107335b0fb17/mng_course_mapping_report.md'

with open(report_path, 'w', encoding='utf-8') as f:
    f.write("# Derece Uzem (mng) - s7 Kurs Eşleşme Raporu\n\n")
    f.write(f"Bu rapor, Muro sistemindeki **{len(muro_courses)}** dersin hangilerinin `s7` sunucu kayıtları ile eşleştiğini gösterir.\n\n")
    
    f.write(f"## Eşleşen Dersler ({len(matched_muro)})\n")
    f.write("Bu derslerin `s7` sunucusunda kayıtları bulunmuştur ve SQL aktarım dosyasında yer almaktadır:\n\n")
    f.write("| Muro Ders Adı | Excel (Okinar) Ders Adı | Ders ID (CourseId) |\n")
    f.write("|---|---|---|\n")
    for mc, ec in sorted(matched_muro.items()):
        f.write(f"| {mc} | {ec} | `{muro_courses[mc]}` |\n")
        
    f.write(f"\n## Eşleşmeyen Dersler ({len(unmatched_muro)})\n")
    f.write("Bu derslerin `s7` sunucusunda kaydı bulunamamıştır (diğer sunucularda veya henüz kaydı olmayan dersler):\n\n")
    for umc in sorted(unmatched_muro):
        f.write(f"- {umc} (`{muro_courses[umc]}`)\n")

print("Report generated successfully.")
