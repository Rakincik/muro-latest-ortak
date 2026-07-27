import urllib.request
import urllib.parse
import hashlib
import xml.etree.ElementTree as ET
import sys
import ssl

# Ignore SSL errors just in case
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

BBB_URL = "https://canli.mvz.muro.click/bigbluebutton/api"
BBB_SECRET = "eouZjmhrLwfGrB6MucK5b4TT2gdqD7RWnQoeBzCAyU"  # with uppercase K

api_call = "getRecordings"
query_string = "" # no params means get all
checksum_str = api_call + query_string + BBB_SECRET
checksum = hashlib.sha1(checksum_str.encode('utf-8')).hexdigest()

request_url = f"{BBB_URL}/{api_call}?checksum={checksum}"

try:
    print(f"Fetching from: {request_url}")
    req = urllib.request.Request(request_url, headers={'User-Agent': 'Mozilla/5.0'})
    response = urllib.request.urlopen(req, context=ctx)
    xml_data = response.read()
except Exception as e:
    print(f"Error fetching API: {e}")
    sys.exit(1)

try:
    root = ET.fromstring(xml_data)
except Exception as e:
    print(f"Error parsing XML: {e}")
    sys.exit(1)

returncode = root.findtext('returncode')
if returncode != 'SUCCESS':
    print(f"API returned failed: {root.findtext('message')}")
    sys.exit(1)

recordings = root.findall('.//recording')
print(f"Found {len(recordings)} total recordings in BBB.")

full_record_ids = []
for rec in recordings:
    rec_id = rec.findtext('recordID')
    if rec_id:
        full_record_ids.append(rec_id)

print(f"Extracted {len(full_record_ids)} record IDs.")

sql_statements = []

for full_id in full_record_ids:
    if "-" in full_id:
        short_id = full_id.split("-")[0]
        sql = f"""UPDATE "Sessions" SET "BbbMeetingId" = '{full_id}', "VideoUrl" = 'https://canli.mvz.muro.click/playback/presentation/2.3/{full_id}' WHERE "BbbMeetingId" = '{short_id}';"""
        sql_statements.append(sql)

with open("update_bbb_ids.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_statements))

print(f"Generated {len(sql_statements)} SQL UPDATE statements.")
print("Done!")
