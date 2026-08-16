import psycopg2
import uuid

data = [
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785220204210", "title": "KIT KAYNAKLARIN KULLANIM SORUNU: EKONOMİK SİSTEMLER", "course_id": "3aa1521f-b6d0-40df-b20a-909543478edd"}, # MİKRO İKTİSAT 2026 (Akşam Grubu)
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785176499428", "title": "TİCARET HUKUKU DERS 4", "course_id": "f508886f-35fe-4528-bcca-f742f6bc299e"}, # TİCARET HUKUKU 2026 (Akşam Grubu)
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785259904033", "title": "İcra Dairesinin Yükümlülükleri- İcra Mahk. ve Genel Mahk.", "course_id": "f4b16d66-c96c-4648-98a7-158ce3730c1e"}, # İCRA-İFLAS HUKUKU 2026 (Akşam Grubu)
    {"uid": "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785170029760", "title": "Medeni - Borçlar Tarama Dersleri - 1", "course_id": "a1cc5c05-a849-4284-97f7-46f71bf3d477"}, # BORÇLAR HUKUKU 2026 (Akşam Grubu)
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785225675508", "title": "KAMU MALİYESİNİ AÇIKLAYAN YAKLAŞIMLAR", "course_id": "1c081124-5b8a-48ba-bcf0-7dd32d1465dc"}, # MALİYE 2026 (Akşam Grubu)
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785256142332", "title": "Giriş - Temel İlkeler ve Cebri İcra Teşkilatı", "course_id": "f4b16d66-c96c-4648-98a7-158ce3730c1e"},
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785269191174", "title": "İtirazın Hükümden Düşürülmesi - İtirazın İptali ve İtirazın Kesin/Geçici Kaldırılması", "course_id": "f4b16d66-c96c-4648-98a7-158ce3730c1e"},
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785240231963", "title": "PİYASA BAŞARISIZLIĞI-3", "course_id": "3aa1521f-b6d0-40df-b20a-909543478edd"},
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785265641800", "title": "İlamsız İcra- Genel Haciz Yolunda Ödeme Emri Tebliği ve İtiraz", "course_id": "f4b16d66-c96c-4648-98a7-158ce3730c1e"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785171458920", "title": "TİCARET HUKUKU DERS 2", "course_id": "f508886f-35fe-4528-bcca-f742f6bc299e"},
    {"uid": "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785177352545", "title": "Medeni Borçlar 3. ders", "course_id": "a1cc5c05-a849-4284-97f7-46f71bf3d477"},
    {"uid": "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785173556825", "title": "Medeni Borçlar 2", "course_id": "a1cc5c05-a849-4284-97f7-46f71bf3d477"},
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785228444056", "title": "REFAH İKTİSADININ TEMEL TEOREMLERİ", "course_id": "3aa1521f-b6d0-40df-b20a-909543478edd"},
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785222699516", "title": "İKTİSADİ YAKLAŞIMLARA GÖRE DEVLETİN ROLÜ", "course_id": "1c081124-5b8a-48ba-bcf0-7dd32d1465dc"},
    {"uid": "79d7ec6eec46b18bf7427f0916031100e47783e5-1785112849978", "title": "KPSS 2018- SON BEŞLİ & İKTİSAT", "course_id": "c68e2a68-da4b-450f-8100-4f90fa48ba09"}, # SON BEŞLİ İKTİSAT 2026
    {"uid": "95dbe3c9f31b31fdc66e0349a01961530be9f36b-1785154455450", "title": "TİCARİ İŞLETME HUKUKU DENEME KAYDI", "course_id": "f508886f-35fe-4528-bcca-f742f6bc299e"} # TİCARET HUKUKU 2026 (Akşam)
]

try:
    print("Connecting to prod db...")
    conn = psycopg2.connect("host=31.214.152.143 port=5434 dbname=muro_demo user=muro_user password=MuroDem0_2026!Str0ng")
    cur = conn.cursor()
    
    for i, d in enumerate(data):
        url = f"https://canli.4takademi.com/playback/presentation/2.3/{d['uid']}"
        title = d['title']
        course_id = d['course_id']
        uid = d['uid']
        new_uuid = str(uuid.uuid4())
        
        # Insert into Sessions
        cur.execute("""
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd")
            SELECT %s, %s, %s, %s, %s, false, NOW(), 4, %s, true, false, NOW(), NOW()
            WHERE NOT EXISTS (
                SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = %s
            )
            RETURNING "Id";
        """, (new_uuid, course_id, title, url, uid, i+1, uid))
        
        row = cur.fetchone()
        if row:
            session_id = row[0]
            
            # Insert into CourseMedias
            cur.execute("""
                INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt")
                SELECT gen_random_uuid(), %s, %s, 0, NOW()
                WHERE NOT EXISTS (
                    SELECT 1 FROM "CourseMedias" WHERE "SessionId" = %s
                );
            """, (course_id, session_id, session_id))
            print(f"Inserted {title}")
        else:
            print(f"Skipped {title}, already exists.")
        
    conn.commit()
    cur.close()
    conn.close()
    print("Successfully inserted 16 missing sessions to prod db!")
    
except Exception as e:
    print("Error:", e)
