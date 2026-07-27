import os
import subprocess
import json
import time
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

print_lock = threading.Lock()
state_lock = threading.Lock()
completed_folders_in_memory = set()

def safe_print(message):
    with print_lock:
        print(message)

def print_banner():
    safe_print(f"""{Colors.CYAN}{Colors.BOLD}
  ███████╗███╗   ██╗███████╗
  ██╔════╝████╗  ██║██╔════╝
  █████╗  ██╔██╗ ██║███████╗
  ██╔══╝  ██║╚██╗██║╚════██║
  ███████╗██║ ╚████║███████║
  ╚══════╝╚═╝  ╚═══╝╚══════╝
       ⚡ ENS RECORDING MIGRATOR v1.0 ⚡{Colors.ENDC}""")

def log_error_remote(folder_name, error_message, target_server, ssh_user, ssh_port, target_dir):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    temp_file = f"/tmp/err_ens_{folder_name}.txt"
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
    """Transfer geçmişini doğrudan HEDEF sunucudaki transfer_state_ens.json dosyasından okur."""
    cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"cat {target_dir}/transfer_state_ens.json"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            return json.loads(result.stdout)
    except Exception:
        pass
    return {"completed_folders": []}

def save_remote_state(state, target_server, ssh_user, ssh_port, target_dir):
    """Transfer geçmişini doğrudan HEDEF sunucudaki transfer_state_ens.json dosyasına yazar."""
    state_str = json.dumps(state, indent=4, ensure_ascii=False)
    cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"cat > {target_dir}/transfer_state_ens.json"]
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

def apply_bbb3_playback_fix_remote(folder, target_server, ssh_user, ssh_port, target_dir):
    """BBB 3.0 playback fix işlemini hedef sunucuda bu klasör için çalıştırır (tldraw.json ve external_videos.json 404 düzeltmesi)."""
    # Hedefte tldraw.json ve external_videos.json dosyalarını kontrol et ve yoksa oluştur + izinleri düzelt
    remote_script = (
        f"[ ! -f {target_dir}/{folder}/tldraw.json ] && echo '[]' > {target_dir}/{folder}/tldraw.json; "
        f"[ ! -f {target_dir}/{folder}/external_videos.json ] && echo '[]' > {target_dir}/{folder}/external_videos.json; "
        f"chown -R bigbluebutton:bigbluebutton {target_dir}/{folder}"
    )
    cmd = ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", remote_script]
    try:
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=5)
    except Exception:
        pass

def setup_environment():
    """Rsync kurar ve şifresiz SSH bağlantısı için anahtar oluşturup hedef sunucuya kopyalar."""
    safe_print(f"\n{Colors.CYAN}{Colors.BOLD}⚡ --- AŞAMA 1: Rsync Kurulumu ---{Colors.ENDC}")
    try:
        safe_print("[i] Sistem paketleri güncelleniyor ve rsync kuruluyor...")
        subprocess.run(["sudo", "apt-get", "update"], check=True)
        subprocess.run(["sudo", "apt-get", "install", "-y", "rsync"], check=True)
        safe_print(f"{Colors.GREEN}[+] Rsync başarıyla kuruldu veya zaten mevcut.{Colors.ENDC}")
    except subprocess.CalledProcessError:
        safe_print(f"{Colors.FAIL}[❌] HATA: Rsync kurulumu başarısız oldu. Sudo yetkilerini kontrol edin.{Colors.ENDC}")
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

    target_server = input(f"\n{Colors.BOLD}Anahtarın kopyalanacağı HEDEF sunucu IP (Varsayılan: 185.184.25.66): {Colors.ENDC}").strip() or "185.184.25.66"
    ssh_user = input(f"{Colors.BOLD}SSH Kullanıcı Adı (Varsayılan: root): {Colors.ENDC}").strip() or "root"
    ssh_port = input(f"{Colors.BOLD}SSH Portu (Varsayılan: 22): {Colors.ENDC}").strip() or "22"
    
    safe_print(f"\n[i] Anahtar {ssh_user}@{target_server}:{ssh_port} adresine gönderiliyor...")
    safe_print(f"{Colors.WARNING}NOT: Lütfen istendiğinde hedef sunucunun şifresini girin (Bu şifre son kez sorulacaktır!){Colors.ENDC}")
    
    try:
        subprocess.run(["ssh-copy-id", "-p", ssh_port, f"{ssh_user}@{target_server}"], check=True)
        safe_print(f"\n{Colors.GREEN}[✔️] MÜKEMMEL! Şifresiz SSH bağlantısı başarıyla kuruldu.{Colors.ENDC}")
        safe_print("Artık transfer işlemini hiçbir şifre girmeden yapabilirsiniz.")
    except subprocess.CalledProcessError:
        safe_print(f"\n{Colors.FAIL}[❌] HATA: Anahtar kopyalanamadı. Lütfen bilgileri kontrol edin.{Colors.ENDC}")

