import os
import json
import csv
import re
import datetime

# Kurum Alan Adı -> Dost Canlısı Kurum Adı Eşleşmesi
DOMAIN_MAP = {
    "turkceoabtdeyiz.okinar.com": "Türkçe ÖABTdeyiz",
    "akademikmasa.okinar.com": "Akademik Masa",
    "dereceuzem.okinar.com": "Dereceuzem",
    "ataniyorumhocam.okinar.com": "Atanıyorum Hocam",
    "omurhoca.okinar.com": "Ömür Hoca",
    "dershaneonline.okinar.com": "Dershane Online",
    "4tuzem.okinar.com": "4T Uzem"
}

# Gelişmiş Kurum Belirleme Kuralları (Düzenli İfadelerle Arama)
ADVANCED_RULES = [
    # 1. Türkçe ÖABTdeyiz (Edebiyat, Eski Dil, Mazmun vb.)
    (r'(eski dil|eski edebiyat|halk edebiyat|yte|mazmun|nazim|4 temel beceri|turkce oabt|alan egitimi|edebiyati)', "Türkçe ÖABTdeyiz"),
    # 2. Atanıyorum Hocam (KPSS Eğitim Bilimleri ve GYGK Tarih/Coğrafya)
    (r'(egitim bilim|egitimin temelleri|vatandaslik|anayasa|kpss|gygk|ogrenme psikoloji|gelisim psikoloji|oyt|rehberlik ozel|inkilap|osmanli tarihi|tarih konu|cografya konu|tarih soru|cografya soru|halk egitim)', "Atanıyorum Hocam"),
    # 3. Dershane Online (YKS Dersleri - Geometri, Fizik, Kimya, Matematik, Biyoloji vb.)
    (r'(ayt|tyt|yks|lgs|geometri|fizik|kimya|biyoloji|felsefe|matematik konu|matematik soru|ayt edebiyat|yks tarih)', "Dershane Online"),
    # 4. 4T Uzem (Ekonomi, Robotik, Sanayi)
    (r'(verimlilik|robotik|uzay|sanayii|muhasebe|maliye|iktisat|hukuk|kamu)', "4T Uzem"),
    # 5. Akademik Masa
    (r'(akademik|masa)', "Akademik Masa"),
    # 6. Dereceuzem
    (r'(derece)', "Dereceuzem"),
    # 7. Ömür Hoca
    (r'(ömür|omur)', "Ömür Hoca")
]

def clean_text(text):
    if not text:
        return ""
    text = text.lower()
    text = text.replace("ı", "i").replace("ğ", "g").replace("ü", "u").replace("ş", "s").replace("ö", "o").replace("ç", "c")
    return re.sub(r'[^a-z0-9\s]', '', text)

def get_institution_by_advanced_rules(meeting_name, keywords=""):
    combined = clean_text(meeting_name) + " " + clean_text(keywords)
    for pattern, inst in ADVANCED_RULES:
        if re.search(pattern, combined):
            return inst
    return None

def load_local_jsons():
    """Çalışma dizinindeki tüm *_recordings.json dosyalarını okur ve ders referans veritabanını oluşturur."""
    master_mappings = {}
    print("\n[LMS Referans Veritabanı] Yukleniyor...")
    
    files = [f for f in os.listdir(".") if f.endswith("_recordings.json")]
    
    if not files:
        print("Uyari: Klasorde *_recordings.json dosyasi bulunamadi. Sadece isim analizi yapilacak.")
        return {}
        
    for file in files:
        domain = file.replace("_recordings.json", "")
        friendly_name = DOMAIN_MAP.get(domain, domain)
        
        try:
            with open(file, "r", encoding="utf-8") as f:
                data = json.load(f)
                
            if not isinstance(data, list):
                continue
                
            print(f"File: {file} yuklendi ({len(data)} kayit)")
            
            for item in data:
                record_id = item.get("recordID")
                if record_id:
                    clean_id = record_id.split("-")[0]
                    
                    master_mappings[clean_id] = {
                        "kurum": friendly_name,
                        "class_name": item.get("className", "Bilinmeyen Ders"),
                        "class_desc": item.get("classDesc", ""),
                        "recording_name": item.get("recordingName", "Ders"),
                        "start_time": item.get("startTime", ""),
                        "duration": item.get("duration", "Bilinmiyor")
                    }
                    
        except Exception as e:
            print(f"Error: {file} okunurken hata: {e}")
            
    print(f"Toplam {len(master_mappings)} video referansi basariyla bellege alindi.\n")
    return master_mappings

