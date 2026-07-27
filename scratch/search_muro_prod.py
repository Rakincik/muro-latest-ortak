import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()
cursor.execute('SELECT "Id", "Title", "TenantId" FROM "Courses" WHERE "IsDeleted" = False AND "Title" ILIKE \'%rehber%\' ORDER BY "Title"')
rows = cursor.fetchall()
print(f"Matching courses count: {len(rows)}")
for idx, r in enumerate(rows):
    print(f"  {idx+1}. ID: {r[0]} | Title: {r[1]} | TenantId: {r[2]}")

print("\nTenants count in database:")
cursor.execute('SELECT DISTINCT "TenantId" FROM "Courses" WHERE "IsDeleted" = False')
tenants = cursor.fetchall()
for t in tenants:
    cursor.execute('SELECT COUNT(*) FROM "Courses" WHERE "TenantId" = %s AND "IsDeleted" = False', (t[0],))
    cnt = cursor.fetchone()[0]
    print(f"  Tenant: {t[0]} | Course count: {cnt}")

conn.close()
