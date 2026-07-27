import subprocess

def flush_redis():
    try:
        print("[*] Doğru Redis konteyneri aranıyor...")
        output = subprocess.check_output(['docker', 'ps', '--format', '{{.Names}}']).decode('utf-8')
        containers = output.strip().split('\n')
        
        redis_container = None
        for c in containers:
            if 'muro' in c.lower() and 'redis' in c.lower():
                redis_container = c
                break
                
        if not redis_container:
            print("[-] Muro Redis konteyneri bulunamadı!")
            print("Mevcut konteynerler:")
            print(output)
            return
            
        print(f"[*] Muro Redis konteyneri bulundu: {redis_container}")
        
        # We might need authentication for redis. Try without first, if NOAUTH, we can't easily guess.
        # But Muro default redis might not have auth or has standard.
        try:
            flush_out = subprocess.check_output(['docker', 'exec', redis_container, 'redis-cli', 'FLUSHALL'], stderr=subprocess.STDOUT).decode('utf-8')
            if 'NOAUTH' in flush_out:
                print("[-] Redis şifre istiyor! Farklı bir yöntem deneyeceğiz.")
            else:
                print(f"[+] Çıktı: {flush_out.strip()}")
                print("[+] ZAFER! Muro önbelleği başarıyla temizlendi!")
        except subprocess.CalledProcessError as e:
            out = e.output.decode('utf-8')
            if 'NOAUTH' in out:
                print("[-] Redis şifre istiyor!")
            else:
                print(f"[-] Komut hatası: {out}")
        
    except Exception as e:
        print(f"[-] Hata oluştu: {e}")

if __name__ == "__main__":
    flush_redis()
