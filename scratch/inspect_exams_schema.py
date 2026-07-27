import psycopg2
import json

def main():
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_mng_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Get Exams columns
    cur.execute('''
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'Exams';
    ''')
    print("--- Exams Table Columns ---")
    for r in cur.fetchall():
        print(f" - {r[0]}: {r[1]}")

    # Select existing exams to see their values
    cur.execute('SELECT "Id", "Title", "ExamType", "QuestionCount", "PdfUrl", "AnswerKeyJson", "Status" FROM "Exams" LIMIT 5;')
    rows = cur.fetchall()
    print("\n--- Sample Exams ---")
    for r in rows:
        print(f" ID: {r[0]} | Title: {r[1]} | Type: {r[2]} | Count: {r[3]} | Pdf: {r[4]} | AnswerKey: {r[5][:100] if r[5] else None} | Status: {r[6]}")

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
