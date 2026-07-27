import json
import os
import difflib
import re

# Türkçe karakter dönüştürme tablosu
TR_MAP = str.maketrans("ığüşöçİĞÜŞÖÇ", "igusocIGUSOC")

def clean_name(name):
    if not name:
        return ""
    name = name.translate(TR_MAP).lower().strip()
    name = re.sub(r'[^a-z0-9\s]', '', name)
    return " ".join(name.split())

def calculate_similarity(s1, s2):
    return difflib.SequenceMatcher(None, clean_name(s1), clean_name(s2)).ratio()

def main():
    import psycopg2
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_mng_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Load MURO courses
    cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "IsDeleted" = False;')
    muro_courses = [{"id": r[0], "title": r[1]} for r in cur.fetchall()]

    # Load JSON materials
    with open('okinar_materials.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    print(f"Loaded {len(data)} courses from JSON.")
    print(f"Loaded {len(muro_courses)} courses from MURO.")

    print("\n--- EŞLEŞMEYEN OKİNAR DERSLERİ VE MURO'DAKİ EN YAKIN ADAYLAR ---")
    
    unmatched_count = 0
    for item in data:
        okinar_name = item["courseName"]
        files = item.get("files", [])
        if not files:
            continue  # Dosyası olmayanları atla

        # MURO'da eşleşen var mı bak
        best_match = None
        best_score = 0.0
        for mc in muro_courses:
            score = calculate_similarity(okinar_name, mc["title"])
            if score > best_score:
                best_score = score
                best_match = mc

        if best_score < 0.80:
            unmatched_count += 1
            print(f"\n❌ Eşleşmedi: '{okinar_name}' ({len(files)} dosya barındırıyor)")
            print(f"   -> En yakın MURO adayı: '{best_match['title'] if best_match else 'Yok'}' (Benzerlik: %{best_score*100:.1f})")
            
            # Diğer yakın adayları göster (%50 üzeri)
            alt_candidates = []
            for mc in muro_courses:
                score = calculate_similarity(okinar_name, mc["title"])
                if 0.50 <= score < 0.80:
                    alt_candidates.append((score, mc["title"]))
            alt_candidates.sort(reverse=True)
            if alt_candidates:
                print("   -> Diğer olası adaylar:")
                for score, title in alt_candidates[:3]:
                    print(f"      - '{title}' (%{score*100:.1f})")

    print(f"\nToplam eşleşmeyen dosya barındıran ders sayısı: {unmatched_count}")
    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
