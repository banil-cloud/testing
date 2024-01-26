import os
import requests
from requests.auth import HTTPBasicAuth

jira_url = os.environ.get("http://lb-620059437.us-east-2.elb.amazonaws.com:8080")
username = os.environ.get("JIRA_USERNAME")
api_token = os.environ.get("JIRA_API_TOKEN")

project_name = os.environ.get("PROJECT_NAME")
project_key = os.environ.get("PROJECT_KEY")

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
    auth=HTTPBasicAuth(username, api_token),
    headers={"Content-Type": "application/json"},
)

if response.status_code == 200:
    print(f"Project '{project_name}' with key '{project_key}' cloned successfully.")
else:
    print(f"Failed to clone project. Error: {response.text}")
