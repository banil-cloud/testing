import sys
import os
import requests
import base64

# Check if the required number of command line arguments is provided
if len(sys.argv) != 3:
    print("Usage: python create_jira_project.py <JIRA_URL> <JIRA_USERNAME> <JIRA_API_TOKEN>")
    sys.exit(1)

project_name = sys.argv[1]
project_key = sys.argv[2]

jira_url = os.environ.get("JIRA_URL")
username = os.environ.get("JIRA_USERNAME")
api_token = os.environ.get("JIRA_API_TOKEN")

# Manually handle authentication by constructing the Authorization header
auth_header = f"Basic {base64.b64encode(f'{username}:{api_token}'.encode()).decode()}"

api_url = f"{jira_url}/rest/scriptrunner/latest/canned/com.onresolve.scriptrunner.canned.jira.admin.CopyProject"

payload = {
    "FIELD_SOURCE_PROJECT": "BAS",
    "FIELD_TARGET_PROJECT": project_key,
    "FIELD_TARGET_PROJECT_NAME": project_name,
    "canned-script": "com.onresolve.scriptrunner.canned.jira.admin.CopyProject",
}

response = requests.post(
    api_url,
    json=payload,
    headers={"Content-Type": "application/json", "Authorization": auth_header},
)

if response.status_code == 200:
    print(f"Project '{project_name}' with key '{project_key}' cloned successfully.")
else:
    print(f"Failed to clone project. Error: {response.text}")
