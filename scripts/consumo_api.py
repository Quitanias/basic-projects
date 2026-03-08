import requests
import sys

url = "https://api.github.com/users/hashicorp/repos"

try:
    # A 5-second timeout is a rule in DevOps
    response = requests.get(url, timeout=5)
    
    # raise_for_status() is a shortcut from requests.
    # If the status code is 4XX or 5XX, it automatically raises an error and goes to 'except'
    response.raise_for_status() 
    
    data = response.json()
    
    for item in data:
        # Using the .get() method for safety, in case the 'name' key is missing from the API
        name = item.get('name', '')
        if 'terraform' in name:
            print(f"Name: {item['name']}")
            print(f"URL: {item['html_url']}") 

# Catches any network error (Timeout, DNS failure, 500 Error, etc.)
except requests.exceptions.RequestException as e:
    print(f"[CRITICAL] Failed to communicate with GitHub API: {e}")
    sys.exit(1) # Forces the script to fail so the CI/CD pipeline stops