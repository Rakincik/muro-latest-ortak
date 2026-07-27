import urllib.request
import json
import ssl

def main():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    
    url = "http://localhost:5292/api/v1/courses?pageSize=1000"
    print(f"Calling API: {url}")
    try:
        req = urllib.request.Request(url)
        # We need tenant header
        # In core.ts: headers["X-Tenant-Id"] = finalTenantId
        # Wait, since it's database-per-tenant, what tenant header is needed?
        # Let's check without headers first
        with urllib.request.urlopen(req, context=ctx) as response:
            data = json.loads(response.read().decode('utf-8'))
            items = data.get('items', [])
            print(f"API returned {len(items)} courses.")
            for c in items:
                title = c.get('title')
                session_cnt = c.get('sessionCount')
                if 'REHBER' in title or session_cnt > 0:
                    print(f"  - {title}: {session_cnt} sessions (ID: {c.get('id')})")
    except Exception as e:
        print(f"API request failed: {e}")

if __name__ == "__main__":
    main()
