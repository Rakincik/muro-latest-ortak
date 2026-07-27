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

# We want to match all rows in the CSV against the 127 Muro courses
matched_courses = set()
matched_records_count = 0

with open(csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    reader = csv.reader(f, delimiter=';')
    header = next(reader)
    for row in reader:
        if len(row) < 10:
            continue
        
        excel_course_name = row[4].strip() if row[4] else ""
        if not excel_course_name:
            continue
            
        norm_ec = normalize(excel_course_name)
        for mc, mc_id in muro_courses.items():
            if normalize(mc) == norm_ec or norm_ec in normalize(mc) or normalize(mc) in norm_ec:
                matched_courses.add(mc)
                matched_records_count += 1
                break

print(f"Total Muro Courses: {len(muro_courses)}")
print(f"Matched Courses: {len(matched_courses)}")
print(f"Total Mapped Video Records: {matched_records_count}")
print("\nMatched Courses List:")
for c in sorted(matched_courses):
    print("-", c)
