import json
import glob
import re

search_terms = ["hukuk", "yogun", "yoğun", "soru", "cozumu", "çözümü"]

print("=" * 70)
print("      HUKUK YOĞUN SORU ÇÖZÜMÜ 2026 - DERS VE ID ARAMA SERVİSİ")
print("=" * 70)

# 1. Search JSON files
json_files = glob.glob("**/*.json", recursive=True)

found_courses = []
found_recordings = []

for jf in json_files:
    try:
        with open(jf, "r", encoding="utf-8") as f:
            data = json.load(f)
            
            def scan(obj, path=""):
                if isinstance(obj, dict):
                    name = str(obj.get("name") or obj.get("title") or obj.get("recordingName") or obj.get("courseName") or "")
                    name_lower = name.lower()
                    if ("hukuk" in name_lower or "yogun" in name_lower or "yoğun" in name_lower) and ("2026" in name_lower or "soru" in name_lower or "kamp" in name_lower):
                        found_courses.append({
                            "source": jf,
                            "name": name,
                            "obj": obj
                        })
                    for k, v in obj.items():
                        scan(v, f"{path}.{k}")
                elif isinstance(obj, list):
                    for idx, elem in enumerate(obj):
                        scan(elem, f"{path}[{idx}]")

            scan(data)
    except Exception:
        pass

print(f"\n[JSON Taraması] Bulunan eşleşmeler: {len(found_courses)}")
for c in found_courses[:20]:
    print(f"Kaynak: {c['source']}")
    print(f"  Ad: {c['name']}")
    o = c['obj']
    rec_id = o.get("recordID") or o.get("id") or o.get("meetingID") or o.get("uid") or o.get("courseId")
    if rec_id:
        print(f"  ID/RecordID: {rec_id}")
    print("-" * 50)

# 2. Search TXT/SQL files
text_files = glob.glob("**/*.txt", recursive=True) + glob.glob("**/*.sql", recursive=True) + glob.glob("**/*.md", recursive=True)

print("\n[Metin/SQL Taraması Başlıyor...]")
for tf in text_files:
    try:
        with open(tf, "r", encoding="utf-8", errors="ignore") as f:
            for line_no, line in enumerate(f, 1):
                line_lower = line.lower()
                if "hukuk" in line_lower and ("yogun" in line_lower or "yoğun" in line_lower or "soru" in line_lower or "2026" in line_lower):
                    if len(line.strip()) < 300:
                        print(f"[{tf}:L{line_no}] {line.strip()}")
    except Exception:
        pass
