import csv
import html
import sys

def normalize(text):
    if not text:
        return ""
    text = html.unescape(text)
    text = text.replace("I", "ı").replace("İ", "i")
    return text.lower().strip()

print("Reading s7_kesin_MevzuatAdam.csv...")
lines = open('C:/Users/Rüstem/Desktop/okideolar/s7_kesin_MevzuatAdam.csv', 'r', encoding='utf-8').read().splitlines()
real_videos = {}

for line in lines[1:]:
    if not line.strip():
        continue
    parts = line.split(";")
    if len(parts) >= 2:
        folder = parts[0].strip()
        title = html.unescape(parts[1].strip().replace('"', ''))
        norm_title = normalize(title)
        real_videos[norm_title] = folder

print(f"Loaded {len(real_videos)} unique titles from CSV.")

import json
with open('okinar_bireysel_dersler mvz.json', 'r', encoding='utf-8') as f:
    mvz_data = json.load(f)

sql_statements = []
matched_count = 0

for course in mvz_data:
    materials = course.get("Materials", [])
    for mat in materials:
        title = mat.get("Title", "")
        norm_title = normalize(title)
        
        if norm_title in real_videos:
            folder = real_videos[norm_title]
            video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
            safe_title = title.replace("'", "''")
            sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" LIKE '%{safe_title}%';"""
            sql_statements.append(sql)
            matched_count += 1
        else:
            for csv_title, folder in real_videos.items():
                if csv_title in norm_title or norm_title in csv_title:
                    video_url = f"https://canli.mvz.muro.click/playback/presentation/2.3/playback.html?meetingId={folder}"
                    safe_title = title.replace("'", "''")
                    sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{folder}', "VideoUrl" = '{video_url}' WHERE "Title" LIKE '%{safe_title}%';"""
                    sql_statements.append(sql)
                    matched_count += 1
                    break

print(f"Generated {matched_count} SQL UPDATE statements.")
with open("apply_mvz_fix.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_statements))
print("Saved to apply_mvz_fix.sql")
