import json

akm_isim_path = "c:\\Users\\Rüstem\\.gemini\\antigravity\\scratch\\muro-demo\\AKM\\akm_isim_eslestirme.json"
akm_guncel_path = "c:\\Users\\Rüstem\\.gemini\\antigravity\\scratch\\muro-demo\\AKM\\akm_guncel_kayitlar.json"

with open(akm_isim_path, "r", encoding="utf-8") as f:
    isim_data = json.load(f)

with open(akm_guncel_path, "r", encoding="utf-8") as f:
    guncel_data = json.load(f)

# Find all Yelda courses
yelda_isim = [item for item in isim_data if "yelda" in item.get("courseName", "").lower()]
print(f"Yelda courses in excel mapping: {len(yelda_isim)}")

link_to_name = {item.get("classroomLink"): item.get("courseName").strip() for item in isim_data if item.get("classroomLink") and item.get("courseName")}

yelda_guncel = []
for item in guncel_data:
    link = item.get("classroomLink")
    real_name = link_to_name.get(link, "")
    if "yelda" in real_name.lower():
        yelda_guncel.append({
            "name": real_name,
            "vcount": item.get("videoCount"),
            "recs": len(item.get("recordings", []))
        })

print(f"Yelda courses in Okinar JSON: {len(yelda_guncel)}")
for yg in yelda_guncel:
    print(f"  - {yg['name']}: {yg['vcount']} videos, {yg['recs']} recs extracted")

# 2024 courses
c2024_isim = [item for item in isim_data if "2024" in item.get("courseName", "").lower()]
print(f"\n2024 courses in excel mapping: {len(c2024_isim)}")

c2024_guncel = []
for item in guncel_data:
    link = item.get("classroomLink")
    real_name = link_to_name.get(link, "")
    if "2024" in real_name.lower():
        c2024_guncel.append({
            "name": real_name,
            "vcount": item.get("videoCount"),
            "recs": len(item.get("recordings", []))
        })

print(f"2024 courses in Okinar JSON: {len(c2024_guncel)}")
for cg in c2024_guncel:
    print(f"  - {cg['name']}: {cg['vcount']} videos, {cg['recs']} recs extracted")
