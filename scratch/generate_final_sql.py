import json
import uuid

data = [
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785220204210", "title": "KIT KAYNAKLARIN KULLANIM SORUNU: EKONOMİK SİSTEMLER", "course_id": "2c3d01c8-708e-41c5-877f-7a488dd994c4"}, # MİKRO İKTİSAT 2026 (Sabah Grubu)
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785176499428", "title": "TİCARET HUKUKU DERS 4", "course_id": "23bc3b60-7697-455b-bac8-25d9f93c42d7"}, # TİCARET HUKUKU 2026 (Sabah Grubu)
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785259904033", "title": "İcra Dairesinin Yükümlülükleri- İcra Mahk. ve Genel Mahk.", "course_id": "949f4f6b-b368-454d-aa6b-b8e2d490d617"}, # İCRA-İFLAS HUKUKU 2026 (Sabah Grubu)
    {"uid": "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785170029760", "title": "Medeni - Borçlar Tarama Dersleri - 1", "course_id": "39db3666-d775-41a7-bfda-1c1f6d0dcaf2"}, # BORÇLAR HUKUKU 2026 (Sabah Grubu)
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785225675508", "title": "KAMU MALİYESİNİ AÇIKLAYAN YAKLAŞIMLAR", "course_id": "2b4c8faa-011b-4142-84fb-796ba8494fbf"}, # MALİYE 2026 (Sabah Grubu)
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785256142332", "title": "Giriş - Temel İlkeler ve Cebri İcra Teşkilatı", "course_id": "949f4f6b-b368-454d-aa6b-b8e2d490d617"},
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785269191174", "title": "İtirazın Hükümden Düşürülmesi - İtirazın İptali ve İtirazın Kesin/Geçici Kaldırılması", "course_id": "949f4f6b-b368-454d-aa6b-b8e2d490d617"},
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785240231963", "title": "PİYASA BAŞARISIZLIĞI-3", "course_id": "2c3d01c8-708e-41c5-877f-7a488dd994c4"},
    {"uid": "a58af72bc85d23eca37dc0cab01d921da858ab42-1785265641800", "title": "İlamsız İcra- Genel Haciz Yolunda Ödeme Emri Tebliği ve İtiraz", "course_id": "949f4f6b-b368-454d-aa6b-b8e2d490d617"},
    {"uid": "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785171458920", "title": "TİCARET HUKUKU DERS 2", "course_id": "23bc3b60-7697-455b-bac8-25d9f93c42d7"},
    {"uid": "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785177352545", "title": "Medeni Borçlar 3. ders", "course_id": "39db3666-d775-41a7-bfda-1c1f6d0dcaf2"},
    {"uid": "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785173556825", "title": "Medeni Borçlar 2", "course_id": "39db3666-d775-41a7-bfda-1c1f6d0dcaf2"},
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785228444056", "title": "REFAH İKTİSADININ TEMEL TEOREMLERİ", "course_id": "2c3d01c8-708e-41c5-877f-7a488dd994c4"},
    {"uid": "216207eb59a91acf266b5b3591fbebd18f0f9061-1785222699516", "title": "İKTİSADİ YAKLAŞIMLARA GÖRE DEVLETİN ROLÜ", "course_id": "2b4c8faa-011b-4142-84fb-796ba8494fbf"},
    {"uid": "79d7ec6eec46b18bf7427f0916031100e47783e5-1785112849978", "title": "KPSS 2018- SON BEŞLİ & İKTİSAT", "course_id": "2b0ff09c-b75c-45d4-8b21-f0408d532b0f"}, # SON BEŞLİ İKTİSAT 2026
    {"uid": "95dbe3c9f31b31fdc66e0349a01961530be9f36b-1785154455450", "title": "TİCARİ İŞLETME HUKUKU DENEME KAYDI", "course_id": "8ef15682-6937-4003-98e1-eca61a6f0abd"} # 2025 IMS TİCARİ İŞLETME
]

sql_sessions = []
for i, d in enumerate(data):
    url = f"https://canli.4takademi.com/playback/presentation/2.3/{d['uid']}"
    title = d['title'].replace("'", "''")
    course_id = d['course_id']
    uid = d['uid']
    sql_sessions.append(f"('{uuid.uuid4()}', '{course_id}', '{title}', '{url}', '{uid}', false, NOW(), 4, {i+1}, true, false, NOW(), NOW())")

query = f"""docker exec -i muro_3u_postgres psql -U muro_user -d muro_demo -c "INSERT INTO \\"Sessions\\" (\\"Id\\", \\"CourseId\\", \\"Title\\", \\"VideoUrl\\", \\"BbbMeetingId\\", \\"IsDeleted\\", \\"CreatedAt\\", \\"Status\\", \\"Order\\", \\"RecordingEnabled\\", \\"IsFree\\", \\"ScheduledStart\\", \\"ScheduledEnd\\") VALUES {', '.join(sql_sessions)} ON CONFLICT (\\"BbbMeetingId\\") DO UPDATE SET \\"VideoUrl\\" = EXCLUDED.\\"VideoUrl\\", \\"CourseId\\" = EXCLUDED.\\"CourseId\\";" """

with open("scratch/final_insert.sh", "w", encoding="utf-8") as f:
    f.write(query + "\n")
    
    # CourseMedias Insert
    query2 = f"""docker exec -i muro_3u_postgres psql -U muro_user -d muro_demo -c "INSERT INTO \\"CourseMedias\\" (\\"Id\\", \\"CourseId\\", \\"SessionId\\", \\"OrderIndex\\", \\"CreatedAt\\") SELECT gen_random_uuid(), \\"CourseId\\", \\"Id\\", 0, NOW() FROM \\"Sessions\\" s WHERE s.\\"BbbMeetingId\\" IN ({', '.join([f"'{d['uid']}'" for d in data])}) AND NOT EXISTS (SELECT 1 FROM \\"CourseMedias\\" cm WHERE cm.\\"SessionId\\" = s.\\"Id\\");" """
    f.write(query2 + "\n")

print("Created scratch/final_insert.sh")
