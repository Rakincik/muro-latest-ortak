import urllib.request
import urllib.parse
import hashlib
import xml.etree.ElementTree as ET
import sys
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

BBB_URL = "https://canli.mvz.muro.click/bigbluebutton/api"
BBB_SECRET = "eouZjmhrLwfGrB6MucK5b4TT2gdqD7RWnQoeBzCAyU"

api_call = "getRecordings"
query_string = "state=any"
checksum_str = api_call + query_string + BBB_SECRET
checksum = hashlib.sha1(checksum_str.encode('utf-8')).hexdigest()

request_url = f"{BBB_URL}/{api_call}?{query_string}&checksum={checksum}"

try:
    req = urllib.request.Request(request_url, headers={'User-Agent': 'Mozilla/5.0'})
    response = urllib.request.urlopen(req, context=ctx)
    xml_data = response.read()
except Exception as e:
    print(f"Error fetching API: {e}")
    sys.exit(1)

root = ET.fromstring(xml_data)
recordings = root.findall('.//recording')
print(f"Found {len(recordings)} total recordings in BBB with state=any.")

full_record_ids = []
for rec in recordings:
    rec_id = rec.findtext('recordID')
    if rec_id:
        full_record_ids.append(rec_id)

with open("muro_sessions_update.sql", "r", encoding="utf-8") as f:
    data = f.read()

import re
db_ids = set(re.findall(r'\'([a-z0-9]{40})\'', data))

common = []
for fid in full_record_ids:
    short_id = fid.split("-")[0]
    if short_id in db_ids:
        common.append(fid)

print(f"Found {len(common)} common IDs with state=any!")
