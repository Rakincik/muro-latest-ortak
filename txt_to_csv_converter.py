import re
import csv
import html
from collections import defaultdict

def convert_txt_to_csv(txt_filename, csv_filename):
    # Klasör verilerini tutacağımız sözlük yapısı
    # data = { "klasor_id": {"meetingName": "...", "start_time": "..."} }
    data = defaultdict(dict)
    
    # Dosya okuma (encoding'i utf-8 yaparak Türkçe karakterleri kurtarıyoruz)
    with open(txt_filename, 'r', encoding='utf-8') as f:
        for line in f:
            # Satırdaki Klasör ID'sini (ffdb26...-12345) bulmak için Regex
            path_match = re.search(r'/presentation/([^/]+)/metadata.xml', line)
            if not path_match:
                continue
            
            folder_id = path_match.group(1)
            
            # meetingName bilgisini bul
            meeting_name_match = re.search(r'<meetingName>(.*?)</meetingName>', line)
            if meeting_name_match:
                # &amp;#xc7; gibi HTML encode edilmiş karakterleri temizle (Örn: Ç, ö, ü)
                raw_name = meeting_name_match.group(1)
                clean_name = html.unescape(raw_name)
                data[folder_id]['meetingName'] = clean_name
                
            # İsteğe bağlı: Linki veya id'yi vs de kaydedebiliriz ama bize meetingName yetiyor
    
    # CSV dosyasına yazma
    with open(csv_filename, 'w', encoding='utf-8-sig', newline='') as f:
        # Bizim asıl scriptimizin (YENİokinartransfer.py) beklediği sütun başlıkları: "Klasor Adi" ve "Kurum"
        writer = csv.writer(f, delimiter=';')
        writer.writerow(['Klasor Adi', 'Ders Adi', 'Kurum']) # Başlıklar
        
        for folder_id, info in data.items():
            ders_adi = info.get('meetingName', 'Bilinmeyen Ders')
            
            # Burada kurum adını "Ders Adına" göre sen manuel gireceksin
            # Şimdilik "Kurum Girilecek" yazıyoruz.
            kurum_adi = "Kurum Girilecek" 
            
            writer.writerow([folder_id, ders_adi, kurum_adi])

    print(f"[+] Başarılı! {len(data)} adet klasör bulundu ve '{csv_filename}' dosyasına dönüştürüldü.")
    print("-> Lütfen oluşan CSV dosyasını Excel ile açıp 'Kurum' sütununu doldurun.")

if __name__ == "__main__":
    txt_dosyasi = "s7_videolar.txt"   # Senin elindeki txt dosyası
    csv_dosyasi = "kesin_video_analiz_raporu_s7.csv" # Bizim asıl taşıma scriptimizin tanıyacağı dosya formatı
    
    convert_txt_to_csv(txt_dosyasi, csv_dosyasi)
