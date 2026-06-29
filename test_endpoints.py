import socket

domains = [
    "turkceoabtdeyiz.okinar.com",
    "dereceuzem.okinar.com",
    "akademikmasa.okinar.com",
    "ataniyorumhocam.okinar.com",
    "omurhoca.okinar.com",
    "4tuzem.okinar.com"
]

print("Resolving LMS domains...")
for domain in domains:
    try:
        ip = socket.gethostbyname(domain)
        print(f"Domain: {domain} -> IP: {ip}")
    except Exception as e:
        print(f"Domain: {domain} -> Error: {e}")
