import json
import glob

prefix = "cc90649bb4cdc5f01bcad86b95dc5f42964681ee"

uids = [
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785047490902",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785065761785",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784980509435",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784961049982",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784983309134",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784968892181",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785062867103",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785055908195",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785049793310",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785060005968",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784975510873",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1785053117755",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784978082912",
    "cc90649bb4cdc5f01bcad86b95dc5f42964681ee-1784964942397"
]

json_files = glob.glob("**/*.json", recursive=True)

results = {}

for jf in json_files:
    try:
        with open(jf, "r", encoding="utf-8") as f:
            content = json.load(f)
            if isinstance(content, list):
                for item in content:
                    if isinstance(item, dict):
                        rec_id = item.get("recordID") or item.get("id") or item.get("uid") or ""
                        if prefix in rec_id:
                            name = item.get("recordingName") or item.get("name") or item.get("title") or ""
                            start = item.get("startTime") or item.get("date") or ""
                            results[rec_id] = {"name": name, "start": start, "file": jf}
    except Exception:
        pass

print(f"Total matching UIDs found: {len(results)}")
for u in uids:
    r = results.get(u, {})
    print(f"UID: {u}")
    print(f"  Title: {r.get('name', 'Ders Kaydı')}")
    print(f"  Start: {r.get('start', 'N/A')}")
    print("-" * 50)
