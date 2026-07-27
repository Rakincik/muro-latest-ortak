-- ==================================================
-- MURO LMS - BBB Sessions Import Script
-- Generated on 2026-07-15 20:31:54
-- ==================================================

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '08.11.2025 Deneme Sınavı' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '5dc1291e1f89bf8ba48ec9209b12390349c8e5be') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (08.11.2025 Deneme Sınavı)', '5dc1291e1f89bf8ba48ec9209b12390349c8e5be', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '09.11.2025 Deneme Sınavı' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '095dd429aa6ac73b228d4a2f2d0c26e4b78c4a67') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (09.11.2025 Deneme Sınavı)', '095dd429aa6ac73b228d4a2f2d0c26e4b78c4a67', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '1 sayılı Cumhurbaşkanlığı Kararnamesi (Tarım ve Orman Bakanlığı)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '1efb1f79a61e7505249fb439d17f44679d883f9f') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (1 sayılı Cumhurbaşkanlığı Kararnamesi (T)', '1efb1f79a61e7505249fb439d17f44679d883f9f', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '1 sayılı Cumhurbaşkanlığı Teşkilatı Hakkında Cumhurbaşkanlığı Kararnamesi (GSB Bölümü)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bc76e3781aa3653fa2fff7b362628d62d2e39800') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (1 sayılı Cumhurbaşkanlığı Teşkilatı Hakk)', 'bc76e3781aa3653fa2fff7b362628d62d2e39800', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '15.11.2025 Deneme Sınavı' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bacc71058420e76df2f39677e0b147cc61ab54b3') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (15.11.2025 Deneme Sınavı)', 'bacc71058420e76df2f39677e0b147cc61ab54b3', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '16.11.2025 Deneme Sınavı' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'f646ef8bc2fb0b89dca2c5adfe129710518df5b5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (16.11.2025 Deneme Sınavı)', 'f646ef8bc2fb0b89dca2c5adfe129710518df5b5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '2576 sayılı Bölge İdare Mahkemeleri, İdare Mahkemeleri ve Vergi Mahkemelerinin Kuruluşu ve Görevleri Hakkında Kanun' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'beba82aa9975e3352e7f520ad212087b90be59e3') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (2576 sayılı Bölge İdare Mahkemeleri, İda)', 'beba82aa9975e3352e7f520ad212087b90be59e3', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '2577 sayılı İdari Yarılama Usulü Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '21fa2ee77adc73a2c34f7e6c1d1069c32300f757') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (2577 sayılı İdari Yarılama Usulü Kanunu)', '21fa2ee77adc73a2c34f7e6c1d1069c32300f757', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '26 Nisan 2026 Gençlik ve Spor Bakanlığı' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '88811c5b5d856a129fd9fc68cbf717283a7f1791') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (26 Nisan 2026 Gençlik ve Spor Bakanlığı)', '88811c5b5d856a129fd9fc68cbf717283a7f1791', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '2802 sayılı Hakimler ve Savcılar Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ef3f80c2014fb3e7b9290d586f1874a2eb5f7fc7') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (2802 sayılı Hakimler ve Savcılar Kanunu)', 'ef3f80c2014fb3e7b9290d586f1874a2eb5f7fc7', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '2886 DİK' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'b321a3fef8c40e6afcb6d8845880e16ab96da9cc') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (2886 DİK)', 'b321a3fef8c40e6afcb6d8845880e16ab96da9cc', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '30 Kasım 2025 Adalet Bakanlığı Yazı İşleri Müdürlüğü' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '5cb1e7685e84df89ef9989f1fb926072ac27e82d') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (30 Kasım 2025 Adalet Bakanlığı Yazı İşle)', '5cb1e7685e84df89ef9989f1fb926072ac27e82d', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '3071 sayılı Dilekçe Hakkının Kullanılmasına Dair Kanun' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6ceea1437df357ffdc19b02ac2f2327eeafb1d7b') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (3071 sayılı Dilekçe Hakkının Kullanılmas)', '6ceea1437df357ffdc19b02ac2f2327eeafb1d7b', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '3289 sayılı Gençlik ve Spor Hizmetleri Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ffd4f563f7162bb9df2604430892620a37231966') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (3289 sayılı Gençlik ve Spor Hizmetleri K)', 'ffd4f563f7162bb9df2604430892620a37231966', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '351 sayılı Yüksek Öğrenim Kredi ve Yurt Hizmetleri Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd21863d2341b69553b63a09ec1e923bb75bf7324') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (351 sayılı Yüksek Öğrenim Kredi ve Yurt )', 'd21863d2341b69553b63a09ec1e923bb75bf7324', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '3628 Sayılı Kanun' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '895c200acfeeed67735edbf32fbb2e08f43e43cf') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (3628 Sayılı Kanun)', '895c200acfeeed67735edbf32fbb2e08f43e43cf', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '4483 sayılı Memurlar ve Diğer Kamu Görevlilerinin Yargılanması Hakkında Kanun' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'cee98595b2086098b7bca95efd74ee603b967a3a') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (4483 sayılı Memurlar ve Diğer Kamu Görev)', 'cee98595b2086098b7bca95efd74ee603b967a3a', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '4688 sayılı Kamu Görevlileri Sendikaları ve Toplu Sözleşme Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'b12cbba5b943458b812776f3932711aa06f3c0cd') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (4688 sayılı Kamu Görevlileri Sendikaları)', 'b12cbba5b943458b812776f3932711aa06f3c0cd', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '4721 sayılı TÜRK MEDENİ KANUNU' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'e68e9d29d75642bf8e7a3ee1f9f7fdb94dc3dc04') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (4721 sayılı TÜRK MEDENİ KANUNU)', 'e68e9d29d75642bf8e7a3ee1f9f7fdb94dc3dc04', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '4734 sayılı Kamu İhale Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5709d990f0379f7ae3fbe528c7cf6b937bafd37') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (4734 sayılı Kamu İhale Kanunu)', 'd5709d990f0379f7ae3fbe528c7cf6b937bafd37', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '4735 sayılı Kamu İhale Sözleşmeleri Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7ae77d8310d74ef03694bae1ac1d0657c5098d01') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (4735 sayılı Kamu İhale Sözleşmeleri Kanu)', '7ae77d8310d74ef03694bae1ac1d0657c5098d01', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '492 sayılı Harçlar Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '9464f7b9af9ef8f2422667660fb30c3d08de534e') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (492 sayılı Harçlar Kanunu)', '9464f7b9af9ef8f2422667660fb30c3d08de534e', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '4982 sayılı BİLGİ EDİNME HAKKI KANUNU' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '5cb477dba2aabc2f57470c7096528c0395471441') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (4982 sayılı BİLGİ EDİNME HAKKI KANUNU)', '5cb477dba2aabc2f57470c7096528c0395471441', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5018 sayılı Kamu Mali Yönetimi ve Kontrol Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'f96363c0d817711a478799ce91750b91dd5c6a00') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5018 sayılı Kamu Mali Yönetimi ve Kontro)', 'f96363c0d817711a478799ce91750b91dd5c6a00', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5070 sayılı Elektronik İmza Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '68f936d39398da733f2268b35484100f537be68c') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5070 sayılı Elektronik İmza Kanunu)', '68f936d39398da733f2268b35484100f537be68c', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5235 sayılı ADLÎ YARGI İLK DERECE MAHKEMELERİ İLE BÖLGE ADLİYE MAHKEMELERİNİN KURULUŞ, GÖREV VE YETKİLERİ HAKKINDA KANUN' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '98f9e5787ce7b823d0385f815ec48b195b60f1b5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5235 sayılı ADLÎ YARGI İLK DERECE MAHKEM)', '98f9e5787ce7b823d0385f815ec48b195b60f1b5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5237 sayılı Türk Ceza Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ddc739bd96d40d1ffa763095be7033285114a21a') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5237 sayılı Türk Ceza Kanunu)', 'ddc739bd96d40d1ffa763095be7033285114a21a', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5271 sayılı Ceza Muhakemesi Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'f36ceced524bcb8f5b430cacad94985fb6b67a74') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5271 sayılı Ceza Muhakemesi Kanunu)', 'f36ceced524bcb8f5b430cacad94985fb6b67a74', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5275 sayılı Ceza ve Güvenlik Tedbirlerinin İnfazı Hakkında Kanun' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd8a6869ff39b7698b1144c4ab79fd8da57e20fbb') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5275 sayılı Ceza ve Güvenlik Tedbirlerin)', 'd8a6869ff39b7698b1144c4ab79fd8da57e20fbb', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5275 sayılı Ceza Ve Güvenlik Tedbirlerinin İnfazı Hakkında Kanun' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '75976861e2a3e7e78376a3bc65faeef84393c981') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5275 sayılı Ceza Ve Güvenlik Tedbirlerin)', '75976861e2a3e7e78376a3bc65faeef84393c981', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5302 sayılı İl Özel İdaresi Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'e153e6151929a67b752a5c1b748281f8d375b036') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5302 sayılı İl Özel İdaresi Kanunu)', 'e153e6151929a67b752a5c1b748281f8d375b036', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5393 sayılı Belediye Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '1623fb03b6adc35b7248b154a22034c1592d6760') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5393 sayılı Belediye Kanunu)', '1623fb03b6adc35b7248b154a22034c1592d6760', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5442 sayılı İl İdaresi Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '570dd70df86e85752b584ac3f924c1357a175453') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5442 sayılı İl İdaresi Kanunu)', '570dd70df86e85752b584ac3f924c1357a175453', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '5549 sayılı SUÇ GELİRLERİNİN AKLANMASININ ÖNLENMESİ HAKKINDA KANUN' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '34f9c40e0be71f29804314319dcc36d350a84eb2') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (5549 sayılı SUÇ GELİRLERİNİN AKLANMASINI)', '34f9c40e0be71f29804314319dcc36d350a84eb2', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '6100 SAYILI HMK (YİM ÖZEL)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd442f826210e3067ad3c26512514ee6fff6e755d') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (6100 SAYILI HMK (YİM ÖZEL))', 'd442f826210e3067ad3c26512514ee6fff6e755d', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '6100 sayılı Hukuk Muhakemeleri Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '976c7e315a638ebb9d0b27a6304be39c5173fed9') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (6100 sayılı Hukuk Muhakemeleri Kanunu)', '976c7e315a638ebb9d0b27a6304be39c5173fed9', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '6245 sayılı Harcırah Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '22125300eb27fe766d1083bfef7f13b6a0f134d5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (6245 sayılı Harcırah Kanunu)', '22125300eb27fe766d1083bfef7f13b6a0f134d5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '6331 sayılı İş Sağlığı ve Güvenliği Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0173a802307e9442c910af0dd96ee6d9060b1d05') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (6331 sayılı İş Sağlığı ve Güvenliği Kanu)', '0173a802307e9442c910af0dd96ee6d9060b1d05', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '657 sayılı Devlet Memurları Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6a4e9115ee6f7a9087f2e65deaa53c6d367a5baa') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (657 sayılı Devlet Memurları Kanunu)', '6a4e9115ee6f7a9087f2e65deaa53c6d367a5baa', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '6698 Kişisel Verilerin Korunması Kanunu' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7c1ae3d96c9118a3ca79406fe7c26ac6a40e6b25') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (6698 Kişisel Verilerin Korunması Kanunu)', '7c1ae3d96c9118a3ca79406fe7c26ac6a40e6b25', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || '7201 sayılı Tebligat Kanunu ve Uygulama Yönetmelikleri' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'b299bcb76076a6ab1376b75a4347f7bbc5f68008') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (7201 sayılı Tebligat Kanunu ve Uygulama )', 'b299bcb76076a6ab1376b75a4347f7bbc5f68008', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Adalet Bakanlığı Disiplin Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '9df1dd1966ebd98ff3adbcbaf32cf890dfa9b791') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Adalet Bakanlığı Disiplin Yönetmeliği)', '9df1dd1966ebd98ff3adbcbaf32cf890dfa9b791', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Adalet Bakanlığı Memur Sınav, Atama ve Nakil Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '1ec2b2a0222ccc62ef32c7f6f29d3fd96e17920d') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Adalet Bakanlığı Memur Sınav, Atama ve N)', '1ec2b2a0222ccc62ef32c7f6f29d3fd96e17920d', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Adalet Bakanlığı Personeli Görevde Yükselme ve Unvan Değişikliği Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ae81fe5b577dd230d960c8efe70fd3008406663b') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Adalet Bakanlığı Personeli Görevde Yükse)', 'ae81fe5b577dd230d960c8efe70fd3008406663b', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Atatürk ilkeleri ve İnkılap Tarihi, Ulusal Güvenlik' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '868d4e0e350821a83595eaa91b22aac18ec976ed') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Atatürk ilkeleri ve İnkılap Tarihi, Ulus)', '868d4e0e350821a83595eaa91b22aac18ec976ed', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'BİM, İdare Mahkemeleri ve Vergi Mahkemelerinin İdari İşler İle Yazı İşleri Hizmetlerinin Yürütülmesi Usul ve Esaslarına İlişkin Yönetmelik' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '75ce6b49508744b711b472c33f80aad4c1b9048a') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (BİM, İdare Mahkemeleri ve Vergi Mahkemel)', '75ce6b49508744b711b472c33f80aad4c1b9048a', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Bölge Adliye ve Adli Yargı İlk Derece Mahkemeleri İle Cumhuriyet Başsavcılıkları İdari ve Yazı İşleri Hizmetlerinin Yürütülmesine Dair Yönetmelik' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4a275ff0e499fca0bd33bc8ae99c0fcb8e42a41c') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Bölge Adliye ve Adli Yargı İlk Derece Ma)', '4a275ff0e499fca0bd33bc8ae99c0fcb8e42a41c', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Cumhurbaşkanlığı Teşkilatı Hakkında 1 sayılı Cumhurbaşkanlığı Kararnamesi (Adalet Bakanlığı)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '822ff8dc88660c9fcfbc8501fb19e841d1ef6fad') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Cumhurbaşkanlığı Teşkilatı Hakkında 1 sa)', '822ff8dc88660c9fcfbc8501fb19e841d1ef6fad', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Cumhurbaşkanlığı Teşkilatı Hakkında 1 sayılı Cumhurbaşkanlığı Kararnamesi (CUMHURBAŞKANLIĞI)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2e549876977818e31218008252da2385a059c662') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Cumhurbaşkanlığı Teşkilatı Hakkında 1 sa)', '2e549876977818e31218008252da2385a059c662', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Etik Davranış İlkeleri' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'e672839b52ae5214e16f443ccea3b7515c3070f6') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Etik Davranış İlkeleri)', 'e672839b52ae5214e16f443ccea3b7515c3070f6', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Gençlik ve Spor Bakanlığı Yurt Hizmetleri Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c87401de6031840ac5f1615dc2d687e1df91b557') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Gençlik ve Spor Bakanlığı Yurt Hizmetler)', 'c87401de6031840ac5f1615dc2d687e1df91b557', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'GSB Personeli Görevde Yükselme ve Unvan Değişikliği Yönetmeliği - Disiplin Amirleri Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '66bcf69e7f3d190d9dbea9bf0f910f02e53ddd92') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (GSB Personeli Görevde Yükselme ve Unvan )', '66bcf69e7f3d190d9dbea9bf0f910f02e53ddd92', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'GSB Taşra Teşkilatının Kuruluşu, Görevleri, Çalışma Usul ve Esasları Hakkında Yönerge' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '23d8e82108da53b023f4c9b2e25ce75d3baad5dd') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (GSB Taşra Teşkilatının Kuruluşu, Görevle)', '23d8e82108da53b023f4c9b2e25ce75d3baad5dd', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'GSB- Bütçe ve Muhasebe Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'f857a8e48480e7955dfbef82671adea2ce9493c1') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (GSB- Bütçe ve Muhasebe Yönetmeliği)', 'f857a8e48480e7955dfbef82671adea2ce9493c1', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Görüşme' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '458b295d163439cac84fb66ecbdb389f75fb6a41') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Görüşme)', '458b295d163439cac84fb66ecbdb389f75fb6a41', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Kamu İhale Mevzuatı' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '73b2c959185803dc4cd36071cc6671e54a14ebd5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Kamu İhale Mevzuatı)', '73b2c959185803dc4cd36071cc6671e54a14ebd5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Rehberlik' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b615854447a390dfdfc064dae88fe9698daef29') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Rehberlik)', '2b615854447a390dfdfc064dae88fe9698daef29', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Resmi Yazışmalarda Uygulanacak Usul ve Esaslar Hakkında Yönetmelik' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dd91c35c626016155ea494436fd2433ff331af15') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Resmi Yazışmalarda Uygulanacak Usul ve E)', 'dd91c35c626016155ea494436fd2433ff331af15', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 1 sayılı CBK (TOB-Onbeşinci Bölüm)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '83e051252fa3f0b95f9d2b7fdd3f5db33002452a') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 1 sayılı CBK (TOB-Onbeşinc)', '83e051252fa3f0b95f9d2b7fdd3f5db33002452a', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 3289' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2cfb59fbfd524bce5581a46d2436ed5193b6b007') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 3289)', '2cfb59fbfd524bce5581a46d2436ed5193b6b007', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 351' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ebf46dfda0f526de2328f392094fb2caba78eab5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 351)', 'ebf46dfda0f526de2328f392094fb2caba78eab5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 3628' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '524c153a23131096293b32d9f104a6bef5a7f7af') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 3628)', '524c153a23131096293b32d9f104a6bef5a7f7af', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 4483' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8543e880fcf8a3f65bce0e1c64748c487a201d31') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 4483)', '8543e880fcf8a3f65bce0e1c64748c487a201d31', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 4734' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '07689f6bc4df1aa4cecee457cc077e25aad61fe3') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 4734)', '07689f6bc4df1aa4cecee457cc077e25aad61fe3', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 4735' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '1a96ce4f4599b5a529e07d629fed73f18e4fe0e8') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 4735)', '1a96ce4f4599b5a529e07d629fed73f18e4fe0e8', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 4982' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '741151817d41c68930566df2555746d0c2d88365') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 4982)', '741151817d41c68930566df2555746d0c2d88365', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 5018' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6555ec2636fb2fa09f418d25ecc000353195de3f') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 5018)', '6555ec2636fb2fa09f418d25ecc000353195de3f', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 5442' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6bad4cc853bfb8b233adab3e1423931c44a47b11') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 5442)', '6bad4cc853bfb8b233adab3e1423931c44a47b11', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 6222' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '78d2240eb30ee4b2ec83f7706cd462a2029a1fd7') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 6222)', '78d2240eb30ee4b2ec83f7706cd462a2029a1fd7', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 6245' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'b6f4c0265bc50e43d49c6733d8f011f40d4914b0') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 6245)', 'b6f4c0265bc50e43d49c6733d8f011f40d4914b0', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 6331' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ef7540a4bc85d2ef84baa109e6ccc72389d47c6c') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 6331)', 'ef7540a4bc85d2ef84baa109e6ccc72389d47c6c', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 657' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '62876ca7efb3d18a80d7c0c5be47b858400e4112') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 657)', '62876ca7efb3d18a80d7c0c5be47b858400e4112', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 657 sayılı DMK (TOB)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'f8f9fe2920897fe78ffdb2f41fc6555d04ebde69') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 657 sayılı DMK (TOB))', 'f8f9fe2920897fe78ffdb2f41fc6555d04ebde69', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 6698' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '485443c232a2c510ff5e793496e0135047bc9588') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 6698)', '485443c232a2c510ff5e793496e0135047bc9588', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - 7405' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '14fa5686eb42e92a843a8469886c334c342d4c97') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - 7405)', '14fa5686eb42e92a843a8469886c334c342d4c97', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - Anayasa' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'cc37e86a081855c4aa08795bde159a3e74bd0923') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - Anayasa)', 'cc37e86a081855c4aa08795bde159a3e74bd0923', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - CBK1 (GSB Bölümü)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ab39784fcc3a74b728e44327b661f4b995c073c6') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - CBK1 (GSB Bölümü))', 'ab39784fcc3a74b728e44327b661f4b995c073c6', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - Etik Davranış İlkeleri' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '29aa27e95551bbd116f6af41e7df9d7aca6165c6') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - Etik Davranış İlkeleri)', '29aa27e95551bbd116f6af41e7df9d7aca6165c6', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - Gençlik ve Spor Bakanlığı Yurt Hizmetleri Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '10f0af093a8fdd42d9737027a3010991ae2aaa51') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - Gençlik ve Spor Bakanlığı )', '10f0af093a8fdd42d9737027a3010991ae2aaa51', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - GSB Taşra Teşkilatı Yönergesi' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'ab7e6282c1735c05c2f7bbc50e410304c603f292') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - GSB Taşra Teşkilatı Yönerg)', 'ab7e6282c1735c05c2f7bbc50e410304c603f292', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - GYS ve UDS Yönetmeliği - Disiplin Amirleri Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd89b7f76f0b429374915364bdb21ba1baf1ea5b5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - GYS ve UDS Yönetmeliği - D)', 'd89b7f76f0b429374915364bdb21ba1baf1ea5b5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - Resmi Yazışmalar' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '757a9704244c9a99c4e397c51eed4d03c2140ab5') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - Resmi Yazışmalar)', '757a9704244c9a99c4e397c51eed4d03c2140ab5', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü - TOB GYS ve Unvan Değişikliği Yönetmeliği' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '9fe5ae77329bb68997d045f506b08095c1cf9bfb') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü - TOB GYS ve Unvan Değişikli)', '9fe5ae77329bb68997d045f506b08095c1cf9bfb', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü- 657 sayılı DMK' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7b0456d60d0969c046d302ff215924e2a60f5018') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü- 657 sayılı DMK)', '7b0456d60d0969c046d302ff215924e2a60f5018', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Soru Çözümü-4734-4375-2886' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'a3c35b281bacc9888b109d99589a16d24d6734a3') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Soru Çözümü-4734-4375-2886)', 'a3c35b281bacc9888b109d99589a16d24d6734a3', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'T.C. ANAYASASI' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '9aa23ae709a43723199ac4bae6d1380027fc7c8a') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (T.C. ANAYASASI)', '9aa23ae709a43723199ac4bae6d1380027fc7c8a', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'TOB Personeli Görevde Yükselme ve Unvan Değişikliği Yönetmeliğİ' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '40a0d2436a3f1dc5f4a94d733a9b03bae8ce466b') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (TOB Personeli Görevde Yükselme ve Unvan )', '40a0d2436a3f1dc5f4a94d733a9b03bae8ce466b', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Türkiye Geneli Çözümlü Deneme Sınavı (02.11.2025)' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4f73a7acb149a6c0434f72c5bbf67b092eca316c') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Türkiye Geneli Çözümlü Deneme Sınavı (02)', '4f73a7acb149a6c0434f72c5bbf67b092eca316c', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'Türkçe Dil Bilgisi' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8f85abe212b7513adabc6ea22eca5670b37e682a') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (Türkçe Dil Bilgisi)', '8f85abe212b7513adabc6ea22eca5670b37e682a', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" ILIKE '%' || 'UYAP ve SEGBİS' || '%' AND "IsDeleted" = false 
    ORDER BY "CreatedAt" DESC LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '9309083f322b04213dfb2f09b55943b62eb04b6b') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree")
            VALUES (gen_random_uuid(), cid, 'BBB Kayıtları (UYAP ve SEGBİS)', '9309083f322b04213dfb2f09b55943b62eb04b6b', false, NOW(), 3, 0, true, false);
        END IF;
    END IF;
END $$;
