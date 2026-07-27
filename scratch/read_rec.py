import json
import datetime
import os

json_path = 'okinar dersler/ataniyorumhocam.okinar.com_recordings.json'
if not os.path.exists(json_path):
    print("File not found")
    exit(1)

with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

count = 0
for item in data:
    rec_id = item.get('recordID')
    if rec_id and '-' in rec_id:
        try:
            ts = int(rec_id.split('-')[-1][:13])
            dt = datetime.datetime.utcfromtimestamp(ts/1000.0)
            if dt >= datetime.datetime(2026, 6, 28):
                print(f"Course: {item.get('className')} | Recording: {item.get('recordingName')} | Date: {dt}")
                count += 1
                if count >= 10:
                    break
        except Exception as e:
            pass
