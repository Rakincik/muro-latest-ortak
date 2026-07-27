import json
import os
import psycopg2

def normalize(s):
    if not s:
        return ''
    import re
    s = str(s).lower().strip()
    char_map = {
        'ı': 'i', 'İ': 'i', 'I': 'i',
        'ş': 's', 'Ş': 's',
        'ğ': 'g', 'Ğ': 'g',
        'ü': 'u', 'Ü': 'u',
        'ö': 'o', 'Ö': 'o',
        'ç': 'c', 'Ç': 'c'
    }
    for tr, eng in char_map.items():
        s = s.replace(tr, eng)
    s = re.sub(r'[^a-z0-9]', '', s)
    return s

def clean_phone(phone):
    if not phone:
        return None
    import re
    s = re.sub(r'\D', '', str(phone))
    if len(s) == 11 and s.startswith('0'):
        s = s[1:]
    elif len(s) == 12 and s.startswith('90'):
        s = s[2:]
    if len(s) == 10 and s.startswith('5'):
        return s
    return None

def main():
    # Connect to DB
    try:
        import subprocess
        result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', 'muro_3u_postgres'], stderr=subprocess.DEVNULL)
        db_host = result.decode('utf-8').strip()
    except Exception:
        db_host = '127.0.0.1'

    conn = psycopg2.connect(host=db_host, port=5432, dbname='muro_demo', user='muro_user', password='MuroDem0_2026!Str0ng')
    cur = conn.cursor()

    # Load users from database
    cur.execute('SELECT "Id", "Email", "Phone", "Username", "FirstName", "LastName", "Role" FROM "Users";')
    db_users_raw = cur.fetchall()
    
    db_by_email = {r[1].lower().strip(): r for r in db_users_raw if r[1]}
    db_by_phone = {r[2].strip(): r for r in db_users_raw if r[2]}
    db_by_name = {normalize(f"{r[4]} {r[5]}"): r for r in db_users_raw}

    # Load JSON
    with open('okinar_bireysel_dersler.json', 'r', encoding='utf-8') as f:
        scraped_users = json.load(f)

    print(f"Loaded {len(scraped_users)} users from JSON.")
    print(f"Loaded {len(db_users_raw)} users from DB.")

    missing = []
    duplicates = {}
    invalid_data = []

    for entry in scraped_users:
        name = entry.get('name', '').strip()
        phone = clean_phone(entry.get('phone'))
        email = entry.get('email', '').strip().lower()

        if not name:
            invalid_data.append(entry)
            continue

        norm_name = normalize(name)

        # Check match
        matched_user = None
        match_reason = ""
        if phone and phone in db_by_phone:
            matched_user = db_by_phone[phone]
            match_reason = "Phone match"
        elif email and email in db_by_email:
            matched_user = db_by_email[email]
            match_reason = "Email match"
        elif norm_name in db_by_name:
            matched_user = db_by_name[norm_name]
            match_reason = "Name match"

        if not matched_user:
            missing.append({
                'name': name,
                'phone': entry.get('phone'),
                'email': entry.get('email'),
                'clean_phone': phone
            })
        else:
            # Check duplicate tracking
            key = (phone if phone else norm_name)
            if key in duplicates:
                duplicates[key].append(name)
            else:
                duplicates[key] = [name]

    print("\n--- MISSING USERS IN DATABASE ---")
    print(f"Total missing: {len(missing)}")
    for idx, m in enumerate(missing[:15]):
        print(f" {idx+1}. Name: '{m['name']}' | Tel: '{m['phone']}' | Email: '{m['email']}'")
    if len(missing) > 15:
        print(" ... and more.")

    print("\n--- DUPLICATE USERS DETECTED ---")
    dup_count = sum(1 for k, v in duplicates.items() if len(v) > 1)
    print(f"Total duplicate entries collapsed: {dup_count}")
    count = 0
    for k, v in duplicates.items():
        if len(v) > 1:
            count += 1
            if count <= 10:
                print(f"  {count}. Matches: {v}")
    
    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
