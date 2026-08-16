import argparse
import psycopg2

def main():
    parser = argparse.ArgumentParser(description="OMURHOCA LMS - List Courses")
    parser.add_argument("--host", required=True, help="PostgreSQL host")
    parser.add_argument("--port", type=int, default=5432, help="PostgreSQL port")
    parser.add_argument("--dbname", required=True, help="PostgreSQL database name")
    parser.add_argument("--user", required=True, help="PostgreSQL username")
    parser.add_argument("--password", required=True, help="PostgreSQL password")
    args = parser.parse_args()

    conn = psycopg2.connect(
        host=args.host,
        port=args.port,
        dbname=args.dbname,
        user=args.user,
        password=args.password
    )
    cur = conn.cursor()

    cur.execute("SELECT \"Id\" FROM \"Tenants\" WHERE \"Identifier\" = 'omr'")
    tenant = cur.fetchone()
    if not tenant:
        print("Tenant 'omr' bulunamadi!")
        return
    tenant_id = tenant[0]

    cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "TenantId" = %s ORDER BY "CreatedAt" DESC', (tenant_id,))
    courses = cur.fetchall()

    with open("omr_dersler.txt", "w", encoding="utf-8") as f:
        f.write("DERS_ID | DERS_ADI\n")
        f.write("-" * 80 + "\n")
        for c in courses:
            f.write(f"{c[0]} | {c[1]}\n")

    print(f"Başarıyla {len(courses)} ders 'omr_dersler.txt' dosyasına kaydedildi!")
    conn.close()

if __name__ == '__main__':
    main()