def transfer_single_folder(folder, source_dir, target_server, ssh_user, ssh_port, target_dir, bw_limit, max_workers):
    """Tek bir klasörü aktarır ve hedefin BBB 3.0 playback fix ayarını yapar."""
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
            safe_print(f"{Colors.GREEN}[✔️] BAŞARILI: {folder} karşıya aktarıldı. Playback Fix uygulanıyor...{Colors.ENDC}")
            apply_bbb3_playback_fix_remote(folder, target_server, ssh_user, ssh_port, target_dir)
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
    global completed_folders_in_memory
    
    source_dir = input(f"\n{Colors.BOLD}Transfer edilecek kaynak dizin yolu (Varsayılan: /var/bigbluebutton/published/presentation): {Colors.ENDC}").strip() or "/var/bigbluebutton/published/presentation"
    if not os.path.exists(source_dir):
        safe_print(f"\n{Colors.FAIL}[❌] HATA: Kaynak dizin '{source_dir}' bulunamadı.{Colors.ENDC}")
        return

    active_ids_file = "active_ids_ens.txt"
    if not os.path.exists(active_ids_file):
        safe_print(f"\n{Colors.FAIL}[❌] HATA: Filtreleme için '{active_ids_file}' dosyası bulunamadı.{Colors.ENDC}")
        return

    # Load active BbbMeetingId values
    with open(active_ids_file, "r", encoding="utf-8") as f:
        active_ids = set(line.strip() for line in f if line.strip())

    safe_print(f"[i] '{active_ids_file}' dosyasından {len(active_ids)} adet aktif kayıt ID'si yüklendi.")

    # Scan directories
    all_folders = [f for f in os.listdir(source_dir) if os.path.isdir(os.path.join(source_dir, f))]
    
    # Filter folders
    folders_to_transfer = [f for f in all_folders if f in active_ids]
    
    safe_print(f"[i] Kaynak dizinde toplam {len(all_folders)} klasör tarandı.")
    safe_print(f"[+] Eşleşen ve aktarılacak ENS video klasörü sayısı: {len(folders_to_transfer)}")

    if not folders_to_transfer:
        safe_print(f"\n{Colors.WARNING}[!] Aktarılacak hiçbir eşleşen klasör bulunamadı.{Colors.ENDC}")
        return

    target_server = input(f"\n{Colors.BOLD}Hedef sunucu IP/Hostname (Varsayılan: 185.184.25.66): {Colors.ENDC}").strip() or "185.184.25.66"
    ssh_user = input(f"{Colors.BOLD}SSH Kullanıcı Adı (Varsayılan: root): {Colors.ENDC}").strip() or "root"
    ssh_port = input(f"{Colors.BOLD}SSH Portu (Varsayılan: 22): {Colors.ENDC}").strip() or "22"
    target_dir = input(f"{Colors.BOLD}Hedef kayıt dizini (Varsayılan: /var/bigbluebutton/published/presentation): {Colors.ENDC}").strip() or "/var/bigbluebutton/published/presentation"
    
    bw_limit_input = input(f"{Colors.BOLD}Bant Genişliği Sınırı (bwlimit) - KB/s (Varsayılan: Sınırsız): {Colors.ENDC}").strip()
    bw_limit = int(bw_limit_input) if bw_limit_input else None
    
    max_workers_input = input(f"{Colors.BOLD}Paralel Aktarım Kanal Sayısı (Varsayılan: 5): {Colors.ENDC}").strip()
    max_workers = int(max_workers_input) if max_workers_input else 5

    # Check for target remote state to see what is already completed
    safe_print("\n[i] Hedef sunucu ile bağlantı kuruluyor ve transfer geçmişi kontrol ediliyor...")
    remote_state = load_remote_state(target_server, ssh_user, ssh_port, target_dir)
    completed_folders_in_memory = set(remote_state.get("completed_folders", []))
    
    safe_print(f"{Colors.GREEN}[✔️] Bağlantı başarılı! {len(completed_folders_in_memory)} klasörün daha önce aktarıldığı tespit edildi.{Colors.ENDC}")
    
    # Filter out completed folders
    pending_folders = [f for f in folders_to_transfer if f not in completed_folders_in_memory]
    safe_print(f"🔄 Kalan aktarılacak klasör sayısı: {len(pending_folders)}")
    
    if not pending_folders:
        safe_print(f"\n{Colors.GREEN}[✔️] Harika! Aktarılacak bekleyen hiçbir klasör kalmadı. Tüm transferler tamam!{Colors.ENDC}")
        return

    confirm = input(f"\n{Colors.WARNING}Transferi başlatmak istiyor musunuz? (e/H): {Colors.ENDC}").strip().lower()
    if confirm != 'e':
        safe_print("[i] Transfer iptal edildi.")
        return

    start_time = time.time()
    success_count = len(completed_folders_in_memory)
    fail_count = 0
    
    # Create target directory on remote if it doesn't exist
    subprocess.run(
        ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"mkdir -p {target_dir}"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )

    safe_print(f"\n{Colors.BLUE}{Colors.BOLD}🚀 Transfer işlemi {max_workers} paralel kanal üzerinden başlatılıyor...{Colors.ENDC}\n")

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {
            executor.submit(
                transfer_single_folder, folder, source_dir, target_server, ssh_user, ssh_port, target_dir, bw_limit, max_workers
            ): folder for folder in pending_folders
        }
        
        for future in as_completed(futures):
            folder = futures[future]
            try:
                success, error = future.result()
                if success:
                    success_count += 1
                else:
                    fail_count += 1
            except Exception as e:
                safe_print(f"{Colors.FAIL}[❌] {folder} beklenmedik hata nedeniyle elendi: {e}{Colors.ENDC}")
                fail_count += 1
                
            completed = success_count + fail_count
            total = len(folders_to_transfer)
            percent = (completed / total) * 100
            safe_print(f"{Colors.BOLD}[İLERLEME] {completed}/{total} tamamlandı (%{percent:.1f}) | Başarılı: {success_count} | Başarısız: {fail_count}{Colors.ENDC}")

    # Son olarak tüm /var/bigbluebutton/published/presentation klasörünün izinlerini hedefte bir kez daha topluca düzeltelim
    safe_print(f"\n[i] Hedef sunucuda genel klasör izinleri düzeltiliyor...")
    subprocess.run(
        ["ssh", "-p", ssh_port, "-o", "StrictHostKeyChecking=no", f"{ssh_user}@{target_server}", f"chown -R bigbluebutton:bigbluebutton {target_dir}"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )

    end_time = time.time()
    elapsed_time = end_time - start_time
    hours, rem = divmod(elapsed_time, 3600)
    minutes, seconds = divmod(rem, 60)

    safe_print(f"\n{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
    safe_print(f"{Colors.GREEN}{Colors.BOLD}🏁 TRANSFER İŞLEMİ TAMAMLANDI!{Colors.ENDC}")
    safe_print(f"{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}")
    safe_print(f"⏱️ Toplam Geçen Süre: {int(hours):02d}:{int(minutes):02d}:{int(seconds):02d}")
    safe_print(f"📊 Toplam Klasör Sayısı: {len(folders_to_transfer)}")
    safe_print(f"✅ Başarılı Aktarım     : {success_count}")
    safe_print(f"❌ Başarısız Aktarım    : {fail_count}")
    
    if fail_count > 0:
        safe_print(f"{Colors.WARNING}[!] Bazı klasörler aktarılamadı. Detayları hedef sunucudaki '{target_dir}/recordingslog.txt' dosyasında görebilirsiniz.{Colors.ENDC}")
    safe_print(f"{Colors.GREEN}{Colors.BOLD}============================================================{Colors.ENDC}\n")

def main():
    print_banner()
    while True:
        safe_print(f"\n{Colors.BOLD}--- ANA MENÜ ---{Colors.ENDC}")
        safe_print("1. SSH & Çevre Kurulumu Yap (Sadece ilk kez)")
        safe_print("2. Kayıt Transferini Başlat (ENS / turkceoabtdeyiz.okinar.com)")
        safe_print("3. Çıkış")
        
        choice = input(f"\n{Colors.BOLD}Seçiminiz (1/2/3): {Colors.ENDC}").strip()
        
        if choice == '1':
            setup_environment()
        elif choice == '2':
            transfer_records()
        elif choice == '3':
            safe_print("\nGörüşmek üzere kanka!")
            break
        else:
            safe_print(f"\n{Colors.FAIL}[!] Geçersiz seçim. Lütfen tekrar deneyin.{Colors.ENDC}")

if __name__ == "__main__":
    import sys
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    main()
