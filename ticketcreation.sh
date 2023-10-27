#!/bin/bash

# Use Jenkins credentials
Username=$(curl -s --user anil123:API_TOKEN http://192.168.0.109:8080/credentials/store/system/domain/_/api/json | jq -r '.credentials[0].username')
Password=$(curl -s --user anil123:API_TOKEN http://192.168.0.109:8080/credentials/store/system/domain/_/api/json | jq -r '.credentials[0].password')

echo "ticket creation"

# Capture the response from the Jira API
response="$(time curl -v -u $Username:$Password -X POST -H "Content-Type: application/json" http://lina-j-loadb-jffut0okjfjc-1151237937.us-east-2.elb.amazonaws.com/rest/api/2/issue/ -d '{
     "fields": {
        "project": {
             "key": "LINA"
         },
        "issuetype": {
             "name": "Story"
         },
        "summary": "testing create ticket",
        "description": "testing create ticket",
        "assignee": {
            "name": "MaheshK"
        }
     }
}' 2>/dev/null)"

# Log the entire response for debugging
echo "API Response: $response"

# Check for HTTP status code
http_status=$(echo "$response" | grep -o 'HTTP/1.1 [0-9]*' | awk '{print $2}')
if [ $http_status -ne 200 ]; then
    echo "HTTP Status Code: $http_status"
    echo "API Request Failed."
    exit 1
fi

# Extract the issue key
KEY="$(echo $response | grep -o '"key": *"[^"]*"' | grep -o '"[^"]*"$' | sed "s/\"//g")"
echo "Issue Key: $KEY"

echo "*********Issue comment***********"
time curl --silent -u $Username:$Password -X POST -H "Content-Type: application/json" http://lina-j-loadb-jffut0okjfjc-1151237937.us-east-2.elb.amazonaws.com/rest/api/2/issue/$KEY/comment -d '{
    "body": "adding comment from REST api."
}' > /dev/null
