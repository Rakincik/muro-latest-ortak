import html
import csv

print("Reading s7_kesin_MevzuatAdam.csv...")
lines = open('C:/Users/Rüstem/Desktop/okideolar/s7_kesin_MevzuatAdam.csv', 'r', encoding='utf-8').read().splitlines()

sql_statements = []

for line in lines[1:]:
    if not line.strip():
        continue
    parts = line.split(";")
    if len(parts) >= 2:
        folder = parts[0].strip()
        title = html.unescape(parts[1].strip().replace('"', ''))
        
        # skip extremely short titles to avoid accidental matching
        if len(title) < 4:
            continue
            
        video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
        safe_title = title.replace("'", "''")
        
        # Muro DB might have "BBB Kayıtları (TITLE)" or just "TITLE"
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" ILIKE '%{safe_title}%' AND "IsDeleted" = false;"""
        sql_statements.append(sql)

print(f"Generated {len(sql_statements)} SQL UPDATE statements.")

with open("apply_mvz_fix_final.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_statements))
print("Saved to apply_mvz_fix_final.sql")
