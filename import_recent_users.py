import os
import sys
import re
import uuid
import datetime
import json
import argparse
import hashlib

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def normalize(s):
    if not s:
        return ''
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

def parse_name(full_name):
    parts = str(full_name).strip().split()
    if not parts:
        return "", ""
    if len(parts) == 1:
        return parts[0], ""
    return " ".join(parts[:-1]), parts[-1]

def clean_phone_number(phone):
    if not phone:
        return None
    s = re.sub(r'\D', '', str(phone))
    if len(s) == 11 and s.startswith('0'):
        s = s[1:]
    elif len(s) == 12 and s.startswith('90'):
        s = s[2:]
    elif len(s) == 13 and s.startswith('+90'):
        s = s[3:]
    if len(s) == 10 and s.startswith('5'):
        return s
    return None

def generate_mock_phone(name, existing_phones):
    h = hashlib.md5(normalize(name).encode('utf-8')).hexdigest()
    val = int(h, 16)
    base_suffix = val % 10000000 # 7 haneli
    phone = f"111{base_suffix:07d}"
    while phone in existing_phones:
        base_suffix = (base_suffix + 1) % 10000000
        phone = f"111{base_suffix:07d}"
    existing_phones.add(phone)
    return phone

def generate_mock_email(name, existing_emails):
    norm = normalize(name)
    parts = norm.split()
    if not parts:
        base_email = f"ogrenci_{str(uuid.uuid4())[:8]}"
    elif len(parts) == 1:
        base_email = parts[0]
    else:
        base_email = f"{parts[0]}.{parts[-1]}"
        
    email = f"{base_email}@akademikmasa.com"
    counter = 1
    while email in existing_emails:
        email = f"{base_email}{counter}@akademikmasa.com"
        counter += 1
    existing_emails.add(email)
    return email

def generate_password(name, phone):
    first, last = parse_name(name)
    first_clean = normalize(first).split()
    first_val = first_clean[0] if first_clean else "ogrenci"
    last_clean = normalize(last)
    last_char = last_clean[0] if last_clean else "x"
    phone_val = str(phone)
    phone_suffix = phone_val[-2:] if len(phone_val) >= 2 else "00"
    return f"{first_val}.{phone_suffix}.{last_char}"

