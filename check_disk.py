import paramiko
import getpass

def main():
    print("=== Sunucu Disk Alanı Kontrolü ===")
    ip = input("Sunucu IP (Örn: 185.86.155.222): ").strip()
    password = getpass.getpass("Sunucu SSH Şifresi: ").strip()
    
    if not ip or not password:
        print("Hata: IP ve Şifre zorunludur.")
        return
        
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        ssh.connect(ip, username="root", password=password, timeout=10)
        stdin, stdout, stderr = ssh.exec_command("df -h")
        
        print("\n--- Disk Durumu ---")
        for line in stdout:
            print(line.strip())
            
    except Exception as e:
        print(f"Bağlantı Hatası: {e}")
    finally:
        ssh.close()

if __name__ == "__main__":
    main()
