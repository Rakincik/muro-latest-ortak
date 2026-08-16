import os
import xml.etree.ElementTree as ET
import sys
import re

def search_recordings(root_dir, search_query):
    print(f"Scanning directory: {root_dir}")
    print(f"Searching for meetings containing: '{search_query}'\n")
    print(f"{'Folder / Record ID':<65} | {'Meeting Name'}")
    print("-" * 130)
    
    matches = 0
    total_scanned = 0
    folders = [item for item in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, item))]
    total_folders = len(folders)
    
    print(f"Found {total_folders} folders to scan.")
    
    # Scan directories
    for item in folders:
        total_scanned += 1
        if total_scanned % 200 == 0:
            print(f"Progress: Scanned {total_scanned}/{total_folders} folders... ({matches} matches found)", end='\r', flush=True)
            
        item_path = os.path.join(root_dir, item)
        meta_path = os.path.join(item_path, 'metadata.xml')
        if os.path.exists(meta_path):
            try:
                tree = ET.parse(meta_path)
                root = tree.getroot()
                
                meeting_name = ""
                
                # 1. Try finding in standard BBB path <meta><meetingName>
                meta_tag = root.find('meta')
                if meta_tag is not None:
                    name_tag = meta_tag.find('meetingName') or meta_tag.find('meetingId')
                    if name_tag is not None:
                        meeting_name = name_tag.text or ""
                
                # 2. Fallback to searching all tags for name/title keywords
                if not meeting_name:
                    for tag in root.iter():
                        if tag.tag in ['meetingName', 'name', 'title']:
                            meeting_name = tag.text or ""
                            break
                            
                # Match query (case-insensitive)
                if search_query.lower() in meeting_name.lower():
                    # Clear the progress line before printing match
                    print(" " * 80, end='\r')
                    print(f"{item:<65} | {meeting_name}")
                    matches += 1
                    
            except Exception:
                # Fallback to regex text search if XML parser fails
                try:
                    with open(meta_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        if search_query.lower() in content.lower():
                            match = re.search(r'<meetingName>(.*?)</meetingName>', content, re.IGNORECASE)
                            m_name = match.group(1) if match else "Unknown (Regex Match)"
                            print(" " * 80, end='\r')
                            print(f"{item:<65} | {m_name}")
                            matches += 1
                except:
                    pass
                    
    # Clear final progress line
    print(" " * 80, end='\r')
    print("-" * 130)
    print(f"Total matching recordings found: {matches}")

if __name__ == "__main__":
    query = sys.argv[1] if len(sys.argv) > 1 else "umut"
    
    # Default to current directory if not specified
    path = sys.argv[2] if len(sys.argv) > 2 else "."
    
    if not os.path.exists(path):
        print(f"Error: Path '{path}' does not exist.")
        sys.exit(1)
        
    search_recordings(path, query)
