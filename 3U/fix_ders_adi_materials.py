import psycopg2

def main():
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_mng_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Get IDs
    cur.execute('SELECT "Id" FROM "Courses" WHERE "Title" = \'ders_adi\';')
    row_dummy = cur.fetchone()
    dummy_id = row_dummy[0] if row_dummy else None

    cur.execute('SELECT "Id" FROM "Courses" WHERE "Title" = \'2026 EKYS Maarif Eğitim Modeli Soru Kampı\';')
    row_target = cur.fetchone()
    target_id = row_target[0] if row_target else None

    print(f"Dummy Course ('ders_adi') ID: {dummy_id}")
    print(f"Target Course ('2026 EKYS Maarif Eğitim Modeli Soru Kampı') ID: {target_id}")

    if not dummy_id:
        print("[HATA] 'ders_adi' isimli kaynak ders veritabanında bulunamadı!")
        return

    if not target_id:
        print("[HATA] '2026 EKYS Maarif Eğitim Modeli Soru Kampı' isimli hedef ders bulunamadı!")
        return

    # Check materials linked to dummy_id
    cur.execute('SELECT COUNT(*) FROM "CourseMaterials" WHERE "CourseId" = %s;', (dummy_id,))
    count = cur.fetchone()[0]
    print(f"Moving {count} documents from 'ders_adi' to '2026 EKYS Maarif Eğitim Modeli Soru Kampı'...")

    if count > 0:
        cur.execute('''
            UPDATE "CourseMaterials" 
            SET "CourseId" = %s 
            WHERE "CourseId" = %s;
        ''', (target_id, dummy_id))
        conn.commit()
        print("[OK] Dosyalar başarıyla doğru derse taşındı!")
    else:
        print("[BILGI] Taşınacak dosya bulunamadı.")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
