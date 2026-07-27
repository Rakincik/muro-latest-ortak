import os
import json
import subprocess
import re

# Paths on Panel Server
json_path = "/opt/mng/dereceuzem_guncel_kayitlar_full.json"
if not os.path.exists(json_path):
    json_path = "/opt/mng/dereceuzem_guncel_kayitlar (2).json"

# 1. Fetch live BBB IDs from the Postgres container of the MNG tenant
print("Connecting to live Postgres container muro_mng_postgres...")
db_hashes = set()
try:
    cmd = 'docker exec -i muro_mng_postgres psql -U muro_user -d muro_demo -t -c "SELECT \\"BbbMeetingId\\" FROM \\"Sessions\\" WHERE \\"BbbMeetingId\\" IS NOT NULL;"'
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
    print("Falling back to parsing SQL file...")
    sql_path = "/opt/mng/mng_sessions_insert.sql"
    if os.path.exists(sql_path):
        hex_pattern = re.compile(r'\b[a-f0-9]{40}\b')
        with open(sql_path, 'r', encoding='utf-8') as f:
            for line in f:
                matches = hex_pattern.findall(line)
                for m in matches:
                    db_hashes.add(m)

print(f"Total unique record hashes found in database: {len(db_hashes)}")

if not db_hashes:
    print("Error: No record IDs found in database or SQL. Exiting.")
    exit(1)

# 2. Load Okinar scraped recordings
with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Collect all unique recordIDs and their servers, matching against the live database hashes
okinar_recs = {}
total_in_json = 0
for item in data:
    for r in item.get('recordings', []):
        rec_id = r.get('recordID')
        server = r.get('server', 's4')
        if rec_id:
            total_in_json += 1
            prefix = rec_id.split("-")[0] if "-" in rec_id else rec_id
            
            # Filter: only include if it actually exists in the database Sessions table
            if prefix in db_hashes:
                okinar_recs[rec_id] = server

print(f"Total unique recordings in Okinar JSON: {total_in_json}")
print(f"Filtered recordings (strictly active in database): {len(okinar_recs)}")

# 3. Fetch folder list from the BBB server via SSH
bbb_host = "canli.mng.muro.click"
print(f"Fetching existing folder list from BBB server ({bbb_host})...")

try:
    cmd = f"ssh -o StrictHostKeyChecking=no root@{bbb_host} 'find /var/bigbluebutton/published/newrecords/dereceuzem/ -maxdepth 1 -type d && find /var/bigbluebutton/published/presentation/ -maxdepth 1 -type d'"
    output = subprocess.check_output(cmd, shell=True, text=True)
    existing_folders = set()
    for line in output.splitlines():
        folder_name = os.path.basename(line.strip())
        if folder_name:
            existing_folders.add(folder_name)
except Exception as e:
    print(f"Error connecting to BBB server: {e}")
    print("Make sure SSH key auth is working from Panel to BBB server")
    exit(1)

print(f"Total existing folders on BBB server: {len(existing_folders)}")

# 4. Find missing recordings
missing_s4 = []
missing_s7 = []

for rec_id, server in okinar_recs.items():
    if rec_id not in existing_folders:
        if server == 's7':
            missing_s7.append(rec_id)
        else:
            missing_s4.append(rec_id)

print(f"Missing from s4 (Strictly Mapped): {len(missing_s4)}")
print(f"Missing from s7 (Strictly Mapped): {len(missing_s7)}")

# 5. Generate optimized parallel scripts
if missing_s4:
    # 1. Write the list of folder IDs to a txt file
    list_path = "/opt/mng/missing_s4_folders.txt"
    with open(list_path, "w", encoding="utf-8") as f:
        for rec_id in missing_s4:
            f.write(f"{rec_id}\n")
    subprocess.run(f"scp -o StrictHostKeyChecking=no {list_path} root@{bbb_host}:/tmp/", shell=True)
    
    # 2. Write the optimized shell script
    s4_script = "/opt/mng/rsync_missing_s4.sh"
    with open(s4_script, "w", encoding="utf-8") as f:
        f.write("#!/bin/bash\n")
        f.write("echo 'Starting sequential transfer from s4...'\n")
        f.write("for d in $(cat /tmp/missing_s4_folders.txt); do\n")
        f.write("    echo \"Transferring folder: $d\"\n")
        f.write("    rsync -avz -e 'ssh -o StrictHostKeyChecking=no' root@s4.okinar.com:/var/bigbluebutton/published/presentation/$d /var/bigbluebutton/published/newrecords/dereceuzem/\n")
        f.write("    echo 'Creating symlink...'\n")
        f.write("    ln -sf /var/bigbluebutton/published/newrecords/dereceuzem/$d /var/bigbluebutton/published/presentation/\n")
        f.write("done\n")
        f.write("echo 'Setting permissions...'\n")
        f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/newrecords/dereceuzem/\n")
        f.write("chmod -R 755 /var/bigbluebutton/published/newrecords/dereceuzem/\n")
        f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/presentation/\n")
        f.write("chmod -R 755 /var/bigbluebutton/published/presentation/\n")
        f.write("echo 's4 transfer and configuration completed successfully!'\n")
    subprocess.run(f"scp -o StrictHostKeyChecking=no {s4_script} root@{bbb_host}:/tmp/", shell=True)
    print("s4 parallel script uploaded to BBB server at /tmp/rsync_missing_s4.sh")

if missing_s7:
    # 1. Write the list of folder IDs to a txt file
    list_path = "/opt/mng/missing_s7_folders.txt"
    with open(list_path, "w", encoding="utf-8") as f:
        for rec_id in missing_s7:
            f.write(f"{rec_id}\n")
    subprocess.run(f"scp -o StrictHostKeyChecking=no {list_path} root@{bbb_host}:/tmp/", shell=True)
    
    # 2. Write the optimized shell script
    s7_script = "/opt/mng/rsync_missing_s7.sh"
    with open(s7_script, "w", encoding="utf-8") as f:
        f.write("#!/bin/bash\n")
        f.write("echo 'Starting sequential transfer from s7...'\n")
        f.write("for d in $(cat /tmp/missing_s7_folders.txt); do\n")
        f.write("    echo \"Transferring folder: $d\"\n")
        f.write("    rsync -avz -e 'ssh -o StrictHostKeyChecking=no' root@s7.okinar.com:/var/bigbluebutton/published/presentation/$d /var/bigbluebutton/published/newrecords/dereceuzem/\n")
        f.write("    echo 'Creating symlink...'\n")
        f.write("    ln -sf /var/bigbluebutton/published/newrecords/dereceuzem/$d /var/bigbluebutton/published/presentation/\n")
        f.write("done\n")
        f.write("echo 'Setting permissions...'\n")
        f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/newrecords/dereceuzem/\n")
        f.write("chmod -R 755 /var/bigbluebutton/published/newrecords/dereceuzem/\n")
        f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/presentation/\n")
        f.write("chmod -R 755 /var/bigbluebutton/published/presentation/\n")
        f.write("echo 's7 transfer and configuration completed successfully!'\n")
    subprocess.run(f"scp -o StrictHostKeyChecking=no {s7_script} root@{bbb_host}:/tmp/", shell=True)
    print("s7 parallel script uploaded to BBB server at /tmp/rsync_missing_s7.sh")

print("\nSUCCESS: Optimized parallel scripts generated and uploaded to BBB server.")
