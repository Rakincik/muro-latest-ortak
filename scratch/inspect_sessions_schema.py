import pg8000

conn = pg8000.connect(
    host="31.214.152.143",
    port=5434,
    database="muro_prod",
    user="muro_user",
    password="MuroDb2026!Pr0d"
)

cursor = conn.cursor()
cursor.execute('SELECT * FROM "Sessions" LIMIT 1')
col_names = [desc[0] for desc in cursor.description]
print("Sessions table columns:", col_names)
conn.close()
