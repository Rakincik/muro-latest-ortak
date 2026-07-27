import re
import html

def parse_txt_file(file_path):
    recordings = {}
    pattern = re.compile(r'/var/bigbluebutton/published/presentation/([^/]+)/metadata.xml:(.*)')
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = pattern.search(line)
            if match:
                folder_id = match.group(1).strip()
                content = match.group(2).strip()
                
                if folder_id not in recordings:
                    recordings[folder_id] = {
                        'folder_id': folder_id,
                        'start_time': '',
                        'meeting_name': ''
                    }
                
                # Check for fields
                if '<start_time>' in content:
                    st_match = re.search(r'<start_time>(.*?)</start_time>', content)
                    if st_match:
                        recordings[folder_id]['start_time'] = st_match.group(1).strip()
                elif '<meetingName>' in content:
                    mn_match = re.search(r'<meetingName>(.*?)</meetingName>', content)
                    if mn_match:
                        # Unescape XML entities
                        raw_name = mn_match.group(1).strip()
                        recordings[folder_id]['meeting_name'] = html.unescape(raw_name)
                        
    return list(recordings.values())

s4_recs = parse_txt_file('mng/s4_videolar_listesi.txt')
s7_recs = parse_txt_file('mng/s7_videolar.txt')

print(f"Parsed from s4_videolar_listesi.txt: {len(s4_recs)} unique recordings.")
print(f"Parsed from s7_videolar.txt: {len(s7_recs)} unique recordings.")

if s4_recs:
    print("\ns4 Sample:")
    for r in s4_recs[:5]:
        print(f"- {r['folder_id']} | {r['meeting_name']} | {r['start_time']}")
        
if s7_recs:
    print("\ns7 Sample:")
    for r in s7_recs[:5]:
        print(f"- {r['folder_id']} | {r['meeting_name']} | {r['start_time']}")
