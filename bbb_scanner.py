import os
import xml.etree.ElementTree as ET
import json
import re
import gzip

PRES_DIR = "/var/bigbluebutton/published/presentation"

def parse_nginx_logs():
    print("Parsing Nginx logs for referers...")
    folder_to_referer = {}
    
    log_files = ["/var/log/nginx/bigbluebutton.access.log", "/var/log/nginx/bigbluebutton.access.log.1"]
    for i in range(2, 15):
        path = f"/var/log/nginx/bigbluebutton.access.log.{i}.gz"
        if os.path.exists(path):
            log_files.append(path)
            
    for log_path in log_files:
        if not os.path.exists(log_path):
            continue
        try:
            if log_path.endswith(".gz"):
                f = gzip.open(log_path, "rt", encoding="utf-8", errors="ignore")
            else:
                f = open(log_path, "r", encoding="utf-8", errors="ignore")
                
            for line in f:
                # Find presentation playback request
                match = re.search(r'GET /playback/presentation/2.3/([0-9a-f\-]+)', line)
                if match:
                    folder = match.group(1)
                    # Find referer domain in the log line
                    # Nginx log format usually: IP - - [date] "GET ..." status bytes "REFERER" "USER_AGENT"
                    # We can find the referer domain using regex
                    ref_matches = re.findall(r'https?://([a-zA-Z0-9\-\.]+)', line)
                    for domain in ref_matches:
                        if "okinar.com" in domain and not domain.startswith("api-"):
                            folder_to_referer[folder] = domain
            f.close()
        except Exception as e:
            print(f"Error reading log {log_path}: {e}")
            
    print(f"Found referers for {len(folder_to_referer)} folders from Nginx logs.")
    return folder_to_referer

def scan_bbb_recordings():
    print("BBB recordings scanning started...")
    
    if not os.path.exists(PRES_DIR):
        print(f"Error: {PRES_DIR} path not found!")
        return
        
    folders = [f for f in os.listdir(PRES_DIR) if os.path.isdir(os.path.join(PRES_DIR, f))]
    print(f"Found {len(folders)} folders to scan.")
    
    # Parse Nginx logs first
    referer_map = parse_nginx_logs()
    
    results = {}
    
    for idx, folder in enumerate(folders, 1):
        xml_path = os.path.join(PRES_DIR, folder, "metadata.xml")
        
        meeting_name = "Bilinmeyen Toplanti"
        duration = 0
        start_time = 0
        meeting_id = ""
        
        if os.path.exists(xml_path):
            try:
                tree = ET.parse(xml_path)
                root = tree.getroot()
                
                meta = root.find("meta")
                if meta is not None:
                    m_name_el = meta.find("meetingName")
                    if m_name_el is not None and m_name_el.text:
                        meeting_name = m_name_el.text
                    
                    m_id_el = meta.find("meetingId")
                    if m_id_el is not None and m_id_el.text:
                        meeting_id = m_id_el.text
                
                st_el = root.find("start_time")
                if st_el is not None and st_el.text:
                    start_time = int(st_el.text)
                else:
                    # Try meta -> startTime
                    if meta is not None:
                        st_meta = meta.find("startTime")
                        if st_meta is not None and st_meta.text:
                            start_time = int(st_meta.text)
                    
                playback = root.find("playback")
                if playback is not None:
                    format_el = playback.find("format")
                    if format_el is not None:
                        len_el = format_el.find("length")
                        if len_el is not None and len_el.text:
                            duration = int(len_el.text)
                            
            except Exception as e:
                pass
                
        slide_text_path = os.path.join(PRES_DIR, folder, "presentation_text.json")
        keywords = ""
        if os.path.exists(slide_text_path):
            try:
                with open(slide_text_path, "r", encoding="utf-8") as f:
                    text_data = json.load(f)
                slide_strings = []
                for slide in list(text_data.values())[:5]:
                    if isinstance(slide, str):
                        slide_strings.append(slide)
                    elif isinstance(slide, dict) and "text" in slide:
                        slide_strings.append(slide["text"])
                keywords = " ".join(slide_strings)[:1000]
            except:
                pass
                
        # Get referer if found in logs
        referer_domain = referer_map.get(folder, "")
        
        results[folder] = {
            "meetingName": meeting_name,
            "meetingId": meeting_id,
            "startTime": start_time,
            "duration": duration,
            "slideKeywords": keywords,
            "refererDomain": referer_domain
        }
        
        if idx % 200 == 0:
            print(f"Scanned {idx}/{len(folders)} folders...")
            
    output_path = "/root/bbb_metadata.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
        
    print(f"Scan complete! Data saved to {output_path}")

if __name__ == "__main__":
    scan_bbb_recordings()
