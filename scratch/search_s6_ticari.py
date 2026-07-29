import json

json_path = 'okinar dersler/4tuzem.okinar.com_recordings.json'

try:
    with open(json_path, 'r', encoding='utf-8') as f:
        recordings = json.load(f)

    print("Found recordings, searching for TİCARİ İŞLETME or IMS...")
    results = []
    for r in recordings:
        class_name = r.get('className', '')
        rec_name = r.get('recordingName', '')
        if 'TİCARİ İŞLETME' in class_name.upper() or 'TİCARİ İŞLETME' in rec_name.upper() or 'ŞİRKETLER' in class_name.upper():
            results.append({
                'class': class_name,
                'name': rec_name,
                'recordID': r.get('recordID'),
                'url': r.get('playbackUrl')
            })

    if results:
        print(f"Found {len(results)} matches!")
        for res in results[:10]:
            print(f"- Ders: {res['class']}, Video: {res['name']}, ID: {res['recordID']}")
    else:
        print("No matches found.")

except Exception as e:
    print("Error:", e)