def main():
    print("=== MURO LMS & BBB Akilli Eşleştirme Sistemi (Pro Surum) ===")
    
    master_mappings = load_local_jsons()
    
    print("-" * 60)
    server_ip = input("Analiz edilecek Sunucu IP girin (Orn: 185.86.155.222): ").strip()
    metadata_file = f"bbb_metadata_{server_ip}.json"
    
    if not os.path.exists(metadata_file):
        print(f"Error: '{metadata_file}' dosyasi bulunamadi!")
        print("Lutfen once 'python upload_and_scan.py' calistirarak sunucuyu taratin.")
        return
        
    with open(metadata_file, "r", encoding="utf-8") as f:
        bbb_metadata = json.load(f)
        
    print(f"3056 adet sunucu klasor detayi '{metadata_file}' dosyasindan yuklendi.")
    
    output_file = f"kesin_video_analiz_raporu_{server_ip}.csv"
    results = []
    
    matched_by_db = 0
    matched_by_referer = 0
    matched_by_keyword = 0
    unmatched_count = 0
    
    for idx, (folder, meta) in enumerate(bbb_metadata.items(), 1):
        rec_id = folder.split("-")[0]
        
        meeting_name = meta.get("meetingName", "Bilinmeyen Ders")
        slide_kws = meta.get("slideKeywords", "")
        referer_domain = meta.get("refererDomain", "")
        
        duration_sec = meta.get("duration", 0)
        duration_min = round(duration_sec / 60) if duration_sec > 0 else "Bilinmiyor"
        
        start_time_ts = meta.get("startTime", 0)
        start_time_str = ""
        if start_time_ts > 0:
            try:
                if start_time_ts > 9999999999:
                    start_time_ts = start_time_ts / 1000
                start_time_str = datetime.datetime.fromtimestamp(start_time_ts).strftime('%d.%m.%Y %H:%M')
            except:
                pass

        # 1. Aşama: LMS JSON Veritabanı ile eşleştir (ID bazlı kesin eşleşme)
        info = master_mappings.get(rec_id)
        
        if info:
            kurum = info["kurum"]
            class_name = info["class_name"]
            class_desc = info["class_desc"]
            recording_name = info["recording_name"]
            start_time = info["start_time"] if info["start_time"] else start_time_str
            duration = f"{info['duration']} dk" if info["duration"] != "Bilinmiyor" else f"{duration_min} dk"
            matched_by_db += 1
        
        # 2. Aşama: Nginx logs Referer domain kontrolü (Log bazlı kesin eşleşme)
        elif referer_domain and referer_domain in DOMAIN_MAP:
            kurum = DOMAIN_MAP[referer_domain]
            class_name = meeting_name
            class_desc = "Nginx Referer Eslesmesi (Gecmis Donem)"
            recording_name = meeting_name
            start_time = start_time_str
            duration = f"{duration_min} dk" if duration_min != "Bilinmiyor" else "Bilinmiyor"
            matched_by_referer += 1
            
        else:
            # 3. Aşama: Akıllı Kelime Kuralları (NLP bazlı arşiv eşleşmesi)
            kurum_guess = get_institution_by_advanced_rules(meeting_name, slide_kws)
            
            if kurum_guess:
                kurum = kurum_guess
                class_name = meeting_name
                class_desc = "Akilli Kelime Eslesmesi (Arsiv Donemi)"
                recording_name = meeting_name
                start_time = start_time_str
                duration = f"{duration_min} dk" if duration_min != "Bilinmiyor" else "Bilinmiyor"
                matched_by_keyword += 1
            else:
                # Eşleşme yoksa belirsiz bırak
                kurum = "Belirsiz / Bilinmeyen Musteri"
                class_name = meeting_name
                class_desc = "Eslesme Bulunamadi"
                recording_name = meeting_name
                start_time = start_time_str
                duration = f"{duration_min} dk" if duration_min != "Bilinmiyor" else "Bilinmiyor"
                unmatched_count += 1
                
        playback_url = f"https://{server_ip}/playback/presentation/2.3/{folder}"
        
        results.append({
            "No": idx,
            "Kurum": kurum,
            "Ders Kategorisi": class_name,
            "Ders Aciklamasi": class_desc,
            "Ders Konusu": recording_name,
            "Tarih": start_time,
            "Süre": duration,
            "Klasor Adi": folder,
            "Oynatma Linki": playback_url
        })
        
    fieldnames = ["No", "Kurum", "Ders Kategorisi", "Ders Aciklamasi", "Ders Konusu", "Tarih", "Süre", "Klasor Adi", "Oynatma Linki"]
    
    with open(output_file, mode="w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter=";")
        writer.writeheader()
        writer.writerows(results)
        
    total = len(results)
    matched_total = matched_by_db + matched_by_referer + matched_by_keyword
    
    print(f"\n🎉 Tebrikler! Eslesme Raporu Basariyla Olusturuldu: '{output_file}'")
    print(f"ISTATISTIKLER:")
    print(f"   - Toplam Klasor Sayisi: {total}")
    print(f"   - Veritabanı (ID) Eslesmesi: {matched_by_db}")
    print(f"   - Nginx Log Referer Eslesmesi: {matched_by_referer}")
    print(f"   - Akilli Kelime Eslesmesi (Arsivler dahil): {matched_by_keyword}")
    print(f"   - Toplam Eslesen Video: {matched_total} / {total} (Eslesme Orani: %{round(matched_total/total*100, 2)})")
    print(f"   - Belirsiz Kalan: {unmatched_count} video")
    
if __name__ == "__main__":
    main()
