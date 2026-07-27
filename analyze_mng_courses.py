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

print(f'Muro Courses Count: {len(muro_courses)}')
print(f'Excel Courses Count: {len(excel_courses)}')

# Simple matching
matches = {}
unmatched = []
for ec in sorted(excel_courses):
    norm_ec = normalize(ec)
    matched = False
    for mc, mc_id in muro_courses.items():
        if normalize(mc) == norm_ec or norm_ec in normalize(mc) or normalize(mc) in norm_ec:
            matches[ec] = (mc, mc_id)
            matched = True
            break
    if not matched:
        unmatched.append(ec)

print('\n--- MATCHED COURSES ---')
for ec, (mc, mc_id) in matches.items():
    print(f'Excel: \"{ec}\"  ==>  Muro: \"{mc}\" ({mc_id})')

print('\n--- UNMATCHED COURSES ---')
for ec in unmatched:
    print(f'- \"{ec}\"')
