import os
import sys
import psycopg2

class Colors:
    GREEN = '\033[92m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

def load_env():
    config = {}
    env_paths = [
        ".env.omr", "../.env.omr", "../../.env.omr",
        ".env", "../.env", "../../.env",
        "/opt/omr/.env.omr", "/opt/omr/.env"
    ]
    for ep in env_paths:
        if os.path.exists(ep):
            try:
                with open(ep, "r", encoding="utf-8") as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith("#") and "=" in line:
                            k, v = line.split("=", 1)
                            config[k.strip()] = v.strip()
                break
            except Exception:
                pass
    return config

def main():
    env_config = load_env()
    db_host = env_config.get("DB_HOST", "localhost")
    db_port = int(env_config.get("DB_PORT", 5432))
    db_name = env_config.get("DB_NAME", "muro_demo")
    db_user = env_config.get("DB_USER", "muro_user")
    db_pass = env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Resolve local docker IP if running on server
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_omr_postgres'], stderr=subprocess.DEVNULL)
        ip = result.decode('utf-8').strip()
        if ip:
            db_host = ip
    except Exception:
        pass

    print("[*] Connecting to database to correct video URLs...")
    try:
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
        cur = conn.cursor()
    except Exception as e:
        print(f"{Colors.FAIL}[X] Connection failed: {e}{Colors.ENDC}")
        sys.exit(1)

    try:
        # Update incorrect URLs
        cur.execute("""
            UPDATE "Sessions"
            SET "VideoUrl" = REPLACE("VideoUrl", 'canli.omr.muro.click', 'canli.omurhoca.muro.click')
            WHERE "VideoUrl" LIKE '%canli.omr.muro.click%';
        """)
        updated_rows = cur.rowcount
        conn.commit()
        print(f"{Colors.GREEN}[+] SUCCESS: Corrected {updated_rows} video URLs in the database!{Colors.ENDC}")
    except Exception as e:
        conn.rollback()
        print(f"{Colors.FAIL}[X] Failed to update URLs: {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
