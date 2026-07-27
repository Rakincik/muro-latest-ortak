-- ==================================================

-- MURO LMS - ENS (turkceoabtdeyiz.okinar.com) Sessions Import

-- Generated on 2026-07-16 10:37:18

-- ==================================================

BEGIN;



DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1775065972880') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MART AYI REHBERLİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1775065972880', '2c9c467309288b393c174b75223f4225b0d7472a-1775065972880', false, '2026-04-01 20:52:52', 3, 0, true, false, '2026-04-01 20:52:52', '2026-04-01 21:46:52', 54);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1779036251500') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MAYIS AYI REHBERLİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1779036251500', '2c9c467309288b393c174b75223f4225b0d7472a-1779036251500', false, '2026-05-17 19:44:11', 3, 0, true, false, '2026-05-17 19:44:11', '2026-05-17 20:38:11', 54);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1767988876332') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ARA DÖNEM REHBERLİK - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1767988876332', '2c9c467309288b393c174b75223f4225b0d7472a-1767988876332', false, '2026-01-09 23:01:16', 3, 0, true, false, '2026-01-09 23:01:16', '2026-01-09 23:38:16', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1757177436262') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANIŞMA DERSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1757177436262', '2c9c467309288b393c174b75223f4225b0d7472a-1757177436262', false, '2025-09-06 19:50:36', 3, 0, true, false, '2025-09-06 19:50:36', '2025-09-06 20:38:36', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1772391068881') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞUBAT AYI REHBERLİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1772391068881', '2c9c467309288b393c174b75223f4225b0d7472a-1772391068881', false, '2026-03-01 21:51:08', 3, 0, true, false, '2026-03-01 21:51:08', '2026-03-01 22:42:08', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1764352404941') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KASIM AYI REHBERLİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1764352404941', '2c9c467309288b393c174b75223f4225b0d7472a-1764352404941', false, '2025-11-28 20:53:24', 3, 0, true, false, '2025-11-28 20:53:24', '2025-11-28 21:54:24', 61);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1767984335892') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ARA DÖNEM REHBERLİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1767984335892', '2c9c467309288b393c174b75223f4225b0d7472a-1767984335892', false, '2026-01-09 21:45:35', 3, 0, true, false, '2026-01-09 21:45:35', '2026-01-09 22:44:35', 59);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1757357013139') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'AGS - ÖABT REHBERLİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1757357013139', '2c9c467309288b393c174b75223f4225b0d7472a-1757357013139', false, '2025-09-08 21:43:33', 3, 0, true, false, '2025-09-08 21:43:33', '2025-09-08 22:57:33', 74);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '. 2026 REHBERLİK' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2c9c467309288b393c174b75223f4225b0d7472a-1764356740105') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KASIM AYI REHBERLİK -2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2c9c467309288b393c174b75223f4225b0d7472a-1764356740105', '2c9c467309288b393c174b75223f4225b0d7472a-1764356740105', false, '2025-11-28 22:05:40', 3, 0, true, false, '2025-11-28 22:05:40', '2025-11-28 23:06:40', 61);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782414040653') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATI-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782414040653', '8797722914e101baa4578694025ea8348a748303-1782414040653', false, '2026-06-25 22:00:40', 3, 0, true, false, '2026-06-25 22:00:40', '2026-06-25 22:40:40', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782578698059') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Halk 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782578698059', '8797722914e101baa4578694025ea8348a748303-1782578698059', false, '2026-06-27 19:44:58', 3, 0, true, false, '2026-06-27 19:44:58', '2026-06-27 20:29:58', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782406674235') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATI-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782406674235', '8797722914e101baa4578694025ea8348a748303-1782406674235', false, '2026-06-25 19:57:54', 3, 0, true, false, '2026-06-25 19:57:54', '2026-06-25 20:45:54', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782233088048') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782233088048', '8797722914e101baa4578694025ea8348a748303-1782233088048', false, '2026-06-23 19:44:48', 3, 0, true, false, '2026-06-23 19:44:48', '2026-06-23 20:25:48', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782489006836') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Halk 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782489006836', '8797722914e101baa4578694025ea8348a748303-1782489006836', false, '2026-06-26 18:50:06', 3, 0, true, false, '2026-06-26 18:50:06', '2026-06-26 19:40:06', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782230004344') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782230004344', '8797722914e101baa4578694025ea8348a748303-1782230004344', false, '2026-06-23 18:53:24', 3, 0, true, false, '2026-06-23 18:53:24', '2026-06-23 19:37:24', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782493042891') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782493042891', '8797722914e101baa4578694025ea8348a748303-1782493042891', false, '2026-06-26 19:57:22', 3, 0, true, false, '2026-06-26 19:57:22', '2026-06-26 20:42:22', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782236239332') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782236239332', '8797722914e101baa4578694025ea8348a748303-1782236239332', false, '2026-06-23 20:37:19', 3, 0, true, false, '2026-06-23 20:37:19', '2026-06-23 21:21:19', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782402851175') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATI-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782402851175', '8797722914e101baa4578694025ea8348a748303-1782402851175', false, '2026-06-25 18:54:11', 3, 0, true, false, '2026-06-25 18:54:11', '2026-06-25 19:47:11', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782496794819') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782496794819', '8797722914e101baa4578694025ea8348a748303-1782496794819', false, '2026-06-26 20:59:54', 3, 0, true, false, '2026-06-26 20:59:54', '2026-06-26 21:38:54', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782142814641') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782142814641', '8797722914e101baa4578694025ea8348a748303-1782142814641', false, '2026-06-22 18:40:14', 3, 0, true, false, '2026-06-22 18:40:14', '2026-06-22 19:25:14', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782575413042') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Halk 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782575413042', '8797722914e101baa4578694025ea8348a748303-1782575413042', false, '2026-06-27 18:50:13', 3, 0, true, false, '2026-06-27 18:50:13', '2026-06-27 19:29:13', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782582143015') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Halk 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782582143015', '8797722914e101baa4578694025ea8348a748303-1782582143015', false, '2026-06-27 20:42:23', 3, 0, true, false, '2026-06-27 20:42:23', '2026-06-27 21:37:23', 55);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782410467214') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATI-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782410467214', '8797722914e101baa4578694025ea8348a748303-1782410467214', false, '2026-06-25 21:01:07', 3, 0, true, false, '2026-06-25 21:01:07', '2026-06-25 21:49:07', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782150456379') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782150456379', '8797722914e101baa4578694025ea8348a748303-1782150456379', false, '2026-06-22 20:47:36', 3, 0, true, false, '2026-06-22 20:47:36', '2026-06-22 21:32:36', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '..2026 GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '8797722914e101baa4578694025ea8348a748303-1782147223764') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=8797722914e101baa4578694025ea8348a748303-1782147223764', '8797722914e101baa4578694025ea8348a748303-1782147223764', false, '2026-06-22 19:53:43', 3, 0, true, false, '2026-06-22 19:53:43', '2026-06-22 20:38:43', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765904343117') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Fiil, ek-fiil, fiilimsi)-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765904343117', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765904343117', false, '2025-12-16 19:59:03', 3, 0, true, false, '2025-12-16 19:59:03', '2025-12-16 20:42:03', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764093607775') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (zarf)-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1764093607775', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764093607775', false, '2025-11-25 21:00:07', 3, 0, true, false, '2025-11-25 21:00:07', '2025-11-25 21:41:07', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762876625215') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞEKİL/YAPI/BİÇİM BİLGİSİ ( Ek Bilgisi)-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762876625215', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762876625215', false, '2025-11-11 18:57:05', 3, 0, true, false, '2025-11-11 18:57:05', '2025-11-11 19:38:05', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764694180513') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (edat-bağlaç-ünlem)-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1764694180513', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764694180513', false, '2025-12-02 19:49:40', 3, 0, true, false, '2025-12-02 19:49:40', '2025-12-02 20:29:40', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761667470862') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ünsüzlerin Sınıflandırılması, Ses Olayları)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1761667470862', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761667470862', false, '2025-10-28 19:04:30', 3, 0, true, false, '2025-10-28 19:04:30', '2025-10-28 19:45:30', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1763484907257') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük Türleri (İsim, zamir)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1763484907257', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1763484907257', false, '2025-11-18 19:55:07', 3, 0, true, false, '2025-11-18 19:55:07', '2025-11-18 20:38:07', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765303658813') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Fiil, ek-fiil, fiilimsi)-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765303658813', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765303658813', false, '2025-12-09 21:07:38', 3, 0, true, false, '2025-12-09 21:07:38', '2025-12-09 21:33:38', 26);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762880060255') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞEKİL/YAPI/BİÇİM BİLGİSİ ( Ek Bilgisi)-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762880060255', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762880060255', false, '2025-11-11 19:54:20', 3, 0, true, false, '2025-11-11 19:54:20', '2025-11-11 20:38:20', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767718047669') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Fiilde Çatı, o biterse cümle çeşitleri:) )-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1767718047669', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767718047669', false, '2026-01-06 19:47:27', 3, 0, true, false, '2026-01-06 19:47:27', '2026-01-06 20:27:27', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762883396800') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞEKİL/YAPI/BİÇİM BİLGİSİ ( Ek Bilgisi)-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762883396800', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762883396800', false, '2025-11-11 20:49:56', 3, 0, true, false, '2025-11-11 20:49:56', '2025-11-11 21:31:56', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761061891796') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ses Bilgisiyle İlgili Kavramlar ve Türkçenin Ses Özellikleri)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1761061891796', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761061891796', false, '2025-10-21 18:51:31', 3, 0, true, false, '2025-10-21 18:51:31', '2025-10-21 19:35:31', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1766505079577') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Kelime Grupları)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1766505079577', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1766505079577', false, '2025-12-23 18:51:19', 3, 0, true, false, '2025-12-23 18:51:19', '2025-12-23 19:31:19', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764090357321') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (sıfat)-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1764090357321', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764090357321', false, '2025-11-25 20:05:57', 3, 0, true, false, '2025-11-25 20:05:57', '2025-11-25 20:47:57', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1768319892817') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Cümle Çeşitleri)-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1768319892817', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1768319892817', false, '2026-01-13 18:58:12', 3, 0, true, false, '2026-01-13 18:58:12', '2026-01-13 19:37:12', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765302571856') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Tamlamalar)-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765302571856', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765302571856', false, '2025-12-09 20:49:31', 3, 0, true, false, '2025-12-09 20:49:31', '2025-12-09 21:04:31', 15);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765907663421') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Fiil, ek-fiil, fiilimsi)-14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765907663421', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765907663421', false, '2025-12-16 20:54:23', 3, 0, true, false, '2025-12-16 20:54:23', '2025-12-16 21:31:23', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767110325898') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Cümlenin Ögeleri)-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1767110325898', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767110325898', false, '2025-12-30 18:58:45', 3, 0, true, false, '2025-12-30 18:58:45', '2025-12-30 19:38:45', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1768322916254') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Cümle Çeşitleri)-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1768322916254', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1768322916254', false, '2026-01-13 19:48:36', 3, 0, true, false, '2026-01-13 19:48:36', '2026-01-13 20:29:36', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1768326315853') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2025 ÇIKMIŞ DİL BİLGİSİ SORULAR ÇÖZÜMÜ VE VEDA :((', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1768326315853', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1768326315853', false, '2026-01-13 20:45:15', 3, 0, true, false, '2026-01-13 20:45:15', '2026-01-13 21:39:15', 54);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1766511571304') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Cümlenin Ögeleri)-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1766511571304', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1766511571304', false, '2025-12-23 20:39:31', 3, 0, true, false, '2025-12-23 20:39:31', '2025-12-23 21:18:31', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761674131678') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ünsüzlerin Sınıflandırılması, Ses Olayları)-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1761674131678', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761674131678', false, '2025-10-28 20:55:31', 3, 0, true, false, '2025-10-28 20:55:31', '2025-10-28 21:40:31', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1766508537194') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Kelime Grupları-Kısaltma Grupları-Cümlenin Ögeleri)-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1766508537194', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1766508537194', false, '2025-12-23 19:48:57', 3, 0, true, false, '2025-12-23 19:48:57', '2025-12-23 20:29:57', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761670764877') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ünsüzlerin Sınıflandırılması, Ses Olayları)-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1761670764877', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761670764877', false, '2025-10-28 19:59:24', 3, 0, true, false, '2025-10-28 19:59:24', '2025-10-28 20:38:24', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761065900455') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ses Bilgisiyle İlgili Kavramlar ve Türkçenin Ses Özellikleri)-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1761065900455', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761065900455', false, '2025-10-21 19:58:20', 3, 0, true, false, '2025-10-21 19:58:20', '2025-10-21 20:38:20', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762277346394') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞEKİL/YAPI/BİÇİM BİLGİSİ (Kök)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762277346394', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762277346394', false, '2025-11-04 20:29:06', 3, 0, true, false, '2025-11-04 20:29:06', '2025-11-04 20:55:06', 26);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767714711064') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Fiilde Çatı, o biterse cümle çeşitleri:) )-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1767714711064', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767714711064', false, '2026-01-06 18:51:51', 3, 0, true, false, '2026-01-06 18:51:51', '2026-01-06 19:31:51', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765900803434') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Fiil, ek-fiil, fiilimsi)-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765900803434', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765900803434', false, '2025-12-16 19:00:03', 3, 0, true, false, '2025-12-16 19:00:03', '2025-12-16 19:43:03', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764086241847') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük Türleri (Sıfat)-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1764086241847', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764086241847', false, '2025-11-25 18:57:21', 3, 0, true, false, '2025-11-25 18:57:21', '2025-11-25 19:38:21', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765299265267') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Tamlamalar)-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765299265267', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765299265267', false, '2025-12-09 19:54:25', 3, 0, true, false, '2025-12-09 19:54:25', '2025-12-09 20:35:25', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762279879029') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞEKİL/YAPI/BİÇİM BİLGİSİ (Kök + Ek Bilgisi)-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762279879029', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762279879029', false, '2025-11-04 21:11:19', 3, 0, true, false, '2025-11-04 21:11:19', '2025-11-04 21:52:19', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764691059251') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (zarf ve edat-bağlaç-ünlem)-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1764691059251', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764691059251', false, '2025-12-02 18:57:39', 3, 0, true, false, '2025-12-02 18:57:39', '2025-12-02 19:37:39', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767721140957') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '37. CÜMLE BİLGİSİ (Cümle Çeşitleri)-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1767721140957', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767721140957', false, '2026-01-06 20:39:00', 3, 0, true, false, '2026-01-06 20:39:00', '2026-01-06 21:18:00', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761069433362') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ünlülerin Sınıflandırılması, Ünlü Olayları)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1761069433362', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1761069433362', false, '2025-10-21 20:57:13', 3, 0, true, false, '2025-10-21 20:57:13', '2025-10-21 21:38:13', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767116615785') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Fiilde Çatı)-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1767116615785', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767116615785', false, '2025-12-30 20:43:35', 3, 0, true, false, '2025-12-30 20:43:35', '2025-12-30 21:21:35', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1763488307743') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük Türleri (Zamir)-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1763488307743', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1763488307743', false, '2025-11-18 20:51:47', 3, 0, true, false, '2025-11-18 20:51:47', '2025-11-18 21:34:47', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767113329951') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLE BİLGİSİ (Cümlenin Ögeleri ve yetişirse Fiilde Çatı:) )-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1767113329951', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1767113329951', false, '2025-12-30 19:48:49', 3, 0, true, false, '2025-12-30 19:48:49', '2025-12-30 20:29:49', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765295662243') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (Tamlamalar)-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1765295662243', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1765295662243', false, '2025-12-09 18:54:22', 3, 0, true, false, '2025-12-09 18:54:22', '2025-12-09 19:34:22', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764697480704') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Sözcük türleri (edat-bağlaç-ünlem)-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1764697480704', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1764697480704', false, '2025-12-02 20:44:40', 3, 0, true, false, '2025-12-02 20:44:40', '2025-12-02 21:25:40', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762275525759') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ünsüzlerin Sınıflandırılması, Ses Olayları)-5 KESİN SON :)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762275525759', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762275525759', false, '2025-11-04 19:58:45', 3, 0, true, false, '2025-11-04 19:58:45', '2025-11-04 20:14:45', 16);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762271959608') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLGİSİ/FONETİK (Ünsüzlerin Sınıflandırılması, Ses Olayları)-4 SON', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1762271959608', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1762271959608', false, '2025-11-04 18:59:19', 3, 0, true, false, '2025-11-04 18:59:19', '2025-11-04 19:42:19', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'dc12c9d877c70209ea7d0274e884c99ee397001f-1763481587281') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞEKİL/YAPI/BİÇİM BİLGİSİ ( Yapısı Bakımından Sözcükler)-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=dc12c9d877c70209ea7d0274e884c99ee397001f-1763481587281', 'dc12c9d877c70209ea7d0274e884c99ee397001f-1763481587281', false, '2025-11-18 18:59:47', 3, 0, true, false, '2025-11-18 18:59:47', '2025-11-18 19:40:47', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773510552492') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edim Bilimi (Pragmatik) - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773510552492', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773510552492', false, '2026-03-14 20:49:12', 3, 0, true, false, '2026-03-14 20:49:12', '2026-03-14 21:34:12', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764954952539') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM DİL BİLİM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764954952539', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764954952539', false, '2025-12-05 20:15:52', 3, 0, true, false, '2025-12-05 20:15:52', '2025-12-05 20:33:52', 18);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762530623832') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'PARÇAÜSTÜ SESBİRİMLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762530623832', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762530623832', false, '2025-11-07 18:50:23', 3, 0, true, false, '2025-11-07 18:50:23', '2025-11-07 19:33:23', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772908809802') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edim Bilimi (Pragmatik) - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772908809802', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772908809802', false, '2026-03-07 21:40:09', 3, 0, true, false, '2026-03-07 21:40:09', '2026-03-07 22:18:09', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766165821699') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SAUSSURE - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766165821699', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766165821699', false, '2025-12-19 20:37:01', 3, 0, true, false, '2025-12-19 20:37:01', '2025-12-19 21:09:01', 32);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761929156139') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM ALT DALLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761929156139', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761929156139', false, '2025-10-31 19:45:56', 3, 0, true, false, '2025-10-31 19:45:56', '2025-10-31 20:28:56', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767368858945') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'NOAM CHOMSKY - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767368858945', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767368858945', false, '2026-01-02 18:47:38', 3, 0, true, false, '2026-01-02 18:47:38', '2026-01-02 19:29:38', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772905790982') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Anlam Bilimi (Semantik) - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772905790982', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772905790982', false, '2026-03-07 20:49:50', 3, 0, true, false, '2026-03-07 20:49:50', '2026-03-07 21:29:50', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770742120229') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLİMİ (FONOLOJİ) - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770742120229', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770742120229', false, '2026-02-10 19:48:40', 3, 0, true, false, '2026-02-10 19:48:40', '2026-02-10 20:27:40', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766770941174') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MODERN DİL BİLİM OKULLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766770941174', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766770941174', false, '2025-12-26 20:42:21', 3, 0, true, false, '2025-12-26 20:42:21', '2025-12-26 21:22:21', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773507463220') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edim Bilimi (Pragmatik) - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773507463220', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773507463220', false, '2026-03-14 19:57:43', 3, 0, true, false, '2026-03-14 19:57:43', '2026-03-14 20:37:43', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763739877718') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'GÖSTERGEBİLİM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763739877718', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763739877718', false, '2025-11-21 18:44:37', 3, 0, true, false, '2025-11-21 18:44:37', '2025-11-21 19:27:37', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761324082003') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİLLERİN SINIFLANDIRILMASI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761324082003', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761324082003', false, '2025-10-24 19:41:22', 3, 0, true, false, '2025-10-24 19:41:22', '2025-10-24 20:29:22', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770748163149') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİÇİM BİLİMİ (MORFOLOJİ) - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770748163149', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770748163149', false, '2026-02-10 21:29:23', 3, 0, true, false, '2026-02-10 21:29:23', '2026-02-10 22:08:23', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766774215419') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MODERN DİL BİLİM OKULLARI - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766774215419', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766774215419', false, '2025-12-26 21:36:55', 3, 0, true, false, '2025-12-26 21:36:55', '2025-12-26 22:16:55', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772297968823') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TÜMCE BİLİMİ (SÖZ DİZİMİ /SENTAKS) - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772297968823', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772297968823', false, '2026-02-28 19:59:28', 3, 0, true, false, '2026-02-28 19:59:28', '2026-02-28 20:39:28', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763134788743') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SEMANTİK - ANLAMBİLİM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763134788743', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763134788743', false, '2025-11-14 18:39:48', 3, 0, true, false, '2025-11-14 18:39:48', '2025-11-14 19:31:48', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764949522886') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİLBİLİM - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764949522886', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764949522886', false, '2025-12-05 18:45:22', 3, 0, true, false, '2025-12-05 18:45:22', '2025-12-05 19:26:22', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768754737302') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇIKMIŞ SORULAR - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768754737302', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768754737302', false, '2026-01-18 19:45:37', 3, 0, true, false, '2026-01-18 19:45:37', '2026-01-18 20:25:37', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765557958969') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM DİL BİLİM - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765557958969', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765557958969', false, '2025-12-12 19:45:58', 3, 0, true, false, '2025-12-12 19:45:58', '2025-12-12 20:23:58', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763143085935') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SEMANTİK - ANLAMBİLİM - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763143085935', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763143085935', false, '2025-11-14 20:58:05', 3, 0, true, false, '2025-11-14 20:58:05', '2025-11-14 21:51:05', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776008977692') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil Bilimi Okulları ve Temsilcileri - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776008977692', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776008977692', false, '2026-04-12 18:49:37', 3, 0, true, false, '2026-04-12 18:49:37', '2026-04-12 19:27:37', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766162508745') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SAUSSURE - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766162508745', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766162508745', false, '2025-12-19 19:41:48', 3, 0, true, false, '2025-12-19 19:41:48', '2025-12-19 20:22:48', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771692824243') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİÇİM BİLİMİ (MORFOLOJİ) -3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771692824243', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771692824243', false, '2026-02-21 19:53:44', 3, 0, true, false, '2026-02-21 19:53:44', '2026-02-21 20:33:44', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773513820855') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edim Bilimi (Pragmatik) - 4 SON ve yetişirse Gösterge Bilimi (Semiyotik) - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773513820855', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1773513820855', false, '2026-03-14 21:43:40', 3, 0, true, false, '2026-03-14 21:43:40', '2026-03-14 22:21:40', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761932443466') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FONETİK / FONOLOJİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761932443466', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761932443466', false, '2025-10-31 20:40:43', 3, 0, true, false, '2025-10-31 20:40:43', '2025-10-31 21:23:43', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762533907469') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'PARÇAÜSTÜ SESBİRİMLER - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762533907469', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762533907469', false, '2025-11-07 19:45:07', 3, 0, true, false, '2025-11-07 19:45:07', '2025-11-07 20:26:07', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766767793985') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MODERN DİL BİLİM OKULLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766767793985', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766767793985', false, '2025-12-26 19:49:53', 3, 0, true, false, '2025-12-26 19:49:53', '2025-12-26 20:29:53', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776012514117') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil Bilimi Okulları ve Temsilcileri - 5 GALİBA SON:((', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776012514117', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776012514117', false, '2026-04-12 19:48:34', 3, 0, true, false, '2026-04-12 19:48:34', '2026-04-12 20:27:34', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770137328869') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL, DİL TEORİLERİ VE DİL AİLELERİ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770137328869', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770137328869', false, '2026-02-03 19:48:48', 3, 0, true, false, '2026-02-03 19:48:48', '2026-02-03 20:08:48', 20);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763747072004') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİLBİLİM - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763747072004', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763747072004', false, '2025-11-21 20:44:32', 3, 0, true, false, '2025-11-21 20:44:32', '2025-11-21 21:09:32', 25);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763743493687') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİL BİLİM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763743493687', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763743493687', false, '2025-11-21 19:44:53', 3, 0, true, false, '2025-11-21 19:44:53', '2025-11-21 20:26:53', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775411066306') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil Bilimi Okulları ve Temsilcileri - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775411066306', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775411066306', false, '2026-04-05 20:44:26', 3, 0, true, false, '2026-04-05 20:44:26', '2026-04-05 21:21:26', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771699154733') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TÜMCE BİLİMİ (SÖZ DİZİMİ /SENTAKS) - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771699154733', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771699154733', false, '2026-02-21 21:39:14', 3, 0, true, false, '2026-02-21 21:39:14', '2026-02-21 22:17:14', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761327815103') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL DOĞUŞ TEORİLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761327815103', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761327815103', false, '2025-10-24 20:43:35', 3, 0, true, false, '2025-10-24 20:43:35', '2025-10-24 21:29:35', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767372360266') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'NOAM CHOMSKY - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767372360266', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767372360266', false, '2026-01-02 19:46:00', 3, 0, true, false, '2026-01-02 19:46:00', '2026-01-02 20:24:00', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1769533101478') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİMİ KURAMLARI VE DİL BİLİMİNİN ALT DALLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1769533101478', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1769533101478', false, '2026-01-27 19:58:21', 3, 0, true, false, '2026-01-27 19:58:21', '2026-01-27 20:48:21', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775404542888') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Metin Dil Bilimi -2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775404542888', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775404542888', false, '2026-04-05 18:55:42', 3, 0, true, false, '2026-04-05 18:55:42', '2026-04-05 19:34:42', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768751115047') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇIKMIŞ SORULAR - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768751115047', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768751115047', false, '2026-01-18 18:45:15', 3, 0, true, false, '2026-01-18 18:45:15', '2026-01-18 19:30:15', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770745143505') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLİMİ (FONOLOJİ) - 2 YETİŞİRSE BİÇİM BİLİMİ (NORFOLOJİ) - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770745143505', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770745143505', false, '2026-02-10 20:39:03', 3, 0, true, false, '2026-02-10 20:39:03', '2026-02-10 21:18:03', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763139681299') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SEMANTİK - ANLAMBİLİM - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763139681299', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1763139681299', false, '2025-11-14 20:01:21', 3, 0, true, false, '2025-11-14 20:01:21', '2025-11-14 20:45:21', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771696131927') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİÇİM BİLİMİ (MORFOLOJİ) -4 YETİŞİRSE TÜMCE BİLİMİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771696131927', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1771696131927', false, '2026-02-21 20:48:51', 3, 0, true, false, '2026-02-21 20:48:51', '2026-02-21 21:28:51', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774799766178') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Gösterge Bilimi (Semiyotik) - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774799766178', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774799766178', false, '2026-03-29 18:56:06', 3, 0, true, false, '2026-03-29 18:56:06', '2026-03-29 19:35:06', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770738260127') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL, DİL TEORİLERİ VE DİL AİLELERİ-2  VE BİTERSE SES BİLİMİ (FONOLOJİ) - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770738260127', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770738260127', false, '2026-02-10 18:44:20', 3, 0, true, false, '2026-02-10 18:44:20', '2026-02-10 19:24:20', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765554353975') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM DİL BİLİM - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765554353975', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765554353975', false, '2025-12-12 18:45:53', 3, 0, true, false, '2025-12-12 18:45:53', '2025-12-12 19:29:53', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768578207865') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'AÖF EK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768578207865', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768578207865', false, '2026-01-16 18:43:27', 3, 0, true, false, '2026-01-16 18:43:27', '2026-01-16 19:25:27', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774805973160') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Metin Dil Bilimi -1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774805973160', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774805973160', false, '2026-03-29 20:39:33', 3, 0, true, false, '2026-03-29 20:39:33', '2026-03-29 21:18:33', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775407676588') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil Bilimi Okulları ve Temsilcileri - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775407676588', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1775407676588', false, '2026-04-05 19:47:56', 3, 0, true, false, '2026-04-05 19:47:56', '2026-04-05 20:29:56', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765561240504') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'GELENEKSEL DİL BİLİM OKULLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765561240504', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1765561240504', false, '2025-12-12 20:40:40', 3, 0, true, false, '2025-12-12 20:40:40', '2025-12-12 21:19:40', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768581877659') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FONETİK', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768581877659', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1768581877659', false, '2026-01-16 19:44:37', 3, 0, true, false, '2026-01-16 19:44:37', '2026-01-16 20:19:37', 35);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766159447573') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SAUSSURE - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766159447573', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1766159447573', false, '2025-12-19 18:50:47', 3, 0, true, false, '2025-12-19 18:50:47', '2025-12-19 19:29:47', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767375598429') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İŞLEVSELCİLİK VE POSTMODERNİZM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767375598429', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1767375598429', false, '2026-01-02 20:39:58', 3, 0, true, false, '2026-01-02 20:39:58', '2026-01-02 21:16:58', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776015526368') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil Bilimi Okulları ve Temsilcileri - 5 KURANIMA SON. :)) VEDA :(((', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776015526368', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1776015526368', false, '2026-04-12 20:38:46', 3, 0, true, false, '2026-04-12 20:38:46', '2026-04-12 21:26:46', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1769528989173') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİMİNE GİRİŞ, DİL BİLİMİ KURAMLARI VE DİL BİLİMİNİN ALT DALLARI - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1769528989173', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1769528989173', false, '2026-01-27 18:49:49', 3, 0, true, false, '2026-01-27 18:49:49', '2026-01-27 19:39:49', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772301210641') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TÜMCE BİLİMİ (SÖZ DİZİMİ /SENTAKS) - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772301210641', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772301210641', false, '2026-02-28 20:53:30', 3, 0, true, false, '2026-02-28 20:53:30', '2026-02-28 21:33:30', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761320779039') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'GİRİŞ - TANIŞMA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761320779039', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761320779039', false, '2025-10-24 18:46:19', 3, 0, true, false, '2025-10-24 18:46:19', '2025-10-24 19:24:19', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772304267414') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TÜMCE BİLİMİ (SÖZ DİZİMİ /SENTAKS) - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772304267414', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772304267414', false, '2026-02-28 21:44:27', 3, 0, true, false, '2026-02-28 21:44:27', '2026-02-28 22:28:27', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764952967259') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİLBİLİM - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764952967259', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764952967259', false, '2025-12-05 19:42:47', 3, 0, true, false, '2025-12-05 19:42:47', '2025-12-05 20:02:47', 20);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764956294744') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM DİL BİLİM - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764956294744', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1764956294744', false, '2025-12-05 20:38:14', 3, 0, true, false, '2025-12-05 20:38:14', '2025-12-05 21:28:14', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761926041308') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM ALT DALLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761926041308', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1761926041308', false, '2025-10-31 18:54:01', 3, 0, true, false, '2025-10-31 18:54:01', '2025-10-31 19:33:01', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770134335596') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL, DİL TEORİLERİ VE DİL AİLELERİ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770134335596', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1770134335596', false, '2026-02-03 18:58:55', 3, 0, true, false, '2026-02-03 18:58:55', '2026-02-03 19:38:55', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762537160324') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MORFOLOJİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762537160324', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1762537160324', false, '2025-11-07 20:39:20', 3, 0, true, false, '2025-11-07 20:39:20', '2025-11-07 21:19:20', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772902178383') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLAM BİLİMİ (SEMANTİK) - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772902178383', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1772902178383', false, '2026-03-07 19:49:38', 3, 0, true, false, '2026-03-07 19:49:38', '2026-03-07 20:29:38', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774802932809') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Gösterge Bilimi (Semiyotik) - 3 BELKİ Metin Bilimine de gireriz. :))', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774802932809', '63f2e14f54fa66ec3aceda1ecb023cfc40028865-1774802932809', false, '2026-03-29 19:48:52', 3, 0, true, false, '2026-03-29 19:48:52', '2026-03-29 20:27:52', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764438477006') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME ÖĞRETİMİNİN AMAÇLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764438477006', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764438477006', false, '2025-11-29 20:47:57', 3, 0, true, false, '2025-11-29 20:47:57', '2025-11-29 21:36:57', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764434976340') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME BECERİSİNİ GELİŞTİRME ÇALIŞMALARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764434976340', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764434976340', false, '2025-11-29 19:49:36', 3, 0, true, false, '2025-11-29 19:49:36', '2025-11-29 20:31:36', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771001085963') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA ÇIKMIŞ SORULAR - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771001085963', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771001085963', false, '2026-02-13 19:44:45', 3, 0, true, false, '2026-02-13 19:44:45', '2026-02-13 20:05:45', 21);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762623973398') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ KAZANIMLARI - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762623973398', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762623973398', false, '2025-11-08 20:46:13', 3, 0, true, false, '2025-11-08 20:46:13', '2025-11-08 21:32:13', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763829989305') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ GİRİŞ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763829989305', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763829989305', false, '2025-11-22 19:46:29', 3, 0, true, false, '2025-11-22 19:46:29', '2025-11-22 20:24:29', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762018884531') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ KAZANIMLARI - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762018884531', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762018884531', false, '2025-11-01 20:41:24', 3, 0, true, false, '2025-11-01 20:41:24', '2025-11-01 21:24:24', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762011997895') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762011997895', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762011997895', false, '2025-11-01 18:46:37', 3, 0, true, false, '2025-11-01 18:46:37', '2025-11-01 19:27:37', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779639425016') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLAMA MODELLERİ VE BLOOM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779639425016', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779639425016', false, '2026-05-24 19:17:05', 3, 0, true, false, '2026-05-24 19:17:05', '2026-05-24 19:56:05', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765035842388') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEMEYİ ETKİLEYEN FAKTÖRLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765035842388', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765035842388', false, '2025-12-06 18:44:02', 3, 0, true, false, '2025-12-06 18:44:02', '2025-12-06 19:30:02', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778953008558') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN VE ANLAM KURMA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778953008558', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778953008558', false, '2026-05-16 20:36:48', 3, 0, true, false, '2026-05-16 20:36:48', '2026-05-16 21:16:48', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779557524134') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SEZDİRME YÖNTEMİ VE ANLAM KURMA DÜZEYLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779557524134', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779557524134', false, '2026-05-23 20:32:04', 3, 0, true, false, '2026-05-23 20:32:04', '2026-05-23 21:07:04', 35);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771346827788') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA TÜRLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771346827788', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771346827788', false, '2026-02-17 19:47:07', 3, 0, true, false, '2026-02-17 19:47:07', '2026-02-17 20:32:07', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766857384227') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'PARÇAÜSTÜ SESBİRİMLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766857384227', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766857384227', false, '2025-12-27 20:43:04', 3, 0, true, false, '2025-12-27 20:43:04', '2025-12-27 21:29:04', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763225383429') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ KAZANIMLARI - 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763225383429', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763225383429', false, '2025-11-15 19:49:43', 3, 0, true, false, '2025-11-15 19:49:43', '2025-11-15 20:29:43', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771350702719') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMAYI GELİŞTİRİCİ TEKNİKLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771350702719', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771350702719', false, '2026-02-17 20:51:42', 3, 0, true, false, '2026-02-17 20:51:42', '2026-02-17 21:31:42', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771951724009') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA TÜR, YÖNTEM VE TEKNİKLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771951724009', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771951724009', false, '2026-02-24 19:48:44', 3, 0, true, false, '2026-02-24 19:48:44', '2026-02-24 20:35:44', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761414226425') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ KAZANIMLARI - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761414226425', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761414226425', false, '2025-10-25 20:43:46', 3, 0, true, false, '2025-10-25 20:43:46', '2025-10-25 21:32:46', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765043811628') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME TÜRLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765043811628', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765043811628', false, '2025-12-06 20:56:51', 3, 0, true, false, '2025-12-06 20:56:51', '2025-12-06 21:42:51', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766245615693') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ GİRİŞ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766245615693', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766245615693', false, '2025-12-20 18:46:55', 3, 0, true, false, '2025-12-20 18:46:55', '2025-12-20 19:29:55', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767462448962') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA YÖNTEM VE TEKNİKLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767462448962', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767462448962', false, '2026-01-03 20:47:28', 3, 0, true, false, '2026-01-03 20:47:28', '2026-01-03 21:28:28', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763228487945') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763228487945', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763228487945', false, '2025-11-15 20:41:27', 3, 0, true, false, '2025-11-15 20:41:27', '2025-11-15 21:30:27', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772559942626') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ GİRİŞ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772559942626', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772559942626', false, '2026-03-03 20:45:42', 3, 0, true, false, '2026-03-03 20:45:42', '2026-03-03 21:21:42', 36);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769877881529') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUDUĞUNU ANLAMA SÜRECİNİN AŞAMALARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769877881529', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769877881529', false, '2026-01-31 19:44:41', 3, 0, true, false, '2026-01-31 19:44:41', '2026-01-31 20:23:41', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766850881281') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İYİ BİR KONUŞMADA SES ÖZELLİKLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766850881281', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766850881281', false, '2025-12-27 18:54:41', 3, 0, true, false, '2025-12-27 18:54:41', '2025-12-27 19:03:41', 9);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765039711428') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEYİCİ TİPLERİ VE YANLIŞ DİNLEYİCİ TÜRLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765039711428', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765039711428', false, '2025-12-06 19:48:31', 3, 0, true, false, '2025-12-06 19:48:31', '2025-12-06 20:43:31', 55);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779642590344') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BLOOM TAKSONOMİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779642590344', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779642590344', false, '2026-05-24 20:09:50', 3, 0, true, false, '2026-05-24 20:09:50', '2026-05-24 20:55:50', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765644195425') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME YÖNTEM VE TEKNİKLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765644195425', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765644195425', false, '2025-12-13 19:43:15', 3, 0, true, false, '2025-12-13 19:43:15', '2025-12-13 20:30:15', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778946272098') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖLÇME VE DEĞERLENDİRME', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778946272098', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778946272098', false, '2026-05-16 18:44:32', 3, 0, true, false, '2026-05-16 18:44:32', '2026-05-16 19:27:32', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766252543937') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA BECERİSİNİ GELİŞTİRME ÇALIŞMALARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766252543937', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766252543937', false, '2025-12-20 20:42:23', 3, 0, true, false, '2025-12-20 20:42:23', '2025-12-20 21:17:23', 35);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769880981213') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA STRATEJİLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769880981213', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769880981213', false, '2026-01-31 20:36:21', 3, 0, true, false, '2026-01-31 20:36:21', '2026-01-31 21:17:21', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768409163819') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZLÜ ANLATIM TÜRLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768409163819', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768409163819', false, '2026-01-14 19:46:03', 3, 0, true, false, '2026-01-14 19:46:03', '2026-01-14 20:31:03', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763833190744') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME STRATEJİLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763833190744', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763833190744', false, '2025-11-22 20:39:50', 3, 0, true, false, '2025-11-22 20:39:50', '2025-11-22 21:21:50', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768405716447') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA YÖNTEM VE TEKNİKLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768405716447', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768405716447', false, '2026-01-14 18:48:36', 3, 0, true, false, '2026-01-14 18:48:36', '2026-01-14 19:31:36', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773596810938') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÜREÇ TEMELLİ YAZMA YÖNTEMİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773596810938', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773596810938', false, '2026-03-15 20:46:50', 3, 0, true, false, '2026-03-15 20:46:50', '2026-03-15 21:23:50', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770482966777') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ZİHİNSEL SÖZLÜK VE SÖZCÜK ÖĞRETİM YÖNTEMLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770482966777', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770482966777', false, '2026-02-07 19:49:26', 3, 0, true, false, '2026-02-07 19:49:26', '2026-02-07 20:32:26', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770486607289') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA ÇIKMIŞ SORULAR - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770486607289', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770486607289', false, '2026-02-07 20:50:07', 3, 0, true, false, '2026-02-07 20:50:07', '2026-02-07 21:38:07', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766853929233') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'PARÇAÜSTÜ SESBİRİMLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766853929233', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766853929233', false, '2025-12-27 19:45:29', 3, 0, true, false, '2025-12-27 19:45:29', '2025-12-27 20:25:29', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766249219401') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMANIN UNSURLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766249219401', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766249219401', false, '2025-12-20 19:46:59', 3, 0, true, false, '2025-12-20 19:46:59', '2025-12-20 20:27:59', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761410921084') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ KAZANIMLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761410921084', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761410921084', false, '2025-10-25 19:48:41', 3, 0, true, false, '2025-10-25 19:48:41', '2025-10-25 20:31:41', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761407434641') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ KAZANIMLARI - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761407434641', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1761407434641', false, '2025-10-25 18:50:34', 3, 0, true, false, '2025-10-25 18:50:34', '2025-10-25 19:36:34', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766851990345') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İYİ BİR KONUŞMADA SESİN ÖZELLİKLERİ - (YENİDEN)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766851990345', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1766851990345', false, '2025-12-27 19:13:10', 3, 0, true, false, '2025-12-27 19:13:10', '2025-12-27 19:39:10', 26);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771003294333') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK ÖĞRETİM YÖNTEMLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771003294333', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771003294333', false, '2026-02-13 20:21:34', 3, 0, true, false, '2026-02-13 20:21:34', '2026-02-13 20:45:34', 24);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771005018513') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA MODELLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771005018513', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771005018513', false, '2026-02-13 20:50:18', 3, 0, true, false, '2026-02-13 20:50:18', '2026-02-13 21:29:18', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765640573155') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME TÜRLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765640573155', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765640573155', false, '2025-12-13 18:42:53', 3, 0, true, false, '2025-12-13 18:42:53', '2025-12-13 19:22:53', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770997760469') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA ÇIKMIŞ SORULAR - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770997760469', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770997760469', false, '2026-02-13 18:49:20', 3, 0, true, false, '2026-02-13 18:49:20', '2026-02-13 19:30:20', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773593341229') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÜRÜN VE SÜREÇ ODAKLI YAZMA YAKLAŞIMI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773593341229', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773593341229', false, '2026-03-15 19:49:01', 3, 0, true, false, '2026-03-15 19:49:01', '2026-03-15 20:34:01', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771955353811') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA TÜR, YÖNTEM VE TEKNİKLERİ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771955353811', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771955353811', false, '2026-02-24 20:49:13', 3, 0, true, false, '2026-02-24 20:49:13', '2026-02-24 21:29:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773769523249') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA TÜR, YÖNTEM VE TEKNİKLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773769523249', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773769523249', false, '2026-03-17 20:45:23', 3, 0, true, false, '2026-03-17 20:45:23', '2026-03-17 21:33:23', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763826830522') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ KAZANIMLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763826830522', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763826830522', false, '2025-11-22 18:53:50', 3, 0, true, false, '2025-11-22 18:53:50', '2025-11-22 19:38:50', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779554374357') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YÖNTEM VE TEKNİKLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779554374357', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779554374357', false, '2026-05-23 19:39:34', 3, 0, true, false, '2026-05-23 19:39:34', '2026-05-23 20:18:34', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764431573150') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME BECERİSİNİ GELİŞTİRME ÇALIŞMALARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764431573150', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1764431573150', false, '2025-11-29 18:52:53', 3, 0, true, false, '2025-11-29 18:52:53', '2025-11-29 19:39:53', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772556751476') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZ VARLIĞI ÇALIŞMALARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772556751476', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772556751476', false, '2026-03-03 19:52:31', 3, 0, true, false, '2026-03-03 19:52:31', '2026-03-03 20:36:31', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770479177330') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİNİN AMAÇLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770479177330', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1770479177330', false, '2026-02-07 18:46:17', 3, 0, true, false, '2026-02-07 18:46:17', '2026-02-07 19:33:17', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769874843817') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA ALT ALANLARI VE İLKELERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769874843817', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1769874843817', false, '2026-01-31 18:54:03', 3, 0, true, false, '2026-01-31 18:54:03', '2026-01-31 19:33:03', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768412772581') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZLÜ ANLATIM TÜRLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768412772581', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768412772581', false, '2026-01-14 20:46:12', 3, 0, true, false, '2026-01-14 20:46:12', '2026-01-14 21:18:12', 32);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768664880867') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ SON DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768664880867', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768664880867', false, '2026-01-17 18:48:00', 3, 0, true, false, '2026-01-17 18:48:00', '2026-01-17 19:14:00', 26);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779551071164') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN YAPILARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779551071164', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1779551071164', false, '2026-05-23 18:44:31', 3, 0, true, false, '2026-05-23 18:44:31', '2026-05-23 19:23:31', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1774626249649') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1774626249649', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1774626249649', false, '2026-03-27 18:44:09', 3, 0, true, false, '2026-03-27 18:44:09', '2026-03-27 19:26:09', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768667248921') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ GİRİŞ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768667248921', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1768667248921', false, '2026-01-17 19:27:28', 3, 0, true, false, '2026-01-17 19:27:28', '2026-01-17 19:53:28', 26);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767455350550') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA BOZUKLUKLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767455350550', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767455350550', false, '2026-01-03 18:49:10', 3, 0, true, false, '2026-01-03 18:49:10', '2026-01-03 19:36:10', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778949958698') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLGİSİ ANLAYIŞLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778949958698', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1778949958698', false, '2026-05-16 19:45:58', 3, 0, true, false, '2026-05-16 19:45:58', '2026-05-16 20:20:58', 35);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762015800259') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ KAZANIMLAR - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762015800259', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762015800259', false, '2025-11-01 19:50:00', 3, 0, true, false, '2025-11-01 19:50:00', '2025-11-01 20:29:00', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773765736538') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA TÜR, YÖNTEM VE TEKNİKLERİ - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773765736538', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773765736538', false, '2026-03-17 19:42:16', 3, 0, true, false, '2026-03-17 19:42:16', '2026-03-17 20:26:16', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767458964432') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA BOZUKLUKLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767458964432', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1767458964432', false, '2026-01-03 19:49:24', 3, 0, true, false, '2026-01-03 19:49:24', '2026-01-03 20:30:24', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762620363321') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA KAZANIMLARI - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762620363321', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762620363321', false, '2025-11-08 19:46:03', 3, 0, true, false, '2025-11-08 19:46:03', '2025-11-08 20:28:03', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763221612875') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ KAZANIMLARI - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763221612875', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1763221612875', false, '2025-11-15 18:46:52', 3, 0, true, false, '2025-11-15 18:46:52', '2025-11-15 19:32:52', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773599886155') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA SÜRECİNDE GÖRÜLEN HATALAR', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773599886155', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773599886155', false, '2026-03-15 21:38:06', 3, 0, true, false, '2026-03-15 21:38:06', '2026-03-15 22:10:06', 32);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762617019269') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ KAZANIMLARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762617019269', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1762617019269', false, '2025-11-08 18:50:19', 3, 0, true, false, '2025-11-08 18:50:19', '2025-11-08 19:34:19', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773773320632') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLATIM BİÇİMLERİNİN ÖĞRETİMİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773773320632', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1773773320632', false, '2026-03-17 21:48:40', 3, 0, true, false, '2026-03-17 21:48:40', '2026-03-17 22:09:40', 21);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771958866270') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZ VARLIĞI ÇALIŞMALARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771958866270', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771958866270', false, '2026-02-24 21:47:46', 3, 0, true, false, '2026-02-24 21:47:46', '2026-02-24 22:29:46', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772563014818') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA BECERİSİNİN ALT ALANLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772563014818', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1772563014818', false, '2026-03-03 21:36:54', 3, 0, true, false, '2026-03-03 21:36:54', '2026-03-03 22:09:54', 33);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1774629812266') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ SORU ÇÖZÜMÜ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1774629812266', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1774629812266', false, '2026-03-27 19:43:32', 3, 0, true, false, '2026-03-27 19:43:32', '2026-03-27 20:16:32', 33);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771354003259') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA TÜR, YÖNTEM VE TEKNİKLERİ - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771354003259', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1771354003259', false, '2026-02-17 21:46:43', 3, 0, true, false, '2026-02-17 21:46:43', '2026-02-17 22:28:43', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765647787673') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME YÖNTEM VE TEKNİKLERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765647787673', '2b34ff093a4fe562ccbd4d1dec9defa11fabe2e9-1765647787673', false, '2025-12-13 20:43:07', 3, 0, true, false, '2025-12-13 20:43:07', '2025-12-13 21:15:07', 32);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765730702530') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ingiliz 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765730702530', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765730702530', false, '2025-12-14 19:45:02', 3, 0, true, false, '2025-12-14 19:45:02', '2025-12-14 20:34:02', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767546401616') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Rus ed. 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767546401616', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767546401616', false, '2026-01-04 20:06:41', 3, 0, true, false, '2026-01-04 20:06:41', '2026-01-04 20:49:41', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768153972207') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eleştiri ve kuram 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768153972207', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768153972207', false, '2026-01-11 20:52:52', 3, 0, true, false, '2026-01-11 20:52:52', '2026-01-11 21:41:52', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767549994531') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Diğer Dünya ED.', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767549994531', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767549994531', false, '2026-01-04 21:06:34', 3, 0, true, false, '2026-01-04 21:06:34', '2026-01-04 21:51:34', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763913107250') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Fransız 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763913107250', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763913107250', false, '2025-11-23 18:51:47', 3, 0, true, false, '2025-11-23 18:51:47', '2025-11-23 19:35:47', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763312098477') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Fransız Edebiyatı', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763312098477', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763312098477', false, '2025-11-16 19:54:58', 3, 0, true, false, '2025-11-16 19:54:58', '2025-11-16 20:39:58', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768150902982') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eleştiri ve kuram', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768150902982', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768150902982', false, '2026-01-11 20:01:42', 3, 0, true, false, '2026-01-11 20:01:42', '2026-01-11 20:45:42', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762098429968') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Akımlar 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762098429968', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762098429968', false, '2025-11-02 18:47:09', 3, 0, true, false, '2025-11-02 18:47:09', '2025-11-02 19:30:09', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761497407616') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'AKIMLAR 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761497407616', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761497407616', false, '2025-10-26 19:50:07', 3, 0, true, false, '2025-10-26 19:50:07', '2025-10-26 20:35:07', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762106002223') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Akımlar 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762106002223', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762106002223', false, '2025-11-02 20:53:22', 3, 0, true, false, '2025-11-02 20:53:22', '2025-11-02 21:38:22', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765121850500') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'fransız 10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765121850500', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765121850500', false, '2025-12-07 18:37:30', 3, 0, true, false, '2025-12-07 18:37:30', '2025-12-07 19:18:30', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766944790954') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Rus Ed.', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766944790954', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766944790954', false, '2025-12-28 20:59:50', 3, 0, true, false, '2025-12-28 20:59:50', '2025-12-28 21:44:50', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765129772746') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ingiliz 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765129772746', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765129772746', false, '2025-12-07 20:49:32', 3, 0, true, false, '2025-12-07 20:49:32', '2025-12-07 21:30:32', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766940667791') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'italyan 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766940667791', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766940667791', false, '2025-12-28 19:51:07', 3, 0, true, false, '2025-12-28 19:51:07', '2025-12-28 20:37:07', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763307895694') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Hız testi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763307895694', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763307895694', false, '2025-11-16 18:44:55', 3, 0, true, false, '2025-11-16 18:44:55', '2025-11-16 19:30:55', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765727539262') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İngiliz 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765727539262', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765727539262', false, '2025-12-14 18:52:19', 3, 0, true, false, '2025-12-14 18:52:19', '2025-12-14 19:33:19', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767553170247') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİĞER 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767553170247', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767553170247', false, '2026-01-04 21:59:30', 3, 0, true, false, '2026-01-04 21:59:30', '2026-01-04 22:51:30', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762711030531') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'akım 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762711030531', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762711030531', false, '2025-11-09 20:57:10', 3, 0, true, false, '2025-11-09 20:57:10', '2025-11-09 21:44:10', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761493762352') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Akımlar 1. ders', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761493762352', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761493762352', false, '2025-10-26 18:49:22', 3, 0, true, false, '2025-10-26 18:49:22', '2025-10-26 19:32:22', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761501111805') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'AKIMLAR 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761501111805', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1761501111805', false, '2025-10-26 20:51:51', 3, 0, true, false, '2025-10-26 20:51:51', '2025-10-26 21:38:51', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766936653945') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Amerikan son', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766936653945', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766936653945', false, '2025-12-28 18:44:13', 3, 0, true, false, '2025-12-28 18:44:13', '2025-12-28 19:30:13', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764521443737') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'fransız 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764521443737', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764521443737', false, '2025-11-30 19:50:43', 3, 0, true, false, '2025-11-30 19:50:43', '2025-11-30 20:30:43', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765734766426') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Alman 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765734766426', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765734766426', false, '2025-12-14 20:52:46', 3, 0, true, false, '2025-12-14 20:52:46', '2025-12-14 21:33:46', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764525093226') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'fransız 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764525093226', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764525093226', false, '2025-11-30 20:51:33', 3, 0, true, false, '2025-11-30 20:51:33', '2025-11-30 21:37:33', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762101882306') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Akımlar 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762101882306', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762101882306', false, '2025-11-02 19:44:42', 3, 0, true, false, '2025-11-02 19:44:42', '2025-11-02 20:29:42', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763920595870') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FRANSIZ ed. 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763920595870', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763920595870', false, '2025-11-23 20:56:35', 3, 0, true, false, '2025-11-23 20:56:35', '2025-11-23 21:38:35', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765125958472') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ingiliz 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765125958472', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1765125958472', false, '2025-12-07 19:45:58', 3, 0, true, false, '2025-12-07 19:45:58', '2025-12-07 20:27:58', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763316116109') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Fransız ed. 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763316116109', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763316116109', false, '2025-11-16 21:01:56', 3, 0, true, false, '2025-11-16 21:01:56', '2025-11-16 21:47:56', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763916896238') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FRANSI ED. 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763916896238', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1763916896238', false, '2025-11-23 19:54:56', 3, 0, true, false, '2025-11-23 19:54:56', '2025-11-23 20:38:56', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768146424891') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'kuram ve eleştiriler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768146424891', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1768146424891', false, '2026-01-11 18:47:04', 3, 0, true, false, '2026-01-11 18:47:04', '2026-01-11 19:33:04', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766332369660') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'amerikan 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766332369660', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766332369660', false, '2025-12-21 18:52:49', 3, 0, true, false, '2025-12-21 18:52:49', '2025-12-21 19:37:49', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762703812945') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Akımlar 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762703812945', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762703812945', false, '2025-11-09 18:56:52', 3, 0, true, false, '2025-11-09 18:56:52', '2025-11-09 19:42:52', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766339542424') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'amerikan 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766339542424', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766339542424', false, '2025-12-21 20:52:22', 3, 0, true, false, '2025-12-21 20:52:22', '2025-12-21 21:38:22', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767542007380') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Rus Ed. 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767542007380', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1767542007380', false, '2026-01-04 18:53:27', 3, 0, true, false, '2026-01-04 18:53:27', '2026-01-04 19:38:27', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766335773403') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'amerikan 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766335773403', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1766335773403', false, '2025-12-21 19:49:33', 3, 0, true, false, '2025-12-21 19:49:33', '2025-12-21 20:31:33', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762707223336') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'akımlar 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762707223336', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1762707223336', false, '2025-11-09 19:53:43', 3, 0, true, false, '2025-11-09 19:53:43', '2025-11-09 20:38:43', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764517613474') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'fransız 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764517613474', '35055dac95adb3f6c0c8afe1593ea9f87912dc72-1764517613474', false, '2025-11-30 18:46:53', 3, 0, true, false, '2025-11-30 18:46:53', '2025-11-30 19:31:53', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761234522072') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı- Tanıtım- Üniteler- Kaynaklar...', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1761234522072', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761234522072', false, '2025-10-23 18:48:42', 3, 0, true, false, '2025-10-23 18:48:42', '2025-10-23 19:39:42', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767891161505') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1767891161505', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767891161505', false, '2026-01-08 19:52:41', 3, 0, true, false, '2026-01-08 19:52:41', '2026-01-08 20:32:41', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770917777935') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatında Mesnevi-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1770917777935', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770917777935', false, '2026-02-12 20:36:17', 3, 0, true, false, '2026-02-12 20:36:17', '2026-02-12 21:20:17', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766073329863') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1766073329863', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766073329863', false, '2025-12-18 18:55:29', 3, 0, true, false, '2025-12-18 18:55:29', '2025-12-18 19:45:29', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772124614697') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1772124614697', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772124614697', false, '2026-02-26 19:50:14', 3, 0, true, false, '2026-02-26 19:50:14', '2026-02-26 20:33:14', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763049246585') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Mazmunlar-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1763049246585', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763049246585', false, '2025-11-13 18:54:06', 3, 0, true, false, '2025-11-13 18:54:06', '2025-11-13 19:55:06', 61);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770911974775') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Türleri-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1770911974775', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770911974775', false, '2026-02-12 18:59:34', 3, 0, true, false, '2026-02-12 18:59:34', '2026-02-12 19:41:34', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1765471659383') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1765471659383', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1765471659383', false, '2025-12-11 19:47:39', 3, 0, true, false, '2025-12-11 19:47:39', '2025-12-11 20:34:39', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1773341034695') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1773341034695', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1773341034695', false, '2026-03-12 21:43:54', 3, 0, true, false, '2026-03-12 21:43:54', '2026-03-12 22:26:54', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1765475008005') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1765475008005', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1765475008005', false, '2025-12-11 20:43:28', 3, 0, true, false, '2025-12-11 20:43:28', '2025-12-11 21:28:28', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772131027701') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1772131027701', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772131027701', false, '2026-02-26 21:37:07', 3, 0, true, false, '2026-02-26 21:37:07', '2026-02-26 22:26:07', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1771520112632') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatında Mesnevi-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1771520112632', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1771520112632', false, '2026-02-19 19:55:12', 3, 0, true, false, '2026-02-19 19:55:12', '2026-02-19 20:40:12', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1762450747474') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Mazmunlar-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1762450747474', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1762450747474', false, '2025-11-06 20:39:07', 3, 0, true, false, '2025-11-06 20:39:07', '2025-11-06 21:28:07', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764265252400') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Şekilleri-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1764265252400', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764265252400', false, '2025-11-27 20:40:52', 3, 0, true, false, '2025-11-27 20:40:52', '2025-11-27 21:38:52', 58);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1774540535376') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1774540535376', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1774540535376', false, '2026-03-26 18:55:35', 3, 0, true, false, '2026-03-26 18:55:35', '2026-03-26 19:36:35', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1768498979579') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1768498979579', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1768498979579', false, '2026-01-15 20:42:59', 3, 0, true, false, '2026-01-15 20:42:59', '2026-01-15 21:27:59', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772729075434') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1772729075434', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772729075434', false, '2026-03-05 19:44:35', 3, 0, true, false, '2026-03-05 19:44:35', '2026-03-05 20:29:35', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770313096560') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Türleri-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1770313096560', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770313096560', false, '2026-02-05 20:38:16', 3, 0, true, false, '2026-02-05 20:38:16', '2026-02-05 21:22:16', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766677971867') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1766677971867', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766677971867', false, '2025-12-25 18:52:51', 3, 0, true, false, '2025-12-25 18:52:51', '2025-12-25 19:38:51', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766079664846') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Günümüz Türkçesine Aktarım-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1766079664846', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766079664846', false, '2025-12-18 20:41:04', 3, 0, true, false, '2025-12-18 20:41:04', '2025-12-18 21:34:04', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764863623756') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1764863623756', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764863623756', false, '2025-12-04 18:53:43', 3, 0, true, false, '2025-12-04 18:53:43', '2025-12-04 19:36:43', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1775146693556') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1775146693556', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1775146693556', false, '2026-04-02 19:18:13', 3, 0, true, false, '2026-04-02 19:18:13', '2026-04-02 20:01:13', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772127915178') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1772127915178', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772127915178', false, '2026-02-26 20:45:15', 3, 0, true, false, '2026-02-26 20:45:15', '2026-02-26 21:26:15', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1774545730366') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1774545730366', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1774545730366', false, '2026-03-26 20:22:10', 3, 0, true, false, '2026-03-26 20:22:10', '2026-03-26 21:14:10', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770914762439') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Türleri-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1770914762439', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770914762439', false, '2026-02-12 19:46:02', 3, 0, true, false, '2026-02-12 19:46:02', '2026-02-12 20:27:02', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767289342978') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1767289342978', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767289342978', false, '2026-01-01 20:42:22', 3, 0, true, false, '2026-01-01 20:42:22', '2026-01-01 21:31:22', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1762447420167') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Mazmunlar-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1762447420167', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1762447420167', false, '2025-11-06 19:43:40', 3, 0, true, false, '2025-11-06 19:43:40', '2025-11-06 20:25:40', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1768492107471') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1768492107471', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1768492107471', false, '2026-01-15 18:48:27', 3, 0, true, false, '2026-01-15 18:48:27', '2026-01-15 19:35:27', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766076809897') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Günümüz Türkçesine Aktarım-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1766076809897', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766076809897', false, '2025-12-18 19:53:29', 3, 0, true, false, '2025-12-18 19:53:29', '2025-12-18 20:33:29', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763654482058') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Şekilleri-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1763654482058', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763654482058', false, '2025-11-20 19:01:22', 3, 0, true, false, '2025-11-20 19:01:22', '2025-11-20 19:49:22', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766684440257') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Günümüz Türkçesine Aktarım-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1766684440257', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766684440257', false, '2025-12-25 20:40:40', 3, 0, true, false, '2025-12-25 20:40:40', '2025-12-25 21:28:40', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767280304473') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1767280304473', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767280304473', false, '2026-01-01 18:11:44', 3, 0, true, false, '2026-01-01 18:11:44', '2026-01-01 18:51:44', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1769709406030') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Türleri-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1769709406030', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1769709406030', false, '2026-01-29 20:56:46', 3, 0, true, false, '2026-01-29 20:56:46', '2026-01-29 21:40:46', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764261899117') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Şekilleri-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1764261899117', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764261899117', false, '2025-11-27 19:44:59', 3, 0, true, false, '2025-11-27 19:44:59', '2025-11-27 20:27:59', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1769701555942') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1769701555942', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1769701555942', false, '2026-01-29 18:45:55', 3, 0, true, false, '2026-01-29 18:45:55', '2026-01-29 19:33:55', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772732846462') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1772732846462', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772732846462', false, '2026-03-05 20:47:26', 3, 0, true, false, '2026-03-05 20:47:26', '2026-03-05 21:29:26', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761842553475') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Mazmunlar-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1761842553475', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761842553475', false, '2025-10-30 19:42:33', 3, 0, true, false, '2025-10-30 19:42:33', '2025-10-30 20:27:33', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1775149479639') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1775149479639', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1775149479639', false, '2026-04-02 20:04:39', 3, 0, true, false, '2026-04-02 20:04:39', '2026-04-02 20:47:39', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1773334578819') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1773334578819', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1773334578819', false, '2026-03-12 19:56:18', 3, 0, true, false, '2026-03-12 19:56:18', '2026-03-12 20:38:18', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1771523186116') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatında Mesnevi-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1771523186116', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1771523186116', false, '2026-02-19 20:46:26', 3, 0, true, false, '2026-02-19 20:46:26', '2026-02-19 21:30:26', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766681380570') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Günümüz Türkçesine Aktarım-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1766681380570', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1766681380570', false, '2025-12-25 19:49:40', 3, 0, true, false, '2025-12-25 19:49:40', '2025-12-25 20:31:40', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763056035580') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Âşık- Sevgili- Rakip-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1763056035580', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763056035580', false, '2025-11-13 20:47:15', 3, 0, true, false, '2025-11-13 20:47:15', '2025-11-13 21:37:15', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1775152810908') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Genel Değerlendirme ve Tekrar Soruları', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1775152810908', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1775152810908', false, '2026-04-02 21:00:10', 3, 0, true, false, '2026-04-02 21:00:10', '2026-04-02 21:46:10', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1762444233781') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Mazmunlar-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1762444233781', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1762444233781', false, '2025-11-06 18:50:33', 3, 0, true, false, '2025-11-06 18:50:33', '2025-11-06 19:33:33', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764869984194') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1764869984194', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764869984194', false, '2025-12-04 20:39:44', 3, 0, true, false, '2025-12-04 20:39:44', '2025-12-04 21:23:44', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1771526454779') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatında Mesnevi-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1771526454779', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1771526454779', false, '2026-02-19 21:40:54', 3, 0, true, false, '2026-02-19 21:40:54', '2026-02-19 22:20:54', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763657573548') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Şekilleri-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1763657573548', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763657573548', false, '2025-11-20 19:52:53', 3, 0, true, false, '2025-11-20 19:52:53', '2025-11-20 20:37:53', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761238331479') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı Giriş-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1761238331479', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761238331479', false, '2025-10-23 19:52:11', 3, 0, true, false, '2025-10-23 19:52:11', '2025-10-23 20:37:11', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1768495692078') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1768495692078', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1768495692078', false, '2026-01-15 19:48:12', 3, 0, true, false, '2026-01-15 19:48:12', '2026-01-15 20:31:12', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1774543319139') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1774543319139', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1774543319139', false, '2026-03-26 19:41:59', 3, 0, true, false, '2026-03-26 19:41:59', '2026-03-26 20:12:59', 31);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764258675682') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Şekilleri-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1764258675682', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764258675682', false, '2025-11-27 18:51:15', 3, 0, true, false, '2025-11-27 18:51:15', '2025-11-27 19:34:15', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767887536869') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1767887536869', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767887536869', false, '2026-01-08 18:52:16', 3, 0, true, false, '2026-01-08 18:52:16', '2026-01-08 19:42:16', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763053327307') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Âşık- Sevgili- Rakip-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1763053327307', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763053327307', false, '2025-11-13 20:02:07', 3, 0, true, false, '2025-11-13 20:02:07', '2025-11-13 20:37:07', 35);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770306590212') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Türleri-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1770306590212', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770306590212', false, '2026-02-05 18:49:50', 3, 0, true, false, '2026-02-05 18:49:50', '2026-02-05 19:31:50', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767285677516') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Günümüz Türkçesine Aktarım-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1767285677516', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767285677516', false, '2026-01-01 19:41:17', 3, 0, true, false, '2026-01-01 19:41:17', '2026-01-01 20:32:17', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761241592917') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı Giriş-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1761241592917', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761241592917', false, '2025-10-23 20:46:32', 3, 0, true, false, '2025-10-23 20:46:32', '2025-10-23 21:38:32', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763660767074') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Şekilleri-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1763660767074', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1763660767074', false, '2025-11-20 20:46:07', 3, 0, true, false, '2025-11-20 20:46:07', '2025-11-20 21:32:07', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772736022182') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1772736022182', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1772736022182', false, '2026-03-05 21:40:22', 3, 0, true, false, '2026-03-05 21:40:22', '2026-03-05 22:27:22', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761839318158') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatı Giriş-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1761839318158', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761839318158', false, '2025-10-30 18:48:38', 3, 0, true, false, '2025-10-30 18:48:38', '2025-10-30 19:30:38', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1769705372566') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1769705372566', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1769705372566', false, '2026-01-29 19:49:32', 3, 0, true, false, '2026-01-29 19:49:32', '2026-01-29 20:40:32', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761845844118') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Eski Türk Edebiyatında Mazmunlar-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1761845844118', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1761845844118', false, '2025-10-30 20:37:24', 3, 0, true, false, '2025-10-30 20:37:24', '2025-10-30 21:30:24', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767894109843') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Edebi Sanatlar-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1767894109843', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1767894109843', false, '2026-01-08 20:41:49', 3, 0, true, false, '2026-01-08 20:41:49', '2026-01-08 21:28:49', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1773337371223') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Klasik Türk Edebiyatı Tarihi-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1773337371223', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1773337371223', false, '2026-03-12 20:42:51', 3, 0, true, false, '2026-03-12 20:42:51', '2026-03-12 21:27:51', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1765468143369') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1765468143369', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1765468143369', false, '2025-12-11 18:49:03', 3, 0, true, false, '2025-12-11 18:49:03', '2025-12-11 19:35:03', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770309814725') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Nazım Türleri-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1770309814725', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1770309814725', false, '2026-02-05 19:43:34', 3, 0, true, false, '2026-02-05 19:43:34', '2026-02-05 20:26:34', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764866646752') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Bilgisi-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=d5a49c3ab0991a06073f0f2931a2fc49ad269629-1764866646752', 'd5a49c3ab0991a06073f0f2931a2fc49ad269629-1764866646752', false, '2025-12-04 19:44:06', 3, 0, true, false, '2025-12-04 19:44:06', '2025-12-04 20:27:06', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764002876837') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk şairleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764002876837', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764002876837', false, '2025-11-24 19:47:56', 3, 0, true, false, '2025-11-24 19:47:56', '2025-11-24 20:28:56', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762793119854') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762793119854', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762793119854', false, '2025-11-10 19:45:19', 3, 0, true, false, '2025-11-10 19:45:19', '2025-11-10 20:26:19', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760975596681') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk bilim kuram ve yöntemler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760975596681', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760975596681', false, '2025-10-20 18:53:16', 3, 0, true, false, '2025-10-20 18:53:16', '2025-10-20 19:35:16', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767020183380') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'destanlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767020183380', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767020183380', false, '2025-12-29 17:56:23', 3, 0, true, false, '2025-12-29 17:56:23', '2025-12-29 18:35:23', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761580565865') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk bilim ve kuramlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761580565865', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761580565865', false, '2025-10-27 18:56:05', 3, 0, true, false, '2025-10-27 18:56:05', '2025-10-27 19:37:05', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764604698839') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk şairler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764604698839', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764604698839', false, '2025-12-01 18:58:18', 3, 0, true, false, '2025-12-01 18:58:18', '2025-12-01 19:38:18', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764006042273') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk şairleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764006042273', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764006042273', false, '2025-11-24 20:40:42', 3, 0, true, false, '2025-11-24 20:40:42', '2025-11-24 21:24:42', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763398218011') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763398218011', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763398218011', false, '2025-11-17 19:50:18', 3, 0, true, false, '2025-11-17 19:50:18', '2025-11-17 20:30:18', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766421667521') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk hikayeler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766421667521', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766421667521', false, '2025-12-22 19:41:07', 3, 0, true, false, '2025-12-22 19:41:07', '2025-12-22 20:19:07', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765215564729') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mit efsane masal', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765215564729', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765215564729', false, '2025-12-08 20:39:24', 3, 0, true, false, '2025-12-08 20:39:24', '2025-12-08 21:18:24', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764607741354') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk şairler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764607741354', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764607741354', false, '2025-12-01 19:49:01', 3, 0, true, false, '2025-12-01 19:49:01', '2025-12-01 20:27:01', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767029807753') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edebiyatı kaynaklar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767029807753', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767029807753', false, '2025-12-29 20:36:47', 3, 0, true, false, '2025-12-29 20:36:47', '2025-12-29 21:20:47', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763999791551') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk şairler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763999791551', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763999791551', false, '2025-11-24 18:56:31', 3, 0, true, false, '2025-11-24 18:56:31', '2025-11-24 19:36:31', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764610779580') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk şairler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764610779580', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1764610779580', false, '2025-12-01 20:39:39', 3, 0, true, false, '2025-12-01 20:39:39', '2025-12-01 21:21:39', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765814183496') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'masallar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765814183496', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765814183496', false, '2025-12-15 18:56:23', 3, 0, true, false, '2025-12-15 18:56:23', '2025-12-15 19:36:23', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766418449412') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk hikayeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766418449412', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766418449412', false, '2025-12-22 18:47:29', 3, 0, true, false, '2025-12-22 18:47:29', '2025-12-22 19:26:29', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762185387038') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762185387038', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762185387038', false, '2025-11-03 18:56:27', 3, 0, true, false, '2025-11-03 18:56:27', '2025-11-03 19:37:27', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762796369467') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762796369467', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762796369467', false, '2025-11-10 20:39:29', 3, 0, true, false, '2025-11-10 20:39:29', '2025-11-10 21:25:29', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761583755930') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edb. kuramlar ve halk edeb.tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761583755930', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761583755930', false, '2025-10-27 19:49:15', 3, 0, true, false, '2025-10-27 19:49:15', '2025-10-27 20:28:15', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762188485793') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762188485793', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762188485793', false, '2025-11-03 19:48:05', 3, 0, true, false, '2025-11-03 19:48:05', '2025-11-03 20:28:05', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763394854958') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edeb. tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763394854958', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763394854958', false, '2025-11-17 18:54:14', 3, 0, true, false, '2025-11-17 18:54:14', '2025-11-17 19:34:14', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766424495038') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'destanlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766424495038', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766424495038', false, '2025-12-22 20:28:15', 3, 0, true, false, '2025-12-22 20:28:15', '2025-12-22 21:06:15', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767026665723') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'diğer anonim halk türleri realist halk hikayeleri fıkra vs', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767026665723', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767026665723', false, '2025-12-29 19:44:25', 3, 0, true, false, '2025-12-29 19:44:25', '2025-12-29 20:23:25', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767023544708') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'geleneksel tiyatro', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767023544708', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1767023544708', false, '2025-12-29 18:52:24', 3, 0, true, false, '2025-12-29 18:52:24', '2025-12-29 19:33:24', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765209360321') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'cumhuriyet dönemi hak ozanları', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765209360321', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765209360321', false, '2025-12-08 18:56:00', 3, 0, true, false, '2025-12-08 18:56:00', '2025-12-08 19:37:00', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765817200719') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'masallar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765817200719', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765817200719', false, '2025-12-15 19:46:40', 3, 0, true, false, '2025-12-15 19:46:40', '2025-12-15 20:26:40', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763401106372') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763401106372', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1763401106372', false, '2025-11-17 20:38:26', 3, 0, true, false, '2025-11-17 20:38:26', '2025-11-17 21:18:26', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760979733352') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ikinci ders', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760979733352', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760979733352', false, '2025-10-20 20:02:13', 3, 0, true, false, '2025-10-20 20:02:13', '2025-10-20 20:41:13', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765820399839') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk hikayeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765820399839', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765820399839', false, '2025-12-15 20:39:59', 3, 0, true, false, '2025-12-15 20:39:59', '2025-12-15 21:19:59', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761586667198') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edeb. tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761586667198', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1761586667198', false, '2025-10-27 20:37:47', 3, 0, true, false, '2025-10-27 20:37:47', '2025-10-27 21:17:47', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765212609202') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'anonim halk edebiyatı', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765212609202', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1765212609202', false, '2025-12-08 19:50:09', 3, 0, true, false, '2025-12-08 19:50:09', '2025-12-08 20:30:09', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762191497568') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762191497568', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762191497568', false, '2025-11-03 20:38:17', 3, 0, true, false, '2025-11-03 20:38:17', '2025-11-03 21:19:17', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766415351129') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halkhikayeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766415351129', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1766415351129', false, '2025-12-22 17:55:51', 3, 0, true, false, '2025-12-22 17:55:51', '2025-12-22 18:36:51', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760982531820') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk  bilim kuramlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760982531820', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1760982531820', false, '2025-10-20 20:48:51', 3, 0, true, false, '2025-10-20 20:48:51', '2025-10-20 21:30:51', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762789993125') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edebiyatında tür ve şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762789993125', '6fb816cac8d877ed782a082bbfb25c5eb5744b39-1762789993125', false, '2025-11-10 18:53:13', 3, 0, true, false, '2025-11-10 18:53:13', '2025-11-10 19:33:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776613676929') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA ÖĞRENME ÇIKTILARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776613676929', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776613676929', false, '2026-04-19 18:47:56', 3, 0, true, false, '2026-04-19 18:47:56', '2026-04-19 19:28:56', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775663440837') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA ÖĞRENME ÇIKTILARI - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775663440837', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775663440837', false, '2026-04-08 18:50:40', 3, 0, true, false, '2026-04-08 18:50:40', '2026-04-08 19:28:40', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777743453092') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777743453092', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777743453092', false, '2026-05-02 20:37:33', 3, 0, true, false, '2026-05-02 20:37:33', '2026-05-02 21:19:33', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777135282441') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA ÖĞRENME ÇIKTILARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777135282441', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777135282441', false, '2026-04-25 19:41:22', 3, 0, true, false, '2026-04-25 19:41:22', '2026-04-25 20:19:22', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775583536680') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME ÖĞRENME ÇIKTILARI - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775583536680', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775583536680', false, '2026-04-07 20:38:56', 3, 0, true, false, '2026-04-07 20:38:56', '2026-04-07 21:21:56', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777138437508') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777138437508', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777138437508', false, '2026-04-25 20:33:57', 3, 0, true, false, '2026-04-25 20:33:57', '2026-04-25 20:58:57', 25);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1774632927262') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME ÖĞRENME ÇIKTILARI - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1774632927262', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1774632927262', false, '2026-03-27 20:35:27', 3, 0, true, false, '2026-03-27 20:35:27', '2026-03-27 21:12:27', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1780760669389') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1780760669389', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1780760669389', false, '2026-06-06 18:44:29', 3, 0, true, false, '2026-06-06 18:44:29', '2026-06-06 19:31:29', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777132348272') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA ÖĞRENME ÇIKTILARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777132348272', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777132348272', false, '2026-04-25 18:52:28', 3, 0, true, false, '2026-04-25 18:52:28', '2026-04-25 19:32:28', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1781369151342') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1781369151342', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1781369151342', false, '2026-06-13 19:45:51', 3, 0, true, false, '2026-06-13 19:45:51', '2026-06-13 20:30:51', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775666624559') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA ÖĞRENME ÇIKTILARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775666624559', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775666624559', false, '2026-04-08 19:43:44', 3, 0, true, false, '2026-04-08 19:43:44', '2026-04-08 20:37:44', 54);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1778341675531') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL YAPILARI VE SÖZ VARLIĞI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1778341675531', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1778341675531', false, '2026-05-09 18:47:55', 3, 0, true, false, '2026-05-09 18:47:55', '2026-05-09 19:27:55', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777740117553') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777740117553', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777740117553', false, '2026-05-02 19:41:57', 3, 0, true, false, '2026-05-02 19:41:57', '2026-05-02 20:20:57', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777736790901') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777736790901', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1777736790901', false, '2026-05-02 18:46:30', 3, 0, true, false, '2026-05-02 18:46:30', '2026-05-02 19:28:30', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1780764541734') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1780764541734', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1780764541734', false, '2026-06-06 19:49:01', 3, 0, true, false, '2026-06-06 19:49:01', '2026-06-06 20:38:01', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776620373560') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA ÖĞRENME ÇIKTILARI - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776620373560', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776620373560', false, '2026-04-19 20:39:33', 3, 0, true, false, '2026-04-19 20:39:33', '2026-04-19 21:17:33', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776617482468') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA ÖĞRENME ÇIKTILARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776617482468', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1776617482468', false, '2026-04-19 19:51:22', 3, 0, true, false, '2026-04-19 19:51:22', '2026-04-19 20:29:22', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775580352843') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME ÖĞRENME ÇIKTILARI - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775580352843', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775580352843', false, '2026-04-07 19:45:52', 3, 0, true, false, '2026-04-07 19:45:52', '2026-04-07 20:26:52', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1778345106432') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİLİŞSEL VE ÜSTBİLİŞSEL STRATEJİLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1778345106432', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1778345106432', false, '2026-05-09 19:45:06', 3, 0, true, false, '2026-05-09 19:45:06', '2026-05-09 20:43:06', 58);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775576752925') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME ÖĞRENME ÇIKTILARI - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775576752925', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1775576752925', false, '2026-04-07 18:45:52', 3, 0, true, false, '2026-04-07 18:45:52', '2026-04-07 19:25:52', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 MAARİF PROGRAMI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1781365906174') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRENME ÇIKTILARI SORU ÇÖZÜMÜ - 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=51ff007f49e5d77e56517d69fb5c853e9d09bd18-1781365906174', '51ff007f49e5d77e56517d69fb5c853e9d09bd18-1781365906174', false, '2026-06-13 18:51:46', 3, 0, true, false, '2026-06-13 18:51:46', '2026-06-13 19:36:46', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1741123270341') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2. DENEME DİLBİLGİSİ - DİLBİLİM -EDEBİYAT ÇÖZÜMLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1741123270341', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1741123270341', false, '2025-03-05 00:21:10', 3, 0, true, false, '2025-03-05 00:21:10', '2025-03-05 01:13:10', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1770342900232') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1. DENEME DÖRT TEMEL BECERİ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1770342900232', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1770342900232', false, '2026-02-06 04:55:00', 3, 0, true, false, '2026-02-06 04:55:00', '2026-02-06 05:25:00', 30);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1780887004967') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '5. DENEME DÖRT TEMEL BECERİ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1780887004967', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1780887004967', false, '2026-06-08 05:50:04', 3, 0, true, false, '2026-06-08 05:50:04', '2026-06-08 06:03:04', 13);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1751031539642') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '9. DENEME DİLBİLİM DİLBİLGİSİ EDEBİYAT ÇÖZÜM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1751031539642', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1751031539642', false, '2025-06-27 16:38:59', 3, 0, true, false, '2025-06-27 16:38:59', '2025-06-27 17:35:59', 57);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750631727239') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '6. DENEME DİLBİLGİSİ DİLBİLİM EDEBİYAT ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750631727239', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750631727239', false, '2025-06-23 01:35:27', 3, 0, true, false, '2025-06-23 01:35:27', '2025-06-23 02:19:27', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1747780378018') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '5. DENEME DİLBİLGİSİ DİLBİLİM EDEBİYAT ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1747780378018', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1747780378018', false, '2025-05-21 01:32:58', 3, 0, true, false, '2025-05-21 01:32:58', '2025-05-21 02:31:58', 59);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750777205401') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '8. DENEME DİLBİLİM DİLBİLGİSİ EDEBİYAT ÇÖZÜM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750777205401', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750777205401', false, '2025-06-24 18:00:05', 3, 0, true, false, '2025-06-24 18:00:05', '2025-06-24 18:44:05', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1746218397177') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '4. DENEME DİLBİLGİSİ DİLBİLİM EDEBİYAT ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1746218397177', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1746218397177', false, '2025-05-02 23:39:57', 3, 0, true, false, '2025-05-02 23:39:57', '2025-05-03 00:38:57', 59);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1777330551634') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '4. DENEME DÖRT TEMEL BECERİ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1777330551634', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1777330551634', false, '2026-04-28 01:55:51', 3, 0, true, false, '2026-04-28 01:55:51', '2026-04-28 02:13:51', 18);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750717598929') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7. DENEME DİLBİLİM DİLBİLGİSİ EDEBİYAT ÇÖZÜM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750717598929', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1750717598929', false, '2025-06-24 01:26:38', 3, 0, true, false, '2025-06-24 01:26:38', '2025-06-24 02:05:38', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1775694680323') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '3. DENEME DÖRT TEMEL BECERİ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1775694680323', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1775694680323', false, '2026-04-09 03:31:20', 3, 0, true, false, '2026-04-09 03:31:20', '2026-04-09 03:47:20', 16);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1772673759722') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2. DENEME DÖRT TEMEL BECERİ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1772673759722', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1772673759722', false, '2026-03-05 04:22:39', 3, 0, true, false, '2026-03-05 04:22:39', '2026-03-05 04:37:39', 15);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1739137079408') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1. DENEME DİLBİLGİSİ- DİLBİLİM -EDEBİYAT ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1739137079408', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1739137079408', false, '2025-02-10 00:37:59', 3, 0, true, false, '2025-02-10 00:37:59', '2025-02-10 01:24:59', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1745003051522') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '3. DENEME DİLBİLGİSİ DİLBİLİM EDEBİYAT ÇÖZÜMLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1745003051522', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1745003051522', false, '2025-04-18 22:04:11', 3, 0, true, false, '2025-04-18 22:04:11', '2025-04-18 22:49:11', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ONLİNE DENEME ÇÖZÜMLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1751400501802') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '10. DENEME DİLBİLİM DİLBİLGİSİ EDEBİYAT ÇÖZÜM', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=3af846574fd50b2f85a88fec4e1df1aa4af0361e-1751400501802', '3af846574fd50b2f85a88fec4e1df1aa4af0361e-1751400501802', false, '2025-07-01 23:08:21', 3, 0, true, false, '2025-07-01 23:08:21', '2025-07-01 23:46:21', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772823699886') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-10 (BAĞIMSIZ SANATÇILAR)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772823699886', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772823699886', false, '2026-03-06 22:01:39', 3, 0, true, false, '2026-03-06 22:01:39', '2026-03-06 22:48:39', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778260988010') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-14 VE CUMHURİYET TİYATROSU-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1778260988010', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778260988010', false, '2026-05-08 20:23:08', 3, 0, true, false, '2026-05-08 20:23:08', '2026-05-08 21:05:08', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770227662692') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770227662692', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770227662692', false, '2026-02-04 20:54:22', 3, 0, true, false, '2026-02-04 20:54:22', '2026-02-04 21:44:22', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777652853954') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMAN-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1777652853954', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777652853954', false, '2026-05-01 19:27:33', 3, 0, true, false, '2026-05-01 19:27:33', '2026-05-01 20:11:33', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777047918528') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1777047918528', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777047918528', false, '2026-04-24 19:25:18', 3, 0, true, false, '2026-04-24 19:25:18', '2026-04-24 20:10:18', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772816195920') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772816195920', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772816195920', false, '2026-03-06 19:56:35', 3, 0, true, false, '2026-03-06 19:56:35', '2026-03-06 20:40:35', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770399818954') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770399818954', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770399818954', false, '2026-02-06 20:43:38', 3, 0, true, false, '2026-02-06 20:43:38', '2026-02-06 21:29:38', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1774713695208') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ -10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1774713695208', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1774713695208', false, '2026-03-28 19:01:35', 3, 0, true, false, '2026-03-28 19:01:35', '2026-03-28 19:48:35', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773255160338') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773255160338', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773255160338', false, '2026-03-11 21:52:40', 3, 0, true, false, '2026-03-11 21:52:40', '2026-03-11 22:42:40', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772642287343') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772642287343', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772642287343', false, '2026-03-04 19:38:07', 3, 0, true, false, '2026-03-04 19:38:07', '2026-03-04 20:24:07', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772646601199') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772646601199', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772646601199', false, '2026-03-04 20:50:01', 3, 0, true, false, '2026-03-04 20:50:01', '2026-03-04 21:33:01', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772218690921') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772218690921', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772218690921', false, '2026-02-27 21:58:10', 3, 0, true, false, '2026-02-27 21:58:10', '2026-02-27 22:40:10', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771606792403') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771606792403', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771606792403', false, '2026-02-20 19:59:52', 3, 0, true, false, '2026-02-20 19:59:52', '2026-02-20 20:43:52', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777656706375') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1777656706375', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777656706375', false, '2026-05-01 20:31:46', 3, 0, true, false, '2026-05-01 20:31:46', '2026-05-01 21:14:46', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769788189321') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATININ OLUŞUMU-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1769788189321', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769788189321', false, '2026-01-30 18:49:49', 3, 0, true, false, '2026-01-30 18:49:49', '2026-01-30 19:35:49', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778523189473') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRETİCİ METİNLER-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1778523189473', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778523189473', false, '2026-05-11 21:13:09', 3, 0, true, false, '2026-05-11 21:13:09', '2026-05-11 21:37:09', 24);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769623183330') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATININ OLUŞUMU-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1769623183330', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769623183330', false, '2026-01-28 20:59:43', 3, 0, true, false, '2026-01-28 20:59:43', '2026-01-28 21:51:43', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772038444638') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FECRİATİ EDEBİYATI-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772038444638', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772038444638', false, '2026-02-25 19:54:04', 3, 0, true, false, '2026-02-25 19:54:04', '2026-02-25 20:41:04', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771092079237') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771092079237', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771092079237', false, '2026-02-14 21:01:19', 3, 0, true, false, '2026-02-14 21:01:19', '2026-02-14 21:41:19', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1774716908600') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1774716908600', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1774716908600', false, '2026-03-28 19:55:08', 3, 0, true, false, '2026-03-28 19:55:08', '2026-03-28 20:39:08', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777660072120') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1777660072120', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777660072120', false, '2026-05-01 21:27:52', 3, 0, true, false, '2026-05-01 21:27:52', '2026-05-01 22:09:52', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773860790601') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773860790601', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773860790601', false, '2026-03-18 22:06:30', 3, 0, true, false, '2026-03-18 22:06:30', '2026-03-18 22:59:30', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771084779295') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BATILI NAZIM ŞEKİLLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771084779295', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771084779295', false, '2026-02-14 18:59:39', 3, 0, true, false, '2026-02-14 18:59:39', '2026-02-14 19:45:39', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769792034204') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1769792034204', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769792034204', false, '2026-01-30 19:53:54', 3, 0, true, false, '2026-01-30 19:53:54', '2026-01-30 20:41:54', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769618971749') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATININ OLUŞUMU-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1769618971749', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769618971749', false, '2026-01-28 19:49:31', 3, 0, true, false, '2026-01-28 19:49:31', '2026-01-28 20:46:31', 57);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771433572814') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771433572814', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771433572814', false, '2026-02-18 19:52:52', 3, 0, true, false, '2026-02-18 19:52:52', '2026-02-18 20:38:52', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771440613722') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771440613722', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771440613722', false, '2026-02-18 21:50:13', 3, 0, true, false, '2026-02-18 21:50:13', '2026-02-18 22:39:13', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1779127557813') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YTE SORU ÇÖZÜMÜ-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1779127557813', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1779127557813', false, '2026-05-18 21:05:57', 3, 0, true, false, '2026-05-18 21:05:57', '2026-05-18 21:51:57', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775844626961') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMAN-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1775844626961', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775844626961', false, '2026-04-10 21:10:26', 3, 0, true, false, '2026-04-10 21:10:26', '2026-04-10 21:54:26', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773853059954') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773853059954', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773853059954', false, '2026-03-18 19:57:39', 3, 0, true, false, '2026-03-18 19:57:39', '2026-03-18 20:49:39', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773248361482') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773248361482', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773248361482', false, '2026-03-11 19:59:21', 3, 0, true, false, '2026-03-11 19:59:21', '2026-03-11 20:43:21', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778514922352') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRETİCİ METİNLER-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1778514922352', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778514922352', false, '2026-05-11 18:55:22', 3, 0, true, false, '2026-05-11 18:55:22', '2026-05-11 19:42:22', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770832550769') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770832550769', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770832550769', false, '2026-02-11 20:55:50', 3, 0, true, false, '2026-02-11 20:55:50', '2026-02-11 21:46:50', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773428020649') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773428020649', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773428020649', false, '2026-03-13 21:53:40', 3, 0, true, false, '2026-03-13 21:53:40', '2026-03-13 22:38:40', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770223964830') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770223964830', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770223964830', false, '2026-02-04 19:52:44', 3, 0, true, false, '2026-02-04 19:52:44', '2026-02-04 20:34:44', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769795871910') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1769795871910', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769795871910', false, '2026-01-30 20:57:51', 3, 0, true, false, '2026-01-30 20:57:51', '2026-01-30 21:34:51', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773424051663') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773424051663', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773424051663', false, '2026-03-13 20:47:31', 3, 0, true, false, '2026-03-13 20:47:31', '2026-03-13 21:35:31', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773251943269') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773251943269', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773251943269', false, '2026-03-11 20:59:03', 3, 0, true, false, '2026-03-11 20:59:03', '2026-03-11 21:46:03', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777055086709') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1777055086709', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777055086709', false, '2026-04-24 21:24:46', 3, 0, true, false, '2026-04-24 21:24:46', '2026-04-24 22:08:46', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771609961603') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771609961603', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771609961603', false, '2026-02-20 20:52:41', 3, 0, true, false, '2026-02-20 20:52:41', '2026-02-20 21:44:41', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775323377940') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1775323377940', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775323377940', false, '2026-04-04 20:22:57', 3, 0, true, false, '2026-04-04 20:22:57', '2026-04-04 21:06:57', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771613845038') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FECRİATİ EDEBİYATI-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771613845038', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771613845038', false, '2026-02-20 21:57:25', 3, 0, true, false, '2026-02-20 21:57:25', '2026-02-20 22:55:25', 58);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772214820035') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772214820035', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772214820035', false, '2026-02-27 20:53:40', 3, 0, true, false, '2026-02-27 20:53:40', '2026-02-27 21:41:40', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773857033961') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ -8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773857033961', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773857033961', false, '2026-03-18 21:03:53', 3, 0, true, false, '2026-03-18 21:03:53', '2026-03-18 21:44:53', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772650004459') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772650004459', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772650004459', false, '2026-03-04 21:46:44', 3, 0, true, false, '2026-03-04 21:46:44', '2026-03-04 22:28:44', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775836321680') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMAN-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1775836321680', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775836321680', false, '2026-04-10 18:52:01', 3, 0, true, false, '2026-04-10 18:52:01', '2026-04-10 19:38:01', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1776446513840') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1776446513840', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1776446513840', false, '2026-04-17 20:21:53', 3, 0, true, false, '2026-04-17 20:21:53', '2026-04-17 21:07:53', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773421199975') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1773421199975', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1773421199975', false, '2026-03-13 19:59:59', 3, 0, true, false, '2026-03-13 19:59:59', '2026-03-13 20:40:59', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777051408884') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1777051408884', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1777051408884', false, '2026-04-24 20:23:28', 3, 0, true, false, '2026-04-24 20:23:28', '2026-04-24 21:08:28', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1774721063415') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ -12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1774721063415', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1774721063415', false, '2026-03-28 21:04:23', 3, 0, true, false, '2026-03-28 21:04:23', '2026-03-28 21:52:23', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769615357222') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YENİ TÜRK EDEBİYATINA GİRİŞ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1769615357222', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1769615357222', false, '2026-01-28 18:49:17', 3, 0, true, false, '2026-01-28 18:49:17', '2026-01-28 19:34:17', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778257704379') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1778257704379', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778257704379', false, '2026-05-08 19:28:24', 3, 0, true, false, '2026-05-08 19:28:24', '2026-05-08 20:12:24', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1779119715181') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YTE SORU ÇÖZÜMÜ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1779119715181', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1779119715181', false, '2026-05-18 18:55:15', 3, 0, true, false, '2026-05-18 18:55:15', '2026-05-18 19:45:15', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772045742287') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772045742287', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772045742287', false, '2026-02-25 21:55:42', 3, 0, true, false, '2026-02-25 21:55:42', '2026-02-25 22:45:42', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772041953008') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FECRİATİ EDEBİYATI-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772041953008', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772041953008', false, '2026-02-25 20:52:33', 3, 0, true, false, '2026-02-25 20:52:33', '2026-02-25 21:37:33', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772819456682') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-9 (BAĞIMSIZ SNATÇILAR)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772819456682', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772819456682', false, '2026-03-06 20:50:56', 3, 0, true, false, '2026-03-06 20:50:56', '2026-03-06 21:40:56', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770828990293') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770828990293', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770828990293', false, '2026-02-11 19:56:30', 3, 0, true, false, '2026-02-11 19:56:30', '2026-02-11 20:42:30', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772211349006') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MİLLİ EDEBİYAT-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1772211349006', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1772211349006', false, '2026-02-27 19:55:49', 3, 0, true, false, '2026-02-27 19:55:49', '2026-02-27 20:43:49', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771437167358') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771437167358', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771437167358', false, '2026-02-18 20:52:47', 3, 0, true, false, '2026-02-18 20:52:47', '2026-02-18 21:37:47', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770396434433') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770396434433', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770396434433', false, '2026-02-06 19:47:14', 3, 0, true, false, '2026-02-06 19:47:14', '2026-02-06 20:26:14', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770219684715') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770219684715', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770219684715', false, '2026-02-04 18:41:24', 3, 0, true, false, '2026-02-04 18:41:24', '2026-02-04 19:27:24', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1776442549707') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1776442549707', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1776442549707', false, '2026-04-17 19:15:49', 3, 0, true, false, '2026-04-17 19:15:49', '2026-04-17 20:03:49', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771087969153') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SERVETİFÜNUN EDEBİYATI-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1771087969153', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1771087969153', false, '2026-02-14 19:52:49', 3, 0, true, false, '2026-02-14 19:52:49', '2026-02-14 20:42:49', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775320616106') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ŞİİRİ-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1775320616106', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775320616106', false, '2026-04-04 19:36:56', 3, 0, true, false, '2026-04-04 19:36:56', '2026-04-04 20:18:56', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778518544884') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖĞRETİCİ METİNLER-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1778518544884', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778518544884', false, '2026-05-11 19:55:44', 3, 0, true, false, '2026-05-11 19:55:44', '2026-05-11 20:40:44', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1779123460554') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YTE SORU ÇÖZÜMÜ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1779123460554', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1779123460554', false, '2026-05-18 19:57:40', 3, 0, true, false, '2026-05-18 19:57:40', '2026-05-18 20:49:40', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775841750129') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMAN- 2b', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1775841750129', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1775841750129', false, '2026-04-10 20:22:30', 3, 0, true, false, '2026-04-10 20:22:30', '2026-04-10 21:06:30', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1776450389110') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET ROMANI-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1776450389110', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1776450389110', false, '2026-04-17 21:26:29', 3, 0, true, false, '2026-04-17 21:26:29', '2026-04-17 22:06:29', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770825304807') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770825304807', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770825304807', false, '2026-02-11 18:55:04', 3, 0, true, false, '2026-02-11 18:55:04', '2026-02-11 19:44:04', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770393006339') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANZİMAT EDEBİYATI-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1770393006339', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1770393006339', false, '2026-02-06 18:50:06', 3, 0, true, false, '2026-02-06 18:50:06', '2026-02-06 19:33:06', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778264562548') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CUMHURİYET TİYATROSU-2 VE ÖĞRETİCİ METİNLER-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=80b76a73d9fdf418aed6e143de1468fe9615c84a-1778264562548', '80b76a73d9fdf418aed6e143de1468fe9615c84a-1778264562548', false, '2026-05-08 21:22:42', 3, 0, true, false, '2026-05-08 21:22:42', '2026-05-08 22:04:42', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777913848746') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-20', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777913848746', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777913848746', false, '2026-05-04 19:57:28', 3, 0, true, false, '2026-05-04 19:57:28', '2026-05-04 20:42:28', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776700629663') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776700629663', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776700629663', false, '2026-04-20 18:57:09', 3, 0, true, false, '2026-04-20 18:57:09', '2026-04-20 19:42:09', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775493898388') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775493898388', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775493898388', false, '2026-04-06 19:44:58', 3, 0, true, false, '2026-04-06 19:44:58', '2026-04-06 20:26:58', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774889265412') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774889265412', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774889265412', false, '2026-03-30 19:47:45', 3, 0, true, false, '2026-03-30 19:47:45', '2026-03-30 20:29:45', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776099334252') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776099334252', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776099334252', false, '2026-04-13 19:55:34', 3, 0, true, false, '2026-04-13 19:55:34', '2026-04-13 20:35:34', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776103679108') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776103679108', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776103679108', false, '2026-04-13 21:07:59', 3, 0, true, false, '2026-04-13 21:07:59', '2026-04-13 21:48:59', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776707488531') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-15', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776707488531', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776707488531', false, '2026-04-20 20:51:28', 3, 0, true, false, '2026-04-20 20:51:28', '2026-04-20 21:15:28', 24);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776095644119') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI -10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776095644119', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776095644119', false, '2026-04-13 18:54:04', 3, 0, true, false, '2026-04-13 18:54:04', '2026-04-13 19:42:04', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774886478932') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774886478932', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774886478932', false, '2026-03-30 19:01:18', 3, 0, true, false, '2026-03-30 19:01:18', '2026-03-30 19:41:18', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777910448344') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-19', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777910448344', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777910448344', false, '2026-05-04 19:00:48', 3, 0, true, false, '2026-05-04 19:00:48', '2026-05-04 19:50:48', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774892872315') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774892872315', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774892872315', false, '2026-03-30 20:47:52', 3, 0, true, false, '2026-03-30 20:47:52', '2026-03-30 21:35:52', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777310475899') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-17', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777310475899', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777310475899', false, '2026-04-27 20:21:15', 3, 0, true, false, '2026-04-27 20:21:15', '2026-04-27 21:11:15', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774281570228') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI -1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774281570228', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774281570228', false, '2026-03-23 18:59:30', 3, 0, true, false, '2026-03-23 18:59:30', '2026-03-23 19:48:30', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775491123359') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775491123359', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775491123359', false, '2026-04-06 18:58:43', 3, 0, true, false, '2026-04-06 18:58:43', '2026-04-06 19:38:43', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776704302561') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776704302561', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1776704302561', false, '2026-04-20 19:58:22', 3, 0, true, false, '2026-04-20 19:58:22', '2026-04-20 20:38:22', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774288816913') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774288816913', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774288816913', false, '2026-03-23 21:00:16', 3, 0, true, false, '2026-03-23 21:00:16', '2026-03-23 21:51:16', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775497598722') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775497598722', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1775497598722', false, '2026-04-06 20:46:38', 3, 0, true, false, '2026-04-06 20:46:38', '2026-04-06 21:35:38', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777918485491') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-21', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777918485491', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777918485491', false, '2026-05-04 21:14:45', 3, 0, true, false, '2026-05-04 21:14:45', '2026-05-04 21:57:45', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777314563972') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-18', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777314563972', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777314563972', false, '2026-04-27 21:29:23', 3, 0, true, false, '2026-04-27 21:29:23', '2026-04-27 22:27:23', 58);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774285129536') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774285129536', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1774285129536', false, '2026-03-23 19:58:49', 3, 0, true, false, '2026-03-23 19:58:49', '2026-03-23 20:42:49', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777305388006') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI-16', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777305388006', '0227ecef24ffd5f993e3a594193ec0e6cca913b3-1777305388006', false, '2026-04-27 18:56:28', 3, 0, true, false, '2026-04-27 18:56:28', '2026-04-27 19:43:28', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1770565818804') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ARUZ 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1770565818804', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1770565818804', false, '2026-02-08 18:50:18', 3, 0, true, false, '2026-02-08 18:50:18', '2026-02-08 19:30:18', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1775753390669') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1775753390669', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1775753390669', false, '2026-04-09 19:49:50', 3, 0, true, false, '2026-04-09 19:49:50', '2026-04-09 20:46:50', 57);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1769961826097') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Azur', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1769961826097', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1769961826097', false, '2026-02-01 19:03:46', 3, 0, true, false, '2026-02-01 19:03:46', '2026-02-01 19:50:46', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1777567735270') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1777567735270', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1777567735270', false, '2026-04-30 19:48:55', 3, 0, true, false, '2026-04-30 19:48:55', '2026-04-30 20:31:55', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771779017260') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Serh 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1771779017260', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771779017260', false, '2026-02-22 19:50:17', 3, 0, true, false, '2026-02-22 19:50:17', '2026-02-22 20:34:17', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776966029336') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1776966029336', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776966029336', false, '2026-04-23 20:40:29', 3, 0, true, false, '2026-04-23 20:40:29', '2026-04-23 21:25:29', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1769965826676') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1769965826676', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1769965826676', false, '2026-02-01 20:10:26', 3, 0, true, false, '2026-02-01 20:10:26', '2026-02-01 21:06:26', 56);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1770573764717') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ARUZ SON', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1770573764717', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1770573764717', false, '2026-02-08 21:02:44', 3, 0, true, false, '2026-02-08 21:02:44', '2026-02-08 21:45:44', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778175477108') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-15', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1778175477108', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778175477108', false, '2026-05-07 20:37:57', 3, 0, true, false, '2026-05-07 20:37:57', '2026-05-07 21:26:57', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1777571096644') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1777571096644', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1777571096644', false, '2026-04-30 20:44:56', 3, 0, true, false, '2026-04-30 20:44:56', '2026-04-30 21:21:56', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1770570278361') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1770570278361', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1770570278361', false, '2026-02-08 20:04:38', 3, 0, true, false, '2026-02-08 20:04:38', '2026-02-08 20:51:38', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1769969714785') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1769969714785', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1769969714785', false, '2026-02-01 21:15:14', 3, 0, true, false, '2026-02-01 21:15:14', '2026-02-01 22:02:14', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778774253455') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-16', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1778774253455', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778774253455', false, '2026-05-14 18:57:33', 3, 0, true, false, '2026-05-14 18:57:33', '2026-05-14 19:37:33', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771175487577') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1771175487577', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771175487577', false, '2026-02-15 20:11:27', 3, 0, true, false, '2026-02-15 20:11:27', '2026-02-15 20:54:27', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1777564858177') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1777564858177', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1777564858177', false, '2026-04-30 19:00:58', 3, 0, true, false, '2026-04-30 19:00:58', '2026-04-30 19:45:58', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778169467028') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1778169467028', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778169467028', false, '2026-05-07 18:57:47', 3, 0, true, false, '2026-05-07 18:57:47', '2026-05-07 19:39:47', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778172398485') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1778172398485', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778172398485', false, '2026-05-07 19:46:38', 3, 0, true, false, '2026-05-07 19:46:38', '2026-05-07 20:27:38', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776355484548') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1776355484548', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776355484548', false, '2026-04-16 19:04:44', 3, 0, true, false, '2026-04-16 19:04:44', '2026-04-16 19:46:44', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771179028678') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Şerh 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1771179028678', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771179028678', false, '2026-02-15 21:10:28', 3, 0, true, false, '2026-02-15 21:10:28', '2026-02-15 22:06:28', 56);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776959858436') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1776959858436', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776959858436', false, '2026-04-23 18:57:38', 3, 0, true, false, '2026-04-23 18:57:38', '2026-04-23 19:42:38', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771786993856') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh son ders not sonragelecek', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1771786993856', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771786993856', false, '2026-02-22 22:03:13', 3, 0, true, false, '2026-02-22 22:03:13', '2026-02-22 22:52:13', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771171138761') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1771171138761', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771171138761', false, '2026-02-15 18:58:58', 3, 0, true, false, '2026-02-15 18:58:58', '2026-02-15 19:37:58', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778776855673') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-17', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1778776855673', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778776855673', false, '2026-05-14 19:40:55', 3, 0, true, false, '2026-05-14 19:40:55', '2026-05-14 20:20:55', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1775750323459') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1775750323459', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1775750323459', false, '2026-04-09 18:58:43', 3, 0, true, false, '2026-04-09 18:58:43', '2026-04-09 19:42:43', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776963110625') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1776963110625', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776963110625', false, '2026-04-23 19:51:50', 3, 0, true, false, '2026-04-23 19:51:50', '2026-04-23 20:34:50', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1775758415712') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1775758415712', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1775758415712', false, '2026-04-09 21:13:35', 3, 0, true, false, '2026-04-09 21:13:35', '2026-04-09 21:54:35', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776361082970') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1776361082970', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776361082970', false, '2026-04-16 20:38:02', 3, 0, true, false, '2026-04-16 20:38:02', '2026-04-16 21:25:02', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776358334698') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1776358334698', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1776358334698', false, '2026-04-16 19:52:14', 3, 0, true, false, '2026-04-16 19:52:14', '2026-04-16 20:31:14', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778779971740') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit Şerhi-18 &quot;SON&quot; :(', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1778779971740', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1778779971740', false, '2026-05-14 20:32:51', 3, 0, true, false, '2026-05-14 20:32:51', '2026-05-14 20:57:51', 25);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '.2026 ŞERH UYGULAMALARI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771783434668') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Şerhh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4e115b4f2f6895ce8fc92bc882a966a33afede39-1771783434668', '4e115b4f2f6895ce8fc92bc882a966a33afede39-1771783434668', false, '2026-02-22 21:03:54', 3, 0, true, false, '2026-02-22 21:03:54', '2026-02-22 21:49:54', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751990243507') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Yeni Türk Edebiyatı Soru Çözümü- 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751990243507', '059f2ad29732c04932217af6f0290782094cecca-1751990243507', false, '2025-07-08 18:57:23', 3, 0, true, false, '2025-07-08 18:57:23', '2025-07-08 19:43:23', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751385671419') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'yeni türk edebiyatı soru çözüm-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751385671419', '059f2ad29732c04932217af6f0290782094cecca-1751385671419', false, '2025-07-01 19:01:11', 3, 0, true, false, '2025-07-01 19:01:11', '2025-07-01 19:49:11', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751738194816') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI SORU ÇÖZÜMÜ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751738194816', '059f2ad29732c04932217af6f0290782094cecca-1751738194816', false, '2025-07-05 20:56:34', 3, 0, true, false, '2025-07-05 20:56:34', '2025-07-05 21:30:34', 34);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751219879896') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KAMP DERSLERİ - DİL BİLİM 6. DERS      &quot;HER ŞEYE İNAT ATANACAKSIN!&quot;', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751219879896', '059f2ad29732c04932217af6f0290782094cecca-1751219879896', false, '2025-06-29 20:57:59', 3, 0, true, false, '2025-06-29 20:57:59', '2025-06-29 21:42:59', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752252294502') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752252294502', '059f2ad29732c04932217af6f0290782094cecca-1752252294502', false, '2025-07-11 19:44:54', 3, 0, true, false, '2025-07-11 19:44:54', '2025-07-11 20:26:54', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752169928027') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eski edebiyat genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752169928027', '059f2ad29732c04932217af6f0290782094cecca-1752169928027', false, '2025-07-10 20:52:08', 3, 0, true, false, '2025-07-10 20:52:08', '2025-07-10 21:29:08', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751047614502') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İlker Hayat-Eski Türk Edebiyatı Yıl Sonu Kampı-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751047614502', '059f2ad29732c04932217af6f0290782094cecca-1751047614502', false, '2025-06-27 21:06:54', 3, 0, true, false, '2025-06-27 21:06:54', '2025-06-27 21:49:54', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751997231524') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Yeni Türk Edebiyatı Soru Çözümü -6 (Son - Biz Bitti Demeden Bitmez)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751997231524', '059f2ad29732c04932217af6f0290782094cecca-1751997231524', false, '2025-07-08 20:53:51', 3, 0, true, false, '2025-07-08 20:53:51', '2025-07-08 21:42:51', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751820710070') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'genel tekrar 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751820710070', '059f2ad29732c04932217af6f0290782094cecca-1751820710070', false, '2025-07-06 19:51:50', 3, 0, true, false, '2025-07-06 19:51:50', '2025-07-06 20:38:50', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751132019111') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751132019111', '059f2ad29732c04932217af6f0290782094cecca-1751132019111', false, '2025-06-28 20:33:39', 3, 0, true, false, '2025-06-28 20:33:39', '2025-06-28 21:17:39', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751816523920') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'batı genel tekrarları 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751816523920', '059f2ad29732c04932217af6f0290782094cecca-1751816523920', false, '2025-07-06 18:42:03', 3, 0, true, false, '2025-07-06 18:42:03', '2025-07-06 19:31:03', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751903569585') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLGİSİ SON DERS (Güzel bir sıralama yapmanız dileğiyle:))', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751903569585', '059f2ad29732c04932217af6f0290782094cecca-1751903569585', false, '2025-07-07 18:52:49', 3, 0, true, false, '2025-07-07 18:52:49', '2025-07-07 19:49:49', 57);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751212710972') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KAMP DERSLERİ - DİL BİLİM 4. DERS  &quot;Hayallerine inan, çünkü onlar seni geleceğine taşır.&quot;', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751212710972', '059f2ad29732c04932217af6f0290782094cecca-1751212710972', false, '2025-06-29 18:58:30', 3, 0, true, false, '2025-06-29 18:58:30', '2025-06-29 19:46:30', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751735104192') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI SORU ÇÖZÜMÜ -2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751735104192', '059f2ad29732c04932217af6f0290782094cecca-1751735104192', false, '2025-07-05 20:05:04', 3, 0, true, false, '2025-07-05 20:05:04', '2025-07-05 20:52:04', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751478319909') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edeb.', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751478319909', '059f2ad29732c04932217af6f0290782094cecca-1751478319909', false, '2025-07-02 20:45:19', 3, 0, true, false, '2025-07-02 20:45:19', '2025-07-02 21:29:19', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1750959501050') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1750959501050', '059f2ad29732c04932217af6f0290782094cecca-1750959501050', false, '2025-06-26 20:38:21', 3, 0, true, false, '2025-06-26 20:38:21', '2025-06-26 21:17:21', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751558384543') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eski edebiyat nokta atışı konu tekrarı', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751558384543', '059f2ad29732c04932217af6f0290782094cecca-1751558384543', false, '2025-07-03 18:59:44', 3, 0, true, false, '2025-07-03 18:59:44', '2025-07-03 19:40:44', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751125762352') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751125762352', '059f2ad29732c04932217af6f0290782094cecca-1751125762352', false, '2025-06-28 18:49:22', 3, 0, true, false, '2025-06-28 18:49:22', '2025-06-28 19:28:22', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751731027284') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇOCUK EDEBİYATI SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751731027284', '059f2ad29732c04932217af6f0290782094cecca-1751731027284', false, '2025-07-05 18:57:07', 3, 0, true, false, '2025-07-05 18:57:07', '2025-07-05 19:43:07', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751647872912') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İlker Hayat-Eski Türk Edebiyatı Yıl Sonu Kampı-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751647872912', '059f2ad29732c04932217af6f0290782094cecca-1751647872912', false, '2025-07-04 19:51:12', 3, 0, true, false, '2025-07-04 19:51:12', '2025-07-04 20:43:12', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1750869906967') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KAMP DERSLERİ - DİL BİLİM 2. DERS “Başarı, umutsuzluğun ortasında bile umudunu kaybetmemektir.”', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1750869906967', '059f2ad29732c04932217af6f0290782094cecca-1750869906967', false, '2025-06-25 19:45:06', 3, 0, true, false, '2025-06-25 19:45:06', '2025-06-25 20:31:06', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751044511814') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İlker Hayat-Eski Türk Edebiyatı Yıl Sonu Kampı-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751044511814', '059f2ad29732c04932217af6f0290782094cecca-1751044511814', false, '2025-06-27 20:15:11', 3, 0, true, false, '2025-06-27 20:15:11', '2025-06-27 21:05:11', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751651716270') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İlker Hayat-Eski Türk Edebiyatı Yıl Sonu Kampı-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751651716270', '059f2ad29732c04932217af6f0290782094cecca-1751651716270', false, '2025-07-04 20:55:16', 3, 0, true, false, '2025-07-04 20:55:16', '2025-07-04 21:58:16', 63);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1750952798969') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1750952798969', '059f2ad29732c04932217af6f0290782094cecca-1750952798969', false, '2025-06-26 18:46:38', 3, 0, true, false, '2025-06-26 18:46:38', '2025-06-26 19:26:38', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751911979674') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLGİSİ (VEDA)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751911979674', '059f2ad29732c04932217af6f0290782094cecca-1751911979674', false, '2025-07-07 21:12:59', 3, 0, true, false, '2025-07-07 21:12:59', '2025-07-07 22:08:59', 56);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751824532631') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'genel tekrar 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751824532631', '059f2ad29732c04932217af6f0290782094cecca-1751824532631', false, '2025-07-06 20:55:32', 3, 0, true, false, '2025-07-06 20:55:32', '2025-07-06 21:52:32', 57);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751474943878') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edebiyatı', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751474943878', '059f2ad29732c04932217af6f0290782094cecca-1751474943878', false, '2025-07-02 19:49:03', 3, 0, true, false, '2025-07-02 19:49:03', '2025-07-02 20:28:03', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751471713013') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk edebiyatı', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751471713013', '059f2ad29732c04932217af6f0290782094cecca-1751471713013', false, '2025-07-02 18:55:13', 3, 0, true, false, '2025-07-02 18:55:13', '2025-07-02 19:36:13', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751215807819') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KAMP DERSLERİ - DİL BİLİM 5. DERS &quot;En karanlık anların arkasında ışık vardır.&quot;', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751215807819', '059f2ad29732c04932217af6f0290782094cecca-1751215807819', false, '2025-06-29 19:50:07', 3, 0, true, false, '2025-06-29 19:50:07', '2025-06-29 20:31:07', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751644780403') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İlker Hayat-Eski Türk Edebiyatı Yıl Sonu Kampı-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751644780403', '059f2ad29732c04932217af6f0290782094cecca-1751644780403', false, '2025-07-04 18:59:40', 3, 0, true, false, '2025-07-04 18:59:40', '2025-07-04 19:47:40', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1750873378436') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KAMP DERSLERİ - DİL BİLİM 3. DERS “En büyük başarılar, en büyük engelleri aşanlara aittir.”', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1750873378436', '059f2ad29732c04932217af6f0290782094cecca-1750873378436', false, '2025-06-25 20:42:58', 3, 0, true, false, '2025-06-25 20:42:58', '2025-06-25 21:38:58', 56);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751298719278') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLGİSİ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751298719278', '059f2ad29732c04932217af6f0290782094cecca-1751298719278', false, '2025-06-30 18:51:59', 3, 0, true, false, '2025-06-30 18:51:59', '2025-06-30 19:38:59', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752163258746') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eski edebiyat genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752163258746', '059f2ad29732c04932217af6f0290782094cecca-1752163258746', false, '2025-07-10 19:00:58', 3, 0, true, false, '2025-07-10 19:00:58', '2025-07-10 19:38:58', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751305776449') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil bilgisi-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751305776449', '059f2ad29732c04932217af6f0290782094cecca-1751305776449', false, '2025-06-30 20:49:36', 3, 0, true, false, '2025-06-30 20:49:36', '2025-06-30 21:35:36', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751993588966') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Yeni Türk Edebiyatı Soru Çözümü - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751993588966', '059f2ad29732c04932217af6f0290782094cecca-1751993588966', false, '2025-07-08 19:53:08', 3, 0, true, false, '2025-07-08 19:53:08', '2025-07-08 20:38:08', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1750866293746') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KAMP DERSLERİ - DİL BİLİM 1. DERS “Başarı, cesur adımların atıldığı yerde doğar.”', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1750866293746', '059f2ad29732c04932217af6f0290782094cecca-1750866293746', false, '2025-06-25 18:44:53', 3, 0, true, false, '2025-06-25 18:44:53', '2025-06-25 19:28:53', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751039520333') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'İlker Hayat-Eski Türk Edebiyatı Yıl Sonu Kampı-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751039520333', '059f2ad29732c04932217af6f0290782094cecca-1751039520333', false, '2025-06-27 18:52:00', 3, 0, true, false, '2025-06-27 18:52:00', '2025-06-27 19:41:00', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751564686356') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eski edebiyat genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751564686356', '059f2ad29732c04932217af6f0290782094cecca-1751564686356', false, '2025-07-03 20:44:46', 3, 0, true, false, '2025-07-03 20:44:46', '2025-07-03 21:27:46', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752083388343') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752083388343', '059f2ad29732c04932217af6f0290782094cecca-1752083388343', false, '2025-07-09 20:49:48', 3, 0, true, false, '2025-07-09 20:49:48', '2025-07-09 21:27:48', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752255794741') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ -9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752255794741', '059f2ad29732c04932217af6f0290782094cecca-1752255794741', false, '2025-07-11 20:43:14', 3, 0, true, false, '2025-07-11 20:43:14', '2025-07-11 21:20:14', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752079807191') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752079807191', '059f2ad29732c04932217af6f0290782094cecca-1752079807191', false, '2025-07-09 19:50:07', 3, 0, true, false, '2025-07-09 19:50:07', '2025-07-09 20:30:07', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752076608057') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752076608057', '059f2ad29732c04932217af6f0290782094cecca-1752076608057', false, '2025-07-09 18:56:48', 3, 0, true, false, '2025-07-09 18:56:48', '2025-07-09 19:36:48', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751392887493') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Yeni Türk Edebiyatı Soru Çözümü- 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751392887493', '059f2ad29732c04932217af6f0290782094cecca-1751392887493', false, '2025-07-01 21:01:27', 3, 0, true, false, '2025-07-01 21:01:27', '2025-07-01 21:56:27', 55);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751561479572') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eski edebiyat nokta atışı genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751561479572', '059f2ad29732c04932217af6f0290782094cecca-1751561479572', false, '2025-07-03 19:51:19', 3, 0, true, false, '2025-07-03 19:51:19', '2025-07-03 20:32:19', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751908189631') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLGİSİ SON DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751908189631', '059f2ad29732c04932217af6f0290782094cecca-1751908189631', false, '2025-07-07 20:09:49', 3, 0, true, false, '2025-07-07 20:09:49', '2025-07-07 20:59:49', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1750956020832') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1750956020832', '059f2ad29732c04932217af6f0290782094cecca-1750956020832', false, '2025-06-26 19:40:20', 3, 0, true, false, '2025-06-26 19:40:20', '2025-06-26 20:22:20', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751389018087') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Yeni Türk Edebiyatı Soru Çözümü -2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751389018087', '059f2ad29732c04932217af6f0290782094cecca-1751389018087', false, '2025-07-01 19:56:58', 3, 0, true, false, '2025-07-01 19:56:58', '2025-07-01 20:44:58', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752335171500') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'VEDA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752335171500', '059f2ad29732c04932217af6f0290782094cecca-1752335171500', false, '2025-07-12 18:46:11', 3, 0, true, false, '2025-07-12 18:46:11', '2025-07-12 19:02:11', 16);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751128773308') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751128773308', '059f2ad29732c04932217af6f0290782094cecca-1751128773308', false, '2025-06-28 19:39:33', 3, 0, true, false, '2025-06-28 19:39:33', '2025-06-28 20:22:33', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1751302497848') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Dil bilgisi-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1751302497848', '059f2ad29732c04932217af6f0290782094cecca-1751302497848', false, '2025-06-30 19:54:57', 3, 0, true, false, '2025-06-30 19:54:57', '2025-06-30 20:33:57', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752166522696') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'eski edebiyat tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752166522696', '059f2ad29732c04932217af6f0290782094cecca-1752166522696', false, '2025-07-10 19:55:22', 3, 0, true, false, '2025-07-10 19:55:22', '2025-07-10 20:33:22', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - GENEL TEKRAR' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '059f2ad29732c04932217af6f0290782094cecca-1752248395210') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DÖRT TEMEL BECERİ - 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=059f2ad29732c04932217af6f0290782094cecca-1752248395210', '059f2ad29732c04932217af6f0290782094cecca-1752248395210', false, '2025-07-11 18:39:55', 3, 0, true, false, '2025-07-11 18:39:55', '2025-07-11 19:24:55', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741368596314') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TANIŞMA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741368596314', '885cd183396123664aae15258f36ab40589223ad-1741368596314', false, '2025-03-07 20:29:56', 3, 0, true, false, '2025-03-07 20:29:56', '2025-03-07 21:01:56', 32);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741890456489') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '222 SAYILI KANUN 5. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741890456489', '885cd183396123664aae15258f36ab40589223ad-1741890456489', false, '2025-03-13 21:27:36', 3, 0, true, false, '2025-03-13 21:27:36', '2025-03-13 21:50:36', 23);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746118676474') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 8. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746118676474', '885cd183396123664aae15258f36ab40589223ad-1746118676474', false, '2025-05-01 19:57:56', 3, 0, true, false, '2025-05-01 19:57:56', '2025-05-01 20:41:56', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741886762456') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '222 SAYILI KANUN 4. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741886762456', '885cd183396123664aae15258f36ab40589223ad-1741886762456', false, '2025-03-13 20:26:02', 3, 0, true, false, '2025-03-13 20:26:02', '2025-03-13 21:10:02', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1743103640583') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7528 SAYILI KANUN 3. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1743103640583', '885cd183396123664aae15258f36ab40589223ad-1743103640583', false, '2025-03-27 22:27:20', 3, 0, true, false, '2025-03-27 22:27:20', '2025-03-27 23:15:20', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741375201299') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '222 SAYILI KANUN 3. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741375201299', '885cd183396123664aae15258f36ab40589223ad-1741375201299', false, '2025-03-07 22:20:01', 3, 0, true, false, '2025-03-07 22:20:01', '2025-03-07 23:04:01', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1743096208285') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7528 ÖĞRETMENLİK MESLEK KANUNU 1. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1743096208285', '885cd183396123664aae15258f36ab40589223ad-1743096208285', false, '2025-03-27 20:23:28', 3, 0, true, false, '2025-03-27 20:23:28', '2025-03-27 21:08:28', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1743700116588') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7528 SAYILI KANUN 5. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1743700116588', '885cd183396123664aae15258f36ab40589223ad-1743700116588', false, '2025-04-03 20:08:36', 3, 0, true, false, '2025-04-03 20:08:36', '2025-04-03 20:48:36', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746719524407') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 10. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746719524407', '885cd183396123664aae15258f36ab40589223ad-1746719524407', false, '2025-05-08 18:52:04', 3, 0, true, false, '2025-05-08 18:52:04', '2025-05-08 19:36:04', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1743702817729') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7528 SAYILI KANUN 6. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1743702817729', '885cd183396123664aae15258f36ab40589223ad-1743702817729', false, '2025-04-03 20:53:37', 3, 0, true, false, '2025-04-03 20:53:37', '2025-04-03 21:46:37', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746730902760') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 13. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746730902760', '885cd183396123664aae15258f36ab40589223ad-1746730902760', false, '2025-05-08 22:01:42', 3, 0, true, false, '2025-05-08 22:01:42', '2025-05-08 22:32:42', 31);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1745510159857') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 7. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1745510159857', '885cd183396123664aae15258f36ab40589223ad-1745510159857', false, '2025-04-24 18:55:59', 3, 0, true, false, '2025-04-24 18:55:59', '2025-04-24 19:40:59', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741893817345') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1739 SAYILI KANUN 2. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741893817345', '885cd183396123664aae15258f36ab40589223ad-1741893817345', false, '2025-03-13 22:23:37', 3, 0, true, false, '2025-03-13 22:23:37', '2025-03-13 23:12:37', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1744908787358') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 5. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1744908787358', '885cd183396123664aae15258f36ab40589223ad-1744908787358', false, '2025-04-17 19:53:07', 3, 0, true, false, '2025-04-17 19:53:07', '2025-04-17 20:37:07', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1744912889463') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 6. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1744912889463', '885cd183396123664aae15258f36ab40589223ad-1744912889463', false, '2025-04-17 21:01:29', 3, 0, true, false, '2025-04-17 21:01:29', '2025-04-17 21:46:29', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1742490839699') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1739 SAYILI KANUN 3. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1742490839699', '885cd183396123664aae15258f36ab40589223ad-1742490839699', false, '2025-03-20 20:13:59', 3, 0, true, false, '2025-03-20 20:13:59', '2025-03-20 20:59:59', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746114667287') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 7. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746114667287', '885cd183396123664aae15258f36ab40589223ad-1746114667287', false, '2025-05-01 18:51:07', 3, 0, true, false, '2025-05-01 18:51:07', '2025-05-01 19:35:07', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741371932222') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '222 SAYILI KANUN 2. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741371932222', '885cd183396123664aae15258f36ab40589223ad-1741371932222', false, '2025-03-07 21:25:32', 3, 0, true, false, '2025-03-07 21:25:32', '2025-03-07 22:10:32', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1744905180859') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 4. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1744905180859', '885cd183396123664aae15258f36ab40589223ad-1744905180859', false, '2025-04-17 18:53:00', 3, 0, true, false, '2025-04-17 18:53:00', '2025-04-17 19:38:00', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1743100061753') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7528 ÖĞRETMENLİK MESLEK KANUNU 2. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1743100061753', '885cd183396123664aae15258f36ab40589223ad-1743100061753', false, '2025-03-27 21:27:41', 3, 0, true, false, '2025-03-27 21:27:41', '2025-03-27 22:08:41', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1741892124548') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1739 SAYILI KANUN 1. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1741892124548', '885cd183396123664aae15258f36ab40589223ad-1741892124548', false, '2025-03-13 21:55:24', 3, 0, true, false, '2025-03-13 21:55:24', '2025-03-13 22:13:24', 18);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746122438164') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 9. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746122438164', '885cd183396123664aae15258f36ab40589223ad-1746122438164', false, '2025-05-01 21:00:38', 3, 0, true, false, '2025-05-01 21:00:38', '2025-05-01 21:45:38', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1742498801635') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1739 SAYILI KANUN 5. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1742498801635', '885cd183396123664aae15258f36ab40589223ad-1742498801635', false, '2025-03-20 22:26:41', 3, 0, true, false, '2025-03-20 22:26:41', '2025-03-20 22:51:41', 25);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746727086068') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 12. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746727086068', '885cd183396123664aae15258f36ab40589223ad-1746727086068', false, '2025-05-08 20:58:06', 3, 0, true, false, '2025-05-08 20:58:06', '2025-05-08 21:42:06', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1743695873263') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7528 SAYILI KANUN 4. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1743695873263', '885cd183396123664aae15258f36ab40589223ad-1743695873263', false, '2025-04-03 18:57:53', 3, 0, true, false, '2025-04-03 18:57:53', '2025-04-03 19:54:53', 57);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1744307936747') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 3. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1744307936747', '885cd183396123664aae15258f36ab40589223ad-1744307936747', false, '2025-04-10 20:58:56', 3, 0, true, false, '2025-04-10 20:58:56', '2025-04-10 21:45:56', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1744300365169') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 1. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1744300365169', '885cd183396123664aae15258f36ab40589223ad-1744300365169', false, '2025-04-10 18:52:45', 3, 0, true, false, '2025-04-10 18:52:45', '2025-04-10 19:35:45', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1745513856878') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 8. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1745513856878', '885cd183396123664aae15258f36ab40589223ad-1745513856878', false, '2025-04-24 19:57:36', 3, 0, true, false, '2025-04-24 19:57:36', '2025-04-24 20:43:36', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1744304917768') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI - 2.DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1744304917768', '885cd183396123664aae15258f36ab40589223ad-1744304917768', false, '2025-04-10 20:08:37', 3, 0, true, false, '2025-04-10 20:08:37', '2025-04-10 20:48:37', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1746723438558') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 11. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1746723438558', '885cd183396123664aae15258f36ab40589223ad-1746723438558', false, '2025-05-08 19:57:18', 3, 0, true, false, '2025-05-08 19:57:18', '2025-05-08 20:39:18', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1742494688640') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1739 SAYILI KANUN 4. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1742494688640', '885cd183396123664aae15258f36ab40589223ad-1742494688640', false, '2025-03-20 21:18:08', 3, 0, true, false, '2025-03-20 21:18:08', '2025-03-20 22:04:08', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 - MEVZUAT' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '885cd183396123664aae15258f36ab40589223ad-1745517139276') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1982 ANAYASASI 9. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=885cd183396123664aae15258f36ab40589223ad-1745517139276', '885cd183396123664aae15258f36ab40589223ad-1745517139276', false, '2025-04-24 20:52:19', 3, 0, true, false, '2025-04-24 20:52:19', '2025-04-24 21:33:19', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738518522021') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CÜMLELER ARASI ANLAMSAL İLİŞKİLER &quot;Unutma kaybettiğinde değil, vazgeçtiğinde yenilirsin!&quot;', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738518522021', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738518522021', false, '2025-02-02 20:48:42', 3, 0, true, false, '2025-02-02 20:48:42', '2025-02-02 21:38:42', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740333127750') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİL BİLİM 3 VE SORULAR', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740333127750', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740333127750', false, '2025-02-23 20:52:07', 3, 0, true, false, '2025-02-23 20:52:07', '2025-02-23 21:35:07', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734364060687') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ROMAN JAKOBSON - BİLDİRİŞİM ÖGELERİ VE DİLİN İŞLEVLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734364060687', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734364060687', false, '2024-12-16 18:47:40', 3, 0, true, false, '2024-12-16 18:47:40', '2024-12-16 19:59:40', 72);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740329386132') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİL BİLİM 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740329386132', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740329386132', false, '2025-02-23 19:49:46', 3, 0, true, false, '2025-02-23 19:49:46', '2025-02-23 20:35:46', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739721022181') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM BİLİMİ 2 (TELAFİ)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739721022181', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739721022181', false, '2025-02-16 18:50:22', 3, 0, true, false, '2025-02-16 18:50:22', '2025-02-16 19:31:22', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730130433987') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 1. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730130433987', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730130433987', false, '2024-10-28 18:47:13', 3, 0, true, false, '2024-10-28 18:47:13', '2024-10-28 19:31:13', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731343804360') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 8 - DİL KAVRAMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731343804360', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731343804360', false, '2024-11-11 19:50:04', 3, 0, true, false, '2024-11-11 19:50:04', '2024-11-11 20:35:04', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733161634027') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FERDİNAND DE SAUSSURE VE ÖNEMLİ ÇALIŞMALARI (SORU POTANSİYELİ TAŞIYOR)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733161634027', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733161634027', false, '2024-12-02 20:47:14', 3, 0, true, false, '2024-12-02 20:47:14', '2024-12-02 21:30:14', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739724290638') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM BİLİM 3 (SÖZ EYLEMLER)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739724290638', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739724290638', false, '2025-02-16 19:44:50', 3, 0, true, false, '2025-02-16 19:44:50', '2025-02-16 20:21:50', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735577497010') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLİMİ 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735577497010', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735577497010', false, '2024-12-30 19:51:37', 3, 0, true, false, '2024-12-30 19:51:37', '2024-12-30 20:34:37', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732553527666') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MODERN DİL BİLİM **** ÇOK ÖNEMLİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732553527666', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732553527666', false, '2024-11-25 19:52:07', 3, 0, true, false, '2024-11-25 19:52:07', '2024-11-25 20:39:07', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735580771441') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLİMİ 3 VE SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735580771441', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735580771441', false, '2024-12-30 20:46:11', 3, 0, true, false, '2024-12-30 20:46:11', '2024-12-30 21:16:11', 30);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734973604069') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SON DİL BİLİM KURAMLARI 2 VE SORULARR', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734973604069', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734973604069', false, '2024-12-23 20:06:44', 3, 0, true, false, '2024-12-23 20:06:44', '2024-12-23 21:34:44', 88);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733759426030') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FERDİNAND DE SAUSSURE (DİZİSEL - DİZİMSEL İLİŞKİLER VE DİĞER KAVRAMLAR)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733759426030', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733759426030', false, '2024-12-09 18:50:26', 3, 0, true, false, '2024-12-09 18:50:26', '2024-12-09 19:43:26', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738511724171') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLAM İLİŞKİLERİ - ANLAM OLAYLARI 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738511724171', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738511724171', false, '2025-02-02 18:55:24', 3, 0, true, false, '2025-02-02 18:55:24', '2025-02-02 19:40:24', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736783664891') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK YAPMA YOLLARI VE SÖZ DİZİMİ (SENTAKS)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736783664891', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736783664891', false, '2025-01-13 18:54:24', 3, 0, true, false, '2025-01-13 18:54:24', '2025-01-13 19:36:24', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738514985883') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLAM İLİŞKİLERİ - ANLAM OLAYLARI 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738514985883', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1738514985883', false, '2025-02-02 19:49:45', 3, 0, true, false, '2025-02-02 19:49:45', '2025-02-02 20:34:45', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730133988299') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 2. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730133988299', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730133988299', false, '2024-10-28 19:46:28', 3, 0, true, false, '2024-10-28 19:46:28', '2024-10-28 20:28:28', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734369455878') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİMCİLERİN KURAMLARININ DEVAMI : HARRİS VE SONRASI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734369455878', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734369455878', false, '2024-12-16 20:17:35', 3, 0, true, false, '2024-12-16 20:17:35', '2024-12-16 21:07:35', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732557022633') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM OKULLARI + SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732557022633', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732557022633', false, '2024-11-25 20:50:22', 3, 0, true, false, '2024-11-25 20:50:22', '2024-11-25 21:40:22', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740326264252') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİL BİLİM 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740326264252', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740326264252', false, '2025-02-23 18:57:44', 3, 0, true, false, '2025-02-23 18:57:44', '2025-02-23 19:43:44', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730735702983') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 4. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730735702983', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730735702983', false, '2024-11-04 18:55:02', 3, 0, true, false, '2024-11-04 18:55:02', '2024-11-04 19:41:02', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730137110288') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 3. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730137110288', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730137110288', false, '2024-10-28 20:38:30', 3, 0, true, false, '2024-10-28 20:38:30', '2024-10-28 21:19:30', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739731134662') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM BİLİM (KONU, ODAK) VE SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739731134662', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739731134662', false, '2025-02-16 21:38:54', 3, 0, true, false, '2025-02-16 21:38:54', '2025-02-16 22:29:54', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730743871487') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM SORU ÇÖZÜMÜ DERSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730743871487', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730743871487', false, '2024-11-04 21:11:11', 3, 0, true, false, '2024-11-04 21:11:11', '2024-11-04 21:38:11', 27);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736614087288') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİÇİM BİLİMİ 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736614087288', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736614087288', false, '2025-01-11 19:48:07', 3, 0, true, false, '2025-01-11 19:48:07', '2025-01-11 20:28:07', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739115914291') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'EDİM BİLİMİ 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739115914291', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739115914291', false, '2025-02-09 18:45:14', 3, 0, true, false, '2025-02-09 18:45:14', '2025-02-09 19:34:14', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731949775422') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM TARİHİ (MODERN ÖNCESİ)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731949775422', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731949775422', false, '2024-11-18 20:09:35', 3, 0, true, false, '2024-11-18 20:09:35', '2024-11-18 21:15:35', 66);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736617379858') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİÇİM BİLİMİ 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736617379858', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736617379858', false, '2025-01-11 20:42:59', 3, 0, true, false, '2025-01-11 20:42:59', '2025-01-11 21:47:59', 65);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731340541648') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 7. DERS /  2. ÜNİTE', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731340541648', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731340541648', false, '2024-11-11 18:55:41', 3, 0, true, false, '2024-11-11 18:55:41', '2024-11-11 19:40:41', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733763530759') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'NOAM CHOMSKY VE ANDRE MARTİNET', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733763530759', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733763530759', false, '2024-12-09 19:58:50', 3, 0, true, false, '2024-12-09 19:58:50', '2024-12-09 21:18:50', 80);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730739638879') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM 5. DERS', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730739638879', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1730739638879', false, '2024-11-04 20:00:38', 3, 0, true, false, '2024-11-04 20:00:38', '2024-11-04 20:58:38', 58);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733158479059') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ETKİNLİK VE SORU ÇÖZÜMÜ ✅', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733158479059', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733158479059', false, '2024-12-02 19:54:39', 3, 0, true, false, '2024-12-02 19:54:39', '2024-12-02 20:33:39', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739727619538') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİLGİ DEĞERİ , BİLGİ YAPISI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739727619538', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1739727619538', false, '2025-02-16 20:40:19', 3, 0, true, false, '2025-02-16 20:40:19', '2025-02-16 21:25:19', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736790129884') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SEMANTİK (ANLAM BİLİMİ) 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736790129884', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736790129884', false, '2025-01-13 20:42:09', 3, 0, true, false, '2025-01-13 20:42:09', '2025-01-13 21:30:09', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740336746753') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖNCEKİ DERSTE BİR GİRİŞ YAPTIĞIMIZ GÖSTERGE BİLİM ÜNİTESİNİN DEVAMI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740336746753', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1740336746753', false, '2025-02-23 21:52:26', 3, 0, true, false, '2025-02-23 21:52:26', '2025-02-23 22:35:26', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731944680776') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL AİLELERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731944680776', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731944680776', false, '2024-11-18 18:44:40', 3, 0, true, false, '2024-11-18 18:44:40', '2024-11-18 19:49:40', 65);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732550042140') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MODERN ÖNCESİ PORT ROYAL DİL BİLİM OKULU VE SONRASI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732550042140', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1732550042140', false, '2024-11-25 18:54:02', 3, 0, true, false, '2024-11-25 18:54:02', '2024-11-25 19:41:02', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731347249961') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL EDİNİMİ ÇOK ÖNEMLİ DERS (CHOMSKYE BİR GİRİŞ)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731347249961', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1731347249961', false, '2024-11-11 20:47:29', 3, 0, true, false, '2024-11-11 20:47:29', '2024-11-11 21:42:29', 55);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733155167986') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FERDİNAND DE SAUSSURE *ÇOK ÖNEMLİ*', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733155167986', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1733155167986', false, '2024-12-02 18:59:27', 3, 0, true, false, '2024-12-02 18:59:27', '2024-12-02 19:45:27', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736611005480') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'BİÇİM BİLİMİ 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736611005480', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736611005480', false, '2025-01-11 18:56:45', 3, 0, true, false, '2025-01-11 18:56:45', '2025-01-11 19:40:45', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735574214555') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SES BİLİMİ 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735574214555', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1735574214555', false, '2024-12-30 18:56:54', 3, 0, true, false, '2024-12-30 18:56:54', '2024-12-30 19:38:54', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736786621097') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZ DİZİMİ ( SENTAKS) EVRENSELLİKLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736786621097', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1736786621097', false, '2025-01-13 19:43:41', 3, 0, true, false, '2025-01-13 19:43:41', '2025-01-13 20:28:41', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734968688210') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SON DİL BİLİM KURAMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734968688210', '892b584343d0c9fc7ab552c5c90bbfd699dca74d-1734968688210', false, '2024-12-23 18:44:48', 3, 0, true, false, '2024-12-23 18:44:48', '2024-12-23 19:46:48', 62);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1731516470724') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1731516470724', 'fe534ba2be486200b29eba3998f61d35ede4b765-1731516470724', false, '2024-11-13 19:47:50', 3, 0, true, false, '2024-11-13 19:47:50', '2024-11-13 20:27:50', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1734540591369') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1734540591369', 'fe534ba2be486200b29eba3998f61d35ede4b765-1734540591369', false, '2024-12-18 19:49:51', 3, 0, true, false, '2024-12-18 19:49:51', '2024-12-18 20:27:51', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1733935554667') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1733935554667', 'fe534ba2be486200b29eba3998f61d35ede4b765-1733935554667', false, '2024-12-11 19:45:54', 3, 0, true, false, '2024-12-11 19:45:54', '2024-12-11 20:25:54', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1733333933885') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri türleri sorularla tekrar ve analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1733333933885', 'fe534ba2be486200b29eba3998f61d35ede4b765-1733333933885', false, '2024-12-04 20:38:53', 3, 0, true, false, '2024-12-04 20:38:53', '2024-12-04 21:20:53', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1741198811978') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar eser', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1741198811978', 'fe534ba2be486200b29eba3998f61d35ede4b765-1741198811978', false, '2025-03-05 21:20:11', 3, 0, true, false, '2025-03-05 21:20:11', '2025-03-05 22:01:11', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1733327437854') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi nazım şekilleri türleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1733327437854', 'fe534ba2be486200b29eba3998f61d35ede4b765-1733327437854', false, '2024-12-04 18:50:37', 3, 0, true, false, '2024-12-04 18:50:37', '2024-12-04 19:31:37', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739378771320') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mazmunlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739378771320', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739378771320', false, '2025-02-12 19:46:11', 3, 0, true, false, '2025-02-12 19:46:11', '2025-02-12 20:27:11', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1734543487002') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1734543487002', 'fe534ba2be486200b29eba3998f61d35ede4b765-1734543487002', false, '2024-12-18 20:38:07', 3, 0, true, false, '2024-12-18 20:38:07', '2024-12-18 21:19:07', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1735753242706') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1735753242706', 'fe534ba2be486200b29eba3998f61d35ede4b765-1735753242706', false, '2025-01-01 20:40:42', 3, 0, true, false, '2025-01-01 20:40:42', '2025-01-01 21:22:42', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1733330881753') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri türleri ve sorularla genel tekrar ve analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1733330881753', 'fe534ba2be486200b29eba3998f61d35ede4b765-1733330881753', false, '2024-12-04 19:48:01', 3, 0, true, false, '2024-12-04 19:48:01', '2024-12-04 20:28:01', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1738166052530') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz ve işlemler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1738166052530', 'fe534ba2be486200b29eba3998f61d35ede4b765-1738166052530', false, '2025-01-29 18:54:12', 3, 0, true, false, '2025-01-29 18:54:12', '2025-01-29 19:34:12', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1733932385695') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi - söz sanatları', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1733932385695', 'fe534ba2be486200b29eba3998f61d35ede4b765-1733932385695', false, '2024-12-11 18:53:05', 3, 0, true, false, '2024-12-11 18:53:05', '2024-12-11 19:32:05', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1735750088967') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1735750088967', 'fe534ba2be486200b29eba3998f61d35ede4b765-1735750088967', false, '2025-01-01 19:48:08', 3, 0, true, false, '2025-01-01 19:48:08', '2025-01-01 20:28:08', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1736955568948') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme ve sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1736955568948', 'fe534ba2be486200b29eba3998f61d35ede4b765-1736955568948', false, '2025-01-15 18:39:28', 3, 0, true, false, '2025-01-15 18:39:28', '2025-01-15 19:19:28', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1734537256693') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Beyit incelemesi - sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1734537256693', 'fe534ba2be486200b29eba3998f61d35ede4b765-1734537256693', false, '2024-12-18 18:54:16', 3, 0, true, false, '2024-12-18 18:54:16', '2024-12-18 19:34:16', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1736355232821') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1736355232821', 'fe534ba2be486200b29eba3998f61d35ede4b765-1736355232821', false, '2025-01-08 19:53:52', 3, 0, true, false, '2025-01-08 19:53:52', '2025-01-08 20:34:52', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1731519573290') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1731519573290', 'fe534ba2be486200b29eba3998f61d35ede4b765-1731519573290', false, '2024-11-13 20:39:33', 3, 0, true, false, '2024-11-13 20:39:33', '2024-11-13 21:20:33', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1744041409608') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'anonim halk edebiyatı', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1744041409608', 'fe534ba2be486200b29eba3998f61d35ede4b765-1744041409608', false, '2025-04-07 18:56:49', 3, 0, true, false, '2025-04-07 18:56:49', '2025-04-07 18:56:49', 0);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1730911590862') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1730911590862', 'fe534ba2be486200b29eba3998f61d35ede4b765-1730911590862', false, '2024-11-06 19:46:30', 3, 0, true, false, '2024-11-06 19:46:30', '2024-11-06 20:29:30', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739986719129') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tezkireler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739986719129', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739986719129', false, '2025-02-19 20:38:39', 3, 0, true, false, '2025-02-19 20:38:39', '2025-02-19 21:27:39', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1740588509081') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar eser', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1740588509081', 'fe534ba2be486200b29eba3998f61d35ede4b765-1740588509081', false, '2025-02-26 19:48:29', 3, 0, true, false, '2025-02-26 19:48:29', '2025-02-26 20:25:29', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1736959815814') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar ve sorularla analiz tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1736959815814', 'fe534ba2be486200b29eba3998f61d35ede4b765-1736959815814', false, '2025-01-15 19:50:15', 3, 0, true, false, '2025-01-15 19:50:15', '2025-01-15 20:30:15', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1732726081464') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1732726081464', 'fe534ba2be486200b29eba3998f61d35ede4b765-1732726081464', false, '2024-11-27 19:48:01', 3, 0, true, false, '2024-11-27 19:48:01', '2024-11-27 20:28:01', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1738774252004') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz ve işlemler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1738774252004', 'fe534ba2be486200b29eba3998f61d35ede4b765-1738774252004', false, '2025-02-05 19:50:52', 3, 0, true, false, '2025-02-05 19:50:52', '2025-02-05 20:31:52', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739375804052') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mazmunlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739375804052', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739375804052', false, '2025-02-12 18:56:44', 3, 0, true, false, '2025-02-12 18:56:44', '2025-02-12 19:36:44', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1735148196090') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1735148196090', 'fe534ba2be486200b29eba3998f61d35ede4b765-1735148196090', false, '2024-12-25 20:36:36', 3, 0, true, false, '2024-12-25 20:36:36', '2024-12-25 21:17:36', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1735142009461') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi-sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1735142009461', 'fe534ba2be486200b29eba3998f61d35ede4b765-1735142009461', false, '2024-12-25 18:53:29', 3, 0, true, false, '2024-12-25 18:53:29', '2024-12-25 19:34:29', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1730908421262') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme ve nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1730908421262', 'fe534ba2be486200b29eba3998f61d35ede4b765-1730908421262', false, '2024-11-06 18:53:41', 3, 0, true, false, '2024-11-06 18:53:41', '2024-11-06 19:33:41', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1731512950925') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi - nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1731512950925', 'fe534ba2be486200b29eba3998f61d35ede4b765-1731512950925', false, '2024-11-13 18:49:10', 3, 0, true, false, '2024-11-13 18:49:10', '2024-11-13 19:30:10', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1730306838624') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme ve nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1730306838624', 'fe534ba2be486200b29eba3998f61d35ede4b765-1730306838624', false, '2024-10-30 19:47:18', 3, 0, true, false, '2024-10-30 19:47:18', '2024-10-30 20:28:18', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1730303006264') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit icelemesi ve nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1730303006264', 'fe534ba2be486200b29eba3998f61d35ede4b765-1730303006264', false, '2024-10-30 18:43:26', 3, 0, true, false, '2024-10-30 18:43:26', '2024-10-30 19:23:26', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739983577308') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mazmunlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739983577308', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739983577308', false, '2025-02-19 19:46:17', 3, 0, true, false, '2025-02-19 19:46:17', '2025-02-19 20:25:17', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1732124326641') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1732124326641', 'fe534ba2be486200b29eba3998f61d35ede4b765-1732124326641', false, '2024-11-20 20:38:46', 3, 0, true, false, '2024-11-20 20:38:46', '2024-11-20 21:16:46', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1732121350927') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1732121350927', 'fe534ba2be486200b29eba3998f61d35ede4b765-1732121350927', false, '2024-11-20 19:49:10', 3, 0, true, false, '2024-11-20 19:49:10', '2024-11-20 20:28:10', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1733938787506') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1733938787506', 'fe534ba2be486200b29eba3998f61d35ede4b765-1733938787506', false, '2024-12-11 20:39:47', 3, 0, true, false, '2024-12-11 20:39:47', '2024-12-11 21:17:47', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1736962893238') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar sorularla analiz tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1736962893238', 'fe534ba2be486200b29eba3998f61d35ede4b765-1736962893238', false, '2025-01-15 20:41:33', 3, 0, true, false, '2025-01-15 20:41:33', '2025-01-15 21:24:33', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1730914898637') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1730914898637', 'fe534ba2be486200b29eba3998f61d35ede4b765-1730914898637', false, '2024-11-06 20:41:38', 3, 0, true, false, '2024-11-06 20:41:38', '2024-11-06 21:22:38', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739385031002') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mazmunlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739385031002', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739385031002', false, '2025-02-12 21:30:31', 3, 0, true, false, '2025-02-12 21:30:31', '2025-02-12 22:11:31', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1740594714650') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar eser', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1740594714650', 'fe534ba2be486200b29eba3998f61d35ede4b765-1740594714650', false, '2025-02-26 21:31:54', 3, 0, true, false, '2025-02-26 21:31:54', '2025-02-26 22:04:54', 33);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1740585250591') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar ve eserler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1740585250591', 'fe534ba2be486200b29eba3998f61d35ede4b765-1740585250591', false, '2025-02-26 18:54:10', 3, 0, true, false, '2025-02-26 18:54:10', '2025-02-26 19:33:10', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1730309951493') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1730309951493', 'fe534ba2be486200b29eba3998f61d35ede4b765-1730309951493', false, '2024-10-30 20:39:11', 3, 0, true, false, '2024-10-30 20:39:11', '2024-10-30 21:21:11', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1738770898962') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme ve aruz işlemleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1738770898962', 'fe534ba2be486200b29eba3998f61d35ede4b765-1738770898962', false, '2025-02-05 18:54:58', 3, 0, true, false, '2025-02-05 18:54:58', '2025-02-05 19:37:58', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1735746880369') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi- sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1735746880369', 'fe534ba2be486200b29eba3998f61d35ede4b765-1735746880369', false, '2025-01-01 18:54:40', 3, 0, true, false, '2025-01-01 18:54:40', '2025-01-01 19:33:40', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1736351765599') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi- sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1736351765599', 'fe534ba2be486200b29eba3998f61d35ede4b765-1736351765599', false, '2025-01-08 18:56:05', 3, 0, true, false, '2025-01-08 18:56:05', '2025-01-08 19:39:05', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1735145278947') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1735145278947', 'fe534ba2be486200b29eba3998f61d35ede4b765-1735145278947', false, '2024-12-25 19:47:58', 3, 0, true, false, '2024-12-25 19:47:58', '2024-12-25 20:28:58', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1741195685746') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar eser', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1741195685746', 'fe534ba2be486200b29eba3998f61d35ede4b765-1741195685746', false, '2025-03-05 20:28:05', 3, 0, true, false, '2025-03-05 20:28:05', '2025-03-05 21:08:05', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1732118164346') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit şerhi ve nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1732118164346', 'fe534ba2be486200b29eba3998f61d35ede4b765-1732118164346', false, '2024-11-20 18:56:04', 3, 0, true, false, '2024-11-20 18:56:04', '2024-11-20 19:37:04', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1736359158358') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sanatlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1736359158358', 'fe534ba2be486200b29eba3998f61d35ede4b765-1736359158358', false, '2025-01-08 20:59:18', 3, 0, true, false, '2025-01-08 20:59:18', '2025-01-08 21:43:18', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1740591494537') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar eser', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1740591494537', 'fe534ba2be486200b29eba3998f61d35ede4b765-1740591494537', false, '2025-02-26 20:38:14', 3, 0, true, false, '2025-02-26 20:38:14', '2025-02-26 21:19:14', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1738169163706') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz ve işlemler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1738169163706', 'fe534ba2be486200b29eba3998f61d35ede4b765-1738169163706', false, '2025-01-29 19:46:03', 3, 0, true, false, '2025-01-29 19:46:03', '2025-01-29 20:27:03', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1732722998837') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi nazım şekilleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1732722998837', 'fe534ba2be486200b29eba3998f61d35ede4b765-1732722998837', false, '2024-11-27 18:56:38', 3, 0, true, false, '2024-11-27 18:56:38', '2024-11-27 19:37:38', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1732729209556') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'nazım türleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1732729209556', 'fe534ba2be486200b29eba3998f61d35ede4b765-1732729209556', false, '2024-11-27 20:40:09', 3, 0, true, false, '2024-11-27 20:40:09', '2024-11-27 21:20:09', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739382045527') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mazmunlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739382045527', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739382045527', false, '2025-02-12 20:40:45', 3, 0, true, false, '2025-02-12 20:40:45', '2025-02-12 21:18:45', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1739980458029') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'mazmunlar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1739980458029', 'fe534ba2be486200b29eba3998f61d35ede4b765-1739980458029', false, '2025-02-19 18:54:18', 3, 0, true, false, '2025-02-19 18:54:18', '2025-02-19 19:35:18', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1741202149975') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şair yazar eserler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1741202149975', 'fe534ba2be486200b29eba3998f61d35ede4b765-1741202149975', false, '2025-03-05 22:15:49', 3, 0, true, false, '2025-03-05 22:15:49', '2025-03-05 23:05:49', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '2025 ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fe534ba2be486200b29eba3998f61d35ede4b765-1738172304833') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz ve işlemler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fe534ba2be486200b29eba3998f61d35ede4b765-1738172304833', 'fe534ba2be486200b29eba3998f61d35ede4b765-1738172304833', false, '2025-01-29 20:38:24', 3, 0, true, false, '2025-01-29 20:38:24', '2025-01-29 21:21:24', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714922303160') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714922303160', 'bf34a30375919b679162e745b11e71cb60b00db8-1714922303160', false, '2024-05-05 18:18:23', 3, 0, true, false, '2024-05-05 18:18:23', '2024-05-05 18:19:23', 1);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1716738432821') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 15', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1716738432821', 'bf34a30375919b679162e745b11e71cb60b00db8-1716738432821', false, '2024-05-26 18:47:12', 3, 0, true, false, '2024-05-26 18:47:12', '2024-05-26 19:28:12', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1718297479604') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1718297479604', 'bf34a30375919b679162e745b11e71cb60b00db8-1718297479604', false, '2024-06-13 19:51:19', 3, 0, true, false, '2024-06-13 19:51:19', '2024-06-13 20:35:19', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1716138318725') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1716138318725', 'bf34a30375919b679162e745b11e71cb60b00db8-1716138318725', false, '2024-05-19 20:05:18', 3, 0, true, false, '2024-05-19 20:05:18', '2024-05-19 20:35:18', 30);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1719503397510') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1719503397510', 'bf34a30375919b679162e745b11e71cb60b00db8-1719503397510', false, '2024-06-27 18:49:57', 3, 0, true, false, '2024-06-27 18:49:57', '2024-06-27 19:28:57', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1717952197523') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'tür şekil 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1717952197523', 'bf34a30375919b679162e745b11e71cb60b00db8-1717952197523', false, '2024-06-09 19:56:37', 3, 0, true, false, '2024-06-09 19:56:37', '2024-06-09 20:42:37', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714925448870') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714925448870', 'bf34a30375919b679162e745b11e71cb60b00db8-1714925448870', false, '2024-05-05 19:10:48', 3, 0, true, false, '2024-05-05 19:10:48', '2024-05-05 19:54:48', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1719510166784') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1719510166784', 'bf34a30375919b679162e745b11e71cb60b00db8-1719510166784', false, '2024-06-27 20:42:46', 3, 0, true, false, '2024-06-27 20:42:46', '2024-06-27 21:20:46', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714317120373') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Şerh 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714317120373', 'bf34a30375919b679162e745b11e71cb60b00db8-1714317120373', false, '2024-04-28 18:12:00', 3, 0, true, false, '2024-04-28 18:12:00', '2024-04-28 19:00:00', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1716134159218') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1716134159218', 'bf34a30375919b679162e745b11e71cb60b00db8-1716134159218', false, '2024-05-19 18:55:59', 3, 0, true, false, '2024-05-19 18:55:59', '2024-05-19 19:45:59', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1715533285198') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1715533285198', 'bf34a30375919b679162e745b11e71cb60b00db8-1715533285198', false, '2024-05-12 20:01:25', 3, 0, true, false, '2024-05-12 20:01:25', '2024-05-12 20:38:25', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1717944090579') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Türk ve Şekil', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1717944090579', 'bf34a30375919b679162e745b11e71cb60b00db8-1717944090579', false, '2024-06-09 17:41:30', 3, 0, true, false, '2024-06-09 17:41:30', '2024-06-09 18:27:30', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1718988871752') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1718988871752', 'bf34a30375919b679162e745b11e71cb60b00db8-1718988871752', false, '2024-06-21 19:54:31', 3, 0, true, false, '2024-06-21 19:54:31', '2024-06-21 20:32:31', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1713714459651') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1713714459651', 'bf34a30375919b679162e745b11e71cb60b00db8-1713714459651', false, '2024-04-21 18:47:39', 3, 0, true, false, '2024-04-21 18:47:39', '2024-04-21 19:30:39', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1720112290478') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1720112290478', 'bf34a30375919b679162e745b11e71cb60b00db8-1720112290478', false, '2024-07-04 19:58:10', 3, 0, true, false, '2024-07-04 19:58:10', '2024-07-04 20:35:10', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1718301202574') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1718301202574', 'bf34a30375919b679162e745b11e71cb60b00db8-1718301202574', false, '2024-06-13 20:53:22', 3, 0, true, false, '2024-06-13 20:53:22', '2024-06-13 21:33:22', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1716741018743') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 16', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1716741018743', 'bf34a30375919b679162e745b11e71cb60b00db8-1716741018743', false, '2024-05-26 19:30:18', 3, 0, true, false, '2024-05-26 19:30:18', '2024-05-26 20:11:18', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1718294198727') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'divan şiir beyit şerhi incelemesi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1718294198727', 'bf34a30375919b679162e745b11e71cb60b00db8-1718294198727', false, '2024-06-13 18:56:38', 3, 0, true, false, '2024-06-13 18:56:38', '2024-06-13 19:36:38', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714928194992') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714928194992', 'bf34a30375919b679162e745b11e71cb60b00db8-1714928194992', false, '2024-05-05 19:56:34', 3, 0, true, false, '2024-05-05 19:56:34', '2024-05-05 20:36:34', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1717346819636') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 20', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1717346819636', 'bf34a30375919b679162e745b11e71cb60b00db8-1717346819636', false, '2024-06-02 19:46:59', 3, 0, true, false, '2024-06-02 19:46:59', '2024-06-02 20:27:59', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1720115497018') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1720115497018', 'bf34a30375919b679162e745b11e71cb60b00db8-1720115497018', false, '2024-07-04 20:51:37', 3, 0, true, false, '2024-07-04 20:51:37', '2024-07-04 21:30:37', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1720107964100') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1720107964100', 'bf34a30375919b679162e745b11e71cb60b00db8-1720107964100', false, '2024-07-04 18:46:04', 3, 0, true, false, '2024-07-04 18:46:04', '2024-07-04 19:30:04', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1718992591916') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1718992591916', 'bf34a30375919b679162e745b11e71cb60b00db8-1718992591916', false, '2024-06-21 20:56:31', 3, 0, true, false, '2024-06-21 20:56:31', '2024-06-21 21:40:31', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1718985552905') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit şerhleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1718985552905', 'bf34a30375919b679162e745b11e71cb60b00db8-1718985552905', false, '2024-06-21 18:59:12', 3, 0, true, false, '2024-06-21 18:59:12', '2024-06-21 19:42:12', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1717948389615') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Türk :) ve şekil 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1717948389615', 'bf34a30375919b679162e745b11e71cb60b00db8-1717948389615', false, '2024-06-09 18:53:09', 3, 0, true, false, '2024-06-09 18:53:09', '2024-06-09 19:35:09', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714320327050') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞERH 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714320327050', 'bf34a30375919b679162e745b11e71cb60b00db8-1714320327050', false, '2024-04-28 19:05:27', 3, 0, true, false, '2024-04-28 19:05:27', '2024-04-28 19:50:27', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714324023435') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ŞERH 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714324023435', 'bf34a30375919b679162e745b11e71cb60b00db8-1714324023435', false, '2024-04-28 20:07:03', 3, 0, true, false, '2024-04-28 20:07:03', '2024-04-28 20:50:03', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1713711046890') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1713711046890', 'bf34a30375919b679162e745b11e71cb60b00db8-1713711046890', false, '2024-04-21 17:50:46', 3, 0, true, false, '2024-04-21 17:50:46', '2024-04-21 18:33:46', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1716130301563') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şer 12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1716130301563', 'bf34a30375919b679162e745b11e71cb60b00db8-1716130301563', false, '2024-05-19 17:51:41', 3, 0, true, false, '2024-05-19 17:51:41', '2024-05-19 18:35:41', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1713717839288') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1713717839288', 'bf34a30375919b679162e745b11e71cb60b00db8-1713717839288', false, '2024-04-21 19:43:59', 3, 0, true, false, '2024-04-21 19:43:59', '2024-04-21 20:32:59', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1717339737102') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 17', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1717339737102', 'bf34a30375919b679162e745b11e71cb60b00db8-1717339737102', false, '2024-06-02 17:48:57', 3, 0, true, false, '2024-06-02 17:48:57', '2024-06-02 18:25:57', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1714919695033') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1714919695033', 'bf34a30375919b679162e745b11e71cb60b00db8-1714919695033', false, '2024-05-05 17:34:55', 3, 0, true, false, '2024-05-05 17:34:55', '2024-05-05 17:50:55', 16);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1719507013539') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1719507013539', 'bf34a30375919b679162e745b11e71cb60b00db8-1719507013539', false, '2024-06-27 19:50:13', 3, 0, true, false, '2024-06-27 19:50:13', '2024-06-27 20:30:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1717343489857') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 18', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1717343489857', 'bf34a30375919b679162e745b11e71cb60b00db8-1717343489857', false, '2024-06-02 18:51:29', 3, 0, true, false, '2024-06-02 18:51:29', '2024-06-02 19:34:29', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1715525279092') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1715525279092', 'bf34a30375919b679162e745b11e71cb60b00db8-1715525279092', false, '2024-05-12 17:47:59', 3, 0, true, false, '2024-05-12 17:47:59', '2024-05-12 18:35:59', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1716735181790') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 15', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1716735181790', 'bf34a30375919b679162e745b11e71cb60b00db8-1716735181790', false, '2024-05-26 17:53:01', 3, 0, true, false, '2024-05-26 17:53:01', '2024-05-26 18:11:01', 18);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'BEYİT ŞERHLERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'bf34a30375919b679162e745b11e71cb60b00db8-1715529376562') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=bf34a30375919b679162e745b11e71cb60b00db8-1715529376562', 'bf34a30375919b679162e745b11e71cb60b00db8-1715529376562', false, '2024-05-12 18:56:16', 3, 0, true, false, '2024-05-12 18:56:16', '2024-05-12 19:40:16', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719082681102') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÖÇLME VE DEĞERLENDİRME', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719082681102', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719082681102', false, '2024-06-22 21:58:01', 3, 0, true, false, '2024-06-22 21:58:01', '2024-06-22 22:26:01', 28);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1717864996996') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLAMA KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1717864996996', '96799d44ee03757118ca942f4420977e2fa2f2a2-1717864996996', false, '2024-06-08 19:43:16', 3, 0, true, false, '2024-06-08 19:43:16', '2024-06-08 20:22:16', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1717264373838') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA VE AKICI OKUMA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1717264373838', '96799d44ee03757118ca942f4420977e2fa2f2a2-1717264373838', false, '2024-06-01 20:52:53', 3, 0, true, false, '2024-06-01 20:52:53', '2024-06-01 21:17:53', 25);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1717257076368') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'GİRİŞ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1717257076368', '96799d44ee03757118ca942f4420977e2fa2f2a2-1717257076368', false, '2024-06-01 18:51:16', 3, 0, true, false, '2024-06-01 18:51:16', '2024-06-01 19:37:16', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719856674245') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719856674245', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719856674245', false, '2024-07-01 20:57:54', 3, 0, true, false, '2024-07-01 20:57:54', '2024-07-01 21:41:54', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719849345782') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719849345782', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719849345782', false, '2024-07-01 18:55:45', 3, 0, true, false, '2024-07-01 18:55:45', '2024-07-01 19:46:45', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719251513291') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719251513291', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719251513291', false, '2024-06-24 20:51:53', 3, 0, true, false, '2024-06-24 20:51:53', '2024-06-24 21:09:53', 18);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719597499179') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719597499179', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719597499179', false, '2024-06-28 20:58:19', 3, 0, true, false, '2024-06-28 20:58:19', '2024-06-28 21:35:19', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719244301062') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TEMA VE METİN ÖZELLİKLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719244301062', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719244301062', false, '2024-06-24 18:51:41', 3, 0, true, false, '2024-06-24 18:51:41', '2024-06-24 19:36:41', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719589977823') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719589977823', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719589977823', false, '2024-06-28 18:52:57', 3, 0, true, false, '2024-06-28 18:52:57', '2024-06-28 19:37:57', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719593592700') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719593592700', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719593592700', false, '2024-06-28 19:53:12', 3, 0, true, false, '2024-06-28 19:53:12', '2024-06-28 20:35:12', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1717868242415') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1717868242415', '96799d44ee03757118ca942f4420977e2fa2f2a2-1717868242415', false, '2024-06-08 20:37:22', 3, 0, true, false, '2024-06-08 20:37:22', '2024-06-08 21:17:22', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719079068400') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'PROGRAMIN YAPISI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719079068400', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719079068400', false, '2024-06-22 20:57:48', 3, 0, true, false, '2024-06-22 20:57:48', '2024-06-22 21:37:48', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719943514489') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719943514489', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719943514489', false, '2024-07-02 21:05:14', 3, 0, true, false, '2024-07-02 21:05:14', '2024-07-02 21:38:14', 33);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1717260854256') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1717260854256', '96799d44ee03757118ca942f4420977e2fa2f2a2-1717260854256', false, '2024-06-01 19:54:14', 3, 0, true, false, '2024-06-01 19:54:14', '2024-06-01 20:35:14', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1717861924736') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZ VARLIĞI KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1717861924736', '96799d44ee03757118ca942f4420977e2fa2f2a2-1717861924736', false, '2024-06-08 18:52:04', 3, 0, true, false, '2024-06-08 18:52:04', '2024-06-08 19:32:04', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719853110994') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719853110994', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719853110994', false, '2024-07-01 19:58:30', 3, 0, true, false, '2024-07-01 19:58:30', '2024-07-01 20:38:30', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1720287990413') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - SON', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1720287990413', '96799d44ee03757118ca942f4420977e2fa2f2a2-1720287990413', false, '2024-07-06 20:46:30', 3, 0, true, false, '2024-07-06 20:46:30', '2024-07-06 21:13:30', 27);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1720284837258') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1720284837258', '96799d44ee03757118ca942f4420977e2fa2f2a2-1720284837258', false, '2024-07-06 19:53:57', 3, 0, true, false, '2024-07-06 19:53:57', '2024-07-06 20:30:57', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719248125553') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1.DENEME', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719248125553', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719248125553', false, '2024-06-24 19:55:25', 3, 0, true, false, '2024-06-24 19:55:25', '2024-06-24 20:40:25', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1720281150408') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1720281150408', '96799d44ee03757118ca942f4420977e2fa2f2a2-1720281150408', false, '2024-07-06 18:52:30', 3, 0, true, false, '2024-07-06 18:52:30', '2024-07-06 19:35:30', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719935690282') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR - 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719935690282', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719935690282', false, '2024-07-02 18:54:50', 3, 0, true, false, '2024-07-02 18:54:50', '2024-07-02 19:40:50', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'CİHANGİR DENEMELERİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '96799d44ee03757118ca942f4420977e2fa2f2a2-1719939694640') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'CİHANGİR-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=96799d44ee03757118ca942f4420977e2fa2f2a2-1719939694640', '96799d44ee03757118ca942f4420977e2fa2f2a2-1719939694640', false, '2024-07-02 20:01:34', 3, 0, true, false, '2024-07-02 20:01:34', '2024-07-02 20:48:34', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744387141025') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK, CÜMLE BİLGİSİ 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744387141025', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744387141025', false, '2025-04-11 18:59:01', 3, 0, true, false, '2025-04-11 18:59:01', '2025-04-11 19:40:01', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775058624475') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ -4 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775058624475', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775058624475', false, '2026-04-01 18:50:24', 3, 0, true, false, '2026-04-01 18:50:24', '2026-04-01 19:31:24', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740939563532') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2- SES BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740939563532', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740939563532', false, '2025-03-02 21:19:23', 3, 0, true, false, '2025-03-02 21:19:23', '2025-03-02 22:00:23', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740942860481') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '3 - SES BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740942860481', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740942860481', false, '2025-03-02 22:14:20', 3, 0, true, false, '2025-03-02 22:14:20', '2025-03-02 22:58:20', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743185823420') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743185823420', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743185823420', false, '2025-03-28 21:17:03', 3, 0, true, false, '2025-03-28 21:17:03', '2025-03-28 21:58:03', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775929407526') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ- 8 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775929407526', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775929407526', false, '2026-04-11 20:43:27', 3, 0, true, false, '2026-04-11 20:43:27', '2026-04-11 21:24:27', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777831750408') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-16  ASIM KARA (2025 ÖABT TÜRKÇE SORULARININ ÇÖZÜMÜ)', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777831750408', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777831750408', false, '2026-05-03 21:09:10', 3, 0, true, false, '2026-05-03 21:09:10', '2026-05-03 21:50:10', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774462427692') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-3 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774462427692', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774462427692', false, '2026-03-25 21:13:47', 3, 0, true, false, '2026-03-25 21:13:47', '2026-03-25 22:01:47', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741544303046') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '5- SES BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741544303046', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741544303046', false, '2025-03-09 21:18:23', 3, 0, true, false, '2025-03-09 21:18:23', '2025-03-09 22:06:23', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743182960981') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '6 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743182960981', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743182960981', false, '2025-03-28 20:29:20', 3, 0, true, false, '2025-03-28 20:29:20', '2025-03-28 21:09:20', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775926165193') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-7 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775926165193', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775926165193', false, '2026-04-11 19:49:25', 3, 0, true, false, '2026-04-11 19:49:25', '2026-04-11 20:29:25', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777219151459') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-11 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777219151459', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777219151459', false, '2026-04-26 18:59:11', 3, 0, true, false, '2026-04-26 18:59:11', '2026-04-26 19:51:11', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741973240159') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '7 - SES BİLGİSİ SON', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741973240159', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741973240159', false, '2025-03-14 20:27:20', 3, 0, true, false, '2025-03-14 20:27:20', '2025-03-14 21:11:20', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746201555154') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2022 SORULARININ ÇÖZÜMLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746201555154', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746201555154', false, '2025-05-02 18:59:15', 3, 0, true, false, '2025-05-02 18:59:15', '2025-05-02 19:41:15', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1776528090193') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-9 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1776528090193', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1776528090193', false, '2026-04-18 19:01:30', 3, 0, true, false, '2026-04-18 19:01:30', '2026-04-18 19:48:30', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743189025833') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '8 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743189025833', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1743189025833', false, '2025-03-28 22:10:25', 3, 0, true, false, '2025-03-28 22:10:25', '2025-03-28 23:00:25', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745604036634') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2021 SORULARININ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745604036634', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745604036634', false, '2025-04-25 21:00:36', 3, 0, true, false, '2025-04-25 21:00:36', '2025-04-25 21:33:36', 33);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742584742125') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '5 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742584742125', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742584742125', false, '2025-03-21 22:19:02', 3, 0, true, false, '2025-03-21 22:19:02', '2025-03-21 23:05:02', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740935908753') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1- SES BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740935908753', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1740935908753', false, '2025-03-02 20:18:28', 3, 0, true, false, '2025-03-02 20:18:28', '2025-03-02 21:04:28', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744390041606') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK, CÜMLE BİLGİSİ 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744390041606', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744390041606', false, '2025-04-11 19:47:21', 3, 0, true, false, '2025-04-11 19:47:21', '2025-04-11 20:30:21', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1776531208328') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1776531208328', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1776531208328', false, '2026-04-18 19:53:28', 3, 0, true, false, '2026-04-18 19:53:28', '2026-04-18 20:45:28', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742577860497') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '3 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742577860497', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742577860497', false, '2025-03-21 20:24:20', 3, 0, true, false, '2025-03-21 20:24:20', '2025-03-21 21:08:20', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741976402841') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '1 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741976402841', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741976402841', false, '2025-03-14 21:20:02', 3, 0, true, false, '2025-03-14 21:20:02', '2025-03-14 22:01:02', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777827343225') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-15 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777827343225', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777827343225', false, '2026-05-03 19:55:43', 3, 0, true, false, '2026-05-03 19:55:43', '2026-05-03 20:50:43', 55);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746207488069') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2024 SORULARININ ÇÖZÜMLERİ - ANALİZİ VE &quot;VEDAMIZ&quot;', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746207488069', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746207488069', false, '2025-05-02 20:38:08', 3, 0, true, false, '2025-05-02 20:38:08', '2025-05-02 21:29:08', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775923278868') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-6 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775923278868', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775923278868', false, '2026-04-11 19:01:18', 3, 0, true, false, '2026-04-11 19:01:18', '2026-04-11 19:42:18', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741548326820') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '6 - SES BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741548326820', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741548326820', false, '2025-03-09 22:25:26', 3, 0, true, false, '2025-03-09 22:25:26', '2025-03-09 23:06:26', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742581036340') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '4 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742581036340', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1742581036340', false, '2025-03-21 21:17:16', 3, 0, true, false, '2025-03-21 21:17:16', '2025-03-21 22:02:16', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745597653574') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2019 SORULARININ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745597653574', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745597653574', false, '2025-04-25 19:14:13', 3, 0, true, false, '2025-04-25 19:14:13', '2025-04-25 19:59:13', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745600999260') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2020 SORULARININ ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745600999260', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1745600999260', false, '2025-04-25 20:09:59', 3, 0, true, false, '2025-04-25 20:09:59', '2025-04-25 20:52:59', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774458582055') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-2 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774458582055', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774458582055', false, '2026-03-25 20:09:42', 3, 0, true, false, '2026-03-25 20:09:42', '2026-03-25 20:59:42', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744393514334') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK, CÜMLE BİLGİSİ 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744393514334', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744393514334', false, '2025-04-11 20:45:14', 3, 0, true, false, '2025-04-11 20:45:14', '2025-04-11 21:25:14', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777222694789') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-12 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777222694789', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777222694789', false, '2026-04-26 19:58:14', 3, 0, true, false, '2026-04-26 19:58:14', '2026-04-26 20:43:14', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777823779953') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-14 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777823779953', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777823779953', false, '2026-05-03 18:56:19', 3, 0, true, false, '2026-05-03 18:56:19', '2026-05-03 19:44:19', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746204397384') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2023 SORULARININ ÇÖZÜMLERİ - ANALİZİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746204397384', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1746204397384', false, '2025-05-02 19:46:37', 3, 0, true, false, '2025-05-02 19:46:37', '2025-05-02 20:28:37', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741979542826') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2 - BİÇİM BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741979542826', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741979542826', false, '2025-03-14 22:12:22', 3, 0, true, false, '2025-03-14 22:12:22', '2025-03-14 22:55:22', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774455376259') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-1   Asım KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774455376259', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1774455376259', false, '2026-03-25 19:16:16', 3, 0, true, false, '2026-03-25 19:16:16', '2026-03-25 20:05:16', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744991994883') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK, CÜMLE BİLGİSİ 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744991994883', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744991994883', false, '2025-04-18 18:59:54', 3, 0, true, false, '2025-04-18 18:59:54', '2025-04-18 19:40:54', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744994910080') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK, CÜMLE BİLGİSİ 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744994910080', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744994910080', false, '2025-04-18 19:48:30', 3, 0, true, false, '2025-04-18 19:48:30', '2025-04-18 20:28:30', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744997930535') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SÖZCÜK, CÜMLE BİLGİSİ 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744997930535', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1744997930535', false, '2025-04-18 20:38:50', 3, 0, true, false, '2025-04-18 20:38:50', '2025-04-18 21:20:50', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777226447545') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-13 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777226447545', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1777226447545', false, '2026-04-26 21:00:47', 3, 0, true, false, '2026-04-26 21:00:47', '2026-04-26 21:41:47', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775061926482') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-5 ASIM KARA', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775061926482', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1775061926482', false, '2026-04-01 19:45:26', 3, 0, true, false, '2026-04-01 19:45:26', '2026-04-01 20:28:26', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLGİSİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741540291293') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '4- SES BİLGİSİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741540291293', 'c448cf7c3d21727c59ff7520b1e6d64bb8d26da4-1741540291293', false, '2025-03-09 20:11:31', 3, 0, true, false, '2025-03-09 20:11:31', '2025-03-09 20:55:31', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1748706538372') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'GENEL DEĞERLENDİRME - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1748706538372', '63175c9bc1a07dc877cffb0f987d9d6585316670-1748706538372', false, '2025-05-31 18:48:58', 3, 0, true, false, '2025-05-31 18:48:58', '2025-05-31 19:30:58', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1747503645273') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'METİN DİL BİLİM VE DİL BİLİM OKULLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1747503645273', '63175c9bc1a07dc877cffb0f987d9d6585316670-1747503645273', false, '2025-05-17 20:40:45', 3, 0, true, false, '2025-05-17 20:40:45', '2025-05-17 21:19:45', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1748709828397') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇIKMIŞ SORULAR - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1748709828397', '63175c9bc1a07dc877cffb0f987d9d6585316670-1748709828397', false, '2025-05-31 19:43:48', 3, 0, true, false, '2025-05-31 19:43:48', '2025-05-31 20:24:48', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1748108357172') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'GENEL DEĞERLENDİRME - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1748108357172', '63175c9bc1a07dc877cffb0f987d9d6585316670-1748108357172', false, '2025-05-24 20:39:17', 3, 0, true, false, '2025-05-24 20:39:17', '2025-05-24 21:11:17', 32);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1746296827857') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'MORFOLOJİ SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1746296827857', '63175c9bc1a07dc877cffb0f987d9d6585316670-1746296827857', false, '2025-05-03 21:27:07', 3, 0, true, false, '2025-05-03 21:27:07', '2025-05-03 21:56:07', 29);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1746294017225') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FONOLOJİ/FONETİK SORU ÇÖZÜMÜ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1746294017225', '63175c9bc1a07dc877cffb0f987d9d6585316670-1746294017225', false, '2025-05-03 20:40:17', 3, 0, true, false, '2025-05-03 20:40:17', '2025-05-03 21:10:17', 30);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1745688268114') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'FONOLOJİ/FONETİK SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1745688268114', '63175c9bc1a07dc877cffb0f987d9d6585316670-1745688268114', false, '2025-04-26 20:24:28', 3, 0, true, false, '2025-04-26 20:24:28', '2025-04-26 21:09:28', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1748101598848') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM OKULLARI - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1748101598848', '63175c9bc1a07dc877cffb0f987d9d6585316670-1748101598848', false, '2025-05-24 18:46:38', 3, 0, true, false, '2025-05-24 18:46:38', '2025-05-24 19:26:38', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1746897658288') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SEMANTİK VE GÖSTERGEBİLİM SORU ÇÖZÜMÜ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1746897658288', '63175c9bc1a07dc877cffb0f987d9d6585316670-1746897658288', false, '2025-05-10 20:20:58', 3, 0, true, false, '2025-05-10 20:20:58', '2025-05-10 21:09:58', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1748105014332') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM OKULLARI-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1748105014332', '63175c9bc1a07dc877cffb0f987d9d6585316670-1748105014332', false, '2025-05-24 19:43:34', 3, 0, true, false, '2025-05-24 19:43:34', '2025-05-24 20:26:34', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1745086246250') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİL BİLİM-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1745086246250', '63175c9bc1a07dc877cffb0f987d9d6585316670-1745086246250', false, '2025-04-19 21:10:46', 3, 0, true, false, '2025-04-19 21:10:46', '2025-04-19 22:02:46', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DİL BİLİM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '63175c9bc1a07dc877cffb0f987d9d6585316670-1748713174571') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ÇIKMIŞ SORULAR - 2 VE SON', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=63175c9bc1a07dc877cffb0f987d9d6585316670-1748713174571', '63175c9bc1a07dc877cffb0f987d9d6585316670-1748713174571', false, '2025-05-31 20:39:34', 3, 0, true, false, '2025-05-31 20:39:34', '2025-05-31 21:04:34', 25);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748274625799') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748274625799', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748274625799', false, '2025-05-26 18:50:25', 3, 0, true, false, '2025-05-26 18:50:25', '2025-05-26 19:21:25', 31);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747935533478') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747935533478', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747935533478', false, '2025-05-22 20:38:53', 3, 0, true, false, '2025-05-22 20:38:53', '2025-05-22 21:08:53', 30);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748879252473') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748879252473', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748879252473', false, '2025-06-02 18:47:32', 3, 0, true, false, '2025-06-02 18:47:32', '2025-06-02 19:28:32', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749919631023') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749919631023', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749919631023', false, '2025-06-14 19:47:11', 3, 0, true, false, '2025-06-14 19:47:11', '2025-06-14 20:24:11', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748277166535') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748277166535', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748277166535', false, '2025-05-26 19:32:46', 3, 0, true, false, '2025-05-26 19:32:46', '2025-05-26 20:13:46', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1750092672520') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1750092672520', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1750092672520', false, '2025-06-16 19:51:12', 3, 0, true, false, '2025-06-16 19:51:12', '2025-06-16 20:41:12', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749922673464') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749922673464', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749922673464', false, '2025-06-14 20:37:53', 3, 0, true, false, '2025-06-14 20:37:53', '2025-06-14 21:10:53', 33);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747932405805') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747932405805', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747932405805', false, '2025-05-22 19:46:45', 3, 0, true, false, '2025-05-22 19:46:45', '2025-05-22 20:26:45', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749833287126') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749833287126', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749833287126', false, '2025-06-13 19:48:07', 3, 0, true, false, '2025-06-13 19:48:07', '2025-06-13 20:29:07', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748885619449') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748885619449', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748885619449', false, '2025-06-02 20:33:39', 3, 0, true, false, '2025-06-02 20:33:39', '2025-06-02 21:07:39', 34);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748280178599') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748280178599', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748280178599', false, '2025-05-26 20:22:58', 3, 0, true, false, '2025-05-26 20:22:58', '2025-05-26 21:04:58', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749829606563') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749829606563', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749829606563', false, '2025-06-13 18:46:46', 3, 0, true, false, '2025-06-13 18:46:46', '2025-06-13 19:27:46', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749836651259') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA EĞİTİMİ - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749836651259', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749836651259', false, '2025-06-13 20:44:11', 3, 0, true, false, '2025-06-13 20:44:11', '2025-06-13 21:20:11', 36);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749916007988') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA EĞİTİMİ - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749916007988', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1749916007988', false, '2025-06-14 18:46:47', 3, 0, true, false, '2025-06-14 18:46:47', '2025-06-14 19:28:47', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747928583778') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME EĞİTİMİ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747928583778', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1747928583778', false, '2025-05-22 18:43:03', 3, 0, true, false, '2025-05-22 18:43:03', '2025-05-22 19:26:03', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÖRT TEMEL BECERİ' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748882635516') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748882635516', 'fd5c21dfcef4665bb7e8b67c9d7f92cb619f22e0-1748882635516', false, '2025-06-02 19:43:55', 3, 0, true, false, '2025-06-02 19:43:55', '2025-06-02 20:20:55', 37);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1739710702044') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1739710702044', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1739710702044', false, '2025-02-16 15:58:22', 3, 0, true, false, '2025-02-16 15:58:22', '2025-02-16 16:43:22', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1739701887567') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1739701887567', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1739701887567', false, '2025-02-16 13:31:27', 3, 0, true, false, '2025-02-16 13:31:27', '2025-02-16 14:22:27', 51);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1742121745539') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çözüm 10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1742121745539', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1742121745539', false, '2025-03-16 13:42:25', 3, 0, true, false, '2025-03-16 13:42:25', '2025-03-16 14:27:25', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740920037980') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1740920037980', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740920037980', false, '2025-03-02 15:53:57', 3, 0, true, false, '2025-03-02 15:53:57', '2025-03-02 16:36:57', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1742125729775') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çözüm 11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1742125729775', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1742125729775', false, '2025-03-16 14:48:49', 3, 0, true, false, '2025-03-16 14:48:49', '2025-03-16 15:31:49', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740912641223') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1740912641223', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740912641223', false, '2025-03-02 13:50:41', 3, 0, true, false, '2025-03-02 13:50:41', '2025-03-02 14:34:41', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740314545751') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1740314545751', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740314545751', false, '2025-02-23 15:42:25', 3, 0, true, false, '2025-02-23 15:42:25', '2025-02-23 16:28:25', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740311206295') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1740311206295', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740311206295', false, '2025-02-23 14:46:46', 3, 0, true, false, '2025-02-23 14:46:46', '2025-02-23 15:27:46', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740916175261') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1740916175261', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740916175261', false, '2025-03-02 14:49:35', 3, 0, true, false, '2025-03-02 14:49:35', '2025-03-02 15:33:35', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1742129041142') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çözüm 12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1742129041142', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1742129041142', false, '2025-03-16 15:44:01', 3, 0, true, false, '2025-03-16 15:44:01', '2025-03-16 16:27:01', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740307644001') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'soru çözüm 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1740307644001', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1740307644001', false, '2025-02-23 13:47:24', 3, 0, true, false, '2025-02-23 13:47:24', '2025-02-23 14:28:24', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - DÜNYA EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '975229ad30f83f67fff0cb3430c313edfa6e64a6-1739706790867') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜM 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=975229ad30f83f67fff0cb3430c313edfa6e64a6-1739706790867', '975229ad30f83f67fff0cb3430c313edfa6e64a6-1739706790867', false, '2025-02-16 14:53:10', 3, 0, true, false, '2025-02-16 14:53:10', '2025-02-16 15:37:10', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749147176295') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749147176295', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749147176295', false, '2025-06-05 21:12:56', 3, 0, true, false, '2025-06-05 21:12:56', '2025-06-05 21:51:56', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746640195136') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit şerhleri 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746640195136', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746640195136', false, '2025-05-07 20:49:55', 3, 0, true, false, '2025-05-07 20:49:55', '2025-05-07 21:33:55', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1748454313048') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit şerhi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1748454313048', '7d856a5528132d97c75d058e84f41111ba0cfb69-1748454313048', false, '2025-05-28 20:45:13', 3, 0, true, false, '2025-05-28 20:45:13', '2025-05-28 21:25:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747843037792') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747843037792', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747843037792', false, '2025-05-21 18:57:17', 3, 0, true, false, '2025-05-21 18:57:17', '2025-05-21 19:38:17', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1744221026702') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrara analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1744221026702', '7d856a5528132d97c75d058e84f41111ba0cfb69-1744221026702', false, '2025-04-09 20:50:26', 3, 0, true, false, '2025-04-09 20:50:26', '2025-04-09 21:31:26', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1748450858026') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi ve beyit şerhleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1748450858026', '7d856a5528132d97c75d058e84f41111ba0cfb69-1748450858026', false, '2025-05-28 19:47:38', 3, 0, true, false, '2025-05-28 19:47:38', '2025-05-28 20:25:38', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1744822341628') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz dersi 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1744822341628', '7d856a5528132d97c75d058e84f41111ba0cfb69-1744822341628', false, '2025-04-16 19:52:21', 3, 0, true, false, '2025-04-16 19:52:21', '2025-04-16 20:33:21', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746027718246') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 4 söz sanatları 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746027718246', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746027718246', false, '2025-04-30 18:41:58', 3, 0, true, false, '2025-04-30 18:41:58', '2025-04-30 19:25:58', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749138897829') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru aqnalizi ve beyit şerhi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749138897829', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749138897829', false, '2025-06-05 18:54:57', 3, 0, true, false, '2025-06-05 18:54:57', '2025-06-05 19:34:57', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747244886369') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747244886369', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747244886369', false, '2025-05-14 20:48:06', 3, 0, true, false, '2025-05-14 20:48:06', '2025-05-14 21:30:06', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747241123363') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747241123363', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747241123363', false, '2025-05-14 19:45:23', 3, 0, true, false, '2025-05-14 19:45:23', '2025-05-14 20:29:23', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747410049541') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh şerh şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747410049541', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747410049541', false, '2025-05-16 18:40:49', 3, 0, true, false, '2025-05-16 18:40:49', '2025-05-16 19:26:49', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1741803761963') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrar ve analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1741803761963', '7d856a5528132d97c75d058e84f41111ba0cfb69-1741803761963', false, '2025-03-12 21:22:41', 3, 0, true, false, '2025-03-12 21:22:41', '2025-03-12 22:03:41', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746636826726') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Söz sanatları son ders', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746636826726', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746636826726', false, '2025-05-07 19:53:46', 3, 0, true, false, '2025-05-07 19:53:46', '2025-05-07 20:41:46', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1744214270182') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1744214270182', '7d856a5528132d97c75d058e84f41111ba0cfb69-1744214270182', false, '2025-04-09 18:57:50', 3, 0, true, false, '2025-04-09 18:57:50', '2025-04-09 19:38:50', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1744826278548') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz ve Türkiye Türkçesi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1744826278548', '7d856a5528132d97c75d058e84f41111ba0cfb69-1744826278548', false, '2025-04-16 20:57:58', 3, 0, true, false, '2025-04-16 20:57:58', '2025-04-16 21:43:58', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1742405227183') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemeleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1742405227183', '7d856a5528132d97c75d058e84f41111ba0cfb69-1742405227183', false, '2025-03-19 20:27:07', 3, 0, true, false, '2025-03-19 20:27:07', '2025-03-19 21:08:07', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1742408409483') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit incelemesi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1742408409483', '7d856a5528132d97c75d058e84f41111ba0cfb69-1742408409483', false, '2025-03-19 21:20:09', 3, 0, true, false, '2025-03-19 21:20:09', '2025-03-19 22:01:09', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749059904909') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749059904909', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749059904909', false, '2025-06-04 20:58:24', 3, 0, true, false, '2025-06-04 20:58:24', '2025-06-04 21:40:24', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749143171264') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi ve beyit şerhi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749143171264', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749143171264', false, '2025-06-05 20:06:11', 3, 0, true, false, '2025-06-05 20:06:11', '2025-06-05 20:08:11', 2);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1744217971219') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrar', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1744217971219', '7d856a5528132d97c75d058e84f41111ba0cfb69-1744217971219', false, '2025-04-09 19:59:31', 3, 0, true, false, '2025-04-09 19:59:31', '2025-04-09 20:39:31', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747418194412') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh  ve son', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747418194412', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747418194412', false, '2025-05-16 20:56:34', 3, 0, true, false, '2025-05-16 20:56:34', '2025-05-16 21:37:34', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746809575309') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746809575309', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746809575309', false, '2025-05-09 19:52:55', 3, 0, true, false, '2025-05-09 19:52:55', '2025-05-09 20:41:55', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1744817705021') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Aruz Risalesi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1744817705021', '7d856a5528132d97c75d058e84f41111ba0cfb69-1744817705021', false, '2025-04-16 18:35:05', 3, 0, true, false, '2025-04-16 18:35:05', '2025-04-16 19:22:05', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747846260115') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747846260115', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747846260115', false, '2025-05-21 19:51:00', 3, 0, true, false, '2025-05-21 19:51:00', '2025-05-21 20:32:00', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1743009977689') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrar analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1743009977689', '7d856a5528132d97c75d058e84f41111ba0cfb69-1743009977689', false, '2025-03-26 20:26:17', 3, 0, true, false, '2025-03-26 20:26:17', '2025-03-26 21:07:17', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1748447736351') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi ve beyit şerhleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1748447736351', '7d856a5528132d97c75d058e84f41111ba0cfb69-1748447736351', false, '2025-05-28 18:55:36', 3, 0, true, false, '2025-05-28 18:55:36', '2025-05-28 19:33:36', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747414223957') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerhler şerhler', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747414223957', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747414223957', false, '2025-05-16 19:50:23', 3, 0, true, false, '2025-05-16 19:50:23', '2025-05-16 20:39:23', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749056317451') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi ve beyit incelemesi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749056317451', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749056317451', false, '2025-06-04 19:58:37', 3, 0, true, false, '2025-06-04 19:58:37', '2025-06-04 20:38:37', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747849740807') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit şerhleri', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747849740807', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747849740807', false, '2025-05-21 20:49:00', 3, 0, true, false, '2025-05-21 20:49:00', '2025-05-21 21:29:00', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1743013143451') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrara analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1743013143451', '7d856a5528132d97c75d058e84f41111ba0cfb69-1743013143451', false, '2025-03-26 21:19:03', 3, 0, true, false, '2025-03-26 21:19:03', '2025-03-26 22:00:03', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749052631599') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'çıkmış soru analizi ve beyit şerhi', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749052631599', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749052631599', false, '2025-06-04 18:57:11', 3, 0, true, false, '2025-06-04 18:57:11', '2025-06-04 19:41:11', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1741800454007') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'sorularla genel tekrar ve analiz', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1741800454007', '7d856a5528132d97c75d058e84f41111ba0cfb69-1741800454007', false, '2025-03-12 20:27:34', 3, 0, true, false, '2025-03-12 20:27:34', '2025-03-12 21:08:34', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746813423388') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746813423388', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746813423388', false, '2025-05-09 20:57:03', 3, 0, true, false, '2025-05-09 20:57:03', '2025-05-09 22:02:03', 65);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746035121094') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'söz sanatları 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746035121094', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746035121094', false, '2025-04-30 20:45:21', 3, 0, true, false, '2025-04-30 20:45:21', '2025-04-30 21:30:21', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746632011032') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746632011032', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746632011032', false, '2025-05-07 18:33:31', 3, 0, true, false, '2025-05-07 18:33:31', '2025-05-07 19:15:31', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746031647725') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'Söz Sanatları 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746031647725', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746031647725', false, '2025-04-30 19:47:27', 3, 0, true, false, '2025-04-30 19:47:27', '2025-04-30 20:30:27', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1746806191577') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'aruz +şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1746806191577', '7d856a5528132d97c75d058e84f41111ba0cfb69-1746806191577', false, '2025-05-09 18:56:31', 3, 0, true, false, '2025-05-09 18:56:31', '2025-05-09 19:46:31', 50);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1749143879510') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'beyit inceleme', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1749143879510', '7d856a5528132d97c75d058e84f41111ba0cfb69-1749143879510', false, '2025-06-05 20:17:59', 3, 0, true, false, '2025-06-05 20:17:59', '2025-06-05 20:57:59', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ESKİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7d856a5528132d97c75d058e84f41111ba0cfb69-1747237381651') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'şerh', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7d856a5528132d97c75d058e84f41111ba0cfb69-1747237381651', '7d856a5528132d97c75d058e84f41111ba0cfb69-1747237381651', false, '2025-05-14 18:43:01', 3, 0, true, false, '2025-05-14 18:43:01', '2025-05-14 19:28:01', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719758822612') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '4. ders', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719758822612', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719758822612', false, '2024-06-30 17:47:02', 3, 0, true, false, '2024-06-30 17:47:02', '2024-06-30 18:29:02', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719156846677') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - HALK EDEBİYATI - 23.06.2024 18:34:06', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719156846677', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719156846677', false, '2024-06-23 18:34:06', 3, 0, true, false, '2024-06-23 18:34:06', '2024-06-23 19:17:06', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776268418609') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776268418609', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776268418609', false, '2026-04-15 18:53:38', 3, 0, true, false, '2026-04-15 18:53:38', '2026-04-15 19:47:38', 54);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776872867045') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776872867045', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776872867045', false, '2026-04-22 18:47:47', 3, 0, true, false, '2026-04-22 18:47:47', '2026-04-22 19:35:47', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776881259051') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776881259051', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776881259051', false, '2026-04-22 21:07:39', 3, 0, true, false, '2026-04-22 21:07:39', '2026-04-22 21:51:39', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719765901613') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '6. ders', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719765901613', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719765901613', false, '2024-06-30 19:45:01', 3, 0, true, false, '2024-06-30 19:45:01', '2024-06-30 20:32:01', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719159843032') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'dede korkut 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719159843032', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719159843032', false, '2024-06-23 19:24:03', 3, 0, true, false, '2024-06-23 19:24:03', '2024-06-23 20:07:03', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720367954898') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720367954898', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720367954898', false, '2024-07-07 18:59:14', 3, 0, true, false, '2024-07-07 18:59:14', '2024-07-07 19:39:14', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720371279630') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720371279630', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720371279630', false, '2024-07-07 19:54:39', 3, 0, true, false, '2024-07-07 19:54:39', '2024-07-07 20:33:39', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777485521187') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777485521187', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777485521187', false, '2026-04-29 20:58:41', 3, 0, true, false, '2026-04-29 20:58:41', '2026-04-29 21:54:41', 56);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778090570951') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778090570951', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778090570951', false, '2026-05-06 21:02:50', 3, 0, true, false, '2026-05-06 21:02:50', '2026-05-06 21:55:50', 53);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777477763956') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777477763956', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777477763956', false, '2026-04-29 18:49:23', 3, 0, true, false, '2026-04-29 18:49:23', '2026-04-29 19:37:23', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778086597849') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778086597849', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778086597849', false, '2026-05-06 19:56:37', 3, 0, true, false, '2026-05-06 19:56:37', '2026-05-06 20:38:37', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719163188158') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2. Deneme', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719163188158', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719163188158', false, '2024-06-23 20:19:48', 3, 0, true, false, '2024-06-23 20:19:48', '2024-06-23 21:07:48', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720374442997') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'halk 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720374442997', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1720374442997', false, '2024-07-07 20:47:22', 3, 0, true, false, '2024-07-07 20:47:22', '2024-07-07 21:32:22', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776877237096') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776877237096', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1776877237096', false, '2026-04-22 20:00:37', 3, 0, true, false, '2026-04-22 20:00:37', '2026-04-22 20:46:37', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777481912653') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777481912653', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1777481912653', false, '2026-04-29 19:58:32', 3, 0, true, false, '2026-04-29 19:58:32', '2026-04-29 20:43:32', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778082706584') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2026 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778082706584', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1778082706584', false, '2026-05-06 18:51:46', 3, 0, true, false, '2026-05-06 18:51:46', '2026-05-06 19:40:46', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - HALK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719762414660') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '5. ders', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719762414660', '2989cbd1040502c55f1f74f8b38fcfc5950fc4d1-1719762414660', false, '2024-06-30 18:46:54', 3, 0, true, false, '2024-06-30 18:46:54', '2024-06-30 19:32:54', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745942286084') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745942286084', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745942286084', false, '2025-04-29 18:58:06', 3, 0, true, false, '2025-04-29 18:58:06', '2025-04-29 19:42:06', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745945959861') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745945959861', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745945959861', false, '2025-04-29 19:59:19', 3, 0, true, false, '2025-04-29 19:59:19', '2025-04-29 20:43:19', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748368960054') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-15', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748368960054', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748368960054', false, '2025-05-27 21:02:40', 3, 0, true, false, '2025-05-27 21:02:40', '2025-05-27 21:44:40', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748372809926') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-16', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748372809926', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748372809926', false, '2025-05-27 22:06:49', 3, 0, true, false, '2025-05-27 22:06:49', '2025-05-27 22:45:49', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748364987207') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748364987207', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748364987207', false, '2025-05-27 19:56:27', 3, 0, true, false, '2025-05-27 19:56:27', '2025-05-27 20:43:27', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747154911494') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747154911494', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747154911494', false, '2025-05-13 19:48:31', 3, 0, true, false, '2025-05-13 19:48:31', '2025-05-13 20:32:31', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747158544776') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747158544776', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747158544776', false, '2025-05-13 20:49:04', 3, 0, true, false, '2025-05-13 20:49:04', '2025-05-13 21:34:04', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747760144007') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747760144007', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747760144007', false, '2025-05-20 19:55:44', 3, 0, true, false, '2025-05-20 19:55:44', '2025-05-20 20:38:44', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747151858422') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747151858422', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747151858422', false, '2025-05-13 18:57:38', 3, 0, true, false, '2025-05-13 18:57:38', '2025-05-13 19:42:38', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746550587562') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746550587562', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746550587562', false, '2025-05-06 19:56:27', 3, 0, true, false, '2025-05-06 19:56:27', '2025-05-06 20:37:27', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747756697141') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747756697141', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747756697141', false, '2025-05-20 18:58:17', 3, 0, true, false, '2025-05-20 18:58:17', '2025-05-20 19:46:17', 48);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745949181429') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745949181429', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1745949181429', false, '2025-04-29 20:53:01', 3, 0, true, false, '2025-04-29 20:53:01', '2025-04-29 21:35:01', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748361682386') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748361682386', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1748361682386', false, '2025-05-27 19:01:22', 3, 0, true, false, '2025-05-27 19:01:22', '2025-05-27 19:50:22', 49);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747763662563') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747763662563', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1747763662563', false, '2025-05-20 20:54:22', 3, 0, true, false, '2025-05-20 20:54:22', '2025-05-20 21:46:22', 52);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746553762322') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746553762322', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746553762322', false, '2025-05-06 20:49:22', 3, 0, true, false, '2025-05-06 20:49:22', '2025-05-06 21:34:22', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - YENİ TÜRK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746547035784') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ- 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746547035784', '4b39fd288dc2700c79d58ee85b39fd914c7ff7ef-1746547035784', false, '2025-05-06 18:57:15', 3, 0, true, false, '2025-05-06 18:57:15', '2025-05-06 19:44:15', 47);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746978567991') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ -3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746978567991', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746978567991', false, '2025-05-11 18:49:27', 3, 0, true, false, '2025-05-11 18:49:27', '2025-05-11 19:35:27', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747583406374') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747583406374', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747583406374', false, '2025-05-18 18:50:06', 3, 0, true, false, '2025-05-18 18:50:06', '2025-05-18 19:33:06', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746377330604') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746377330604', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746377330604', false, '2025-05-04 19:48:50', 3, 0, true, false, '2025-05-04 19:48:50', '2025-05-04 20:27:50', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746986701452') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ- 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746986701452', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746986701452', false, '2025-05-11 21:05:01', 3, 0, true, false, '2025-05-11 21:05:01', '2025-05-11 21:49:01', 44);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747586846399') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747586846399', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747586846399', false, '2025-05-18 19:47:26', 3, 0, true, false, '2025-05-18 19:47:26', '2025-05-18 20:30:26', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746374024847') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746374024847', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746374024847', false, '2025-05-04 18:53:44', 3, 0, true, false, '2025-05-04 18:53:44', '2025-05-04 19:34:44', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747590630007') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ-8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747590630007', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1747590630007', false, '2025-05-18 20:50:30', 3, 0, true, false, '2025-05-18 20:50:30', '2025-05-18 21:35:30', 45);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'SORU ÇÖZÜMÜ - ÇOCUK EDEBİYATI' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746982522729') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜM-4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746982522729', '7fd2f948a1f6cecb3e54a9c3e53f5c712948fe53-1746982522729', false, '2025-05-11 19:55:22', 3, 0, true, false, '2025-05-11 19:55:22', '2025-05-11 20:41:22', 46);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685897790271') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 18', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1685897790271', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685897790271', false, '2023-06-04 19:56:30', 3, 0, true, false, '2023-06-04 19:56:30', '2023-06-04 20:30:30', 34);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685895214881') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '-17', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1685895214881', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685895214881', false, '2023-06-04 19:13:34', 3, 0, true, false, '2023-06-04 19:13:34', '2023-06-04 19:41:34', 28);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1681564703991') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YETKİNLİKLER', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1681564703991', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1681564703991', false, '2023-04-15 16:18:23', 3, 0, true, false, '2023-04-15 16:18:23', '2023-04-15 17:00:23', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685209343947') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 16', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1685209343947', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685209343947', false, '2023-05-27 20:42:23', 3, 0, true, false, '2023-05-27 20:42:23', '2023-05-27 21:21:23', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683388364415') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'ANLAMA KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1683388364415', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683388364415', false, '2023-05-06 18:52:44', 3, 0, true, false, '2023-05-06 18:52:44', '2023-05-06 19:32:44', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684342357720') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 6', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684342357720', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684342357720', false, '2023-05-17 19:52:37', 3, 0, true, false, '2023-05-17 19:52:37', '2023-05-17 20:32:37', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683395048516') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 1', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1683395048516', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683395048516', false, '2023-05-06 20:44:08', 3, 0, true, false, '2023-05-06 20:44:08', '2023-05-06 21:27:08', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683740635409') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 4', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1683740635409', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683740635409', false, '2023-05-10 20:43:55', 3, 0, true, false, '2023-05-10 20:43:55', '2023-05-10 21:23:55', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684604089401') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 10', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684604089401', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684604089401', false, '2023-05-20 20:34:49', 3, 0, true, false, '2023-05-20 20:34:49', '2023-05-20 21:12:49', 38);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684949739977') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 13', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684949739977', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684949739977', false, '2023-05-24 20:35:39', 3, 0, true, false, '2023-05-24 20:35:39', '2023-05-24 21:05:39', 30);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684338249924') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 5', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684338249924', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684338249924', false, '2023-05-17 18:44:09', 3, 0, true, false, '2023-05-17 18:44:09', '2023-05-17 19:24:09', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685893377686') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 17', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1685893377686', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685893377686', false, '2023-06-04 18:42:57', 3, 0, true, false, '2023-06-04 18:42:57', '2023-06-04 18:53:57', 11);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684600868484') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 9', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684600868484', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684600868484', false, '2023-05-20 19:41:08', 3, 0, true, false, '2023-05-20 19:41:08', '2023-05-20 20:20:08', 39);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683733573394') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 2', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1683733573394', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683733573394', false, '2023-05-10 18:46:13', 3, 0, true, false, '2023-05-10 18:46:13', '2023-05-10 19:26:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683391285196') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'YAZMA KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1683391285196', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683391285196', false, '2023-05-06 19:41:25', 3, 0, true, false, '2023-05-06 19:41:25', '2023-05-06 20:23:25', 42);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1682783718109') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'DİNLEME VE KONUŞMA KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1682783718109', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1682783718109', false, '2023-04-29 18:55:18', 3, 0, true, false, '2023-04-29 18:55:18', '2023-04-29 19:35:18', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685202445584') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 14', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1685202445584', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685202445584', false, '2023-05-27 18:47:25', 3, 0, true, false, '2023-05-27 18:47:25', '2023-05-27 19:27:25', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685205673766') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 15', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1685205673766', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1685205673766', false, '2023-05-27 19:41:13', 3, 0, true, false, '2023-05-27 19:41:13', '2023-05-27 20:21:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1681561139168') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '2019 TÜRKÇE DERSİ ÖĞRETİM PROGRAMI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1681561139168', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1681561139168', false, '2023-04-15 15:18:59', 3, 0, true, false, '2023-04-15 15:18:59', '2023-04-15 15:59:59', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684345220776') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 7', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684345220776', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684345220776', false, '2023-05-17 20:40:20', 3, 0, true, false, '2023-05-17 20:40:20', '2023-05-17 21:21:20', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683737122046') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 3', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1683737122046', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1683737122046', false, '2023-05-10 19:45:22', 3, 0, true, false, '2023-05-10 19:45:22', '2023-05-10 20:25:22', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684946482669') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 12', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684946482669', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684946482669', false, '2023-05-24 19:41:22', 3, 0, true, false, '2023-05-24 19:41:22', '2023-05-24 20:21:22', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1682786548651') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'KONUŞMA EĞİTİMİ KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1682786548651', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1682786548651', false, '2023-04-29 19:42:28', 3, 0, true, false, '2023-04-29 19:42:28', '2023-04-29 20:25:28', 43);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684597755449') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 8', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684597755449', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684597755449', false, '2023-05-20 18:49:15', 3, 0, true, false, '2023-05-20 18:49:15', '2023-05-20 19:29:15', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684943113621') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'SORU ÇÖZÜMÜ - 11', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1684943113621', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1684943113621', false, '2023-05-24 18:45:13', 3, 0, true, false, '2023-05-24 18:45:13', '2023-05-24 19:25:13', 40);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1682790914871') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'OKUMA KAZANIMLARI', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1682790914871', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1682790914871', false, '2023-04-29 20:55:14', 3, 0, true, false, '2023-04-29 20:55:14', '2023-04-29 21:36:14', 41);
        END IF;
    END IF;
END $$;

DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = 'YİRMİLİ BRANŞ DENEMESİ DÖRT TEMEL BECERİ VE ALAN EĞİTİMİ ÇÖZÜM' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '85cf7f78d52f24b1855c37e9a252bd190adc9774-1681567994720') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, 'TEMA VE METİN ÖZELLİKLERİ', 'https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId=85cf7f78d52f24b1855c37e9a252bd190adc9774-1681567994720', '85cf7f78d52f24b1855c37e9a252bd190adc9774-1681567994720', false, '2023-04-15 17:13:14', 3, 0, true, false, '2023-04-15 17:13:14', '2023-04-15 18:03:14', 50);
        END IF;
    END IF;
END $$;


COMMIT;