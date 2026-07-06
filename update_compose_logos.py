import os
import re

files = [f for f in os.listdir('.') if f.startswith('docker-compose.') and f.endswith('.yml')]

print("Updating logo paths in compose files...")
for filepath in files:
    if filepath in ['docker-compose.prod.yml', 'docker-compose.render.yml', 'docker-compose.demo.yml']:
        continue
    # Extract tenant name, e.g. docker-compose.3u.yml -> 3u
    parts = filepath.split('.')
    if len(parts) >= 3:
        name = parts[1]
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Replace './logo.png' with './logo_{name}.png'
        # e.g. './logo.png:/app/public/logo.png' -> './logo_3u.png:/app/public/logo.png'
        new_content = content.replace('./logo.png:', f'./logo_{name}.png:')
        
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filepath} to use ./logo_{name}.png")
