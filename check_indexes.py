import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()

# Get indexes for key analytics tables
tables = ["Users", "VideoProgresses", "SessionAttendances", "CourseEnrollments", "GroupMembers", "ExamResults", "AssignmentSubmissions", "MediaAssets", "Sessions", "CourseMedias"]

print("--- DATABASE INDEX STATUS REPORT ---\n")

for table in tables:
    cursor.execute(f"""
        SELECT indexname, indexdef
        FROM pg_indexes
        WHERE tablename = '{table}'
    """)
    indexes = cursor.fetchall()
    print(f"Table: [{table}]")
    if not indexes:
        print("  (No indexes found!)")
    for idx in indexes:
        print(f"  - Index Name: {idx[0]}")
        print(f"    Definition: {idx[1]}")
    print()

# Query index usage statistics to check if any indexes are heavily used or scan counts
print("\n--- INDEX USAGE / STATS ---")
cursor.execute("""
    SELECT 
        schemaname,
        relname AS table_name,
        indexrelname AS index_name,
        idx_scan AS number_of_scans,
        idx_tup_read AS tuples_read,
        idx_tup_fetch AS tuples_fetched
    FROM pg_stat_user_indexes
    WHERE relname IN ('Users', 'VideoProgresses', 'SessionAttendances', 'CourseEnrollments', 'GroupMembers', 'ExamResults', 'AssignmentSubmissions', 'MediaAssets', 'Sessions', 'CourseMedias')
    ORDER BY idx_scan DESC;
""")
stats = cursor.fetchall()
for s in stats:
    print(f"Table: {s[1]} | Index: {s[2]} | Scans: {s[3]} | Fetched: {s[5]}")

conn.close()
