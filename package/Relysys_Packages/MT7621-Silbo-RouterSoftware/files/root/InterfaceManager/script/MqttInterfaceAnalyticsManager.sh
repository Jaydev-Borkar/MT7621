#!/bin/sh
if [ "$#" != "1" ]
then
    echo "Usage: $0 <Interface Name>"
    exit 1
fi

Interface="$1"
ReAPMqttHost="localhost"
ReAPMqttPort="1883"
ReAPMqttQos="1"
ReAPMqttNetifdNwkEventSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/ifup/NetifdNWKevent"
ReAPMqttCronEventSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/CronNWKevent"
ReAPMqttAppDataReqSubTopic="IOCard1/AI2DI4DO4_SG200/C/AppDataReq"
ReAPMqttSSReqSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/IREQ/ss"

InterfaceAnalyticsManagerScript="/root/InterfaceManager/script/InterfaceAnalyticsManager.sh"

mosquitto_sub -h "$ReAPMqttHost" -p "$ReAPMqttPort" -t "$ReAPMqttNetifdNwkEventSubTopic" -t "$ReAPMqttCronEventSubTopic" -t "$ReAPMqttAppDataReqSubTopic" -t "$ReAPMqttSSReqSubTopic" -q "$ReAPMqttQos" | while true
do
    read PayLoad
    "$InterfaceAnalyticsManagerScript" "$Interface" "$PayLoad"
done