def load_env():
    config = {}
    env_paths = [
        ".env.3u", "../.env.3u", "../../.env.3u",
        ".env.hll", "../.env.hll", "../../.env.hll",
        ".env.ens", "../.env.ens", "../../.env.ens",
        ".env.omr", "../.env.omr", "../../.env.omr",
        ".env.akm", "../.env.akm", "../../.env.akm",
        ".env", "../.env", "../../.env"
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
    parser = argparse.ArgumentParser(description="MURO LMS - Okinar Güncel Kullanıcı Veri İthalat Betiği")
    parser.add_argument("--host", help="PostgreSQL host")
    parser.add_argument("--port", type=int, help="PostgreSQL port")
    parser.add_argument("--dbname", help="PostgreSQL database name")
    parser.add_argument("--user", help="PostgreSQL username")
    parser.add_argument("--password", help="PostgreSQL password")
    parser.add_argument("--file", default="okinar_recent_users.json", help="Kazınan kullanıcı verilerinin JSON dosya yolu")
    parser.add_argument("--execute", action="store_true", help="Değişiklikleri veritabanına kaydeder (varsayılan: dry-run / simülasyon)")
    args = parser.parse_args()

    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}      MURO LMS - OKINAR GÜNCEL KULLANICI AKTARIM ARACI{Colors.ENDC}")
    print(f"{Colors.CYAN}{Colors.BOLD}============================================================{Colors.ENDC}")

    # Env dosyasından yükle
    env_config = load_env()
    db_host = args.host or env_config.get("DB_HOST", "localhost")
    db_port = args.port or int(env_config.get("DB_PORT", 5432))
    db_name = args.dbname or env_config.get("DB_NAME", env_config.get("DB_DATABASE", "muro_demo"))
    db_user = args.user or env_config.get("DB_USER", env_config.get("DB_USERNAME", "muro_user"))
    db_pass = args.password or env_config.get("DB_PASSWORD", "MuroDem0_2026!Str0ng")

    # Docker container IP'sini çözmeyi dene (3u, hll, akm sırasıyla)
    if not args.host:
        possible_containers = ['muro_3u_postgres', 'muro_hll_postgres', 'muro_akm_postgres']
        for container in possible_containers:
            try:
                import subprocess
                result = subprocess.check_output(['docker', 'inspect', '-f', '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}', container], stderr=subprocess.DEVNULL)
                ip = result.decode('utf-8').strip()
                if ip:
                    db_host = ip
                    print(f"[*] Resolved DB container '{container}' IP: {db_host}")
                    break
            except Exception:
                pass

    print(f"[*] Veritabanı bağlantı bilgileri:")
    print(f"    Host: {db_host}")
    print(f"    Port: {db_port}")
    print(f"    Veritabanı: {db_name}")
    print(f"    Kullanıcı: {db_user}")

    # JSON Oku
    json_path = args.file
    if not os.path.exists(json_path):
        print(f"{Colors.FAIL}[X] HATA: Veri dosyası bulunamadı: '{json_path}'{Colors.ENDC}")
        sys.exit(1)
        
    print(f"[*] '{json_path}' dosyasından veriler okunuyor...")
    with open(json_path, 'r', encoding='utf-8') as f:
        scraped_users = json.load(f)
    print(f"    - Yüklenen toplam kullanıcı sayısı: {len(scraped_users)}")

    if len(scraped_users) == 0:
        print(f"{Colors.WARNING}[!] UYARI: İşlenecek veri bulunamadı.{Colors.ENDC}")
        sys.exit(0)

    # Veritabanına Bağlan
    print(f"[*] '{db_name}' veritabanına bağlanılıyor ('{db_host}:{db_port}')...")
    conn = None
    try:
        import psycopg2
        conn = psycopg2.connect(host=db_host, port=db_port, dbname=db_name, user=db_user, password=db_pass)
    except ImportError:
        try:
            import pg8000
            conn = pg8000.connect(host=db_host, port=db_port, database=db_name, user=db_user, password=db_pass)
        except ImportError:
            print(f"{Colors.FAIL}[X] HATA: psycopg2 veya pg8000 kütüphanelerinden biri kurulu olmalıdır!{Colors.ENDC}")
            sys.exit(1)
    except Exception as e:
        print(f"{Colors.FAIL}[X] Veritabanı bağlantısı başarısız oldu: {e}{Colors.ENDC}")
        sys.exit(1)

    print(f"{Colors.GREEN}[+] Veritabanı bağlantısı kuruldu!{Colors.ENDC}")
    cur = conn.cursor()

    try:
        # Mevcut verileri cache'leme (Hızlı eşleştirme ve dublike önleme için)
        print("[*] Mevcut veritabanı kayıtları önbelleğe alınıyor...")
        
        # Gruplar
        cur.execute('SELECT "Id", "Name" FROM "Groups" WHERE "IsDeleted" = False;')
        db_groups = {r[1].strip().lower(): r[0] for r in cur.fetchall()}


        # Kullanıcılar
        cur.execute('SELECT "Id", "FirstName", "LastName", "Email", "Phone", "Username" FROM "Users";')
        db_users_raw = cur.fetchall()
        
        users_by_phone = {}
        users_by_email = {}
        users_by_username = {}
        users_by_name = {}
        
        existing_phones = set()
        existing_emails = set()
        
        for u_id, first, last, email, phone, username in db_users_raw:
            full_name = f"{first} {last}".strip()
            norm_name = normalize(full_name)
            cleaned_phone = clean_phone_number(phone)
            email_lower = email.lower().strip() if email else None
            
            if phone:
                existing_phones.add(phone.strip())
            if username:
                existing_phones.add(username.strip())
            if email_lower:
                existing_emails.add(email_lower)
            
            if cleaned_phone:
                users_by_phone[cleaned_phone] = u_id
            if email_lower:
                users_by_email[email_lower] = u_id
            if username:
                users_by_username[username.strip()] = u_id
            if norm_name:
                users_by_name[norm_name] = u_id

        # TenantMemberships varlığı
        cur.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'TenantMemberships'
            );
        """)
        has_tenant_memberships = cur.fetchone()[0]
        db_tenant_members = set()
        if has_tenant_memberships:
            cur.execute('SELECT "UserId" FROM "TenantMemberships";')
            db_tenant_members = set(r[0] for r in cur.fetchall())

        # GroupMembers
        cur.execute('SELECT "GroupId", "UserId" FROM "GroupMembers" WHERE "Status" = \'active\';')
        db_group_members = {(r[0], r[1]) for r in cur.fetchall()}

        print("[+] Önbelleğe alma tamamlandı.")

        # Sayaçlar
        users_created = 0
        users_skipped = 0
        tenant_members_created = 0
        groups_created = 0
        group_memberships_created = 0
        group_memberships_skipped = 0

        # Aktarım İşlemi
        print(f"\n{Colors.BLUE}[*] Kullanıcıları ve Atamaları İşleme Başlıyor...{Colors.ENDC}")

        for user_entry in scraped_users:
            name = user_entry.get('name', '').strip()
            phone = clean_phone_number(user_entry.get('phone'))
            email = user_entry.get('email', '').lower().strip()
            groups = user_entry.get('groups', [])

            if not name:
                continue

            norm_name = normalize(name)
            first, last = parse_name(name)

            # Kullanıcı eşleştirme
            u_id = None
            if phone and phone in users_by_phone:
                u_id = users_by_phone[phone]
            elif phone and phone in users_by_username:
                u_id = users_by_username[phone]
            elif email and email in users_by_email:
                u_id = users_by_email[email]
            elif norm_name in users_by_name:
                u_id = users_by_name[norm_name]

            # Mock verileri hazırla (telefon/email yoksa)
            mock_phone = phone if phone else generate_mock_phone(name, existing_phones)
            mock_email = email if email else generate_mock_email(name, existing_emails)
            if phone:
                existing_phones.add(phone)
            if email:
                existing_emails.add(email)
            pwd = generate_password(name, mock_phone)

            # Kullanıcı oluştur veya atla
            if not u_id:
                u_id = str(uuid.uuid4())
                cur.execute(
                    'INSERT INTO "Users" ("Id", "FirstName", "LastName", "Email", "Username", "Phone", "PasswordHash", "Role", "StudentType", "IsActive", "IsDeleted", "CreatedAt") '
                    'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                    (u_id, first, last, mock_email, mock_phone, mock_phone, pwd, 'Student', 'Active', True, False, datetime.datetime.utcnow())
                )
                users_created += 1
                users_by_name[norm_name] = u_id
                users_by_phone[mock_phone] = u_id
                print(f"   -> [Yeni Kullanıcı] {name} | Tel: {mock_phone} | E-posta: {mock_email}")
            else:
                users_skipped += 1

            # Tenant Membership oluştur
            if has_tenant_memberships and u_id not in db_tenant_members:
                cur.execute(
                    'INSERT INTO "TenantMemberships" ("Id", "UserId", "Role", "Status", "JoinedAt") VALUES (%s, %s, %s, %s, %s)',
                    (str(uuid.uuid4()), u_id, 'Student', 'active', datetime.datetime.utcnow())
                )
                db_tenant_members.add(u_id)
                tenant_members_created += 1

            # Grup Atamaları
            for g_name in groups:
                g_name = g_name.strip()
                if not g_name:
                    continue
                g_key = g_name.lower()

                # Grup veritabanında yoksa oluştur
                g_id = db_groups.get(g_key)
                if not g_id:
                    g_id = str(uuid.uuid4())
                    cur.execute(
                        'INSERT INTO "Groups" ("Id", "Name", "Description", "ParentId", "IsDeleted", "CreatedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s)',
                        (g_id, g_name, f"Okinar'dan aktarılan grup: {g_name}", None, False, datetime.datetime.utcnow())
                    )
                    db_groups[g_key] = g_id
                    groups_created += 1
                    print(f"   -> [Yeni Grup] {g_name}")

                # Gruba ata
                if (g_id, u_id) not in db_group_members:
                    cur.execute(
                        'INSERT INTO "GroupMembers" ("Id", "UserId", "GroupId", "Role", "Status", "AddedAt") '
                        'VALUES (%s, %s, %s, %s, %s, %s)',
                        (str(uuid.uuid4()), u_id, g_id, 2, 'active', datetime.datetime.utcnow())
                    )
                    db_group_members.add((g_id, u_id))
                    group_memberships_created += 1
                else:
                    group_memberships_skipped += 1


        print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f"{Colors.GREEN}{Colors.BOLD}                      AKTARIM RAPORU{Colors.ENDC}")
        print(f"{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
        print(f" [Kullanıcı] Yeni Eklenen Öğrenci Sayısı    : {users_created}")
        print(f" [Kullanıcı] Eşleşen/Atlanan Öğrenci Sayısı : {users_skipped}")
        print(f" [Tenant] TenantMemberships Bağlantısı      : {tenant_members_created}")
        print(f" [Grup] Yeni Oluşturulan Grup Sayısı        : {groups_created}")
        print(f" [Üyelik] Gruba Öğrenci Atama (Yeni)        : {group_memberships_created}")
        print(f" [Üyelik] Gruba Öğrenci Atama (Zaten Var)    : {group_memberships_skipped}")

        if args.execute:
            conn.commit()
            print(f"\n{Colors.GREEN}{Colors.BOLD}[OK] BAŞARILI: Değişiklikler veritabanına kalıcı olarak kaydedildi!{Colors.ENDC}")
        else:
            conn.rollback()
            print(f"\n{Colors.WARNING}{Colors.BOLD}[i] SİMÜLASYON MODU: Veritabanında hiçbir değişiklik yapılmadı.{Colors.ENDC}")
            print(f"    Gerçek veri aktarımı yapmak için komuta '--execute' parametresini ekleyin:")
            print(f"    python import_recent_users.py --execute")

    except Exception as e:
        conn.rollback()
        print(f"\n{Colors.FAIL}[X] HATA OLUŞTU (Tüm işlemler geri alınıyor/rollback): {e}{Colors.ENDC}")
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()
