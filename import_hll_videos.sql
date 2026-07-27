BEGIN;

INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '74679023-5dd6-43d2-a2ed-0793ff712739', "Id", 'Türkçe Dil Bilgisi, 27.10.2025', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/0256e3f7c5ef061c781eb33d1a007ce897772ccc-1761580495170', false, 2, true, NOW(), '0256e3f7c5ef061c781eb33d1a007ce897772ccc-1761580495170'
FROM "Courses"
WHERE "Title" = 'TÜRKÇE DİL BİLGİSİ ve YAZIŞMA ile İLGİLİ KURALLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '0256e3f7c5ef061c781eb33d1a007ce897772ccc-1761580495170'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '744e2066-6141-4a1a-9863-5840559b32f6', "Id", 'Elektronik İmza Kanunu 1', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/03b6b8ffd06977baf710636ab352ecc2366ba1f1-1760977657771', false, 2, true, NOW(), '03b6b8ffd06977baf710636ab352ecc2366ba1f1-1760977657771'
FROM "Courses"
WHERE "Title" = 'ELEKTRONİK İMZA KANUNU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '03b6b8ffd06977baf710636ab352ecc2366ba1f1-1760977657771'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '6e18ee40-eec3-4c3d-9a3d-595bd4e37a95', "Id", '21/10/2025 ELEKTRONİK İMZA KANUNU VE SEGBİS', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/03b6b8ffd06977baf710636ab352ecc2366ba1f1-1761062437018', false, 2, true, NOW(), '03b6b8ffd06977baf710636ab352ecc2366ba1f1-1761062437018'
FROM "Courses"
WHERE "Title" = 'ELEKTRONİK İMZA KANUNU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '03b6b8ffd06977baf710636ab352ecc2366ba1f1-1761062437018'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'c8fc77a5-d31a-485e-b57b-40bd45c5a1b3', "Id", '01/10/2025 TEBLİGAT HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759334267170', false, 2, true, NOW(), '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759334267170'
FROM "Courses"
WHERE "Title" = 'TEBLİGAT HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759334267170'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'c02e8365-0947-4b54-9a29-e10e6bec07e5', "Id", '02/10/2025 TEBLİGAT HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759420819196', false, 2, true, NOW(), '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759420819196'
FROM "Courses"
WHERE "Title" = 'TEBLİGAT HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759420819196'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '4f67c904-d9be-4191-8e40-f241f1991fdc', "Id", '06/10/2025 TEBLİGAT KANUNU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759766380974', false, 2, true, NOW(), '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759766380974'
FROM "Courses"
WHERE "Title" = 'TEBLİGAT HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759766380974'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '795ae556-6ed7-4028-b4ba-a1df0477d2b6', "Id", '07/10/2025 (ELEKTRONİK TEBLİGAT YÖNETMELİĞİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759852825133', false, 2, true, NOW(), '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759852825133'
FROM "Courses"
WHERE "Title" = 'TEBLİGAT HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '03c3cc61de5c1c15ca4762eeae74f7ef58cd91af-1759852825133'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '9452fa49-b373-4caf-8fcb-f6fa607042b1', "Id", '18/08/2025 657 DMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/13de97d29ee10ef2d60fc91620172fe008d265b8-1755532731838', false, 2, true, NOW(), '13de97d29ee10ef2d60fc91620172fe008d265b8-1755532731838'
FROM "Courses"
WHERE "Title" = '657 DMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '13de97d29ee10ef2d60fc91620172fe008d265b8-1755532731838'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'fd8e0e24-1608-46f4-be97-2d7ffb918244', "Id", '20/08/2025 657 DMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/13de97d29ee10ef2d60fc91620172fe008d265b8-1755705615205', false, 2, true, NOW(), '13de97d29ee10ef2d60fc91620172fe008d265b8-1755705615205'
FROM "Courses"
WHERE "Title" = '657 DMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '13de97d29ee10ef2d60fc91620172fe008d265b8-1755705615205'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '5b38a430-3b83-460f-8c1f-157d9e1d6201', "Id", '21/08/2025 657 DMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/13de97d29ee10ef2d60fc91620172fe008d265b8-1755792081645', false, 2, true, NOW(), '13de97d29ee10ef2d60fc91620172fe008d265b8-1755792081645'
FROM "Courses"
WHERE "Title" = '657 DMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '13de97d29ee10ef2d60fc91620172fe008d265b8-1755792081645'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'ce534288-db0c-445e-b8e3-694225325fc7', "Id", '25/08/2025 657 DMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/13de97d29ee10ef2d60fc91620172fe008d265b8-1756139564543', false, 2, true, NOW(), '13de97d29ee10ef2d60fc91620172fe008d265b8-1756139564543'
FROM "Courses"
WHERE "Title" = '657 DMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '13de97d29ee10ef2d60fc91620172fe008d265b8-1756139564543'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'b07a53b9-d436-4835-bbbe-ca2b2f841c53', "Id", 'Halkla ilişkiler', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/37f362a91a61e50e55fe63828a97201de0879850-1763308612963', false, 2, true, NOW(), '37f362a91a61e50e55fe63828a97201de0879850-1763308612963'
FROM "Courses"
WHERE "Title" = 'HALKLA İLİŞKİLER VE ETİK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '37f362a91a61e50e55fe63828a97201de0879850-1763308612963'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '184ab923-36f3-416c-b272-3a19fb45d26f', "Id", 'HALKLA İLİŞKİLER VE ETİK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/37f362a91a61e50e55fe63828a97201de0879850-1763915983937', false, 2, true, NOW(), '37f362a91a61e50e55fe63828a97201de0879850-1763915983937'
FROM "Courses"
WHERE "Title" = 'HALKLA İLİŞKİLER VE ETİK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '37f362a91a61e50e55fe63828a97201de0879850-1763915983937'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'b417b116-b476-42f1-8537-d81f91741480', "Id", 'ETİK REHBERİ', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/37f362a91a61e50e55fe63828a97201de0879850-1764094680382', false, 2, true, NOW(), '37f362a91a61e50e55fe63828a97201de0879850-1764094680382'
FROM "Courses"
WHERE "Title" = 'HALKLA İLİŞKİLER VE ETİK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '37f362a91a61e50e55fe63828a97201de0879850-1764094680382'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '3232b738-459c-480e-bd04-d3cb6ff88346', "Id", 'Soru Çözümü', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/37f362a91a61e50e55fe63828a97201de0879850-1764184583062', false, 2, true, NOW(), '37f362a91a61e50e55fe63828a97201de0879850-1764184583062'
FROM "Courses"
WHERE "Title" = 'HALKLA İLİŞKİLER VE ETİK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '37f362a91a61e50e55fe63828a97201de0879850-1764184583062'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '5c1a9982-7de6-4b04-a335-f75e43815b0b', "Id", '21/07/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753113638957', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753113638957'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753113638957'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '7bf4155b-d044-444f-adf5-6793e3d76094', "Id", '22/07/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753199957840', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753199957840'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753199957840'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '07d2fa73-e63b-400b-bca6-f8f3cd533aeb', "Id", '23/07/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753286515464', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753286515464'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753286515464'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '294cda67-2a27-42e1-a61d-6d9134980a0c', "Id", '24/07/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753372814824', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753372814824'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753372814824'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '36d0c152-124f-4416-9f8c-338ea6ac7ec1', "Id", '28/07/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753718424451', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753718424451'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753718424451'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '64883ee1-ad1a-4222-8531-45f879b68848', "Id", '29/07/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753804518067', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753804518067'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1753804518067'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'c78f2bca-3ca1-4d86-90cf-c064bdb1c40f', "Id", '04/08/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754323170508', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754323170508'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754323170508'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '9a160521-ea81-49cf-8215-aacd1d372899', "Id", '05/08/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754409578843', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754409578843'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754409578843'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '971d0cd6-a518-4bd8-b9f9-30ef58e73160', "Id", '06/08/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754495982763', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754495982763'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754495982763'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '77b58cd4-c0b2-472a-8bfa-2b500249b8cf', "Id", '07/08/2025 ANAYASA HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754582373709', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754582373709'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754582373709'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'a9ee5451-a6af-4548-9690-0321644d1232', "Id", '11/08/2025 ANAYASA HUKUKU GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754928222875', false, 2, true, NOW(), '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754928222875'
FROM "Courses"
WHERE "Title" = 'ANAYASA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39b29e4a886f2c62bfe81d04ad402a6b33ea1e51-1754928222875'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'fc2788e0-8bae-4978-a749-8b72754ef2af', "Id", '27/08/2025 CEZA', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756310500679', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756310500679'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756310500679'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '11dff1de-a328-4cd5-9463-125d9ea5d27c', "Id", '28/08/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756396809719', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756396809719'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756396809719'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'ca4c5e6e-916b-4254-ae0f-379940381561', "Id", '01/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756742337931', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756742337931'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756742337931'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '9959c0d6-571f-48cd-8195-f4b29518c9f7', "Id", '02/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756828817250', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756828817250'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756828817250'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'a9186fdb-4dcb-4b55-8ecd-f621f697914c', "Id", '03/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756915215752', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756915215752'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1756915215752'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '249db8ed-4a3b-4251-8ec3-0564e2ca71fc', "Id", '08/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757347202168', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757347202168'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757347202168'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '1c8ce267-6b23-48a7-bafb-c06c2767605b', "Id", '09/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757433640823', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757433640823'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757433640823'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '25b555e9-2d3f-4e43-8fc3-b1d7cab779b2', "Id", '10/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757519816304', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757519816304'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757519816304'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '244fb460-4b59-4ecb-adf9-740aa7b11f01', "Id", '11/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757606354191', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757606354191'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757606354191'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '29f16a03-ad4f-4c93-a662-20f99e00cbcc', "Id", '12/09/2025 CMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757692791231', false, 2, true, NOW(), '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757692791231'
FROM "Courses"
WHERE "Title" = 'CEZA HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '39cedf73cbe6e368ebf325837ad94aff135bb6f6-1757692791231'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '6784fbcf-0697-45c9-adf7-ae763f1fd014', "Id", '26/09/2025 İYUK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1758902343340', false, 2, true, NOW(), '523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1758902343340'
FROM "Courses"
WHERE "Title" = 'İYUK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1758902343340'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'db396c8c-1149-47c4-b101-2f8237444d72', "Id", '29/09/2025 İYUK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1759161694301', false, 2, true, NOW(), '523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1759161694301'
FROM "Courses"
WHERE "Title" = 'İYUK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1759161694301'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '4dd50838-5077-418e-923d-2fd684d3e1b8', "Id", '30/09/2025 İYUK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1759248004543', false, 2, true, NOW(), '523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1759248004543'
FROM "Courses"
WHERE "Title" = 'İYUK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '523e8ce3936953ac1dfb4230ae8d171e35e39ac0-1759248004543'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '4f8cac9b-5525-4680-b952-30f70e40f3f4', "Id", '12/08/2025 İDARİ TEŞKİLAT', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1755014446253', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1755014446253'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1755014446253'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '547dc116-fdff-4a8b-b48a-fd65e6a025b8', "Id", '13/0872025 İDARİ TEŞKİLAT', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1755100919819', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1755100919819'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1755100919819'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'f9c68448-a5ea-41b5-8f08-2c43240422bf', "Id", '17/09/2025 İDARİ TEŞKİLAT (İL İDARESİ KANUNU)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758124886591', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758124886591'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758124886591'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'd5c332ca-ff8e-4495-9089-5ac313c5b61e', "Id", 'İDARİ TEŞKİLAT (İL ÖZEL İDARESİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758211298733', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758211298733'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758211298733'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '8b7f3348-35a7-4b50-b388-0f3d6dfadf61', "Id", '19/09/2025 İDARİ TEŞKİLAT (İL ÖZEL İDARESİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758297593527', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758297593527'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758297593527'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '69b2bdd6-43cc-464f-b44e-eb48a0acce44', "Id", '22/09/2025 İDARİ TEŞKİLAT (İL ÖZEL İDARESİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758556804872', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758556804872'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758556804872'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '077e5c09-49bb-4e35-a38f-f851c6871df1', "Id", '23/09/2025 İDARİ TEŞKİLAT (BELEDİYE KANUNU)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758643247050', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758643247050'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758643247050'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '08dbb43c-2c4e-4efc-9d0d-ef832f04ced7', "Id", '24/09/2025 İDARİ TEŞKİLAT (CB)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758729643417', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758729643417'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758729643417'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '63d7c73b-fd05-46a2-bf51-54575f7172f0', "Id", '25/09/2025 ADALET BAKANLIĞI TEŞKİLATI', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758815996695', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758815996695'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758815996695'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '8d49f526-4202-411c-b9d9-2725dd8f96ae', "Id", '25/09/2025 ADALET BAKANLIĞI TEŞKİLATI', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/554dea71feee3720553a44630426ec191f9d97bc-1758817202289', false, 2, true, NOW(), '554dea71feee3720553a44630426ec191f9d97bc-1758817202289'
FROM "Courses"
WHERE "Title" = 'İDARİ TEŞKİLAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '554dea71feee3720553a44630426ec191f9d97bc-1758817202289'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'fb2b9bbc-9e04-44a8-9a76-88a7480ff5d0', "Id", '15/09/2025 İNFAZ HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/577275372681a17ecf56a334714b27a198f0fd0a-1757952383765', false, 2, true, NOW(), '577275372681a17ecf56a334714b27a198f0fd0a-1757952383765'
FROM "Courses"
WHERE "Title" = 'İNFAZ HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '577275372681a17ecf56a334714b27a198f0fd0a-1757952383765'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'c9bdaf09-9028-454f-8fff-117a34d13252', "Id", '16/09/2025 İNFAZ HUKUKU', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/577275372681a17ecf56a334714b27a198f0fd0a-1758038462996', false, 2, true, NOW(), '577275372681a17ecf56a334714b27a198f0fd0a-1758038462996'
FROM "Courses"
WHERE "Title" = 'İNFAZ HUKUKU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '577275372681a17ecf56a334714b27a198f0fd0a-1758038462996'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '2f5a5b4c-e135-40a0-9487-7e10afe7b65d', "Id", '22/10/2025 DEVLET MEMURLARI İLE İLGİLİ MEVZUAT (BİLGİ EDİNME HAKKI KANUNU)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761149082538', false, 2, true, NOW(), '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761149082538'
FROM "Courses"
WHERE "Title" = 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761149082538'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'f18ce9d6-4236-4fa5-be1b-b26fd7a2aced', "Id", '23/10/2025 DEVLET MEMURLARI İLE İLGİLİ MEVZUAT (DİLEKÇE HAKKININ KULLANILMASINA DAİR KANUN)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761235245551', false, 2, true, NOW(), '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761235245551'
FROM "Courses"
WHERE "Title" = 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761235245551'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '94cfdb8e-8d18-4a2c-ae0b-fa211e5336a3', "Id", 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT ( ADALET BAKANLIĞI PERSONELİ SINAV YÖNETMELİĞİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761840077330', false, 2, true, NOW(), '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761840077330'
FROM "Courses"
WHERE "Title" = 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761840077330'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '20719a52-5cf1-49d9-8210-cea0818cba40', "Id", 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT (ADALET BAKANLIĞI MEMUR SINAV ATAMA  VE NAKİL YÖNETMELİĞİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761926427340', false, 2, true, NOW(), '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761926427340'
FROM "Courses"
WHERE "Title" = 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '60e1a19ccaf4d4db904887c57c2685fbb02b3f5b-1761926427340'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '68292710-52f9-4425-81cb-14ff3422c98d', "Id", '08/10/2025 HMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1759939233367', false, 2, true, NOW(), '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1759939233367'
FROM "Courses"
WHERE "Title" = 'HMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1759939233367'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '6f010ca3-d0d4-437e-a5ba-ac94ceec2a07', "Id", '09/10/2025 HMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760025608981', false, 2, true, NOW(), '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760025608981'
FROM "Courses"
WHERE "Title" = 'HMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760025608981'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '03844688-0eae-4e39-bcbb-01a716ad597f', "Id", '13/10/2025 HMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760371232685', false, 2, true, NOW(), '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760371232685'
FROM "Courses"
WHERE "Title" = 'HMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760371232685'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'db55ed27-ba11-4837-8108-4e4bbca75b69', "Id", '14/10/2025 HMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760457640083', false, 2, true, NOW(), '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760457640083'
FROM "Courses"
WHERE "Title" = 'HMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760457640083'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'a6aec23a-9b2d-4a89-ad0a-c9f44c7fe4af', "Id", '15/10/2025 HMK', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760544023517', false, 2, true, NOW(), '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760544023517'
FROM "Courses"
WHERE "Title" = 'HMK'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '829b799fb0e89df66fe5fbdac0f0f3d37ed1291b-1760544023517'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'b0b4fef1-5bc6-4b2a-a279-7230bcdde1af', "Id", 'ADLİ VE İDARİ YARGI ADALET KOMİSYONLARI', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/8ad9c6c321ede52aa526240ce7c8206ce766a7f5-1762185653210', false, 2, true, NOW(), '8ad9c6c321ede52aa526240ce7c8206ce766a7f5-1762185653210'
FROM "Courses"
WHERE "Title" = 'ADLİ VE İDARİ YARGI ADALET KOMİSYONLARI'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '8ad9c6c321ede52aa526240ce7c8206ce766a7f5-1762185653210'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '0f868e6b-2246-4936-9fa1-c8c25f0d3939', "Id", '20/07/2025 TANITIM DERSİ', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/b0d3564c585625b34d7c3530082753545f5e7508-1753019294562', false, 2, true, NOW(), 'b0d3564c585625b34d7c3530082753545f5e7508-1753019294562'
FROM "Courses"
WHERE "Title" = 'TANITIM '
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'b0d3564c585625b34d7c3530082753545f5e7508-1753019294562'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '598c5be4-9f06-4fe3-9d48-856eaa7f096a', "Id", '20.07.2025', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/b0d3564c585625b34d7c3530082753545f5e7508-1753027242078', false, 2, true, NOW(), 'b0d3564c585625b34d7c3530082753545f5e7508-1753027242078'
FROM "Courses"
WHERE "Title" = 'TANITIM '
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'b0d3564c585625b34d7c3530082753545f5e7508-1753027242078'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '06685d71-6697-410b-995c-84e071637721', "Id", 'GYS', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/bee4a60aa7c180841a40a83e33af607047d8f687-1762098768040', false, 2, true, NOW(), 'bee4a60aa7c180841a40a83e33af607047d8f687-1762098768040'
FROM "Courses"
WHERE "Title" = '492 sayılı HARÇLAR KANUNU'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'bee4a60aa7c180841a40a83e33af607047d8f687-1762098768040'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'ae83b4ca-e0b5-4219-a2bc-665c94879bf8', "Id", 'ATATÜRK İLKELERİ vE İNKILAP TARİHİ', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1753457875188', false, 2, true, NOW(), 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1753457875188'
FROM "Courses"
WHERE "Title" = 'ATATÜRK İLKELERİ ve iNKILAP TARİHİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1753457875188'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '3f7babcc-d92a-400c-bb3a-d66961bfcbd9', "Id", 'mondros', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1753891539558', false, 2, true, NOW(), 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1753891539558'
FROM "Courses"
WHERE "Title" = 'ATATÜRK İLKELERİ ve iNKILAP TARİHİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1753891539558'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '4caf9f17-4e65-433d-894a-fe3a92bfd13e', "Id", 'kongreler', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1754063504682', false, 2, true, NOW(), 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1754063504682'
FROM "Courses"
WHERE "Title" = 'ATATÜRK İLKELERİ ve iNKILAP TARİHİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1754063504682'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '58e38e4f-fd93-404f-972a-270c27b8e6ca', "Id", 'kurtuluş savaşı batı cephesi', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1754668553067', false, 2, true, NOW(), 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1754668553067'
FROM "Courses"
WHERE "Title" = 'ATATÜRK İLKELERİ ve iNKILAP TARİHİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1754668553067'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '0d15fd28-8412-40a2-8721-3ee55b35cf20', "Id", 'lozan barış antlaşması', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1755273363760', false, 2, true, NOW(), 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1755273363760'
FROM "Courses"
WHERE "Title" = 'ATATÜRK İLKELERİ ve iNKILAP TARİHİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1755273363760'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'd2bda4d5-59e9-4cd5-8a59-7392a989e3e2', "Id", 'soru çözümü', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1755881598243', false, 2, true, NOW(), 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1755881598243'
FROM "Courses"
WHERE "Title" = 'ATATÜRK İLKELERİ ve iNKILAP TARİHİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c4bd602be4f15de99a6ebba84a7dd9c7815f5a53-1755881598243'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'c836b953-f38a-46df-b7d6-b109940e0226', "Id", 'DEVLET MEMURLARI İLE İLGİLİ MEVZUAT (ADALET BAKANLIĞI DİSİPLİN YÖNETMELİĞİ)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c75d84876481a4b03c9c240dd89650f679870627-1761753706202', false, 2, true, NOW(), 'c75d84876481a4b03c9c240dd89650f679870627-1761753706202'
FROM "Courses"
WHERE "Title" = 'ADALET BAKANLIĞI DİSİPLİN YÖNETMELİĞİ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c75d84876481a4b03c9c240dd89650f679870627-1761753706202'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '10624ae1-c7d7-4e9e-aeb2-e8ae6c40ef01', "Id", 'Resmi Yazışmalar', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/c96e08b598a6e3ce6e9dd171bec5fdf70b748f07-1763902990871', false, 2, true, NOW(), 'c96e08b598a6e3ce6e9dd171bec5fdf70b748f07-1763902990871'
FROM "Courses"
WHERE "Title" = 'RESMİ YAZIŞMALAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'c96e08b598a6e3ce6e9dd171bec5fdf70b748f07-1763902990871'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '0e0f7f93-98ba-4540-83a3-b720c3546e66', "Id", '06/11/2025 KALEM MEVZUATI (ADLİ YARGI)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/d5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762445032679', false, 2, true, NOW(), 'd5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762445032679'
FROM "Courses"
WHERE "Title" = 'KALEM MEVZUATI'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'd5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762445032679'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'd2ebc46f-3b5b-4a57-9da4-9ca597724380', "Id", '08/11/2025 KALEM MEVZUATI (ADLİ YARGI)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/d5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762610404272', false, 2, true, NOW(), 'd5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762610404272'
FROM "Courses"
WHERE "Title" = 'KALEM MEVZUATI'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'd5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762610404272'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '55a6642c-0223-4556-8301-e38e663f5bef', "Id", '10/11/2025 KALEM MEVZUATI (İDARİ YARGI)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/d5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762790362902', false, 2, true, NOW(), 'd5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762790362902'
FROM "Courses"
WHERE "Title" = 'KALEM MEVZUATI'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'd5efdb0cac887c56f2b40ffbc14733c0a710c83f-1762790362902'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '67302f26-3c18-4a30-90ed-117ccb53835f', "Id", '11/11/2025 TEKRAR (ANAYASA)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1762876827551', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1762876827551'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1762876827551'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '56d6d94a-f4e9-427e-bbe8-2f2903010386', "Id", '12/11/2025 GENEL TEKRAR (ANAYASA-CMK)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1762963099155', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1762963099155'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1762963099155'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '2a9d3755-4112-4ad1-83dd-b4ffd377d7ee', "Id", '13/11/2025 GENEL TEKRAR (CMK-İNFAZ HK)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763049605834', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763049605834'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763049605834'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'b5367de3-4fae-4342-8ec4-d2107c80740e', "Id", '14/11/2025 GENEL TEKRAR (İNFAZ HK-İYUK)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763136099821', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763136099821'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763136099821'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '47471e78-a555-4d71-a26f-94d025af7230', "Id", '15/11/2025 GENEL TEKRAR (HMK-TEBLİGAT HK)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763215169045', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763215169045'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763215169045'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '2af0924b-c12a-4e77-bb5b-92ea5cd6f1e5', "Id", '17/11/2025 GENEL TEKRAR (İDARİ TEŞKİLAT)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763401942790', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763401942790'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763401942790'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '5c196b6b-fd10-41c0-bf04-65c409e5c0d5', "Id", '18/11/2025 GENEL TEKRAR (İDARİ TEŞKİLAT)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763482647715', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763482647715'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763482647715'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '0a96e107-71cc-4a8f-8f53-3fe44fc3afd3', "Id", '19/11/2025 GENEL TEKRAR (KALEM MEVZUATI)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763568081948', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763568081948'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763568081948'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'dad0fbf6-368a-4258-bcaa-366fb3891b02', "Id", '20/11/2025 GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763658195281', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763658195281'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763658195281'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'a0c471e7-70d5-4900-b03b-11bc16a64721', "Id", '21/11/2025 GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763740858843', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763740858843'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763740858843'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '0e24a56b-4d03-43a9-8075-fe9f06abc5dc', "Id", '22/11/2025 GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763823418989', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763823418989'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1763823418989'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '7a5eb217-64bf-431a-8d94-1e18a5ebc838', "Id", 'GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764001016606', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764001016606'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764001016606'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '2208b6dc-5f63-423f-818e-318cf2483104', "Id", 'GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764086352951', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764086352951'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764086352951'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'e16a8048-5ad1-4f1b-bb09-24d99f3e22fc', "Id", 'GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764172643458', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764172643458'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764172643458'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'a7a6f396-21a1-4f36-bda5-aea7b72909b5', "Id", '27/11/2025 GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764261049300', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764261049300'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764261049300'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'a9895092-209b-4726-811b-1e3081646f37', "Id", 'GENEL TEKARAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764345836174', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764345836174'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764345836174'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '05053a6e-9a59-42b2-b592-a24b345a82b1', "Id", 'GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764422795522', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764422795522'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764422795522'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    'b3108b16-8e70-441c-bf53-2f140ee120ae', "Id", '29/11/2025 GENEL TEKRAR', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764430162086', false, 2, true, NOW(), 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764430162086'
FROM "Courses"
WHERE "Title" = 'ETÜTLER VE TEKRARLAR'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'edff49cc043f09d411d862dd74bd6d5b7ec9a901-1764430162086'
)
LIMIT 1;


INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '8515be98-6f88-4c32-b609-4477df1a916f', "Id", 'YARGI ÖRGÜTÜ (İDARİ YARGI)', false, 0, 'https://canli.hll.muro.click/playback/presentation/2.3/fd50634591b747b8fb39b094a835ddef827d2fed-1762358371861', false, 2, true, NOW(), 'fd50634591b747b8fb39b094a835ddef827d2fed-1762358371861'
FROM "Courses"
WHERE "Title" = 'YARGI ÖRGÜTÜ'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = 'fd50634591b747b8fb39b094a835ddef827d2fed-1762358371861'
)
LIMIT 1;

COMMIT;
