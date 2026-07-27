import os
import re

files = [f for f in os.listdir('.') if f.startswith('docker-compose.') and f.endswith('.yml')]

print("Found compose files:", files)

for filepath in files:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # We want to add the volume to 'admin' and 'student' services.
    # We will use regex to find 'admin:' and 'student:' services and add the volume mount.
    
    # 1. Modify 'admin:' service
    # Find 'admin:' and find its next 'networks:' or next service/volumes section
    admin_match = re.search(r'(\s+)admin:\s*\n(.*?)(?=\n\s*\w+:|\Z)', content, re.DOTALL)
    if admin_match:
        indent = admin_match.group(1)
        body = admin_match.group(2)
        if './logo.png' not in body:
            # Check if volumes section already exists in admin
            if 'volumes:' in body:
                # Add it to existing volumes
                new_body = re.sub(
                    r'(\s+)volumes:\s*\n',
                    r'\1volumes:\n\1  - ./logo.png:/app/public/logo.png\n',
                    body,
                    count=1
                )
            else:
                # Create volumes section
                new_body = body + f"\n{indent}  volumes:\n{indent}    - ./logo.png:/app/public/logo.png"
            
            content = content.replace(admin_match.group(0), f"{indent}admin:\n{new_body}")

    # 2. Modify 'student:' service
    student_match = re.search(r'(\s+)student:\s*\n(.*?)(?=\n\s*\w+:|\Z)', content, re.DOTALL)
    if student_match:
        indent = student_match.group(1)
        body = student_match.group(2)
        if './logo.png' not in body:
            if 'volumes:' in body:
                new_body = re.sub(
                    r'(\s+)volumes:\s*\n',
                    r'\1volumes:\n\1  - ./logo.png:/app/public/logo.png\n',
                    body,
                    count=1
                )
            else:
                new_body = body + f"\n{indent}  volumes:\n{indent}    - ./logo.png:/app/public/logo.png"
            
            content = content.replace(student_match.group(0), f"{indent}student:\n{new_body}")

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Updated {filepath}")
