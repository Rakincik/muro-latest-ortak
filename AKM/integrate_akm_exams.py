import json
import os
import re
import uuid
import urllib.request
import argparse
import difflib
from datetime import datetime

# Türkçe karakter dönüştürme tablosu
TR_MAP = str.maketrans("ığüşöçİĞÜŞÖÇ", "igusocIGUSOC")

def clean_name(name):
    if not name:
        return ""
    name = name.translate(TR_MAP).lower().strip()
    # "deneme", "sinavi", "sorulari" gibi ortak kelimeleri temizleyelim
    name = re.sub(r'\b(deneme|sinavi|sorulari|testi|kampi|öabt|ags|tde)\b', '', name)
    name = re.sub(r'[^a-z0-9\s]', '', name)
    return " ".join(name.split())

def calculate_similarity(s1, s2):
    return difflib.SequenceMatcher(None, clean_name(s1), clean_name(s2)).ratio()

def guess_exam_type(name):
    name_upper = name.upper()
    if "ÖABT" in name_upper or "OABT" in name_upper:
        return "OABT"
    elif "AGS" in name_upper:
        return "KPSS_GY"
    elif "EĞİTİM" in name_upper or "EGITIM" in name_upper:
        return "KPSS_EB"
    elif "GY" in name_upper or "GK" in name_upper:
        return "KPSS_GK"
    return "Deneme"

def main():
    parser = argparse.ArgumentParser(description="AKM Okinar Exams and Answer Keys Integrator to MURO LMS")
    parser.add_argument("--exams", default="akm_exams_with_answers.json", help="Scraped exams JSON file")
    parser.add_argument("--pdfs", default="akm_library_pdfs.json", help="Scraped library PDFs JSON file")
    parser.add_argument("--cookie", required=True, help="Okinar session cookie (ci_session=...)")
    parser.add_argument("--dry-run", action="store_true", help="Run without database insert and download")
    args = parser.parse_args()

    # Load JSON files
    if not os.path.exists(args.exams):
        print(f"[HATA] Sınav dosyası bulunamadı: {args.exams}")
        return
    if not os.path.exists(args.pdfs):
        print(f"[HATA] PDF listesi dosyası bulunamadı: {args.pdfs}")
        return

    with open(args.exams, 'r', encoding='utf-8') as f:
        exams_data = json.load(f)
    with open(args.pdfs, 'r', encoding='utf-8') as f:
        pdfs_data = json.load(f)

    print(f"Loaded {len(exams_data)} exams from {args.exams}")
    print(f"Loaded {len(pdfs_data)} PDFs from {args.pdfs}")

    # DB Connection Setup
    import psycopg2
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_akm_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    print(f"[*] Connecting to database on host: {db_host}")
    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Create downloads directory
    os.makedirs("downloads/exams", exist_ok=True)

    print("\n--- EŞLEŞTİRME VE AKTARIM BAŞLATILIYOR ---")
    
    total_inserted = 0
    total_skipped = 0

    for exam in exams_data:
        exam_name = exam["examName"]
        question_count = exam["questionCount"]
        answer_key = exam["answerKey"]
        
        # Check if already exists in DB
        cur.execute('SELECT "Id" FROM "Exams" WHERE "Title" = %s AND "IsDeleted" = False;', (exam_name,))
        if cur.fetchone():
            print(f"[-] Atlanıyor (Zaten veritabanında mevcut): '{exam_name}'")
            total_skipped += 1
            continue

        # Find best PDF match
        best_pdf = None
        best_score = 0.0
        for pdf in pdfs_data:
            score = calculate_similarity(exam_name, pdf["title"])
            if score > best_score:
                best_score = score
                best_pdf = pdf

        # Match PDF if similarity is high enough (>0.60 due to generic exam titles vs file titles)
        matched_pdf_url = None
        pdf_filename = None
        if best_score >= 0.60:
            matched_pdf_url = best_pdf["downloadUrl"]
            print(f"\n[EŞLEŞTİ] Sınav: '{exam_name}' -> PDF: '{best_pdf['title']}' (Benzerlik: %{best_score*100:.1f})")
        else:
            print(f"\n[UYARI] Sınav: '{exam_name}' için eşleşen PDF bulunamadı! (En yüksek benzerlik: %{best_score*100:.1f} -> {best_pdf['title'] if best_pdf else 'Yok'})")

        exam_uuid = str(uuid.uuid4())
        pdf_db_path = None

        if matched_pdf_url:
            pdf_filename = f"{exam_uuid}.pdf"
            local_pdf_path = os.path.join("downloads/exams", pdf_filename)
            pdf_db_path = f"/uploads/exams/{pdf_filename}"

            if not args.dry_run:
                print(f"   [INDIRILTIYOR] URL: {matched_pdf_url} ...")
                try:
                    req = urllib.request.Request(
                        matched_pdf_url,
                        headers={
                            'Cookie': args.cookie,
                            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
                        }
                    )
                    with urllib.request.urlopen(req, timeout=15) as response:
                        with open(local_pdf_path, 'wb') as out_file:
                            out_file.write(response.read())
                    print(f"   [OK] Başarıyla indirildi: {local_pdf_path}")
                except Exception as e:
                    print(f"   [HATA] PDF indirilemedi: {e}")
                    pdf_db_path = None

        # Insert to DB
        exam_type = guess_exam_type(exam_name)
        answer_key_json = json.dumps(answer_key)
        created_at = datetime.utcnow()

        if args.dry_run:
            print(f"   [DRY-RUN] DB Kaydı -> UUID: {exam_uuid} | Tip: {exam_type} | Soru: {question_count} | PDF: {pdf_db_path}")
            total_inserted += 1
        else:
            try:
                cur.execute('''
                    INSERT INTO "Exams" (
                        "Id", "Title", "Description", "IsDeleted", "ExamType", 
                        "QuestionCount", "OptionCount", "WrongPenaltyWeight", "MaxScore", "BaseScore", 
                        "VirtualParticipantCount", "PdfUrl", "AnswerKeyJson", "Status", 
                        "ShowResults", "ResultMode", "CreatedAt"
                    ) VALUES (
                        %s, %s, %s, %s, %s, 
                        %s, %s, %s, %s, %s, 
                        %s, %s, %s, %s, 
                        %s, %s, %s
                    );
                ''', (
                    exam_uuid, exam_name, exam.get("description", ""), False, exam_type,
                    question_count, 5, 0.25, 100.0, 0.0,
                    0, pdf_db_path, answer_key_json, 'Yayında',
                    True, 'immediate', created_at
                ))
                conn.commit()
                print(f"   [OK] Veritabanına başarıyla eklendi!")
                total_inserted += 1
            except Exception as e:
                conn.rollback()
                print(f"   [HATA] Veritabanına eklenemedi: {e}")

    cur.close()
    conn.close()

    print("\n" + "="*50)
    print("AKM SINAV ENTEGRASYON RAPORU:")
    print(f" - Eklenen/Eşleşen Sınav Sayısı: {total_inserted}")
    print(f" - Atlanan (Zaten Var Olan) Sınav Sayısı: {total_skipped}")
    print("="*50)

    if not args.dry_run and total_inserted > 0:
        print("\n[BILGI] ÖNEMLİ SONRAKİ ADIMLAR:")
        print("1. İndirilen sınav PDF'lerini container içine kopyalayın:")
        print("   docker exec -it muro_akm_api mkdir -p /app/wwwroot/uploads/exams")
        print("   docker cp downloads/exams/. muro_akm_api:/app/wwwroot/uploads/exams/")

if __name__ == '__main__':
    main()
