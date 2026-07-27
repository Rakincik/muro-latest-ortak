import os
import json
import subprocess
import re
import datetime

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

# Paths on Panel Server for MVZ
json_path = "/opt/mvz/mevzuatadam.okinar.com_recordings.json"
if not os.path.exists(json_path):
    json_path = "/opt/mvz/mevzuatadam.okinar.com_recordings (1).json"
if not os.path.exists(json_path):
    json_path = "mevzuatadam.okinar.com_recordings.json"
if not os.path.exists(json_path):
    json_path = "mevzuatadam.okinar.com_recordings (1).json"

# 1. Fetch live BBB IDs from the Postgres container of the MVZ tenant
print("Connecting to live Postgres container muro_mvz_postgres...")
db_hashes = set()
try:
    cmd = 'docker exec -i muro_mvz_postgres psql -U muro_user -d muro_demo -t -c "SELECT \\"BbbMeetingId\\" FROM \\"Sessions\\" WHERE \\"BbbMeetingId\\" IS NOT NULL;"'
    output = subprocess.check_output(cmd, shell=True, text=True)
    
    hex_pattern = re.compile(r'[a-f0-9]{40}')
    for line in output.splitlines():
        line = line.strip()
        if line:
            match = hex_pattern.search(line.lower())
            if match:
                db_hashes.add(match.group(0))
except Exception as e:
    print(f"Error querying Postgres container: {e}")
    print("Ensure muro_mvz_postgres container is running.")
    exit(1)

print(f"Total unique record hashes found in database: {len(db_hashes)}")

if not db_hashes:
    print("Error: No record IDs found in database. Exiting.")
    exit(1)

# 2. Load Mevzuat Adam recordings JSON (nested structure)
with open(json_path, 'r', encoding='utf-8') as f:
    scraped_courses = json.load(f)

# Collect all unique recordIDs and map all to s7.okinar.com
okinar_recs = {}
total_in_json = 0

for course_group in scraped_courses:
    recordings_list = course_group.get('recordings', [])
    for rec in recordings_list:
        rec_id = rec.get('recordID')
        if rec_id:
            total_in_json += 1
            prefix = rec_id.split("-")[0] if "-" in rec_id else rec_id
            
            # Filter: only include if active in database
            if prefix in db_hashes:
                # Force s7 since all MVZ recordings are stored on s7.okinar.com
                okinar_recs[rec_id] = 's7'

print(f"Total unique recordings in JSON: {total_in_json}")
print(f"Filtered recordings (strictly active in database): {len(okinar_recs)}")

# 3. Fetch folder list from the BBB server via SSH
bbb_host = "canli.mvz.muro.click"
print(f"Fetching existing folder list from BBB server ({bbb_host})...")

try:
    cmd = f"ssh -o StrictHostKeyChecking=no root@{bbb_host} 'find /var/bigbluebutton/published/newrecords/mevzuatadam/ -maxdepth 1 -type d 2>/dev/null || true; find /var/bigbluebutton/published/presentation/ -maxdepth 1 -type d'"
    output = subprocess.check_output(cmd, shell=True, text=True)
    existing_folders = set()
    for line in output.splitlines():
        folder_name = os.path.basename(line.strip())
        if folder_name:
            existing_folders.add(folder_name)
except Exception as e:
    print(f"Error connecting to BBB server: {e}")
    print("Ensure SSH key authentication is set up correctly.")
    exit(1)

print(f"Total existing folders on BBB server: {len(existing_folders)}")

# 4. Find missing recordings (all mapped to s7)
missing_recs = []
for rec_id in okinar_recs.keys():
    if rec_id not in existing_folders:
        missing_recs.append(rec_id)

print(f"Total missing recordings (routing to S7): {len(missing_recs)}")

# 5. Generate single optimized sequential script for s7
if missing_recs:
    list_path = "/opt/mvz/missing_s7_folders.txt"
    with open(list_path, "w", encoding="utf-8") as f:
        for rec_id in missing_recs:
            f.write(f"{rec_id}\n")
    subprocess.run(f"scp -o StrictHostKeyChecking=no {list_path} root@{bbb_host}:/tmp/", shell=True)
    
    script_path = "/opt/mvz/rsync_missing_s7.sh"
    with open(script_path, "w", encoding="utf-8") as f:
        f.write("#!/bin/bash\n")
        f.write("echo 'Starting sequential transfer from s7.okinar.com...'\n")
        f.write("mkdir -p /var/bigbluebutton/published/newrecords/mevzuatadam/\n")
        f.write("for d in $(cat /tmp/missing_s7_folders.txt); do\n")
        f.write("    echo \"Transferring folder: $d\"\n")
        f.write("    rsync -avz -e 'ssh -o StrictHostKeyChecking=no' root@s7.okinar.com:/var/bigbluebutton/published/presentation/$d /var/bigbluebutton/published/newrecords/mevzuatadam/\n")
        f.write("    echo 'Creating symlink...'\n")
        f.write("    ln -sf /var/bigbluebutton/published/newrecords/mevzuatadam/$d /var/bigbluebutton/published/presentation/\n")
        f.write("done\n")
        f.write("echo 'Setting permissions...'\n")
        f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/newrecords/mevzuatadam/\n")
        f.write("chmod -R 755 /var/bigbluebutton/published/newrecords/mevzuatadam/\n")
        f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/presentation/\n")
        f.write("chmod -R 755 /var/bigbluebutton/published/presentation/\n")
        f.write("echo 's7 transfer and configuration completed successfully!'\n")
        
    subprocess.run(f"scp -o StrictHostKeyChecking=no {script_path} root@{bbb_host}:/tmp/", shell=True)
    print("s7 sequential script uploaded to BBB server at /tmp/rsync_missing_s7.sh")

print("\nSUCCESS: Optimized transfer script generated and uploaded to MVZ BBB server.")
