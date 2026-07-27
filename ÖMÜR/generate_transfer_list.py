import openpyxl
import json
import os
import re

excel_path = r"c:\Users\Rüstem\.gemini\antigravity\scratch\muro-demo\ÖMÜR\Taşınacak Ders Listesi Ömür.xlsx"
json_path = r"c:\Users\Rüstem\.gemini\antigravity\scratch\muro-demo\okinar dersler\omurhoca.okinar.com_recordings.json"
output_txt_path = r"c:\Users\Rüstem\.gemini\antigravity\scratch\muro-demo\ÖMÜR\transfer_folders.txt"

def normalize_text(text):
    if not text:
        return ""
    text = str(text).lower().strip()
    text = text.replace('ı', 'i').replace('ğ', 'g').replace('ü', 'u').replace('ş', 's').replace('ö', 'o').replace('ç', 'c')
    text = re.sub(r'[^a-z0-9]', '', text)
    return text

def main():
    print("[*] Loading Excel courses...")
    wb = openpyxl.load_workbook(excel_path)
    sheet = wb.active
    rows = list(sheet.iter_rows(values_only=True))

    excel_courses = []
    for r in rows:
        if any(cell is not None for cell in r):
            dt, name, hsh = r[0], r[1], r[2]
            if name and hsh:
                excel_courses.append({
                    'name': name.strip(),
                    'norm_name': normalize_text(name)
                })

    print(f"[+] Loaded {len(excel_courses)} courses from Excel.")

    print("[*] Loading Recordings JSON...")
    with open(json_path, 'r', encoding='utf-8') as f:
        recordings = json.load(f)
    print(f"[+] Loaded {len(recordings)} recordings.")

    # Group recordings by normalized className
    recording_by_class = {}
    for rec in recordings:
        c_name = rec.get('className', '')
        norm_c_name = normalize_text(c_name)
        if norm_c_name not in recording_by_class:
            recording_by_class[norm_c_name] = []
        recording_by_class[norm_c_name].append(rec)

    # Collect matched record IDs
    matched_record_ids = []
    matched_courses_count = 0

    for course in excel_courses:
        norm = course['norm_name']
        matched_recs = recording_by_class.get(norm, [])
        if matched_recs:
            matched_courses_count += 1
            for rec in matched_recs:
                rec_id = rec.get('recordID')
                if rec_id:
                    matched_record_ids.append(rec_id.strip())

    print(f"\nMatching Summary:")
    print(f"  - Matched Courses: {matched_courses_count} / {len(excel_courses)}")
    print(f"  - Total Recording Folders to Transfer: {len(matched_record_ids)}")

    # Write to output file
    # We will sort the IDs for cleaner output
    matched_record_ids.sort()
    with open(output_txt_path, 'w', encoding='utf-8') as f:
        for r_id in matched_record_ids:
            f.write(r_id + '\n')

    print(f"[+] Saved folders list to: {output_txt_path}")
    print("\nYou can run the following rsync command on the old BBB server to copy the folders:")
    print(f"rsync -avz --progress --files-from={os.path.basename(output_txt_path)} /var/bigbluebutton/published/presentation/ root@<TARGET_SERVER_IP>:/var/bigbluebutton/published/presentation/")

if __name__ == "__main__":
    main()
