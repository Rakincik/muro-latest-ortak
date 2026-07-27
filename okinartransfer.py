import os
import subprocess
from datetime import datetime

def log_error(folder_name, error_message=""):
    """Başarısız transferleri detaylarıyla birlikte recordingslog.txt dosyasına yazar."""
    log_file = "recordingslog.txt"
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open(log_file, "a", encoding="utf-8") as f:
            f.write(f"[{timestamp}] HATA - Gönderilemeyen Klasör: {folder_name}\n")
            if error_message:
                f.write(f"Hata Detayı:\n{error_message}\n")
            f.write("-" * 50 + "\n")
    except Exception as e:
        print(f"Log yazılamadı: {e}")

def setup_environment():
    """Rsync kurar ve şifresiz SSH bağlantısı için anahtar oluşturup hedef sunucuya kopyalar."""
    print("\n--- 1. Aşama: Rsync Kurulumu ---")
    try:
        print("Sistem paketleri güncelleniyor ve rsync kuruluyor... (Sudo şifreniz istenebilir)")
        subprocess.run(["sudo", "apt-get", "update"], check=True)
        subprocess.run(["sudo", "apt-get", "install", "-y", "rsync"], check=True)
        print("[+] Rsync başarıyla kuruldu veya zaten mevcut.")
    except subprocess.CalledProcessError:
        print("[-] HATA: Rsync kurulumu başarısız oldu. Sudo yetkilerinizi kontrol edin.")
        return

    print("\n--- 2. Aşama: Şifresiz SSH Bağlantı (Key Authentication) Kurulumu ---")
    ssh_key_path = os.path.expanduser("~/.ssh/id_rsa")
    
    # SSH anahtarı var mı kontrol et, yoksa oluştur
    if not os.path.exists(ssh_key_path):
        print("SSH anahtarı bulunamadı, yeni bir tane oluşturuluyor...")
        try:
            # -N "" ile şifresiz bir anahtar oluşturuyoruz
            subprocess.run(["ssh-keygen", "-t", "rsa", "-b", "4096", "-N", "", "-f", ssh_key_path], check=True)
            print("[+] SSH anahtarı başarıyla oluşturuldu.")
        except subprocess.CalledProcessError:
            print("[-] HATA: SSH anahtarı oluşturulamadı.")
            return
    else:
        print("[+] Mevcut SSH anahtarı bulundu, yeniden oluşturmaya gerek yok.")

    # Anahtarı hedef sunucuya kopyala
    target_server = input("\nAnahtarın kopyalanacağı HEDEF sunucu IP veya Hostname: ").strip()
    ssh_user = input("Hedef sunucu SSH Kullanıcı Adı (Örn: root): ").strip()
    ssh_port = input("Hedef sunucu SSH Portu (Varsayılan: 22): ").strip() or "22"
    
    print(f"\nAnahtar {ssh_user}@{target_server}:{ssh_port} adresine kopyalanıyor...")
    print("NOT: Lütfen istendiğinde hedef sunucunun SSH şifresini girin. (Bu şifre son kez sorulacaktır)")
    
    try:
        subprocess.run(["ssh-copy-id", "-p", ssh_port, f"{ssh_user}@{target_server}"], check=True)
        print("\n[+] MÜKEMMEL! Şifresiz bağlantı başarıyla kuruldu.")
        print("Artık 2. seçeneği kullanarak transfer işlemlerini hiçbir şifre girmeden yapabilirsiniz.")
    except subprocess.CalledProcessError:
        print("\n[-] HATA: Anahtar hedef sunucuya kopyalanamadı. IP, Kullanıcı Adı, Port veya Şifreyi kontrol edin.")

def list_directories():
    """Belirtilen dizindeki klasörleri bulur ve metin dosyasına kaydeder."""
    path = input("\nLütfen taranacak dizinin tam yolunu girin (Örn: /var/bigbluebutton/published/presentation): ").strip()
    
    if not os.path.exists(path):
        print(f"\nHATA: '{path}' adında bir dizin bulunamadı.")
        return

    try:
        folders = [f for f in os.listdir(path) if os.path.isdir(os.path.join(path, f))]
        
        if not folders:
            print("\nBelirtilen dizinde hiçbir klasör bulunamadı.")
            return

        output_file = "klasor_listesi.txt"
        with open(output_file, "w", encoding="utf-8") as f:
            for folder in folders:
                f.write(folder + "\n")
                
        print(f"\nBAŞARILI: {len(folders)} adet klasör '{output_file}' dosyasına alt alta kaydedildi.")
    except Exception as e:
        print(f"\nBeklenmeyen bir hata oluştu: {e}")

