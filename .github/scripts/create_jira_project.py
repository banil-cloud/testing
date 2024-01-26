import sys
import requests
from requests.auth import HTTPBasicAuth

# Check if the required number of command line arguments is provided
if len(sys.argv) != 4:
    print("Usage: python create_jira_project.py <JIRA_URL> <JIRA_USERNAME> <JIRA_API_TOKEN>")
    sys.exit(1)

jira_url = sys.argv[1]
username = sys.argv[2]
api_token = sys.argv[3]

project_name = os.environ.get("PROJECT_NAME")
project_key = os.environ.get("PROJECT_KEY")

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
