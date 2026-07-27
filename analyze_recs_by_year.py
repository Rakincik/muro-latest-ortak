import os
import json
from datetime import datetime

json_path = "mng/dereceuzem_guncel_kayitlar_full.json"
if not os.path.exists(json_path):
    json_path = "dereceuzem_guncel_kayitlar (2).json"

with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

year_counts = {}
for item in data:
    for r in item.get('recordings', []):
        start_time = r.get('startTime')
        if not start_time:
            # Try to get from recordID timestamp
            rec_id = r.get('recordID', '')
            if '-' in rec_id:
                try:
                    start_time = int(rec_id.split('-')[1])
                except:
                    pass
        
        if start_time:
            dt = datetime.fromtimestamp(start_time / 1000.0)
            year = dt.year
            year_counts[year] = year_counts.get(year, 0) + 1

print("Recording counts by year:")
for year, count in sorted(year_counts.items()):
    print(f"Year {year}: {count} recordings")
