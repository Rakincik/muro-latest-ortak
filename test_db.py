import psycopg2

try:
    conn = psycopg2.connect("host=localhost port=5432 dbname=muro_dev user=muro_user password=muro_pass_2024")
    cur = conn.cursor()
    cur.execute("""
        SELECT u."FirstName", u."LastName", u."Email", d."CreatedAt"
        FROM "DeviceSessions" d
        JOIN "Users" u ON d."UserId" = u."Id"
        WHERE d."IpAddress" = '31.223.28.178';
    """)
    rows = cur.fetchall()
    print("Results:", rows)
except Exception as e:
    print(e)
