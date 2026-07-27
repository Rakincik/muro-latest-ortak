import json
import os

json_path = "/opt/mvz/mevzuatadam.okinar.com_recordings.json"
if not os.path.exists(json_path):
    json_path = "mevzuatadam.okinar.com_recordings.json"

if os.path.exists(json_path):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    print("=== UNIQUE COURSE NAMES IN JSON ===")
    for idx, item in enumerate(data):
        print(f"{idx+1}. CourseName: '{item.get('courseName')}' (Recordings: {len(item.get('recordings', []))})")
else:
    print("JSON file not found!")
