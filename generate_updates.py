import csv
import uuid

def generate_update_sql():
    sql_lines = []
    
    with open(r'C:\Users\Rüstem\Desktop\okideolar\do.csv', encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter=';')
        
        for row in reader:
            folder_id = row.get("ID")
            course_name = row.get("LMS Ders Adı")
            kurum_lms = row.get("Kurum (LMS)", "").lower()
            video_url = row.get("Link")
            
            if not folder_id or not course_name or not video_url:
                continue
            
            if "dershaneonline" not in kurum_lms:
                continue
                
            sql = f"""UPDATE "Sessions" SET "VideoUrl" = '{video_url}' WHERE "BbbMeetingId" = '{folder_id}';"""
            sql_lines.append(sql)

    with open('update_urls.sql', 'w', encoding='utf-8') as f:
        f.write("\n".join(sql_lines))
        
    print(f"Generated {len(sql_lines)} UPDATE queries into update_urls.sql")

if __name__ == "__main__":
    generate_update_sql()
