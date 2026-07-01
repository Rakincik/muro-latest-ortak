import psycopg2
import json

conn = psycopg2.connect(
    host='localhost', port=5432, 
    dbname='muro_dev', user='muro_user', password='muro_pass_2024'
)
cur = conn.cursor()

# Mevcut tenant'lari gor
cur.execute('SELECT "Id", "Name", "Features" FROM "Tenants" LIMIT 10')
rows = cur.fetchall()
for row in rows:
    print(f"ID: {row[0]}, Name: {row[1]}, Features: {row[2]}")

# Tum tenant'lara podcast feature ekle
for row in rows:
    tid, name, features_str = row
    features = json.loads(features_str) if features_str else {}
    if "podcast" not in features or not features["podcast"]:
        features["podcast"] = True
        cur.execute(
            'UPDATE "Tenants" SET "Features" = %s WHERE "Id" = %s',
            (json.dumps(features), tid)
        )
        print(f"  -> {name}: podcast=true eklendi")

conn.commit()
cur.close()
conn.close()
print("Bitti!")
