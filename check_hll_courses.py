import psycopg2

DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "muro_dev"
DB_USER = "muro_user"
DB_PASS = "muro_pass_2024"

def main():
    try:
        conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASS)
        cursor = conn.cursor()
        
        cursor.execute('SELECT "Id", "Title" FROM "Courses";')
        courses = cursor.fetchall()
        for c in courses:
            print(f"ID: {c[0]}, Title: '{c[1]}'")
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
