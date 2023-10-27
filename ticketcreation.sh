#!/bin/bash

Username="anil"
Password="Lina123@9A"

echo "ticket creation"

creation="$(time curl -u $Username:$Password -X POST -H "Content-Type: application/json" http://lina-j-loadb-jffut0okjfjc-1151237937.us-east-2.elb.amazonaws.com/rest/api/2/issue/ -d '{
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

KEY="$(echo $creation | grep -o '"key": *"[^"]*"' | grep -o '"[^"]*"$'| sed "s/\"//g")"
echo "$KEY"

echo "*********Issue comment***********"
time curl --silent -u $Username:$Password -X POST -H "Content-Type: application/json" http://lina-j-loadb-jffut0okjfjc-1151237937.us-east-2.elb.amazonaws.com/rest/api/2/issue/$KEY/comment -d '{
    "body": "adding comment from REST api."
}' > /dev/null