import urllib.parse
import hashlib

secret = "FQMXtW5wg7AiXkZxtxVLXMfvUevmLqCYRhe9sD67BE"
bbb_url = "https://canli.3u.muro.click/bigbluebutton/api"
callback_url = "https://3u-ap.muro.click/api/v1/bbb/webhook/events"

# Url encode the callback URL
escaped_callback = urllib.parse.quote(callback_url, safe='')

# Construct query string
qs = f"callbackURL={escaped_callback}"

# Construct data to hash
# Formula: hooks/create + query_string + shared_secret
data_to_hash = f"hooks/create{qs}{secret}"

# SHA-1 hash (as per bbb-webhooks standard)
hash_object = hashlib.sha1(data_to_hash.encode('utf-8'))
checksum = hash_object.hexdigest().lower()

# Construct final URL
final_url = f"{bbb_url}/hooks/create?{qs}&checksum={checksum}"

print(f"CALCULATED URL: {final_url}")
