import json
import os
import glob

unique_ids = [
    "216207eb59a91acf266b5b3591fbebd18f0f9061-1785220204210",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785176499428",
    "a58af72bc85d23eca37dc0cab01d921da858ab42-1785259904033",
    "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785170029760",
    "216207eb59a91acf266b5b3591fbebd18f0f9061-1785225675508",
    "a58af72bc85d23eca37dc0cab01d921da858ab42-1785256142332",
    "a58af72bc85d23eca37dc0cab01d921da858ab42-1785269191174",
    "216207eb59a91acf266b5b3591fbebd18f0f9061-1785240231963",
    "a58af72bc85d23eca37dc0cab01d921da858ab42-1785265641800",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785171458920",
    "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785177352545",
    "2e2576ed8d3304dd027567dbf9c3c94c11faf678-1785173556825",
    "216207eb59a91acf266b5b3591fbebd18f0f9061-1785228444056",
    "216207eb59a91acf266b5b3591fbebd18f0f9061-1785222699516",
    "79d7ec6eec46b18bf7427f0916031100e47783e5-1785112849978",
    "95dbe3c9f31b31fdc66e0349a01961530be9f36b-1785154455450"
]

rec_map = {}

for json_path in glob.glob('okinar dersler/*.json'):
    with open(json_path, 'r', encoding='utf-8') as f:
        recordings = json.load(f)
        for r in recordings:
            rid = r.get('recordID')
            if rid in unique_ids:
                rec_map[rid] = {
                    'recordingName': r.get('recordingName'),
                    'className': r.get('className'),
                    'file': os.path.basename(json_path)
                }

print(f"Matched {len(rec_map)} recordings in Okinar JSONs:")
for uid in unique_ids:
    if uid in rec_map:
        print(f"ID: {uid} -> Class: {rec_map[uid]['className']} -> Name: {rec_map[uid]['recordingName']} (in {rec_map[uid]['file']})")
    else:
        print(f"ID: {uid} -> NOT FOUND in ANY JSON")
