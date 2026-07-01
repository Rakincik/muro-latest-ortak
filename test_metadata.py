import paramiko
import xml.etree.ElementTree as ET

ip = "185.86.155.222"
# Prompt for SSH password
password = getpass.getpass("Enter SSH Password: ") if 'getpass' in globals() else "wSh2VNhTqBFM" # Using default for testing

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

try:
    ssh.connect(ip, username="root", password=password, timeout=15)
    
    # Let's inspect metadata.xml for the f2cbea88 folder
    folder = "f2cbea88fd85117b36715ad29b52afd6488b00e6-1741026716638"
    cmd = f"cat /var/bigbluebutton/published/presentation/{folder}/metadata.xml"
    stdin, stdout, stderr = ssh.exec_command(cmd)
    
    content = "".join(stdout)
    print("Metadata XML Content:")
    print(content)
    
except Exception as e:
    print(f"Error: {e}")
finally:
    ssh.close()
