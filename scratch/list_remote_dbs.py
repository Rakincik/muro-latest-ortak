import pg8000

try:
    conn = pg8000.connect(
        host="31.214.152.143",
        port=5434,
        database="muro_prod",
        user="muro_user",
        password="MuroDb2026!Pr0d"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT datname FROM pg_database WHERE datistemplate = false;")
    rows = cursor.fetchall()
    print("Databases on 31.214.152.143:5434:")
    for r in rows:
        print(f"  - {r[0]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Error: {e}")
