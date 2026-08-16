import json
import glob
import os

uids = [
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785002216250",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785085107408",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785088352642",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785081870424",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784995380549",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784998604262"
]

json_files = glob.glob("**/*.json", recursive=True)

found_map = {}

for jf in json_files:
    try:
        with open(jf, "r", encoding="utf-8") as f:
            content = json.load(f)
            if isinstance(content, list):
                for item in content:
                    if isinstance(item, dict):
                        rec_id = item.get("recordID", "") or item.get("id", "") or item.get("uid", "")
                        for target in uids:
                            if target in rec_id or rec_id in target:
                                found_map[target] = item.get("recordingName", "") or item.get("name", "") or item.get("title", "")
                                print(f"Found {target} in {jf}: {found_map[target]}")
    except Exception:
        pass

print("\n--- Summary ---")
for u in uids:
    print(f"{u} -> {found_map.get(u, 'Ders Kaydı')}")
