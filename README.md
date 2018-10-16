# Zabbix slack notifications

Simple script to send alert/recovery notifications to slack from zabbix.

#### Installation

Copy `slack.sh` to your zabbix servers alertscripts directory. Usually this is at `/usr/lib/zabbix/alertscripts`

Edit `url` variable from the beginning of the script to match your slack hook url. If you don't have one already, check out: https://api.slack.com/incoming-webhooks

----

Add a new media type in zabbix server web ui:

`Administration` -> `Media types` -> `Create media type`

Name: Slack
Type: Script
Script name: `slack.sh`
Add three script parameters in this order:
`{ALERT.SENDTO}`
`{ALERT.SUBJECT}`
`{ALERT.MESSAGE}`

Add media.

![Media type](http://yawn.fi/zabbix-slack/zabbix-media-type.png "Media type")

----

Next we need to configure action which uses our new media type.

`Configuration` -> `Actions` -> `Create action`

Name: `Slack`

Add new condition:
Problems is suppressed - `No`

![Action1](http://yawn.fi/zabbix-slack/zabbix-action1.png "Action1")

Hit add and move to `Operations` tab

Default operation step duration: 1h
Default subject: `PROBLEM|({TRIGGER.SEVERITY})|{HOST.NAME1}`
Default message: `{TRIGGER.NAME} | Item value: {ITEM.VALUE1}`
Tick `Pause operations for suppressed problems`

Create new operation:

Steps: `1 - 1`
Step duration: `0`
Operation type: `Send message`
Add users or groups as you wish (usually admin group, or just admin user)
Send only to: `Slack`
Hit add for the operation

![Action2](http://yawn.fi/zabbix-slack/zabbix-action2.png "Action2")

Move to `Recovery operations` tab

Default subject: `RECOVERY|({TRIGGER.SEVERITY})|{HOST.NAME1}|{EVENT.TIME}`
Default message: `{TRIGGER.NAME} | Item value: {ITEM.VALUE1}`

Create new operation:

Operation type: `Send message`
Add users or groups as you wish (usually admin group, or just admin user)
Send only to: `Slack`
Hit add for the operation

We won't be adding update operations here, so just hit add from the bottom to add your new action.

![Action3](http://yawn.fi/zabbix-slack/zabbix-action3.png "Action3")

----

Next we need to actually add this Media for the user we want to use. Usually admin, so login with that. Go to `User profile` from top right corner, next to logout button.

Go to `Media` tab and hit `add`:

Type: `Slack`
Send to: `#alerts` (slack channel)
When active: `1-7,00:00-24:00` this value is the default and equals to 24/7
Choose which severity trigger needs to have for this action to send a message to slack.
Hit `Add` and `Update` and you're done!

![User media](http://yawn.fi/zabbix-slack/zabbix-media-user.png "User media")

----

This example produces messages like this:

![Example](http://yawn.fi/zabbix-slack/zabbix-slack.png "Example")
