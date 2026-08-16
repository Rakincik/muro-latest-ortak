import json
import glob

uids = [
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785002216250",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785085107408",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785088352642",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785081870424",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784995380549",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784998604262"
]

json_files = glob.glob("**/*.json", recursive=True)

results = {}
for jf in json_files:
    try:
        with open(jf, "r", encoding="utf-8") as f:
            data = json.load(f)
            if isinstance(data, list):
                for item in data:
                    if isinstance(item, dict):
                        rec_id = item.get("recordID") or item.get("id") or item.get("uid") or ""
                        if rec_id in uids:
                            results[rec_id] = {
                                "file": jf,
                                "name": item.get("recordingName") or item.get("name") or item.get("title") or "Ders Kaydı",
                                "start": item.get("startTime") or item.get("date") or ""
                            }
    except Exception:
        pass

for u in uids:
    r = results.get(u, {})
    print(f"UID: {u}")
    print(f"  Name: {r.get('name', 'Ders Kaydı')}")
    print(f"  Start: {r.get('start', 'N/A')}")
    print(f"  Source: {r.get('file', 'N/A')}")
    print("-" * 50)
