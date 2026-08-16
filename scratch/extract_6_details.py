import json

uids = [
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785002216250",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785085107408",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785088352642",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785081870424",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784995380549",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784998604262"
]

with open("ÖMÜR/omurhoca.okinar.com_recordings.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print(f"Total recordings in JSON: {len(data)}")

matched = []
for item in data:
    rec_id = item.get("recordID", "")
    if rec_id in uids:
        matched.append({
            "uid": rec_id,
            "title": item.get("recordingName", "Ders Kaydı"),
            "startTime": item.get("startTime", "")
        })

print("\n--- MATCHED RECORDINGS ---")
for m in sorted(matched, key=lambda x: x['startTime']):
    print(f"UID: {m['uid']}")
    print(f"Title: {m['title']}")
    print(f"Start: {m['startTime']}")
    print("-" * 50)
