#!/bin/bash

# slack webhook url
url='https://your-slack-webhook-url' ## Change this!
# username from which messages are coming from
username='Zabbix'
# current times
time=$(date +%s)

# define which channel to send and parse information from subject
channel="$1"
subject=$(echo $2|cut -d'|' -f1)
severity=$(echo $2|cut -d'|' -f2)
server=$(echo $2|cut -d'|' -f3)
eventtime=$(echo $2| cut -d '|' -f4)

# set alert message type
if [ "$subject" == 'RECOVERY' ]; then
        type="R"
elif [ "$subject" == 'PROBLEM' ]; then
        type="P"
else
        type="N"
fi


# define color and subjects based on message type
if ([ $type == 'P' ] && [ $severity == '(Warning)' ]) || ([ $type == 'P' ] && [ $severity == '(Average)' ]); then
        color="warning"
        status="$subject:"
elif ([ $type == 'P' ] && [ $severity == '(High)' ]) || ([ $type == 'P' ] && [ $severity == '(Disaster)' ]); then
        color="danger"
        status="$subject:"
elif [ $type == 'P' ] && [ $severity == '(Information)' ] ; then
        color="#808080"
        status="$subject:"
elif [ $type == 'R' ]; then
        color="good"
        status="$subject:"
        severity="was $severity - started on: $eventtime"
else
        color="#808080"
        status="N/A"
fi

# message sent by zabbix
message="$3"

# compose payload for slack hook
payload="payload={
        \"channel\": \"${channel}\",
        \"username\": \"${username}\",
        \"attachments\": [
           {
                \"title\": \"${status} ${server}\",
                \"fallback\": \"${message}\",
                        \"fields\": [
                        {
                                \"title\": \"Message:\",
                                \"value\": \"${message}\",
                                \"short\": false
                        },
                        {
                                \"title\": \"Priority\",
                                \"value\": \"${severity}\",
                                \"short\": false
                        }
                        ],
                \"color\": \"${color}\",
                \"ts\": \"${time}\",
                \"mrkdwn_in\": [ \"text\" ]
            },
        ] }"

# send payload
/usr/bin/curl -k -m 5 --data-urlencode "${payload}" $url
