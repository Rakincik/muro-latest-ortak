import json

# Count okinar_grup_hiyerarsi_ve_dersler.json
try:
    with open('okinar_grup_hiyerarsi_ve_dersler.json', 'r', encoding='utf-8') as f:
        groups_data = json.load(f)
except Exception:
    import os
    if os.path.exists('3U/okinar_grup_hiyerarsi_ve_dersler.json'):
        with open('3U/okinar_grup_hiyerarsi_ve_dersler.json', 'r', encoding='utf-8') as f:
            groups_data = json.load(f)
    else:
        groups_data = []

# Count okinar_bireysel_dersler.json
try:
    with open('okinar_bireysel_dersler.json', 'r', encoding='utf-8') as f:
        bireysel_data = json.load(f)
except Exception:
    import os
    if os.path.exists('3U/okinar_bireysel_dersler.json'):
        with open('3U/okinar_bireysel_dersler.json', 'r', encoding='utf-8') as f:
            bireysel_data = json.load(f)
    else:
        bireysel_data = []

unique_group_students = set()
group_count = len(groups_data)
group_courses = set()

for g in groups_data:
    for s in g.get('students', []):
        std_name = s.get('name', '').strip()
        std_phone = s.get('phone', '').strip()
        unique_group_students.add((std_name, std_phone))
    for c in g.get('courses', []):
        group_courses.add(c.get('courseName', '').strip())

unique_bireysel_students = set()
bireysel_courses = set()
for b in bireysel_data:
    std_name = b.get('name', '').strip()
    std_phone = b.get('phone', '').strip()
    unique_bireysel_students.add((std_name, std_phone))
    for c in b.get('courses', []):
        bireysel_courses.add(c.get('courseName', '').strip())

all_unique_students = unique_group_students.union(unique_bireysel_students)

print(f"--- GRUP HİYERARŞİ JSON ({group_count} grup) ---")
print(f"  * Benzersiz Öğrenci Sayısı: {len(unique_group_students)}")
print(f"  * Toplam Atanmış Ders Sayısı: {len(group_courses)}")
print()
print(f"--- BİREYSEL DERSLER JSON ---")
print(f"  * Benzersiz Öğrenci Sayısı: {len(unique_bireysel_students)}")
print(f"  * Toplam Atanmış Ders Sayısı: {len(bireysel_courses)}")
print()
print(f"--- GENEL TOPLAM ---")
print(f"  * İki Dosyadaki Toplam Ortak Benzersiz Öğrenci Sayısı: {len(all_unique_students)}")
