#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
MURO LMS - Okinar Doküman İndirme ve Entegrasyon Scripti

Bu script, `okinar_material_scraper.js` ile elde edilen `okinar_materials.json` dosyasını okur:
1. Okinar sunucularından dokümanları güvenli bir şekilde indirir.
2. Okinar ders isimleri ile MURO ders isimlerini akıllı eşleştirme (fuzzy matching) ile eşleştirir.
3. Dokümanları MURO uploads dizinine kopyalar.
4. MURO PostgreSQL veritabanındaki "CourseMaterials" tablosuna kayıtları ekler.

Gereksinimler:
  pip install pg8000 requests

Kullanım:
  python download_and_integrate_materials.py --json okinar_materials.json --cookie "PHPSESSID=your_session_id" --dry-run
"""

import os
import sys
import json
import uuid
import re
import argparse
import difflib
import mimetypes
from datetime import datetime
import pg8000

try:
    import requests
    HAS_REQUESTS = True
except ImportError:
    import urllib.request
    import urllib.error
    HAS_REQUESTS = False

# Türkçe karakter dönüştürme tablosu
TR_MAP = str.maketrans("ığüşöçİĞÜŞÖÇ", "igusocIGUSOC")

def clean_name(name):
    """Eşleştirme kolaylığı için metni normalize eder."""
    if not name:
        return ""
    name = name.translate(TR_MAP).lower().strip()
    name = re.sub(r'[^a-z0-9\s]', '', name)
    return " ".join(name.split())

def calculate_similarity(s1, s2):
    """İki metin arasındaki benzerlik oranını (0.0 - 1.0) döndürür."""
    return difflib.SequenceMatcher(None, clean_name(s1), clean_name(s2)).ratio()

def load_env():
    config = {}
    env_paths = [
        ".env.mvz", "../.env.mvz", "../../.env.mvz",
        ".env.3u", "../.env.3u", "../../.env.3u",
        ".env.hll", "../.env.hll", "../../.env.hll",
        ".env.ens", "../.env.ens", "../../.env.ens",
        ".env.omr", "../.env.omr", "../../.env.omr",
        ".env.akm", "../.env.akm", "../../.env.akm",
        ".env", "../.env", "../../.env"
    ]
    for ep in env_paths:
        if os.path.exists(ep):
            try:
                with open(ep, "r", encoding="utf-8") as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith("#") and "=" in line:
                            k, v = line.split("=", 1)
                            config[k.strip()] = v.strip()
                break
            except Exception:
                pass
    return config

def get_db_connection(args):
    """PostgreSQL veritabanı bağlantısı açar, env ve docker IP çözümler."""
    env_config = load_env()
    db_host = args.db_host
    db_port = int(args.db_port)
    db_name = args.db_name
    db_user = args.db_user
    db_password = args.db_password

    # Use env config if command line arguments are at defaults
    if db_host == "31.214.152.143":
        db_host = env_config.get("DB_HOST", db_host)
    if db_port == 5434:
        db_port = int(env_config.get("DB_PORT", db_port))
    if db_name == "muro_prod":
        db_name = env_config.get("DB_NAME", env_config.get("DB_DATABASE", db_name))
    if db_user == "muro_user":
        db_user = env_config.get("DB_USER", env_config.get("DB_USERNAME", db_user))
    if db_password == "MuroDb2026!Pr0d":
        db_password = env_config.get("DB_PASSWORD", db_password)

    # Try resolving local docker IP on the server
    if db_host in ["localhost", "127.0.0.1", "31.214.152.143"]:
        cwd = os.getcwd().lower()
        if '3u' in cwd:
            possible_containers = ['muro_3u_postgres', 'muro_mng_postgres', 'muro_mvz_postgres', 'muro_omr_postgres', 'muro_hll_postgres']
        elif 'mng' in cwd:
            possible_containers = ['muro_mng_postgres', 'muro_3u_postgres', 'muro_mvz_postgres', 'muro_omr_postgres', 'muro_hll_postgres']
        elif 'omr' in cwd:
            possible_containers = ['muro_omr_postgres', 'muro_3u_postgres', 'muro_mng_postgres', 'muro_mvz_postgres', 'muro_hll_postgres']
        else:
            possible_containers = ['muro_3u_postgres', 'muro_mng_postgres', 'muro_mvz_postgres', 'muro_omr_postgres', 'muro_hll_postgres']
        for container in possible_containers:
            try:
                import subprocess
                result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', container], stderr=subprocess.DEVNULL)
                ip = result.decode('utf-8').strip()
                if ip:
                    db_host = ip
                    db_port = 5432  # Docker internal port is always 5432
                    print(f"[*] Resolved local database container '{container}' IP: {db_host} (Internal port: {db_port})")
                    break
            except Exception:
                pass

    try:
        conn = pg8000.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
        return conn
    except Exception as e:
        print(f"[HATA] Veritabanı bağlantı hatası ({db_host}:{db_port}): {e}")
        sys.exit(1)

def get_muro_courses(conn):
    """MURO veritabanındaki tüm aktif kursları çeker."""
    cursor = conn.cursor()
    cursor.execute('SELECT "Id", "Title" FROM "Courses"')
    rows = cursor.fetchall()
    return [{"id": r[0], "title": r[1]} for r in rows]

def download_file(url, cookies_str, dest_path):
    """Okinar'dan dosyayı indirir ve orijinal adını content-disposition'dan çekmeye çalışır."""
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Cookie": cookies_str
    }
    
    filename = None
    content_type = "application/octet-stream"
    file_data = None
    
    if HAS_REQUESTS:
        try:
            r = requests.get(url, headers=headers, stream=True, timeout=30)
            if r.status_code != 200:
                print(f"   [HATA] İndirme hatası: HTTP {r.status_code}")
                return None, None, None
            
            file_data = r.content
            content_type = r.headers.get("content-type", "application/octet-stream").split(";")[0]
            
            # Content-Disposition başlığından dosya adını al
            cd = r.headers.get("content-disposition")
            if cd:
                filenames = re.findall(r"filename\*=utf-8''(.+)", cd)
                if not filenames:
                    filenames = re.findall(r'filename="(.+)"', cd)
                if not filenames:
                    filenames = re.findall(r'filename=(.+)', cd)
                if filenames:
                    filename = urllib.parse.unquote(filenames[0].strip(' "'))
        except Exception as e:
            print(f"   [HATA] Hata oluştu (requests): {e}")
            return None, None, None
    else:
        # Fallback to urllib
        try:
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=30) as response:
                if response.status != 200:
                    print(f"   [HATA] İndirme hatası: HTTP {response.status}")
                    return None, None, None
                
                file_data = response.read()
                content_type = response.headers.get("Content-Type", "application/octet-stream").split(";")[0]
                
                cd = response.headers.get("Content-Disposition")
                if cd:
                    filenames = re.findall(r"filename\*=utf-8''(.+)", cd)
                    if not filenames:
                        filenames = re.findall(r'filename="(.+)"', cd)
                    if not filenames:
                        filenames = re.findall(r'filename=(.+)', cd)
                    if filenames:
                        filename = urllib.parse.unquote(filenames[0].strip(' "'))
        except Exception as e:
            print(f"   [HATA] Hata oluştu (urllib): {e}")
            return None, None, None
            
    if not file_data:
        return None, None, None
        
    return file_data, filename, content_type

def match_courses_interactively(okinar_courses, muro_courses, conn, dry_run, auto_create_courses=False, only_muro=True):
    """Kursları eşleştirir, eşleşmeyenler için interaktif arayüz sunar."""
    mappings = {}
    print("\n--- Akıllı Ders Eşleştirme Başlatılıyor ---")
    
    if only_muro:
        print(f"[INFO] Sadece MURO'daki {len(muro_courses)} aktif ders için Okinar'dan eşleşme aranıyor...")
        unique_okinar = sorted(list(set(okinar_courses)))
        
        for mc in muro_courses:
            best_match = None
            best_score = 0.0
            for okinar_name in unique_okinar:
                score = calculate_similarity(okinar_name, mc["title"])
                if score > best_score:
                    best_score = score
                    best_match = okinar_name
            
            if best_score >= 0.80:
                mappings[best_match] = mc
                print(f"[OK] Eşleşti: [{mc['title']}] -> Okinar: [{best_match}] (Benzerlik: %{best_score*100:.1f})")
            else:
                print(f"\n[UYARI] '{mc['title']}' dersi için Okinar'da yakın bir isim bulunamadı (En yüksek benzerlik: %{best_score*100:.1f} -> {best_match})")
                print("Seçenekler:")
                print("  [S] Bu dersi ve dokümanlarını atla (Skip)")
                print("  [A] Tüm Okinar derslerini listele ve seç")
                print("  [F] Okinar derslerinde arama yap")
                
                choice = input("Seçiminiz (S/A/F): ").strip().lower()
                
                if choice == 'a':
                    print("\nOkinar Kurs Listesi:")
                    for o_idx, o_name in enumerate(unique_okinar):
                        print(f"  [{o_idx}] {o_name}")
                    try:
                        num = int(input("Okinar Kurs Numarası girin: ").strip())
                        if 0 <= num < len(unique_okinar):
                            mappings[unique_okinar[num]] = mc
                            print(f"-> Eşleşti: {unique_okinar[num]}")
                    except ValueError:
                        print("[HATA] Geçersiz girdi, atlanıyor.")
                elif choice == 'f':
                    query = input("Okinar'da aramak istediğiniz kelime: ").strip().lower()
                    matches = [o for o in unique_okinar if query in o.lower()]
                    if matches:
                        print("\nArama Sonuçları:")
                        for o_idx, o_name in enumerate(matches):
                            print(f"  [{o_idx}] {o_name}")
                        try:
                            num = int(input("Okinar Kurs Numarası girin: ").strip())
                            if 0 <= num < len(matches):
                                mappings[matches[num]] = mc
                                print(f"-> Eşleşti: {matches[num]}")
                        except ValueError:
                            print("[HATA] Geçersiz girdi, atlanıyor.")
                    else:
                        print("Arama sonucu bulunamadı, atlanıyor.")
                else:
                    print("-> Atlandı.")
        return mappings

    # Eski Okinar -> MURO akışı (opsiyonel)
    unmatched_okinar = []
    for okinar_name in okinar_courses:
        best_match = None
        best_score = 0.0
        for mc in muro_courses:
            score = calculate_similarity(okinar_name, mc["title"])
            if score > best_score:
                best_score = score
                best_match = mc
                
        if best_score >= 0.85:
            mappings[okinar_name] = best_match
            print(f"[OK] Otomatik Eşleşti: [{okinar_name}] -> [{best_match['title']}] (Benzerlik: %{best_score*100:.1f})")
        else:
            unmatched_okinar.append((okinar_name, best_match, best_score))
            
    # (Diğer durumlar için eski interaktif kısım...)
    return mappings

def main():
    parser = argparse.ArgumentParser(description="Okinar LMS materials downloader and MURO LMS database integrator")
    parser.add_argument("--json", required=True, help="Scraped JSON file path (e.g. okinar_materials.json)")
    parser.add_argument("--cookie", required=True, help="Okinar session cookies (e.g. 'PHPSESSID=abcdef123...')")
    parser.add_argument("--db-host", default="31.214.152.143", help="PostgreSQL Host (default: 31.214.152.143)")
    parser.add_argument("--db-port", default="5434", help="PostgreSQL Port (default: 5434)")
    parser.add_argument("--db-name", default="muro_prod", help="PostgreSQL Database Name (default: muro_prod)")
    parser.add_argument("--db-user", default="muro_user", help="PostgreSQL User (default: muro_user)")
    parser.add_argument("--db-password", default="MuroDb2026!Pr0d", help="PostgreSQL Password")
    parser.add_argument("--uploads-dir", default="./downloads", help="Local directory to download/save files temporarily")
    parser.add_argument("--dry-run", action="store_true", help="Perform checks and matchings without downloading or database writes")
    parser.add_argument("--auto-create-courses", action="store_true", help="Automatically create missing courses in MURO")
    
    args = parser.parse_args()

    print("=" * 60)
    print("      OKINAR DOKUMAN ENTEGRASYON SISTEMI")
    print("=" * 60)

    # JSON Oku
    json_path = args.json
    if not os.path.exists(json_path):
        fallbacks = [
            "okinar_materials.json",
            "okinar_materials (5).json",
            "okinar_materials(5).json"
        ]
        for f in fallbacks:
            if os.path.exists(f):
                json_path = f
                break
            # Check script dir
            script_dir = os.path.dirname(os.path.abspath(__file__))
            sd_path = os.path.join(script_dir, f)
            if os.path.exists(sd_path):
                json_path = sd_path
                break

        if not os.path.exists(json_path):
            print(f"[HATA] JSON dosyası bulunamadı: {args.json}")
            sys.exit(1)
        
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not data:
        print("[HATA] JSON verisi boş veya geçersiz!")
        sys.exit(1)

    print(f"[INFO] JSON yüklendi. Toplam {len(data)} ders ve doküman listesi mevcut.")

    # Veritabanı Bağlantısı ve Kursları Al
    print("[INFO] Veritabanına bağlanılıyor...")
    conn = get_db_connection(args)
    muro_courses = get_muro_courses(conn)
    print(f"   -> Veritabanında {len(muro_courses)} ders bulundu.")

    # Eşleştirme yap
    okinar_course_names = [item["courseName"] for item in data]
    course_mappings = match_courses_interactively(okinar_course_names, muro_courses, conn, args.dry_run, args.auto_create_courses)

    # İndirme klasörünü oluştur
    os.makedirs(args.uploads_dir, exist_ok=True)
    # MURO materials klasörü formatı (doğrudan materials altında)
    muro_materials_subdir = os.path.join(args.uploads_dir, "materials")
    if not args.dry_run:
        os.makedirs(muro_materials_subdir, exist_ok=True)

    print("\n" + "="*50)
    print("DOKUMAN INDIRME VE VERITABANI YAZMA BASLIYOR...")
    print("="*50)

    total_downloaded = 0
    total_db_records = 0
    total_skipped = 0

    cursor = conn.cursor()

    for item in data:
        okinar_name = item["courseName"]
        if okinar_name not in course_mappings:
            print(f"\n[INFO] Ders atlanıyor (Eşleşme yok): {okinar_name}")
            total_skipped += len(item["files"])
            continue
            
        muro_course = course_mappings[okinar_name]
        course_id = muro_course["id"]
        
        print(f"\n[DERS] [{okinar_name}] -> MURO: [{muro_course['title']}] ({len(item['files'])} dosya)")

        for f in item["files"]:
            title = f["title"]
            download_url = f["downloadUrl"]
            # Mükerrer kontrolü (Duplicate check): Eğer dosya bu derste aynı başlıkla zaten varsa indirme ve ekleme
            cursor.execute('SELECT COUNT(*) FROM "CourseMaterials" WHERE "CourseId" = %s AND "Title" = %s', (course_id, title))
            if cursor.fetchone()[0] > 0:
                print(f"   [ATLANIYOR] '{title}' zaten bu derste mevcut.")
                continue

            # Tarih dönüşümü (Okinar Tarih formatı örn: "2026-03-03 18:26:50")
            created_at_str = f.get("createdAt", "")
            try:
                created_at = datetime.strptime(created_at_str, "%Y-%m-%d %H:%M:%S")
            except Exception:
                try:
                    created_at = datetime.strptime(created_at_str, "%d.%m.%Y %H:%M:%S")
                except Exception:
                    created_at = datetime.utcnow()

            print(f"   [INDIR] Oynatılıyor/İndiriliyor: '{title}'...")

            if args.dry_run:
                print(f"   [DRY-RUN] URL: {download_url} -> Mapped to course {course_id}")
                total_downloaded += 1
                total_db_records += 1
                continue

            # Dosyayı indir
            file_data, orig_filename, content_type = download_file(download_url, args.cookie, args.uploads_dir)

            if not file_data:
                print("   [HATA] Dosya indirilemedi! Sıradakine geçiliyor.")
                continue

            # Orijinal dosya adı belirleme
            if not orig_filename:
                # URL sonundan veya uzantı tahmininden üretelim
                ext = mimetypes.guess_extension(content_type) or ".pdf"
                orig_filename = f"{clean_name(title)}{ext}"

            # Benzersiz dosya adı üret (MURO standardı)
            file_ext = os.path.splitext(orig_filename)[1] or ".pdf"
            unique_id = str(uuid.uuid4())
            unique_filename = f"{unique_id}{file_ext}"
            file_size = len(file_data)

            # Fizyolojik olarak kaydet
            dest_file_path = os.path.join(muro_materials_subdir, unique_filename)
            try:
                with open(dest_file_path, "wb") as f_out:
                    f_out.write(file_data)
                print(f"   [DISK] Kaydedildi: {orig_filename} ({file_size / 1024 / 1024:.2f} MB)")
            except Exception as io_err:
                print(f"   [HATA] Dosya diske yazılamadı: {io_err}")
                continue

            # Veritabanına yaz
            # DB sütunları: ['Id', 'CourseId', 'Title', 'FileName', 'FilePath', 'ContentType', 'FileSize', 'CreatedAt']
            material_id = str(uuid.uuid4())
            # Dosya yolu formatı: /uploads/materials/{uniqueName}
            # (Note: API bu yolu PhysicalFileProvider ile /wwwroot/uploads altında okur)
            db_file_path = f"/uploads/materials/{unique_filename}"

            try:
                cursor.execute(
                    'INSERT INTO "CourseMaterials" ("Id", "CourseId", "Title", "FileName", "FilePath", "ContentType", "FileSize", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                    (material_id, course_id, title, orig_filename, db_file_path, content_type, file_size, created_at)
                )
                total_db_records += 1
                total_downloaded += 1
                print(f"   [DB] Veritabanına eklendi.")
            except Exception as db_err:
                print(f"   [HATA] Veritabanı ekleme hatası: {db_err}")
                # Hata durumunda dosyayı silelim
                if os.path.exists(dest_file_path):
                    os.remove(dest_file_path)

    if not args.dry_run:
        conn.commit()
        print("\n[OK] Veritabanı değişiklikleri başarıyla uygulandı (Committed).")

    conn.close()

    print("\n" + "="*50)
    print("ENTEGRASYON ISLEMI TAMAMLANDI")
    print(f"   - Başarıyla İndirilen & Kaydedilen: {total_downloaded}")
    print(f"   - Veritabanına Eklenen Kayıt: {total_db_records}")
    print(f"   - Eşleşme Olmadığı İçin Atlanan: {total_skipped}")
    print("="*50)
    
    if not args.dry_run and total_downloaded > 0:
        print("\n[BILGI] ONEMLI SONRAKI ADIMLAR:")
        print("1. İndirilen dosyalar yerelde './downloads/materials/' dizinindedir.")
        print("2. Eğer Docker üzerinde deploy yapıyorsanız, bu klasörü api container'ına kopyalamalısınız:")
        print(f"   docker cp {args.uploads_dir}/materials/. muro_mng_api:/app/wwwroot/uploads/materials/")
        print("3. Eğer host üzerinde direkt çalışıyorsanız, dosyaları MURO uploads dizinine kopyalamanız yeterlidir:")
        print("   cp -r downloads/materials/* /mnt/storage/muro/uploads/materials/")

if __name__ == "__main__":
    main()
