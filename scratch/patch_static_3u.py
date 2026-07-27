import os

def clean_and_static_patch(path):
    if not os.path.exists(path):
        print(f"File not found: {path}")
        return

    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # 1. Remove the dynamic_init we added inside api()
    dynamic_init = """
    if (typeof window !== "undefined" && API_URL.includes("localhost") && !window.location.hostname.includes("localhost")) {
        API_URL = getApiUrl();
        API_BASE = API_URL.replace("/api/v1", "");
    }
"""
    if dynamic_init in content:
        content = content.replace(dynamic_init, "")
        print(f"Removed dynamic_init from: {path}")

    # 2. Replace API_URL and API_BASE initialization blocks with clean static ones
    # We want to replace the whole block starting from export let API_URL up to the end of window check
    import re
    # Match:
    # export let API_URL = ...;
    # if (typeof window !== "undefined") { ... }
    # export let API_BASE = ...;
    # if (typeof window !== "undefined") { ... }
    pattern = r'export let API_URL\s*=\s*[^;]+;.*?if\s*\(\s*typeof window !== "undefined"\s*\)\s*\{[^}]+\}.*?export let API_BASE\s*=\s*[^;]+;.*?if\s*\(\s*typeof window !== "undefined"\s*\)\s*\{[^}]+\}'
    replacement = 'export let API_URL = "https://3u-ap.muro.click/api/v1";\nexport let API_BASE = "https://3u-ap.muro.click";'
    
    new_content, count = re.subn(pattern, replacement, content, flags=re.DOTALL)
    if count > 0:
        content = new_content
        print(f"Replaced API_URL/API_BASE blocks with clean static ones in: {path}")
    else:
        # Fallback if whitespace differs:
        # Let's search and replace specifically:
        print(f"Regex match failed in {path}, trying manual replacement...")
        # We will do a targeted replace for the exact lines
        lines = content.split('\n')
        new_lines = []
        skip = False
        skip_count = 0
        for line in lines:
            if 'export let API_URL' in line:
                new_lines.append('export let API_URL = "https://3u-ap.muro.click/api/v1";')
                skip = True
                continue
            if 'export let API_BASE' in line:
                new_lines.append('export let API_BASE = "https://3u-ap.muro.click";')
                skip = True
                continue
            if skip:
                if '}' in line:
                    skip_count += 1
                    if skip_count >= 2:
                        skip = False
                continue
            new_lines.append(line)
        content = '\n'.join(new_lines)
        print(f"Manually replaced API_URL/API_BASE blocks in: {path}")

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def main():
    clean_and_static_patch("frontend/student/src/lib/api.ts")
    clean_and_static_patch("frontend/admin/src/lib/api/core.ts")

if __name__ == "__main__":
    main()
