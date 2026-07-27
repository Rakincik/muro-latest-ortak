import csv

csv_path = 'C:/Users/Rüstem/Desktop/okideolar/video-kurum listesi DereceUzem.csv'

excel_courses = set()
with open(csv_path, 'r', encoding='utf-8', errors='ignore') as f:
    reader = csv.reader(f, delimiter=';')
    next(reader)
    for row in reader:
        if len(row) > 4 and row[4]:
            excel_courses.add(row[4].strip())

print(f"Total Unique Courses in CSV: {len(excel_courses)}")
print("CSV courses sample containing 'edebiyat':")
for ec in sorted(excel_courses):
    if 'edebiyat' in ec.lower() or 'türkçe' in ec.lower() or 'dil' in ec.lower():
        print("-", ec)
