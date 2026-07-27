import json
import os

json_path = 'okinar dersler/4tuzem.okinar.com_recordings.json'

if not os.path.exists(json_path):
    print(f"JSON file not found: {json_path}")
    exit(1)

with open(json_path, 'r', encoding='utf-8') as f:
    recordings = json.load(f)

print(f"Total recordings in {json_path}: {len(recordings)}")

# Let's count recordings per className
from collections import Counter
counts = Counter()
for r in recordings:
    cname = r.get('className')
    if cname:
        counts[cname.strip()] += 1

print("\nTop course counts in Okinar:")
for cname, cnt in counts.most_common(30):
    print(f"  - {cname}: {cnt}")
