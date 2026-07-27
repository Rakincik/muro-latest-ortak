import os
import json
import subprocess
import re
import argparse

def main():
    parser = argparse.ArgumentParser(description="MURO ENS - Find Missing BBB Recordings & Generate Rsync Scripts")
    parser.add_argument("--json", default="/opt/demo/Ens/turkceoabtdeyiz.okinar.com_recordings eness.json", help="Path to scraped recordings JSON file")
    parser.add_argument("--bbb-host", default="canli.ens.muro.click", help="Hostname of the new ENS BBB server")
    args = parser.parse_args()

    json_path = args.json
    bbb_host = args.bbb_host

    print(f"============================================================")
    print(f"      MURO ENS - BBB RECORDINGS COMPARISON & SYNC TOOL")
    print(f"============================================================")

    # 1. Fetch live BBB IDs from the Postgres container of the ENS tenant
    print("Connecting to live Postgres container muro_ens_postgres...")
    db_hashes = set()
    try:
        cmd = 'docker exec -i muro_ens_postgres psql -U $POSTGRES_USER -d $POSTGRES_DB -t -c "SELECT \\"BbbMeetingId\\" FROM \\"Sessions\\" WHERE \\"BbbMeetingId\\" IS NOT NULL;"'
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
        print("Please check if muro_ens_postgres container is running and healthy.")
        exit(1)

    print(f"Total unique record hashes found in database: {len(db_hashes)}")

    if not db_hashes:
        print("Error: No record IDs found in database. Make sure you have imported the ENS data first.")
        exit(1)

    # 2. Load Okinar scraped recordings
    if not os.path.exists(json_path):
        # Fallback to local name or check in directory
        alt_paths = [
            "turkceoabtdeyiz.okinar.com_recordings eness.json",
            "turkceoabtdeyiz.okinar.com_recordings.json"
        ]
        for p in alt_paths:
            if os.path.exists(p):
                json_path = p
                break

    print(f"Reading scraped recordings from '{json_path}'...")
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Collect all unique recordIDs and their servers, matching against the live database hashes
    okinar_recs = {}
    total_in_json = 0
    
    flat_recordings = []
    for item in data:
        if isinstance(item, dict) and 'recordings' in item:
            for rec in item.get('recordings', []):
                flat_recordings.append(rec)
        else:
            flat_recordings.append(item)

    for r in flat_recordings:
        rec_id = r.get('recordID')
        server = r.get('server', 's4')
        if rec_id:
            total_in_json += 1
            # BigBlueButton recordID prefix is the first hex section before the dash
            prefix = rec_id.split("-")[0] if "-" in rec_id else rec_id
            
            # Filter: only include if it actually exists in the database Sessions table
            if prefix in db_hashes:
                okinar_recs[rec_id] = server

    print(f"Total unique recordings in Okinar JSON: {total_in_json}")
    print(f"Filtered recordings (strictly active in database): {len(okinar_recs)}")

    # 3. Fetch folder list from the BBB server via SSH
    print(f"Fetching existing folder list from BBB server ({bbb_host})...")
    existing_folders = set()
    try:
        # Create output folder on BBB server first if it doesn't exist
        setup_cmd = f"ssh -o StrictHostKeyChecking=no root@{bbb_host} 'mkdir -p /var/bigbluebutton/published/newrecords/ens/'"
        subprocess.run(setup_cmd, shell=True)

        cmd = f"ssh -o StrictHostKeyChecking=no root@{bbb_host} 'find /var/bigbluebutton/published/newrecords/ens/ -maxdepth 1 -type d && find /var/bigbluebutton/published/presentation/ -maxdepth 1 -type d'"
        output = subprocess.check_output(cmd, shell=True, text=True)
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
    base_dir = os.path.dirname(json_path) or "."
    
    if missing_s4:
        # 1. Write the list of folder IDs to a txt file
        list_path = os.path.join(base_dir, "missing_s4_folders.txt")
        with open(list_path, "w", encoding="utf-8") as f:
            for rec_id in missing_s4:
                f.write(f"{rec_id}\n")
        print(f"Uploading missing s4 folder list to BBB server...")
        subprocess.run(f"scp -o StrictHostKeyChecking=no \"{list_path}\" root@{bbb_host}:/tmp/", shell=True)
        
        # 2. Write the optimized shell script
        s4_script = os.path.join(base_dir, "rsync_missing_s4.sh")
        with open(s4_script, "w", encoding="utf-8") as f:
            f.write("#!/bin/bash\n")
            f.write("echo 'Starting optimized parallel s4 transfer (10 workers)...'\n")
            f.write("cat /tmp/missing_s4_folders.txt | xargs -I {} -P 10 rsync -avz --quiet -e 'ssh -o StrictHostKeyChecking=no' root@s4.okinar.com:/var/bigbluebutton/published/presentation/{} /var/bigbluebutton/published/newrecords/ens/\n")
            f.write("echo 'Creating symlinks for all downloaded folders...'\n")
            f.write("for d in $(cat /tmp/missing_s4_folders.txt); do\n")
            f.write("    ln -sf /var/bigbluebutton/published/newrecords/ens/$d /var/bigbluebutton/published/presentation/\n")
            f.write("done\n")
            f.write("echo 'Setting permissions...'\n")
            f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/newrecords/ens/\n")
            f.write("chmod -R 755 /var/bigbluebutton/published/newrecords/ens/\n")
            f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/presentation/\n")
            f.write("chmod -R 755 /var/bigbluebutton/published/presentation/\n")
            f.write("echo 's4 transfer and configuration completed successfully!'\n")
            
        print(f"Uploading rsync_missing_s4.sh to BBB server...")
        subprocess.run(f"scp -o StrictHostKeyChecking=no \"{s4_script}\" root@{bbb_host}:/tmp/", shell=True)
        print("s4 parallel script uploaded to BBB server at /tmp/rsync_missing_s4.sh")

    if missing_s7:
        # 1. Write the list of folder IDs to a txt file
        list_path = os.path.join(base_dir, "missing_s7_folders.txt")
        with open(list_path, "w", encoding="utf-8") as f:
            for rec_id in missing_s7:
                f.write(f"{rec_id}\n")
        print(f"Uploading missing s7 folder list to BBB server...")
        subprocess.run(f"scp -o StrictHostKeyChecking=no \"{list_path}\" root@{bbb_host}:/tmp/", shell=True)
        
        # 2. Write the optimized shell script
        s7_script = os.path.join(base_dir, "rsync_missing_s7.sh")
        with open(s7_script, "w", encoding="utf-8") as f:
            f.write("#!/bin/bash\n")
            f.write("echo 'Starting optimized parallel s7 transfer (10 workers)...'\n")
            f.write("cat /tmp/missing_s7_folders.txt | xargs -I {} -P 10 rsync -avz --quiet -e 'ssh -o StrictHostKeyChecking=no' root@s7.okinar.com:/var/bigbluebutton/published/presentation/{} /var/bigbluebutton/published/newrecords/ens/\n")
            f.write("echo 'Creating symlinks for all downloaded folders...'\n")
            f.write("for d in $(cat /tmp/missing_s7_folders.txt); do\n")
            f.write("    ln -sf /var/bigbluebutton/published/newrecords/ens/$d /var/bigbluebutton/published/presentation/\n")
            f.write("done\n")
            f.write("echo 'Setting permissions...'\n")
            f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/newrecords/ens/\n")
            f.write("chmod -R 755 /var/bigbluebutton/published/newrecords/ens/\n")
            f.write("chown -R bigbluebutton:bigbluebutton /var/bigbluebutton/published/presentation/\n")
            f.write("chmod -R 755 /var/bigbluebutton/published/presentation/\n")
            f.write("echo 's7 transfer and configuration completed successfully!'\n")
            
        print(f"Uploading rsync_missing_s7.sh to BBB server...")
        subprocess.run(f"scp -o StrictHostKeyChecking=no \"{s7_script}\" root@{bbb_host}:/tmp/", shell=True)
        print("s7 parallel script uploaded to BBB server at /tmp/rsync_missing_s7.sh")

    print("\nSUCCESS: Optimized parallel scripts generated and uploaded to BBB server.")
    print("Next steps:")
    print(f"1. SSH into the BBB server: ssh root@{bbb_host}")
    if missing_s4:
        print("2. Run the s4 sync script: bash /tmp/rsync_missing_s4.sh")
    if missing_s7:
        print("3. Run the s7 sync script: bash /tmp/rsync_missing_s7.sh")

if __name__ == "__main__":
    main()
