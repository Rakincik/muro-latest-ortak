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

def normalize(text):
    text = text.lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    return ' '.join(text.split())

csv_path = 'C:/Users/Rüstem/Desktop/okideolar/video-kurum listesi DereceUzem.csv'

# Parse unique excel courses
excel_courses = set()
with open(csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader)
    for row in reader:
        if len(row) > 4 and row[4]:
            excel_courses.add(row[4].strip())

matched_muro = set()
for mc, mc_id in muro_courses.items():
    norm_mc = normalize(mc)
    for ec in excel_courses:
        norm_ec = normalize(ec)
        if norm_mc == norm_ec or norm_ec in norm_mc or norm_mc in norm_ec:
            matched_muro.add(mc)
            break

unmatched_muro = set(muro_courses.keys()) - matched_muro

print(f"Total Muro Courses: {len(muro_courses)}")
print(f"Unmatched Muro Courses ({len(unmatched_muro)}):")
for c in sorted(unmatched_muro):
    print("-", c)
