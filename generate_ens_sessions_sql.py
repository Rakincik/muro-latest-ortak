import json
import datetime

def main():
    json_path = 'okinar dersler/turkceoabtdeyiz.okinar.com_recordings.json'
    sql_path = 'import_ens_sessions.sql'

    print(f"[*] Reading Okinar recordings from '{json_path}'...")
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            recs = json.load(f)
    except Exception as e:
        print(f"[!] Error reading JSON: {e}")
        return

    print(f"    - Loaded {len(recs)} recordings from JSON.")

    sql_lines = [
        "-- ==================================================",
        "-- MURO LMS - ENS (turkceoabtdeyiz.okinar.com) Sessions Import",
        f"-- Generated on {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        "-- ==================================================",
        "BEGIN;",
        ""
    ]

    session_count = 0
    for item in recs:
        record_id = item.get('recordID')
        record_id = str(record_id).strip() if isinstance(record_id, (str, int)) else ""
        
        class_name = item.get('className')
        class_name = str(class_name).strip() if isinstance(class_name, (str, int)) else ""
        
        recording_name = item.get('recordingName')
        recording_name = str(recording_name).strip() if isinstance(recording_name, (str, int)) else ""
        
        start_time_str = item.get('startTime')
        start_time_str = str(start_time_str).strip() if isinstance(start_time_str, (str, int)) else ""
        
        duration_str = item.get('duration')
        duration_str = str(duration_str).strip() if isinstance(duration_str, (str, int)) else ""
        
        if not record_id or not class_name:
            continue
            
        safe_class_name = class_name.replace("'", "''")
        
        if recording_name:
            title = recording_name
        else:
            title = f"{class_name} - {start_time_str}"
        safe_title = title.replace("'", "''")
        
        # Parse dates
        dt = None
        if start_time_str:
            for fmt in ("%d.%m.%Y %H:%M:%S", "%d.%m.%Y %H:%M"):
                try:
                    dt = datetime.datetime.strptime(start_time_str, fmt)
                    break
                except ValueError:
                    pass
                    
        if dt:
            created_at_str = dt.strftime("%Y-%m-%d %H:%M:%S")
            scheduled_start_str = created_at_str
            
            try:
                dur_mins = int(duration_str) if duration_str else 60
            except ValueError:
                dur_mins = 60
                
            end_dt = dt + datetime.timedelta(minutes=dur_mins)
            scheduled_end_str = end_dt.strftime("%Y-%m-%d %H:%M:%S")
        else:
            created_at_str = "NOW()"
            scheduled_start_str = "NULL"
            scheduled_end_str = "NULL"
            dur_mins = 60
            
        video_url = f"https://canli.ens.muro.click/playback/presentation/2.3/playback.html?meetingId={record_id}"
        
        sql = f"""
DO $$ 
DECLARE
    cid uuid;
BEGIN
    SELECT "Id" INTO cid FROM "Courses" 
    WHERE "Title" = '{safe_class_name}' AND "IsDeleted" = false 
    LIMIT 1;
    
    IF cid IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM "Sessions" WHERE "CourseId" = cid AND "BbbMeetingId" = '{record_id}') THEN
            INSERT INTO "Sessions" ("Id", "CourseId", "Title", "VideoUrl", "BbbMeetingId", "IsDeleted", "CreatedAt", "Status", "Order", "RecordingEnabled", "IsFree", "ScheduledStart", "ScheduledEnd", "DurationMinutes")
            VALUES (gen_random_uuid(), cid, '{safe_title}', '{video_url}', '{record_id}', false, {'NOW()' if not dt else f"'{created_at_str}'"}, 3, 0, true, false, {'NULL' if not dt else f"'{scheduled_start_str}'"}, {'NULL' if not dt else f"'{scheduled_end_str}'"}, {dur_mins});
        END IF;
    END IF;
END $$;
"""
        sql_lines.append(sql.strip())
        session_count += 1

    sql_lines.append("\nCOMMIT;")

    with open(sql_path, 'w', encoding='utf-8') as f:
        f.write("\n\n".join(sql_lines))

    print(f"[+] Successfully generated {sql_path} with {session_count} sessions.")

if __name__ == "__main__":
    main()
