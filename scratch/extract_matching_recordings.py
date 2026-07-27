import json
import os
import difflib
from datetime import datetime

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

okinar_classes = sorted(list({r.get('className', '').strip() for r in recordings if r.get('className')}))

report = {}

for sc in screenshot_courses:
    sc_clean = clean(sc)
    best_match = None
    best_score = 0.0
    
    # We find the best matching class name in Okinar
    for oc in okinar_classes:
        oc_clean = clean(oc)
        if sc_clean == oc_clean:
            best_match = oc
            best_score = 1.0
            break
        elif sc_clean in oc_clean or oc_clean in sc_clean:
            # Substring match
            score = 0.9
            if score > best_score:
                best_match = oc
                best_score = score
        else:
            score = difflib.SequenceMatcher(None, sc_clean, oc_clean).ratio()
            if score > 0.6 and score > best_score:
                best_match = oc
                best_score = score
                
    if best_match:
        # Get all recordings of this class
        recs = [r for r in recordings if r.get('className', '').strip() == best_match]
        report[sc] = {
            'okinar_class': best_match,
            'match_score': best_score,
            'recordings_count': len(recs),
            'recordings': []
        }
        for r in recs:
            report[sc]['recordings'].append({
                'name': r.get('recordingName', 'Ders'),
                'record_id': r.get('recordID', ''),
                'start_time': r.get('startTime', ''),
                'duration': r.get('duration', '0')
            })
    else:
        report[sc] = {
            'okinar_class': 'Eşleşme Bulunamadı',
            'match_score': 0.0,
            'recordings_count': 0,
            'recordings': []
        }

# Print report in a neat format
print(json.dumps(report, indent=2, ensure_ascii=False))

# Also write to a markdown file
with open('c:/Users/Rüstem/.gemini/antigravity-ide/brain/69bcc576-d196-44a5-ad5b-87c4d095e9e4/okinar_courses_report.md', 'w', encoding='utf-8') as f:
    f.write("# Okinar Oturumsuz Dersler Analiz Raporu\n\n")
    f.write("Aşağıdaki tabloda, yerel panelinizde 0 oturuma (oturumsuz) sahip olan derslerin Okinar üzerindeki durumları listelenmiştir:\n\n")
    f.write("| Yerel Ders Adı | Okinar Ders Adı | Durum | Okinar Kayıt Sayısı | Açıklama |\n")
    f.write("| :--- | :--- | :--- | :--- | :--- |\n")
    for sc, data in report.items():
        ok_class = data['okinar_class']
        cnt = data['recordings_count']
        status = "🟢 DOLU (Okinar'da Var)" if cnt > 0 else "🔴 BOŞ (Okinar'da Yok)"
        desc = ""
        if cnt > 0:
            desc = f"İlk kayıt tarihi: {data['recordings'][0]['start_time']}"
        f.write(f"| **{sc}** | {ok_class} | {status} | **{cnt}** | {desc} |\n")
        
    f.write("\n## Eşleşen Kayıt Detayları\n\n")
    for sc, data in report.items():
        if data['recordings_count'] > 0:
            f.write(f"### {sc} ({data['okinar_class']})\n")
            f.write(f"Toplam kayıt: **{data['recordings_count']}**\n\n")
            f.write("| Kayıt Adı | Başlangıç Zamanı | Süre (Dk) | Kayıt ID |\n")
            f.write("| :--- | :--- | :--- | :--- |\n")
            for r in data['recordings']:
                f.write(f"| {r['name']} | {r['start_time']} | {r['duration']} | `{r['record_id']}` |\n")
            f.write("\n")
            
print("Saved report to artifact!")
