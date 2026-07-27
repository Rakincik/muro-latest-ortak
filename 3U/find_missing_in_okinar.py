import json
import os

courses = {
    'REHBERLİK': 'bde29e84-18df-4a69-a359-2c7c7f3b89b1',
    'REHBERLİK GÖRÜŞME': 'dd2ee3f2-1fb8-4101-b552-8700ef58aeb1',
    'REHBERLİK DENEME PANELİ': 'bd65f6c8-500e-4c74-8b65-6e01a556af5f',
    'REHBERLİK 2026 (Sabah Grubu)': 'cb3d2bf9-1959-4bf9-8664-9844f2d3cf0f',
    'REHBERLİK 2026 (Akşam Grubu)': 'a3f88f12-073c-4d56-b072-bb2f7c0018fe'
}

json_path = 'okinar dersler/4tuzem.okinar.com_recordings.json'

if not os.path.exists(json_path):
    print("JSON file not found!")
    exit(1)

with open(json_path, 'r', encoding='utf-8') as f:
    recordings = json.load(f)

sql_statements = []

for rec in recordings:
    class_name = rec.get('className', '').strip()
    if class_name in courses:
        c_id = courses[class_name]
        rid = rec.get('recordID', '')
        title = rec.get('recordingName', 'Ders')
        start = rec.get('startTime', '')
        duration = rec.get('duration', '0')
        
        # parse date format like '14.01.2026 12:12:10' to standard sql format '2026-01-14 12:12:10'
        try:
            from datetime import datetime
            dt = datetime.strptime(start, '%d.%m.%regular_%expression %H:%M:%S')
            start_sql = dt.strftime('%Y-%m-%d %H:%M:%S')
        except:
            start_sql = start
            
        sql = f"INSERT INTO \"Sessions\" (\"Id\", \"CourseId\", \"Title\", \"VideoUrl\", \"BbbMeetingId\", \"IsDeleted\", \"CreatedAt\", \"Status\", \"Order\", \"RecordingEnabled\", \"IsFree\", \"ScheduledStart\", \"ScheduledEnd\", \"DurationMinutes\", \"TenantId\") VALUES (gen_random_uuid(), '{c_id}', '{title}', 'https://canli.monopoluzem.com.tr/playback/presentation/2.3/{rid}', '{rid}', false, '{start_sql}', 'Completed', 1, true, false, '{start_sql}', '{start_sql}', {duration}, 'b2c1b827-0136-4d56-b072-bb2f7c0018fe');"
        sql_statements.append(sql)

print(f"Found {len(sql_statements)} matching recordings.")
with open('scratch/insert_missing_recordings.sql', 'w', encoding='utf-8') as out:
    out.write("\n".join(sql_statements))
print("Saved SQL statements to scratch/insert_missing_recordings.sql")