def transfer_records():
    """Klasörleri SSH (rsync) üzerinden hedef sunucuya aktarır ve hataları loglar."""
    source_dir = input("\nTransfer edilecek klasörlerin bulunduğu kaynak dizini girin: ").strip()
    
    if not os.path.exists(source_dir):
        print(f"\nHATA: Kaynak dizin '{source_dir}' bulunamadı.")
        return

    target_server = input("Hedef sunucu IP veya Hostname: ").strip()
    ssh_user = input("SSH Kullanıcı Adı (Örn: root): ").strip()
    ssh_port = input("SSH Portu (Varsayılan: 22): ").strip() or "22"
    target_dir = input("Hedef sunucu kayıt dizini (Varsayılan: /var/bigbluebutton/published/newrecords): ").strip() or "/var/bigbluebutton/published/newrecords"
    
    bw_limit = input("Bant genişliği limiti (KB/s cinsinden, Örn: 5000 (5MB/s), Limitsiz için boş bırakın): ").strip()

    folders = [f for f in os.listdir(source_dir) if os.path.isdir(os.path.join(source_dir, f))]

    if not folders:
        print("\nKaynak dizinde transfer edilecek klasör bulunamadı.")
        return

    print(f"\nToplam {len(folders)} klasör {target_server} sunucusuna aktarılıyor...\n")

    for i, folder in enumerate(folders, 1):
        full_path = os.path.join(source_dir, folder)
        print("="*60)
        print(f"[{i}/{len(folders)}] Transfer Başlıyor: {folder}")
        print("="*60)
        
        # rsync komutunu hazırlayalım
        cmd = [
            "rsync", "-avz", "--progress",
            "-e", f"ssh -p {ssh_port} -o StrictHostKeyChecking=no",
        ]
        
        if bw_limit:
            cmd.append(f"--bwlimit={bw_limit}")
            
        cmd.extend([full_path, f"{ssh_user}@{target_server}:{target_dir}"])

        # stdout terminale doğrudan akarken, olası hataları yakalamak için stderr'i pipe yapıyoruz.
        # Bu sayede rsync'in kendi ilerleme çubuğu (progress bar) ekranda canlı görünür.
        process = subprocess.Popen(cmd, stderr=subprocess.PIPE, text=True)
        _, stderr_output = process.communicate()

        if process.returncode == 0:
            print(f"\n[+] BAŞARILI: {folder} başarıyla aktarıldı.\n")
        else:
            print(f"\n[-] HATA: {folder} aktarılamadı! Hata günlüğe yazılıyor...\n")
            log_error(folder, stderr_output)
            
    print("\nTransfer işlemi tamamlandı. Hata durumlarını 'recordingslog.txt' dosyasından kontrol edebilirsiniz.")

def main():
    print("="*55)
    print("      Okinar Recording Transfer - Ana Menü      ")
    print("="*55)

    while True:
        print("\nLütfen yapmak istediğiniz işlemi seçin:")
        print("  [1] Dizin içindeki klasör adlarını metin belgesine kaydet")
        print("  [2] Kayıtları SSH ile hedef sunucuya aktar (ve hataları logla)")
        print("  [3] Sunucu Ortamını Kur (Rsync Kurulumu + Şifresiz SSH Ayarı)")
        print("  [0] Çıkış")

        choice = input("\nSeçiminiz (1/2/3/0): ").strip()

        if choice == '1':
            list_directories()
        elif choice == '2':
            transfer_records()
        elif choice == '3':
            setup_environment()
        elif choice == '0':
            print("\nProgramdan çıkılıyor. İyi çalışmalar!\n")
            break
        else:
            print("\nGeçersiz seçim. Lütfen tekrar deneyin.")

if __name__ == "__main__":
    import sys
    import io
    # Konsol çıktılarının UTF-8 uyumlu olmasını güvenceye alıyoruz
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    main()
