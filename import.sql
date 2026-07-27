-- MURO Student Group Import SQL
BEGIN;

INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'serkanavcu17@gmail.com' AND LOWER(g."Name") = '360° hukuk'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'av.melisayaman@gmail.com' AND LOWER(g."Name") = '360° hukuk'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysenncobann@gmail.com' AND LOWER(g."Name") = '360° maliye'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'suezgiaksoy@gmail.com' AND LOWER(g."Name") = '360° muhasebe'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nida7597@gmail.com' AND LOWER(g."Name") = '360° muhasebe'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aleynazzhr@outlook.com' AND LOWER(g."Name") = '360° muhasebe'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'symaelygn.1907@gmail.com' AND LOWER(g."Name") = '360° muhasebe'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esrasosyalmedyaa@gmail.com' AND LOWER(g."Name") = '360° muhasebe'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gulbenfisekci@gmail.com' AND LOWER(g."Name") = '360° muhasebe'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'serkanavcu17@gmail.com' AND LOWER(g."Name") = '360° i̇ktisat'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'meralsoyata06@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilekcakan@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kbdoganlar@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ferhatkayacan@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'alpr.yazicioglu@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kocmerve859@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'saadetduvan.28@hotmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'durusoysaliha@icloud.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tugceturkekul1@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'duduinci50@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'balimmanta@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ahmettunahanakturk@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynep.altunkayaa@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = '432esraacar@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'eda.gkc14@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dorukdaldal@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busracatal81@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hresit95@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yunusemrekoc6@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'selcanua322@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ogunmezkit@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nadire.onder7@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'edauslu076@gmail.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'meryemabukan@outlook.com' AND LOWER(g."Name") = 'banka sınavlarına hazırlık kampı 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'emekozkan@hotmail.com' AND LOWER(g."Name") = 'guy (deneme çözümü)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bozkurtm2884@gmail.com' AND LOWER(g."Name") = 'guy (deneme çözümü)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aylin_cavusoglu61@hotmail.com' AND LOWER(g."Name") = 'guy (hızlı konu anlatımı)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aylin_cavusoglu61@hotmail.com' AND LOWER(g."Name") = 'guy (yoğun soru çözümü)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'hukuk (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cansuyucesoy48@gmail.com' AND LOWER(g."Name") = 'hukuk (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seminmkocak@gmail.com' AND LOWER(g."Name") = 'hukuk (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sertacaytm@hotmail.com' AND LOWER(g."Name") = 'hukuk (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'hukuk (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cansuyucesoy48@gmail.com' AND LOWER(g."Name") = 'hukuk (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seminmkocak@gmail.com' AND LOWER(g."Name") = 'hukuk (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sertacaytm@hotmail.com' AND LOWER(g."Name") = 'hukuk (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssabahat84@gmail.com' AND LOWER(g."Name") = 'hukuk flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rcpkplnn@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cansuyucesoy48@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kivanckarakas6@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gokcen.simay@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nefes1905@outlook.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elitasege64@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ezkah2906@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melkor4242@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seminmkocak@gmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sertacaytm@hotmail.com' AND LOWER(g."Name") = 'hukuk offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kivanckarakas6@gmail.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gokcen.simay@gmail.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bulutahmet8080@gmail.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nefes1905@outlook.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elitasege64@gmail.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ezkah2906@gmail.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melkor4242@gmail.com' AND LOWER(g."Name") = 'hukuk offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysnurckr11@gmail.com' AND LOWER(g."Name") = 'hızlı konu yoğun soru 2025'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'erdengulcan@icloud.com' AND LOWER(g."Name") = 'hızlı konu yoğun soru 2025'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seymakabadayii@gmail.com' AND LOWER(g."Name") = 'hızlı konu yoğun soru 2025'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'erenkorun@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hakcay061@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaocak2538@hotmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'abdullahyanik241@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cananduygu@icloud.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sibelbozkurt6367@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'toluzeynep@hotmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ktnn.tuba@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bozdemir35@icloud.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'smmm.seda02@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sevvalkaralar.2026@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cemilenur947@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmabusesahin876@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esra13080@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esraa.ozdogan94@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'silanuryaylaci1@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cagri1366@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sevilaysazak@outlook.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'serdemgecti45@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysenurerdogan25@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tcoskung@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysegul.karaks1@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sblltndg@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'symaelygn.1907@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mertcangunbay@icloud.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uutkuxmhg@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'furkankilic2506@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'demirbasfurkan82@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'acakzelihanur@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ruken.gunen@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bilal.kirik@istanbul.edu.tr' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rat0061967@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'deryasahin003@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gulsahozdmr250@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'abdullahunal2@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysenuraltunkulce@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yunusemrekocayigit@hotmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aykuthasan.06@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kubram1064@hotmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nida.sen@hotmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'merveaktas534@hotmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysegulboztas1@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'damlacaparli@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yakirasarikaya@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aydoganselin04@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (10 yıl)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sema66nur66@gmail.com' AND LOWER(g."Name") = 'kpss a çikmiş sorular (5 yil)'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bekcan1997@gmail.com' AND LOWER(g."Name") = 'kpss b offli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gulakgll@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmagultemen015@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bilge.sezer1965@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yusuf.esergun@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'toluzeynep@hotmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ranaecee@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kubra.ygurler@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi akşam grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'amineayyildiz.21@outlook.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ozannaktas@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'edaaydogan001@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihgunduz45@icloud.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gudenmurat06@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dalkilicesraa@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ilkekocak95@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hasanburakdemir0@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynepkn59@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzerirem12@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmagultemen015@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kader.kmc25@icloud.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bakiakbas458@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'smnrkum@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'serkaan.cerik@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tekdemirayse4@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ummuhan690@hotmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'semratnrl@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cgrsnl95@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'wervegedik@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nalanarslan12@icloud.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cakirylmz45@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'vedataltinparmak@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'edacantass@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmabyram44@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssungurludavras@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'svcnakbaba@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'brcdmr.1501@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nurullah_hacioglu@hotmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bengusudedeoglu@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gizem821bla@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nuurdonmez@icloud.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'symnrakkus@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'altinkaynakbusra@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'furkanalbakir@outlook.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mervebilgekaya08@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecesimsek9906@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bektasena7@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 's.atmaca1999@icloud.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiss246@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ledunkamiloglu@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elifsuduman@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nurnidaozdemir@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'abdullahyanik241@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nurcantanyeli@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeeynep.8@outlook.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zehrakalay.97@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'korayanlar128@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yavuznaciye03@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fuattoredi1993@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilaracandan007@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssemanurcetinn@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yahyagndz23@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysemakrbs@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'atasoyvildan@hotmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yusufkocak.engineer@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'alisin001@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sema.peker.1905@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ranaakbiyik06@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'berfum4406@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mervegelen92@hotmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mrv.unverr@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sumeyyekeskin77@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'camrabia75@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rsu710399@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ipknzlshn@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'doguefeyy@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'duygugrgll03@icloud.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'karamanelife99@hotmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'byzanurkoca@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'durmusmustafa17@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sbengk@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'iremkan06@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sebahatkonuss@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'leylacoban1625@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'altaybsr@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hanzadealbayrak@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssedanurgundogdu@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'azra.atilgann@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'subasiofaruk@gmail.com' AND LOWER(g."Name") = 'kpss b onli̇ne hafta i̇çi sabah grubu'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'huseyinagir@hotmail.com' AND LOWER(g."Name") = 'makro i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemtiraki@gmail.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaltintas1453@gmail.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'muhammetenesshacioglu@gmail.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayse_-meyveci@hotmail.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'merttcannpolatt@gmail.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nefes1905@outlook.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melikemaloglu@gmail.com' AND LOWER(g."Name") = 'maliye offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemtiraki@gmail.com' AND LOWER(g."Name") = 'mali̇ye (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'muhammetenesshacioglu@gmail.com' AND LOWER(g."Name") = 'mali̇ye (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayse_-meyveci@hotmail.com' AND LOWER(g."Name") = 'mali̇ye (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemtiraki@gmail.com' AND LOWER(g."Name") = 'mali̇ye (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'muhammetenesshacioglu@gmail.com' AND LOWER(g."Name") = 'mali̇ye (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayse_-meyveci@hotmail.com' AND LOWER(g."Name") = 'mali̇ye (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaltintas1453@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ilaydadurmaz7@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssudeozerr1@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'merttcannpolatt@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bulutahmet8080@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nefes1905@outlook.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elitasege64@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melikemaloglu@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilaracaglar1997@gmail.com' AND LOWER(g."Name") = 'mali̇ye offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'huseyinagir@hotmail.com' AND LOWER(g."Name") = 'mikro i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'devecisuheda@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaocak2538@hotmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dileksimsek829@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'acdmpp23647@hotmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzakgoksu@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihyanikk35@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ctahirekiz@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'oisik484@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecem.deniz.ank@hotmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecses44@hotmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hamdiyeyurttas@icloud.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ilaydadurmaz7@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssudeozerr1@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seminmkocak@gmail.com' AND LOWER(g."Name") = 'muhasebe (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'devecisuheda@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaocak2538@hotmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dileksimsek829@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'acdmpp23647@hotmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzakgoksu@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihyanikk35@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ctahirekiz@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'oisik484@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecem.deniz.ank@hotmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecses44@hotmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hamdiyeyurttas@icloud.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ilaydadurmaz7@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssudeozerr1@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sumeyyesoyturk09@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'irmakyuksel4@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seminmkocak@gmail.com' AND LOWER(g."Name") = 'muhasebe (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yasiincavus@gmail.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sdilarasahin91@gmail.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tagaa06@gmail.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gzde9709@gmail.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysecosknn@outlook.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'onurdalamanmustafa@gmail.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'k.hande_ist@hotmail.com' AND LOWER(g."Name") = 'muhasebe flix'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'devecisuheda@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'agicsinan01@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaocak2538@hotmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dileksimsek829@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'acdmpp23647@hotmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzakgoksu@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilekkucuk.4242@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihyanikk35@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ctahirekiz@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'oisik484@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecem.deniz.ank@hotmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ceylanseda280196@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ahsen_sar8@icloud.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecses44@hotmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayseoncerr@outlook.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sametbayrak955@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kivanckarakas6@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sayamselin@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yaseminmonn@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tunakzl35@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kilicilayda006@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mehmetgokhantucbilekk@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'demirellhale@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemicerr@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sumeyyesoyturk09@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zsirin93@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busratryk8@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiayaren02@icloud.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zehhracskn@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'erdoganemre190@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiadeniz585@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilaracaglar1997@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'seminmkocak@gmail.com' AND LOWER(g."Name") = 'muhasebe offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'agicsinan01@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilekkucuk.4242@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ceylanseda280196@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ahsen_sar8@icloud.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayseoncerr@outlook.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sametbayrak955@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elif.incedere@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kivanckarakas6@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sayamselin@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yaseminmonn@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tunakzl35@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'a.sahin7694@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kilicilayda006@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mehmetgokhantucbilekk@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'demirellhale@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemicerr@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zsirin93@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busratryk8@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiayaren02@icloud.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zehhracskn@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'erdoganemre190@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiadeniz585@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tunahangoksen60@gmail.com' AND LOWER(g."Name") = 'muhasebe offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmanurhazer@gmail.com' AND LOWER(g."Name") = 'p32 + kaymakamlık 2026 offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nrzeytin001@gmail.com' AND LOWER(g."Name") = 'p32 + kaymakamlık 2026 offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'safiye.krkmz58@hotmail.com' AND LOWER(g."Name") = 'p32 + kaymakamlık 2026 offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ubey_gs@outlook.com' AND LOWER(g."Name") = 'p32 + kaymakamlık 2026 offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'recep_ozcan1903@outlook.com' AND LOWER(g."Name") = 'p32 + kaymakamlık 2026 offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'katumehmett@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'amineayyildiz.21@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gulakgll@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ozannaktas@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busra06607@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'devecisuheda@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'agicsinan01@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aybuketurkoglu579@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'edaaydogan001@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aslihantok98@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nuranbayar2008@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihgunduz45@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gudenmurat06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dalkilicesraa@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ilkekocak95@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hasanburakdemir0@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynepkn59@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzerirem12@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gediiktugce@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esratasyurek25@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'betulozel98@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'samedbodur13@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ismailbatuhankocak@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmagultemen015@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'biltekinpakize50@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'frdevs3526@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kader.kmc25@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ozlemete42@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bakiakbas458@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'smnrkum@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elifkuyumcu408@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'eminebusrayilmaz@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'smtyilmaz.272@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'serkaan.cerik@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mustafademir1108@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynepb4888@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tekdemirayse4@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ummuhan690@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tugcesemiz832@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'semratnrl@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'okan1995demirkaynak@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cgrsnl95@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'murattunc066@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'wervegedik@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'suedababatr@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nalanarslan12@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cakirylmz45@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'vedataltinparmak@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'demetcakan95@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bengitysz@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'edacantass@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = '06ali06dilli06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'erenkorun@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fatmabyram44@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssungurludavras@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mehmetbakiyaman@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sdfksknklc@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'simsimygt0915@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'svcnakbaba@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'brcdmr.1501@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bilge.sezer1965@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nurullah_hacioglu@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bengusudedeoglu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sumeyyebuyukcolak2001@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fadimeuludagg@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hakcay061@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kderya326@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gizem821bla@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nuurdonmez@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'alperenpolat0658@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'p.dilay.arslan@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zihni582701@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayanelif5561@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'symnrakkus@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiaonal03@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'altinkaynakbusra@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'burak01_68@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'safinaz.atalay@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisaocak2538@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kubragunyaz99@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gulnur0738@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'furkanalbakir@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busrabilge07@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bsari1922@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mervebilgekaya08@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'firdevsaksu246@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'serifeozdemir048@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecesimsek9906@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'habibesahing@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bektasena7@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 's.atmaca1999@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rabiss246@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'emineezgia@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elifsuduman@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esraaltay4t@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nurnidaozdemir@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'semanur.moglu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'abdullahyanik241@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nurcantanyeli@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dileksimsek829@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cananduygu@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeeynep.8@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sumersedeftansu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fundagungormus1@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busra.oztekin14@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'acdmpp23647@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kadiryigit0106@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kadriyeyakut.429@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zehrakalay.97@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'korayanlar128@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'oguzincemain@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yusuf.esergun@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mnvvrks@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = '1denizyagiz@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ahmetenesyuce0@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'betl-goren@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yavuznaciye03@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'fuattoredi1993@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elifberramasatli@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'salihaesmerr@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'senaayyilmazz160617@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kutluhalilibrahimkutlu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'betulclk61@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'adiguzelismail93@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ozlemnur1@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihamelis.0909@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sinemkrbltt66@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilaracandan007@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mehmet_seyit_1998@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esnaydogann7@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzakgoksu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssemanurcetinn@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yahyagndz23@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elifcelikk717@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysenur.kertmen@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysemakrbs@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'atasoyvildan@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilekkucuk.4242@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tuzcuesmamelisa@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'berrailaydacavdar@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'alisin001@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bernakync8@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'burakhansahin61@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihyanikk35@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yucelhurkan@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sema.peker.1905@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynepbas03062003@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bsrmsk.40@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'halee.cakir@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'birce.stkn@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yturkel3@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynepkarmaksiz@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yusufurkanaktas@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yasemintuncerr@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'c.cerenulku@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ynsakgl35@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ermelisa17@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'handettutar@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ranaakbiyik06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'berfum4406@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ctahirekiz@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'btlkprl@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'betuulciinar@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sibelbozkurt6367@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hazalsilaa2503@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayferonarr162@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mervegelen92@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mrv.unverr@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sselcanorhann@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'beyzaylmaz2002@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'oisik484@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bugra52200@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sumeyyekeskin77@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ecem.deniz.ank@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gknrdemir@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'camrabia75@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'rsu710399@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ipknzlshn@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'altugggzelal@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemtiraki@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'canselbayram2110@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'doguefeyy@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'duygugrgll03@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'karamanelife99@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busrayalli95@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sungurmurat66@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'byzanurkoca@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'durmusmustafa17@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sbengk@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'iremkan06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sebahatkonuss@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'leylacoban1625@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'altaybsr@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hanzadealbayrak@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'has.elicabuk@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mvkaya2341@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yunus126763@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sema66nur66@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'haticecabuk96@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'merve_mereve@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sezgin.2047@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'meltemokcu37@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zisanataman@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nevzatengin94@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gozuyukarigokcen@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'buraksahin287@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssedanurgundogdu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'caglaa099@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'azra.atilgann@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'subasiofaruk@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mhmtkardogan13@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tr.furkancelik@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'toluzeynep@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'huriyesahin641@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'enesturan093@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'harununuvar00@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'oznuraltay11@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'tolgakapan07@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysemefaretkeser@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'erhanboz4129@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'muhammetenesshacioglu@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ranaecee@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kaya_omer04@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'emredic@turanymm.com.tr' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aysekilic2835@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busetoygan91@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ezelkizilgedikk@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'gamzesaybakk@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aycazlp@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dogansercan93@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ayse_-meyveci@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'inciiokk@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'defnegunes222@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hilal_38pkdmr@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melda6196@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'selinozr.97@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ulkubulut06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bozok4001@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ktnn.tuba@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sevvaltutkutoplutepe67@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'irem.nil.ozkan@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cdlar0271@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yildizmikail14@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kubra.ygurler@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nniissyy10@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'mehmettcinar@yahoo.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sutcuebru2@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'boranefe.tok@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'senacansali@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeyneparslan953@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sezerpolat23@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cicekirem2332@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'heredotx@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 't.gunoglu@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'edanurcan27@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'byozbek1@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'akkus.caangul@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kadirozdogan1982@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aticih702@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ebru1gumuss@icloud.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'emree.ocal@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melisa.hemmo1@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dilararslan54@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'esra.isik1992@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'busraakyol8007@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hrygksn@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uresinesmanur3@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'senyurtcansel@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'eliffaldemir00@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'brkzclk.26@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cevriyeeelbir@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sayamselin@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ataerol39@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aksuthatice5@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ynmdk_ceren@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'smmmemineinel@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'drs1286@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'nedimkiraz16@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ertugrulkrdnz05@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cetinhoru1903@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'dogan.mehmet0663@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'melihkavuk44@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aliiboztepe@hotmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'amondgruth@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'pinartaskan1995@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'altinordubeyza@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'hilal.elyildirim@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elifyesilormann@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'uzuneremin6@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'earsln1907@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'aydemirr.oznur@outlook.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zelihaekici06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kubraklcglu06@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'minebuyukakkas@gmail.com' AND LOWER(g."Name") = 'rehberli̇k 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'metehan.kaya.iibf@gmail.com' AND LOWER(g."Name") = 'sayıştay yazılı sınav hazırlık programı'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ali.mecidiyee@gmail.com' AND LOWER(g."Name") = 'sayıştay yazılı sınav hazırlık programı'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'a.sahin7694@gmail.com' AND LOWER(g."Name") = 'son beşli i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'huseyinagir@hotmail.com' AND LOWER(g."Name") = 'son beşli i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'zeynepelasahinn@gmail.com' AND LOWER(g."Name") = 'turbo guy kampi'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'emekozkan@hotmail.com' AND LOWER(g."Name") = 'vmy kampı yazılı sınav online'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'winchester_736@hotmail.com' AND LOWER(g."Name") = 'vmy kampı yazılı sınav online'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'yukselbilgili@hotmail.com' AND LOWER(g."Name") = 'vmy kampı yazılı sınav online'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ibrahimakdoganizmir@hotmail.com' AND LOWER(g."Name") = 'vmy kampı yazılı sınav online'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'sonerhoca@gmail.com' AND LOWER(g."Name") = 'vmy kampı yazılı sınav online'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'byozbek1@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kivanckarakas6@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemicerr@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'huseyinagir@hotmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cemiletzll@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elitasege64@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'doganumutcan@yahoo.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bilalahmet2272@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'celikyusuf34@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'haticekoca2772@gmail.com' AND LOWER(g."Name") = 'i̇ktisat offline'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bilalahmet2272@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'haticekoca2772@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat (akşam grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'byozbek1@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bilalahmet2272@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'haticekoca2772@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat (sabah grubu) 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ilaydadurmaz7@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'ssudeozerr1@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'kivanckarakas6@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cigdemicerr@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'huseyinagir@hotmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'bulutahmet8080@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'cemiletzll@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'elitasege64@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'doganumutcan@yahoo.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;
INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt")
SELECT gen_random_uuid(), u."Id", g."Id", 0, 'active', NOW()
FROM "Users" u
CROSS JOIN "Groups" g
WHERE LOWER(u."Email") = 'celikyusuf34@gmail.com' AND LOWER(g."Name") = 'i̇kti̇sat offli̇ne 2026'
ON CONFLICT ("UserId", "GroupId") DO NOTHING;

COMMIT;
