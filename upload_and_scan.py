import paramiko
import getpass
import os

def main():
    print("=== BBB Remote Scanner & Downloader ===")
    
    server_ip = input("Sunucu IP (Örn: 185.86.155.222): ").strip()
    server_pass = getpass.getpass("Sunucu SSH Şifresi: ").strip()
    
    if not server_ip or not server_pass:
        print("Hata: IP ve Şifre girmek zorunludur.")
        return
        
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        print(f"\n1. [{server_ip}] Sunucusuna bağlanılıyor...")
        ssh.connect(server_ip, username="root", password=server_pass, timeout=15)
        
        # SFTP ile bbb_scanner.py dosyasını yükle
        print("2. 'bbb_scanner.py' sunucuya yükleniyor...")
        sftp = ssh.open_sftp()
        sftp.put("bbb_scanner.py", "/root/bbb_scanner.py")
        sftp.close()
        
        # Sunucuda tarama scriptini çalıştır
        print("3. Sunucuda tarama başlatıldı (Klasör sayısına göre 1-2 dakika sürebilir)...")
        stdin, stdout, stderr = ssh.exec_command("python3 /root/bbb_scanner.py")
        
        # Logları ekrana yazdır
        for line in stdout:
            print(f"   [Server] {line.strip()}")
            
        # Hata çıktılarını kontrol et
        err = "".join(stderr)
        if err:
            print(f"⚠️ Sunucu Hatası/Logu: {err}")
            
        # SFTP ile oluşan bbb_metadata.json dosyasını geri indir
        print("4. Tarama sonuçları (bbb_metadata.json) bilgisayara indiriliyor...")
        sftp = ssh.open_sftp()
        local_output = f"bbb_metadata_{server_ip}.json"
        sftp.get("/root/bbb_metadata.json", local_output)
        sftp.close()
        
        # Sunucudaki geçici dosyaları temizle
        print("5. Sunucudaki geçici dosyalar temizleniyor...")
        ssh.exec_command("rm -f /root/bbb_scanner.py /root/bbb_metadata.json")
        
        print(f"\n✔️ BAŞARILI! '{local_output}' dosyası bilgisayarınıza indirildi.")
        
    except Exception as e:
        print(f"❌ İşlem sırasında hata oluştu: {e}")
    finally:
        ssh.close()

if __name__ == "__main__":
    main()
