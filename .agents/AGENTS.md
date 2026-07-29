# MURO Project Rules

## BBB Server & Tenant Setup (Webhook Registration)

Whenever the user asks to set up a new BigBlueButton (BBB) server for a new tenant or asks why recordings are not dropping to the panel, ALWAYS follow these 4 steps in order:

### 1. Check LogoutURL
In `docker-compose.<tenant>.yml`, ensure `Bbb__Defaults__LogoutURL` is hardcoded and NOT using variables like `${ADMIN_URL}` which cause the "Siteye Ulaşılamıyor" error when a lesson ends.
Example: `- Bbb__Defaults__LogoutURL=https://<tenant-panel>.muro.click/dashboard/courses`

### 2. Check WebhookSharedSecret Indentation & Value
In `docker-compose.<tenant>.yml`, ensure `Bbb__WebhookSharedSecret` exactly matches the actual BBB secret. Ensure the `-` is properly indented with spaces (no tabs), exactly aligned with other environment variables.

### 3. Install bbb-webhooks on the BBB Server
The BBB server might be missing the webhook module. The user MUST run this on the BBB server via SSH:
```bash
apt-get update && apt-get install bbb-webhooks -y
```

### 4. Register the API Webhook on the BBB Server
The API endpoint is `https://<tenant-api>.muro.click/api/v1/bbb/webhook/events` (Do NOT forget the `/events` suffix!).
Instead of manually calculating the SHA1 checksum, provide the user with this exact script to run on their BBB server. It will automatically fetch the BBB secret, calculate the checksum, and register the webhook:

```bash
API_URL="https://<tenant-api>.muro.click/api/v1/bbb/webhook/events"

SECRET=$(bbb-conf --secret | grep "Secret:" | awk '{print $2}')
BBB_URL=$(bbb-conf --secret | grep "URL:" | awk '{print $2}')
STRING_TO_HASH="hooks/createcallbackURL=${API_URL}${SECRET}"
CHECKSUM=$(echo -n "$STRING_TO_HASH" | sha1sum | awk '{print $1}')

curl -s "${BBB_URL}api/hooks/create?callbackURL=${API_URL}&checksum=${CHECKSUM}"
```

If the result is `<response><returncode>SUCCESS</returncode>...`, the webhook is successfully registered and recordings will drop instantly.

### 5. Troubleshooting "Checksums do not match" & Nginx Crashes
If the API throws a 400 Bad Request (`Checksums do not match`) or Nginx refuses to start on the BBB server, ALWAYS check these 3 critical pitfalls:
- **Invisible Windows Line Endings (\r) in `.env`**: If the `.env` file was edited/uploaded from Windows, it may have invisible `\r` characters at the end of the `BBB_SECRET`. The API reads `SECRET\r` and fails the checksum. 
  - **Fix**: Run `sed -i 's/\r$//' /opt/<tenant>/.env` on the CyberPanel server and recreate the container (`docker compose down` && `docker compose up -d`).
- **BBB Server Secret Sync Failure**: Even if `bbb-conf --secret` shows the correct secret, BBB's internal services (bbb-web) might still be using the old one in RAM.
  - **Fix**: Force sync it by running `bbb-conf --setsecret <NEW_SECRET>` on the BBB server, and then ALWAYS run `bbb-conf --restart` afterwards.
- **Certbot Nginx Port Conflict**: Certbot often injects a `listen 443` block into the Nginx `default` site, crashing Nginx because HAProxy/BBB already uses port 443. 
  - **Fix**: Check `nginx -t`. If it shows conflicts, run `rm /etc/nginx/sites-enabled/default && systemctl restart nginx`.
