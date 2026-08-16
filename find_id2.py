# -*- coding: utf-8 -*-
import psycopg2
try:
    conn = psycopg2.connect("host=31.214.152.143 port=5434 dbname=muro_prod user=muro_user password=MuroDb2026!Pr0d")
    cur = conn.cursor()
    cur.execute('SELECT "Id", "Title" FROM "Courses" WHERE "Title" ILIKE \'%HUKUK%\';')
    rows = cur.fetchall()
    for row in rows:
        print(f"ID: {row[0]} | Title: {row[1]}")
    cur.close()
    conn.close()
except Exception as e:
    print(e)
