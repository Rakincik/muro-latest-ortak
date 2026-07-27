import os

def patch_file(path):
    if not os.path.exists(path):
        print(f"File not found: {path}")
        return

    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # 1. Add 3u mapping to getApiUrl if not present
    if "3u-ap.muro.click" not in content:
        old_str = "return `https://${sub}-api.muro.click/api/v1`;"
        new_str = "if (sub === \"3u\") {\n            return `https://3u-ap.muro.click/api/v1`;\n        }\n        return `https://${sub}-api.muro.click/api/v1`;"
        if old_str in content:
            content = content.replace(old_str, new_str)
            print(f"Added 3u mapping in: {path}")
        else:
            print(f"Warning: Could not find target getApiUrl return in {path}")

    # 2. Add runtime API_URL initialization inside api() function to bypass SWC static analysis
    dynamic_init = """
    if (typeof window !== "undefined" && API_URL.includes("localhost") && !window.location.hostname.includes("localhost")) {
        API_URL = getApiUrl();
        API_BASE = API_URL.replace("/api/v1", "");
    }
"""
    if "API_URL.includes(\"localhost\")" not in content:
        student_sig = "export async function api<T = unknown>(endpoint: string, options: FetchOptions = {}): Promise<T> {"
        admin_sig = "export async function api<T = unknown>(\n    endpoint: string,\n    options: FetchOptions = {}\n): Promise<T> {"
        
        if student_sig in content:
            content = content.replace(student_sig, student_sig + dynamic_init)
            print(f"Added dynamic initialization to student signature in: {path}")
        elif admin_sig in content:
            content = content.replace(admin_sig, admin_sig + dynamic_init)
            print(f"Added dynamic initialization to admin signature in: {path}")
        else:
            print(f"Warning: Could not find api() function signature in {path}")
    else:
        print(f"Dynamic initialization already present in: {path}")

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def main():
    patch_file("frontend/student/src/lib/api.ts")
    patch_file("frontend/admin/src/lib/api/core.ts")

if __name__ == "__main__":
    main()
