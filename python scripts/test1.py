import requests
import json
import sys

url = "https://api.staging.drinkprime.in/auth/auth/customer/details//9876543210"

payload = {}
headers = {}

response = requests.request("GET", url, headers=headers, data=payload)

# --- API assertions ---
# 1) Status code
assert response.status_code == 200, f"Unexpected status code: {response.status_code}"

# 2) Content-Type is JSON
content_type = response.headers.get("Content-Type", "")
assert "application/json" in content_type.lower(), f"Unexpected Content-Type: {content_type}"

# 3) Response time check (optional)
assert response.elapsed.total_seconds() < 5, f"Response too slow: {response.elapsed.total_seconds()}s"

# 4) Body is valid JSON
try:
 data = response.json()
except ValueError:
    print("ERROR: Response is not valid JSON")
    print(response.text)
    sys.exit(1)

# 5) Basic structure / value checks
assert isinstance(data, dict), "Expected JSON object at root"

# Check that expected mobile appears somewhere in the JSON
expected_mobile = "9876543210"
assert expected_mobile in json.dumps(data), f"Expected mobile '{expected_mobile}' not found in response JSON"

# Add other key checks if you know the schema, e.g.:
# assert "customerId" in data, "customerId missing"
# assert data.get("mobile") == expected_mobile, "mobile mismatch"

# Pretty-print JSON for human-readable output
print(json.dumps(data, indent=2, ensure_ascii=False))

# --- Additional API call: purifierList ---
url2 = "https://api.staging.drinkprime.in/app/customerApp/purifierList?phone=9650195950"

payload2 = {}
headers2 = {}

response2 = requests.request("GET", url2, headers=headers2, data=payload2)

# Assertions for purifierList
assert response2.status_code == 200, f"PurifierList unexpected status code: {response2.status_code}"
content_type2 = response2.headers.get("Content-Type", "")
assert "application/json" in content_type2.lower(), f"PurifierList unexpected Content-Type: {content_type2}"
assert response2.elapsed.total_seconds() < 5, f"PurifierList response too slow: {response2.elapsed.total_seconds()}s"

try:
    data2 = response2.json()
except ValueError:
    print("ERROR: PurifierList response is not valid JSON")
    print(response2.text)
    sys.exit(1)

assert isinstance(data2, (list, dict)), "Expected JSON array or object for purifierList"
# assert expected_mobile in json.dumps(data2), "Expected phone not found in purifierList response"

print("\nPurifierList response:")
print(json.dumps(data2, indent=2, ensure_ascii=False))