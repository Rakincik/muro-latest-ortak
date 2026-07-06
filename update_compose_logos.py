import os
import re

files = [f for f in os.listdir('.') if f.startswith('docker-compose.') and f.endswith('.yml')]

print("Updating logo paths in compose files to absolute /opt/<tenant>/logo.png paths...")
for filepath in files:
    if filepath in ['docker-compose.prod.yml', 'docker-compose.render.yml', 'docker-compose.demo.yml']:
        continue
    # Extract tenant name, e.g. docker-compose.3u.yml -> 3u
    parts = filepath.split('.')
    if len(parts) >= 3:
        name = parts[1]
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Replace the volume mounts (both ./logo.png and ./logo_xxx.png) with /opt/{name}/logo.png
        # Find any mount pattern matching the logo destination and replace the source path
        new_content = re.sub(
            r'-\s+\S+logo(_\w+)?\.png:/app/public/logo\.png',
            f'- /opt/{name}/logo.png:/app/public/logo.png',
            content
        )
        
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filepath} to use /opt/{name}/logo.png")
