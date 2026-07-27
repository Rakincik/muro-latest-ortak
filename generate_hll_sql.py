import csv
import uuid

CSV_PATH = r"C:\Users\Rüstem\Desktop\okideolar\do.csv"
OUTPUT_SQL = "import_hll_videos.sql"

def main():
    sql_statements = []
    
    with open(CSV_PATH, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter=';')
        for row in reader:
            folder_id = row.get("ID")
            course_name = row.get("LMS Ders Adı")
            session_title = row.get("Oda Adı (BBB)")
            kurum_lms = row.get("Kurum (LMS)", "").lower()
            
            if not folder_id or not course_name:
                continue
                
            if "dershane" not in kurum_lms:
                continue
                
            # Kaçış karakterleri (isimlerdeki kesme işaretlerini vs halletmek için)
            safe_course_name = course_name.replace("'", "''")
            safe_session_title = session_title.replace("'", "''")
            
            video_url = f"https://canli.hll.muro.click/playback/presentation/2.3/{folder_id}"
            session_id = str(uuid.uuid4())
            
            # Eğer bu ders varsa o dersin ID'sini kullanarak Sessions tablosuna ekle.
            # Zaten ekli değilse eklemesi için BbbMeetingId kontrolü yap.
            sql = f"""
INSERT INTO "Sessions" ("Id", "CourseId", "Title", "IsDeleted", "Order", "VideoUrl", "IsFree", "Status", "RecordingEnabled", "CreatedAt", "BbbMeetingId")
SELECT 
    '{session_id}', "Id", '{safe_session_title}', false, 0, '{video_url}', false, 2, true, NOW(), '{folder_id}'
FROM "Courses"
WHERE "Title" = '{safe_course_name}'
AND NOT EXISTS (
    SELECT 1 FROM "Sessions" WHERE "BbbMeetingId" = '{folder_id}'
)
LIMIT 1;
"""
            sql_statements.append(sql)
            
    with open(OUTPUT_SQL, 'w', encoding='utf-8') as out:
        out.write("BEGIN;\n")
        out.write("\n".join(sql_statements))
        out.write("\nCOMMIT;\n")
        
    print(f"{len(sql_statements)} adet SQL insert komutu '{OUTPUT_SQL}' dosyasına yazıldı.")

if __name__ == "__main__":
    main()
