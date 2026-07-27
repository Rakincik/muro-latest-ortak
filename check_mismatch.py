import urllib.request
import json

base_url = "http://localhost:5298"

# 1. Log in
login_url = f"{base_url}/api/v1/auth/login"
login_data = {
    "email": "rustem@muro.com",
    "password": "123456"
}
req_login = urllib.request.Request(
    login_url,
    data=json.dumps(login_data).encode('utf-8'),
    headers={"Content-Type": "application/json"}
)

try:
    print(f"Logging in to: {login_url}")
    with urllib.request.urlopen(req_login) as resp_login:
        login_res = json.loads(resp_login.read().decode('utf-8'))
        token = login_res.get("token")
        print("Login successful! Token obtained.")
except Exception as e:
    print(f"Login failed: {e}")
    if hasattr(e, 'read'):
        print(f"Error detail: {e.read().decode('utf-8')}")
    exit(1)

# 2. Get direct courses
courses_url = f"{base_url}/api/v1/users/b015e34b-14fa-4fc6-bc25-3211ee40a022/courses/direct"
req_courses = urllib.request.Request(
    courses_url,
    headers={
        "Authorization": f"Bearer {token}",
        "X-Tenant-Id": "some-tenant-id"  # optional but let's provide if needed
    }
)

try:
    print(f"Calling: {courses_url}")
    with urllib.request.urlopen(req_courses) as resp_courses:
        courses_res = json.loads(resp_courses.read().decode('utf-8'))
        print(f"Courses response status: {resp_courses.getcode()}")
        print(f"Type of response: {type(courses_res)}")
        if isinstance(courses_res, list):
            print(f"Number of items in list: {len(courses_res)}")
            if len(courses_res) > 0:
                print(f"First item: {json.dumps(courses_res[0], indent=2, ensure_ascii=False)}")
        else:
            print(f"Response: {json.dumps(courses_res, indent=2, ensure_ascii=False)}")
except Exception as e:
    print(f"Courses call failed: {e}")
    if hasattr(e, 'read'):
        print(f"Error detail: {e.read().decode('utf-8')}")
