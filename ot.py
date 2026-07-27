import os
import subprocess
import json
import time
import csv
import threading
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    BG_CYAN = '\033[46m'
    BG_BLACK = '\033[40m'

print_lock = threading.Lock()
state_lock = threading.Lock()
completed_folders_in_memory = set()

def safe_print(message):
    """Farklı thread'lerin çıktılarını karıştırmadan güvenli bir şekilde ekrana yazar."""
    with print_lock:
        print(message)

def print_banner():
    safe_print(f"""{Colors.CYAN}{Colors.BOLD}
  ██████╗ ██╗  ██╗██╗███╗   ██╗ █████╗ ██████╗ 
 ██╔═══██╗██║  ██║██║████╗  ██║██╔══██╗██╔══██╗
 ██║   ██║███████║██║██╔██╗ ██║███████║██████╔╝
 ██║   ██║██╔══██║██║██║╚██╗██║██╔══██║██╔══██╗
 ╚██████╔╝██║  ██║██║██║ ╚████║██║  ██║██║  ██║
  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝
      ⚡ OKINAR RECORDING MIGRATOR v3.0 ⚡{Colors.ENDC}""")

def log_error_remote(folder_name, error_message, target_server, ssh_user, ssh_port, target_dir):
    """Başarısız transfer logunu doğrudan HEDEF sunucudaki recordingslog.txt dosyasına yazar."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    temp_file = f"/tmp/err_{folder_name}.txt"
    try:
        with open(temp_file, "w", encoding="utf-8") as f:
            f.write(f"[{timestamp}] HATA - Gönderilemeyen Klasör: {folder_name}\n")
            if error_message:
                f.write(f"Hata Detayı:\n{error_message}\n")
            f.write("-" * 50 + "\n")
        
        with open(temp_file, "r", encoding="utf-8") as f_in:
            subprocess.run(
                ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"cat >> {target_dir}/recordingslog.txt"],
                stdin=f_in, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            )
        if os.path.exists(temp_file):
            os.remove(temp_file)
    except Exception as e:
        safe_print(f"{Colors.FAIL}[❌] Hedefe log yazılırken hata oluştu: {e}{Colors.ENDC}")

def load_remote_state(target_server, ssh_user, ssh_port, target_dir):
    """Transfer geçmişini doğrudan HEDEF sunucudaki transfer_state.json dosyasından okur."""
    cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"cat {target_dir}/transfer_state.json"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            return json.loads(result.stdout)
    except Exception:
        pass
    return {"completed_folders": []}

def save_remote_state(state, target_server, ssh_user, ssh_port, target_dir):
    """Transfer geçmişini doğrudan HEDEF sunucudaki transfer_state.json dosyasına yazar."""
    state_str = json.dumps(state, indent=4, ensure_ascii=False)
    cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"cat > {target_dir}/transfer_state.json"]
    try:
        subprocess.run(cmd, input=state_str, text=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except Exception as e:
        safe_print(f"{Colors.FAIL}[❌] Hedefe state kaydedilemedi: {e}{Colors.ENDC}")

def update_folder_completed_remote(folder, target_server, ssh_user, ssh_port, target_dir):
    """Bellekteki geçmişi günceller ve hedef sunucudaki state dosyasını günceller."""
    with state_lock:
        global completed_folders_in_memory
        completed_folders_in_memory.add(folder)
        state = {"completed_folders": list(completed_folders_in_memory)}
        save_remote_state(state, target_server, ssh_user, ssh_port, target_dir)

def reset_remote_state():
    """Hedef sunucudaki transfer geçmişi dosyasını siler."""
    safe_print(f"\n{Colors.WARNING}🔄 Hedef sunucu geçmişini sıfırlamak için bilgileri girin:{Colors.ENDC}")
    target_server = input(f"{Colors.BOLD}Hedef sunucu IP/Hostname: {Colors.ENDC}").strip()
    if not target_server:
        return
    ssh_user = input(f"{Colors.BOLD}SSH Kullanıcı Adı (Örn: root): {Colors.ENDC}").strip()
    ssh_port = input(f"{Colors.BOLD}SSH Portu (Varsayılan: 22): {Colors.ENDC}").strip() or "22"
    target_dir = input(f"{Colors.BOLD}Kayıt dizini (Varsayılan: /var/bigbluebutton/published/newrecords): {Colors.ENDC}").strip() or "/var/bigbluebutton/published/newrecords"

    cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"rm -f {target_dir}/transfer_state.json"]
    try:
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        safe_print(f"\n{Colors.GREEN}[✔️] BAŞARILI: Hedef sunucudaki transfer geçmişi başarıyla sıfırlandı.{Colors.ENDC}")
    except Exception as e:
        safe_print(f"{Colors.FAIL}[❌] Sıfırlama hatası: {e}{Colors.ENDC}")

def setup_environment():
    """Rsync kurar ve şifresiz SSH bağlantısı için anahtar oluşturup hedef sunucuya kopyalar."""
    safe_print(f"\n{Colors.CYAN}{Colors.BOLD}⚡ --- AŞAMA 1: Rsync Kurulumu ---{Colors.ENDC}")
    try:
        safe_print("[i] Sistem paketleri güncelleniyor ve rsync kuruluyor... (Sudo yetkisi gerekebilir)")
        subprocess.run(["sudo", "apt-get", "update"], check=True)
        subprocess.run(["sudo", "apt-get", "install", "-y", "rsync"], check=True)
        safe_print(f"{Colors.GREEN}[+] Rsync başarıyla kuruldu veya zaten mevcut.{Colors.ENDC}")
    except subprocess.CalledProcessError:
        safe_print(f"{Colors.FAIL}[❌] HATA: Rsync kurulumu başarısız oldu.{Colors.ENDC}")
        return

    safe_print(f"\n{Colors.CYAN}{Colors.BOLD}🔑 --- AŞAMA 2: Şifresiz SSH Bağlantı Kurulumu ---{Colors.ENDC}")
    ssh_key_path = os.path.expanduser("~/.ssh/id_rsa")
    
    if not os.path.exists(ssh_key_path):
        safe_print("[i] SSH anahtarı bulunamadı, 4096-bit yeni bir anahtar oluşturuluyor...")
        try:
            subprocess.run(["ssh-keygen", "-t", "rsa", "-b", "4096", "-N", "", "-f", ssh_key_path], check=True)
            safe_print(f"{Colors.GREEN}[+] SSH anahtarı başarıyla oluşturuldu.{Colors.ENDC}")
        except subprocess.CalledProcessError:
            safe_print(f"{Colors.FAIL}[❌] HATA: SSH anahtarı oluşturulamadı.{Colors.ENDC}")
            return
    else:
        safe_print(f"{Colors.GREEN}[+] Mevcut SSH anahtarı bulundu.{Colors.ENDC}")

    target_server = input(f"\n{Colors.BOLD}Anahtarın kopyalanacağı HEDEF sunucu IP: {Colors.ENDC}").strip()
    ssh_user = input(f"{Colors.BOLD}SSH Kullanıcı Adı (Örn: root): {Colors.ENDC}").strip()
    ssh_port = input(f"{Colors.BOLD}SSH Portu (Varsayılan: 22): {Colors.ENDC}").strip() or "22"
    
    safe_print(f"\n[i] Anahtar {ssh_user}@{target_server}:{ssh_port} adresine gönderiliyor...")
    safe_print(f"{Colors.WARNING}NOT: Lütfen istendiğinde hedef sunucunun şifresini girin (Bu şifre son kez sorulacaktır!){Colors.ENDC}")
    
    try:
        subprocess.run(["ssh-copy-id", "-p", ssh_port, f"{ssh_user}@{target_server}"], check=True)
        safe_print(f"\n{Colors.GREEN}[✔️] MÜKEMMEL! Şifresiz SSH bağlantısı başarıyla kuruldu.{Colors.ENDC}")
        safe_print("Artık 2. seçeneği kullanarak transferleri hiçbir şifre girmeden başlatabilirsiniz.")
    except subprocess.CalledProcessError:
        safe_print(f"\n{Colors.FAIL}[❌] HATA: Anahtar kopyalanamadı. Lütfen bilgileri kontrol edin.{Colors.ENDC}")

def list_directories():
    """Belirtilen dizindeki klasörleri bulur ve metin dosyasına kaydeder."""
    path = input(f"\n{Colors.BOLD}Taranacak dizinin tam yolunu girin (Örn: /var/bigbluebutton/published/presentation): {Colors.ENDC}").strip()
    
    if not os.path.exists(path):
        safe_print(f"\n{Colors.FAIL}[❌] HATA: '{path}' adında bir dizin bulunamadı.{Colors.ENDC}")
        return

    try:
        folders = [f for f in os.listdir(path) if os.path.isdir(os.path.join(path, f))]
        
        if not folders:
            safe_print(f"\n{Colors.WARNING}[!] Belirtilen dizinde hiçbir klasör bulunamadı.{Colors.ENDC}")
            return

        output_file = "klasor_listesi.txt"
        with open(output_file, "w", encoding="utf-8") as f:
            for folder in folders:
                f.write(folder + "\n")
                
        safe_print(f"\n{Colors.GREEN}[✔️] BAŞARILI: {len(folders)} adet klasör '{output_file}' dosyasına kaydedildi.{Colors.ENDC}")
    except Exception as e:
        safe_print(f"\n{Colors.FAIL}[❌] Hata oluştu: {e}{Colors.ENDC}")

def load_csv_mappings(csv_path):
    """lms_sync.py çıktısı olan analiz CSV raporunu okur."""
    mappings = {}
    if not os.path.exists(csv_path):
        safe_print(f"{Colors.FAIL}[❌] HATA: '{csv_path}' CSV dosyası bulunamadı.{Colors.ENDC}")
        return mappings

    try:
        with open(csv_path, mode="r", encoding="utf-8-sig") as f:
            reader = csv.DictReader(f, delimiter=";")
            for row in reader:
                # Hem eski 'Klasor Adi' hem de orijinal LMS çıktısındaki 'ID' sütununu destekle
                folder = row.get("Klasor Adi") or row.get("ID")
                
                # Kurum adı için birden fazla sütun ismini destekle
                kurum = row.get("Kurum") or row.get("Kurum (Tahmin)") or row.get("Kurum (LMS)")
                
                if folder and kurum:
                    mappings[folder.strip()] = kurum.strip()
    except Exception as e:
        safe_print(f"{Colors.FAIL}[❌] CSV okuma hatası: {e}{Colors.ENDC}")
    return mappings

def clean_filename(name):
    """Kurum isimlerini klasör yapısına uygun hale getirir."""
    import re
    name = name.lower()
    name = name.replace("ı", "i").replace("ğ", "g").replace("ü", "u").replace("ş", "s").replace("ö", "o").replace("ç", "c")
    name = re.sub(r'[^a-z0-9\s\_]', '', name)
    name = name.replace(" ", "_")
    return name

def transfer_single_folder(folder, source_dir, target_server, ssh_user, ssh_port, target_dir, bw_limit, max_workers):
    """Tek bir klasörü aktarır. Hataları ve başarı durumunu doğrudan HEDEF sunucuda günceller."""
    full_path = os.path.join(source_dir, folder)
    
    cmd = [
        "rsync", "-avz",
        "-e", f"ssh -p {ssh_port} -o StrictHostKeyChecking=no",
    ]
    
    if max_workers == 1:
        cmd.append("--progress")
        
    if bw_limit:
        cmd.append(f"--bwlimit={bw_limit}")
        
    cmd.extend([full_path, f"{ssh_user}@{target_server}:{target_dir}"])
    
    max_retries = 3
    retry_delay = 3
    
    for attempt in range(1, max_retries + 1):
        if max_workers == 1:
            safe_print(f"\n{Colors.BLUE}{Colors.BOLD}┌──────────────────────────────────────────────────────────┐")
            safe_print(f"│ ⚡ AKTARIM BAŞLIYOR: {folder:<30} │")
            safe_print(f"│ 🔄 Deneme: {attempt}/{max_retries:<43} │")
            safe_print(f"└──────────────────────────────────────────────────────────┘{Colors.ENDC}")
        else:
            safe_print(f"{Colors.CYAN}[>] {folder} başlatıldı (Deneme {attempt}/{max_retries}){Colors.ENDC}")
            
        if max_workers == 1:
            process = subprocess.Popen(cmd, stderr=subprocess.PIPE, text=True)
            _, stderr_output = process.communicate()
        else:
            process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            _, stderr_output = process.communicate()
            
        if process.returncode == 0:
            safe_print(f"{Colors.GREEN}[✔️] BAŞARILI: {folder} karşıya aktarıldı.{Colors.ENDC}")
            update_folder_completed_remote(folder, target_server, ssh_user, ssh_port, target_dir)
            return True, None
        else:
            if attempt < max_retries:
                safe_print(f"{Colors.WARNING}[!] HATA / KOPMA: {folder} aktarılamadı. {retry_delay} sn sonra yeniden deneniyor...{Colors.ENDC}")
                time.sleep(retry_delay)
            else:
                safe_print(f"{Colors.FAIL}[❌] BAŞARISIZ: {folder} aktarımı 3 deneme sonunda elendi! Hata günlüğe yazılıyor...{Colors.ENDC}")
                log_error_remote(folder, stderr_output, target_server, ssh_user, ssh_port, target_dir)
                return False, stderr_output

def transfer_records():
    """Klasörleri aktarır. CSV entegrasyonu yapar ve logları doğrudan HEDEF sunucuda saklar."""
    global completed_folders_in_memory
    
    source_dir = input(f"\n{Colors.BOLD}Transfer edilecek kaynak dizin yolu: {Colors.ENDC}").strip()
    
    if not os.path.exists(source_dir):
        safe_print(f"\n{Colors.FAIL}[❌] HATA: Kaynak dizin '{source_dir}' bulunamadı.{Colors.ENDC}")
        return

    all_folders = [f for f in os.listdir(source_dir) if os.path.isdir(os.path.join(source_dir, f))]

    if not all_folders:
        safe_print(f"\n{Colors.WARNING}[!] Kaynak dizinde klasör bulunamadı.{Colors.ENDC}")
        return

    use_csv = input(f"\n{Colors.WARNING}lms_sync.py çıktısı olan CSV raporunu kullanarak Kurum Filtresi uygulamak ister misiniz? (e/H): {Colors.ENDC}").strip().lower()
    folder_to_kurum = {}
    chosen_kurum = None

    if use_csv == 'e':
        csv_files = [f for f in os.listdir(".") if f.startswith("kesin_video_analiz_raporu_") and f.endswith(".csv")]
        if csv_files:
            safe_print(f"\n{Colors.CYAN}{Colors.BOLD}--- Bulunan Analiz Raporları ---{Colors.ENDC}")
            for idx, file in enumerate(csv_files, 1):
                safe_print(f"  [{idx}] {file}")
            
            try:
                csv_choice = int(input(f"\n{Colors.BOLD}Hangi raporu kullanmak istersiniz? (Sayı): {Colors.ENDC}").strip())
                selected_csv = csv_files[csv_choice - 1]
            except (ValueError, IndexError):
                selected_csv = input(f"\n{Colors.BOLD}CSV dosyasının adını tam girin: {Colors.ENDC}").strip()
        else:
            selected_csv = input(f"\n{Colors.WARNING}Dizinde otomatik rapor bulunamadı. CSV adını girin: {Colors.ENDC}").strip()

        folder_to_kurum = load_csv_mappings(selected_csv)
        
        if folder_to_kurum:
            kurum_counts = {}
            for f in all_folders:
                k = folder_to_kurum.get(f, "Belirsiz / Bilinmeyen Musteri")
                kurum_counts[k] = kurum_counts.get(k, 0) + 1
                
            safe_print(f"\n{Colors.CYAN}{Colors.BOLD}--- Sunucudaki Kurumlar ve Video Sayıları ---{Colors.ENDC}")
            for idx, k in enumerate(sorted(kurum_counts.keys()), 1):
                safe_print(f"  {Colors.BOLD}[{idx}]{Colors.ENDC} {k:<30} ({kurum_counts[k]} video)")
            safe_print(f"  {Colors.BOLD}[0]{Colors.ENDC} Tümü")
            
            try:
                choice_idx = int(input(f"\n{Colors.BOLD}Hangi kurumun videolarını taşımak istersiniz?: {Colors.ENDC}").strip())
                if choice_idx != 0:
                    chosen_kurum = sorted(kurum_counts.keys())[choice_idx - 1]
                    safe_print(f"\n{Colors.GREEN}[+] Seçilen Filtre: '{chosen_kurum}'{Colors.ENDC}")
            except (ValueError, IndexError):
                safe_print(f"\n{Colors.WARNING}[!] Filtre uygulanmadan devam ediliyor...{Colors.ENDC}")
        else:
            safe_print(f"\n{Colors.FAIL}[❌] CSV eşleşmesi boş veya okunamadı.{Colors.ENDC}")

    target_server = input(f"{Colors.BOLD}Hedef sunucu IP/Hostname: {Colors.ENDC}").strip()
    ssh_user = input(f"{Colors.BOLD}SSH Kullanıcı Adı (Örn: root): {Colors.ENDC}").strip()
    ssh_port = input(f"{Colors.BOLD}SSH Portu (Varsayılan: 22): {Colors.ENDC}").strip() or "22"
    
    default_target_dir = "/var/bigbluebutton/published/newrecords"
    if chosen_kurum:
        suggested_dir = f"{default_target_dir}/{clean_filename(chosen_kurum)}"
        target_dir = input(f"{Colors.BOLD}Hedef sunucu kayıt dizini (Varsayılan: {suggested_dir}): {Colors.ENDC}").strip() or suggested_dir
    else:
        target_dir = input(f"{Colors.BOLD}Hedef sunucu kayıt dizini (Varsayılan: {default_target_dir}): {Colors.ENDC}").strip() or default_target_dir

    bw_limit = input(f"{Colors.BOLD}Bant genişliği limiti (KB/s, Örn: 5000 (5MB/s), Limitsiz için boş): {Colors.ENDC}").strip()
    
    try:
        max_workers = int(input(f"{Colors.BOLD}Aynı anda kaç paralel transfer çalışsın? (Varsayılan: 1): {Colors.ENDC}").strip() or "1")
    except ValueError:
        max_workers = 1

    folders_to_transfer = []
    for f in all_folders:
        if chosen_kurum:
            if folder_to_kurum.get(f) == chosen_kurum:
                folders_to_transfer.append(f)
        else:
            folders_to_transfer.append(f)

    if not folders_to_transfer:
        safe_print(f"\n{Colors.FAIL}[❌] Seçilen kritere uygun video bulunamadı.{Colors.ENDC}")
        return

    safe_print(f"\n[i] Hedef sunucuda klasör yapısı oluşturuluyor...")
    mkdir_cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"mkdir -p {target_dir}"]
    subprocess.run(mkdir_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    safe_print(f"[i] Hedef sunucudaki transfer geçmişi (state) yükleniyor...")
    remote_state = load_remote_state(target_server, ssh_user, ssh_port, target_dir)
    completed_folders_in_memory = set(remote_state.get("completed_folders", []))

    folders_to_transfer = [f for f in folders_to_transfer if f not in completed_folders_in_memory]
    
    if not folders_to_transfer:
        safe_print(f"\n{Colors.GREEN}[✔️] BİLGİ: Kritere uyan tüm videolar zaten hedefe taşınmış!{Colors.ENDC}")
        return

    skipped_count = len(all_folders) - len(folders_to_transfer)
    if skipped_count > 0:
        safe_print(f"\n{Colors.BLUE}[i] Toplam {skipped_count} video zaten taşındığı için es geçilecek.{Colors.ENDC}")
        time.sleep(1)

    safe_print(f"\n{Colors.CYAN}{Colors.BOLD}🚀 Transfer işlemi başlatılıyor... ({len(folders_to_transfer)} video, {max_workers} paralel kanal){Colors.ENDC}\n")
    time.sleep(1)

    success_count = 0
    fail_count = 0

    if max_workers <= 1:
        for folder in folders_to_transfer:
            success, _ = transfer_single_folder(folder, source_dir, target_server, ssh_user, ssh_port, target_dir, bw_limit, max_workers)
            if success:
                success_count += 1
            else:
                fail_count += 1
    else:
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            futures = {
                executor.submit(transfer_single_folder, folder, source_dir, target_server, ssh_user, ssh_port, target_dir, bw_limit, max_workers): folder 
                for folder in folders_to_transfer
            }
            
            for future in as_completed(futures):
                success, _ = future.result()
                if success:
                    success_count += 1
                else:
                    fail_count += 1

    safe_print(f"\n{Colors.CYAN}{Colors.BOLD}" + "="*50)
    safe_print(f"                 MİGRASYON TAMAMLANDI                 ")
    safe_print("="*50 + f"{Colors.ENDC}")
    safe_print(f"{Colors.GREEN}✓ Başarılı Aktarım: {success_count}{Colors.ENDC}")
    safe_print(f"{Colors.FAIL}✗ Başarısız Aktarım: {fail_count}{Colors.ENDC}")
    if fail_count > 0:
        safe_print(f"{Colors.WARNING}[!] Hata ayrıntıları için hedefteki '{target_dir}/recordingslog.txt' dosyasını okuyun.{Colors.ENDC}")
    else:
        safe_print(f"{Colors.GREEN}[✔️] Harika! Seçilen videoların tamamı kayıpsız bir şekilde taşındı.{Colors.ENDC}")
    safe_print(f"{Colors.CYAN}{Colors.BOLD}" + "="*50 + f"{Colors.ENDC}")

def main():
    while True:
        os.system('clear' if os.name == 'posix' else 'cls')
        print_banner()
        
        safe_print(f"""
  {Colors.BOLD}┌─────────────────────────────────────────────────────────┐{Colors.ENDC}
  {Colors.BOLD}│                   ⚙️  İŞLEM SEÇENEKLERİ                 │{Colors.ENDC}
  {Colors.BOLD}└─────────────────────────────────────────────────────────┘{Colors.ENDC}
   {Colors.CYAN}[1]{Colors.ENDC} {Colors.BOLD}📂 Dizin İçindeki Klasörleri Listele (.txt belgesine){Colors.ENDC}
   {Colors.CYAN}[2]{Colors.ENDC} {Colors.BOLD}🚀 Kayıtları Karşı Sunucuya Aktar (Akıllı Filtreli){Colors.ENDC}
   {Colors.CYAN}[3]{Colors.ENDC} {Colors.BOLD}🔧 Sunucu Altyapısını Kur (SSH Şifresiz Bağlantı & Rsync){Colors.ENDC}
   {Colors.CYAN}[4]{Colors.ENDC} {Colors.BOLD}🔄 Hedef Sunucudaki Geçmişi (State) Sıfırla{Colors.ENDC}
   {Colors.CYAN}[0]{Colors.ENDC} {Colors.BOLD}❌ Çıkış{Colors.ENDC}
        """)

        choice = input(f"{Colors.WARNING}{Colors.BOLD}Seçiminiz (1/2/3/4/0): {Colors.ENDC}").strip()

        if choice == '1':
            list_directories()
            input(f"\n{Colors.BLUE}Menüye dönmek için ENTER tuşuna basın...{Colors.ENDC}")
        elif choice == '2':
            transfer_records()
            input(f"\n{Colors.BLUE}Menüye dönmek için ENTER tuşuna basın...{Colors.ENDC}")
        elif choice == '3':
            setup_environment()
            input(f"\n{Colors.BLUE}Menüye dönmek için ENTER tuşuna basın...{Colors.ENDC}")
        elif choice == '4':
            reset_remote_state()
            input(f"\n{Colors.BLUE}Menüye dönmek için ENTER tuşuna basın...{Colors.ENDC}")
        elif choice == '0':
            safe_print(f"\n{Colors.GREEN}Programdan çıkılıyor. İyi çalışmalar dileriz! 🚀{Colors.ENDC}\n")
            break
        else:
            safe_print(f"\n{Colors.FAIL}[❌] Geçersiz seçim. Lütfen tekrar deneyin.{Colors.ENDC}")
            time.sleep(2)

if __name__ == "__main__":
    import sys
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    main()
