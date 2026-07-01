import json
from collections import Counter

# Load bbb_metadata
with open("bbb_metadata_185.86.155.222.json", "r", encoding="utf-8") as f:
    bbb_metadata = json.load(f)

# Load lms_sync mappings
from lms_sync import load_local_jsons, get_institution_by_keywords
master_mappings = load_local_jsons()

unmatched_names = []

for folder, meta in bbb_metadata.items():
    rec_id = folder.split("-")[0]
    info = master_mappings.get(rec_id)
    if not info:
        meeting_name = meta.get("meetingName", "Bilinmeyen Ders")
        slide_kws = meta.get("slideKeywords", "")
        guess = get_institution_by_keywords(meeting_name, slide_kws)
        if not guess:
            unmatched_names.append(meeting_name)

print(f"Total unmatched: {len(unmatched_names)}")
print("\nMost common unmatched meetingNames:")
c = Counter(unmatched_names)
for name, count in c.most_common(50):
    print(f" - {name}: {count} times")
