#!/bin/bash

# Use Jenkins credentials
Username=$(curl -s --user anil123:API_TOKEN https://jenkins.example.com/credentials/store/system/domain/_/api/json | jq -r '.credentials[0].username')
Password=$(curl -s --user anil123:API_TOKEN https://jenkins.example.com/credentials/store/system/domain/_/api/json | jq -r '.credentials[0].password')

echo "ticket creation"

# Capture the response from the Jira API
response="$(curl -u $Username:$Password -X POST -H "Content-Type: application/json" http://lina-j-loadb-jffut0okjfjc-1151237937.us-east-2.elb.amazonaws.com/rest/api/2/issue/ -d '{
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

# Log the response
echo "API Response: $response"

# Extract the issue key
KEY="$(echo $response | grep -o '"key": *"[^"]*"' | grep -o '"[^"]*"$' | sed "s/\"//g")"
echo "Issue Key: $KEY"

echo "*********Issue comment***********"
time curl --silent -u $Username:$Password -X POST -H "Content-Type: application/json" http://lina-j-loadb-jffut0okjfjc-1151237937.us-east-2.elb.amazonaws.com/rest/api/2/issue/$KEY/comment -d '{
    "body": "adding comment from REST api."
}' > /dev/null