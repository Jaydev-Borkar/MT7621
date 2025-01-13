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
ReAPMqttNetifdNwkEventSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/ifdown/NetifdNWKevent"
ReAPMqttInterfaceAnalyzerSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/Analyzer"
ReAPMqttActionsFailureSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/ActionsFailure"
ReAPMqttAmPingStatusSubTopic="IOCard1/AI2DI4DO4_SG200/W/${Interface}/AmPingTest"
InterfaceStatusManagerScript="/root/InterfaceManager/script/InterfaceStatusManager.sh"

#start of script
mosquitto_sub -h "$ReAPMqttHost" -p "$ReAPMqttPort" -t "$ReAPMqttNetifdNwkEventSubTopic" -t "$ReAPMqttInterfaceAnalyzerSubTopic" \
-t "$ReAPMqttAmPingStatusSubTopic" -t "$ReAPMqttActionsFailureSubTopic" -q "$ReAPMqttQos" | while true
do
    read PayLoad
    "$InterfaceStatusManagerScript" "$Interface" "$PayLoad"
done
