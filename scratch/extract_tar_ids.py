import re

text = """
./216207eb59a91acf266b5b3591fbebd18f0f9061-1785220204210/
./bae785c169b3f9a3d1313199347f2aaf92cba61c-1785176499428/
./a58af72bc85d23eca37dc0cab01d921da858ab42-1785259904033/
./2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785170029760/
./216207eb59a91acf266b5b3591fbebd18f0f9061-1785225675508/
./a58af72bc85d23eca37dc0cab01d921da858ab42-1785256142332/
./a58af72bc85d23eca37dc0cab01d921da858ab42-1785269191174/
./216207eb59a91acf266b5b3591fbebd18f0f9061-1785240231963/
./a58af72bc85d23eca37dc0cab01d921da858ab42-1785265641800/
./bae785c169b3f9a3d1313199347f2aaf92cba61c-1785171458920/
./2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785177352545/
./2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785173556825/
./216207eb59a91acf266b5b3591fbebd18f0f9061-1785228444056/
./216207eb59a91acf266b5b3591fbebd18f0f9061-1785222699516/
./79d7ec6eec46b18bf7427f0916031100e47783e5-1785112849978/
./95dbe3c9f31b31fdc66e0349a01961530be9f36b-1785154455450/
"""

# Extract all matches that look like a BBB meeting ID at the start of a path
matches = re.findall(r'\./([a-f0-9]{40}-\d{13})/', text)

# Unique them while preserving order
seen = set()
unique_ids = []
for m in matches:
    if m not in seen:
        seen.add(m)
        unique_ids.append(m)

print(f"Found {len(unique_ids)} unique meeting IDs:")
for uid in unique_ids:
    print(uid)

print("\nGenerating SQL...")
sql_sessions = []
course_id = "7119ed0b-3c8c-4fe6-916c-afb1250d333b"
for i, uid in enumerate(unique_ids):
    title = f"ŞİRKETLER HUKUKU - DERS {i+1}"
    url = f"https://canli.4takademi.com/playback/presentation/2.3/{uid}"
    sql_sessions.append(f"(gen_random_uuid(), '{course_id}', '{title}', '{url}', '{uid}', false, NOW(), 4, {i+1}, true, false, NOW(), NOW())")

query = f"""docker exec -i muro_3u_postgres psql -U muro_user -d muro_demo -c "INSERT INTO \\"Sessions\\" (\\"Id\\", \\"CourseId\\", \\"Title\\", \\"VideoUrl\\", \\"BbbMeetingId\\", \\"IsDeleted\\", \\"CreatedAt\\", \\"Status\\", \\"Order\\", \\"RecordingEnabled\\", \\"IsFree\\", \\"ScheduledStart\\", \\"ScheduledEnd\\") VALUES {', '.join(sql_sessions)};" """
print("\n" + query)

query2 = f"""docker exec -i muro_3u_postgres psql -U muro_user -d muro_demo -c "INSERT INTO \\"CourseMedias\\" (\\"Id\\", \\"CourseId\\", \\"SessionId\\", \\"OrderIndex\\", \\"CreatedAt\\") SELECT gen_random_uuid(), \\"CourseId\\", \\"Id\\", 0, NOW() FROM \\"Sessions\\" WHERE \\"CourseId\\" = '{course_id}' AND NOT EXISTS (SELECT 1 FROM \\"CourseMedias\\" cm WHERE cm.\\"SessionId\\" = \\"Sessions\\".\\"Id\\");" """
print("\n" + query2)
