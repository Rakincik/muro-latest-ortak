import json
import os
import difflib

screenshot_courses = [
    "REHBERLİK 4",
    "REHBERLİK 3",
    "REHBERLİK 2",
    "MUHASEBE HIZLI KONU - YOĞUN SORU",
    "Muhasebe Ders Taraması ve Soru Çözümü 2026",
    "MEDENİ HUKUK DEMO",
    "MALİYE HIZLI KONU - YOĞUN SORU",
    "Maliye Ders Taraması ve Soru Çözümü 2026",
    "KAYMAKAMILIK İKTİSAT HIZLI KONU YOĞUN SORU KAMPI",
    "KAYMAKAMILIK HIZLI KONU YOĞUN SORU KAMPI 2025",
    "İKTİSAT HIZLI KONU - YOĞUN SORU",
    "HUKUK HIZLI KONU - YOĞUN SORU",
    "GY-GK DEMO"
]

json_path = 'okinar dersler/4tuzem.okinar.com_recordings.json'

with open(json_path, 'r', encoding='utf-8') as f:
    recordings = json.load(f)

# Normalize functions
TR_MAP = str.maketrans("ığüşöçİĞÜŞÖÇ", "igusocIGUSOC")
def clean(name):
    if not name: return ""
    return name.translate(TR_MAP).lower().strip()

# Unique clean names from Okinar
okinar_classes = sorted(list({r.get('className', '').strip() for r in recordings if r.get('className')}))

print("Matching local screenshot courses with Okinar class names:")
for sc in screenshot_courses:
    sc_clean = clean(sc)
    matches = []
    for oc in okinar_classes:
        oc_clean = clean(oc)
        # Check if identical or substring or fuzzy match
        if sc_clean in oc_clean or oc_clean in sc_clean:
            matches.append((oc, 1.0))
        else:
            sim = difflib.SequenceMatcher(None, sc_clean, oc_clean).ratio()
            if sim > 0.6:
                matches.append((oc, sim))
    
    matches.sort(key=lambda x: x[1], reverse=True)
    if matches:
        print(f"\nTarget: {sc}")
        for oc, score in matches[:5]:
            # Count recordings for this oc
            rec_cnt = sum(1 for r in recordings if r.get('className', '').strip() == oc)
            print(f"  -> Match: {oc} (Score: {score:.2f}, Recordings: {rec_cnt})")
    else:
        print(f"\nTarget: {sc} -> NO MATCH FOUND")
