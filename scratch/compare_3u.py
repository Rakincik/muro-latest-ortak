import psycopg2
import subprocess

COURSE_ID = "31cb881c-fbdc-4b34-b38b-4877c5a09ede"

FILEZILLA_FOLDERS = [
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785168140106",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785174002658",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785254930082",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785171458920",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785176499428",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785002216250",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784397591631",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784563463200",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784390246125",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784567674531",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784657412835",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784909309978",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784484773715",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784480852117",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784740458707",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784649932221",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784912531156",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785085107408",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784571164369",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785088352642",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784476960685",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784827140598",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784744257532",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784995380549",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784394401966",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1785081870424",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784822688077",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784998604262",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784915737160",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784830567142",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784654284049",
    "bae785c169b3f9a3d1313199347f2aaf92cba61c-1784735965292"
]

db_host = "127.0.0.1"
try:
    res = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
    ip = res.decode('utf-8').strip()
    if ip:
        db_host = ip
except Exception:
    pass

conn = psycopg2.connect(host=db_host, port=5432, dbname="muro_demo", user="muro_user", password="MuroDem0_2026!Str0ng")
cur = conn.cursor()

# Get all BbbMeetingId values in Sessions
cur.execute('SELECT "BbbMeetingId" FROM "Sessions" WHERE "CourseId" = %s AND "BbbMeetingId" IS NOT NULL', (COURSE_ID,))
db_ids = set(r[0].strip() for r in cur.fetchall())

print("Comparing lists...")
not_in_db = [f for f in FILEZILLA_FOLDERS if f not in db_ids]

if not_in_db:
    print(f"FOUND {len(not_in_db)} folder(s) in FileZilla that are NOT in the database:")
    for f in not_in_db:
        print(f"  ➜ {f}")
else:
    print("All folders in FileZilla are already present in the database.")

conn.close()
