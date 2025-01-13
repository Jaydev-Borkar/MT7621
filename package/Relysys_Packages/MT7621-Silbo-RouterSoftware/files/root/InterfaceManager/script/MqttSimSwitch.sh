#!/bin/sh

Interface="$1"
ReAPMqttHost="localhost"
ReAPMqttPort="1883"
ReAPMqttQos="1"                                                                                                                 
ReAPSimSwitchTopic="${Interface}/SimSwitch"
SimSwitchingScript="/root/InterfaceManager/script/SimSwitch.sh"

#start of script
mosquitto_sub -h "$ReAPMqttHost" -p "$ReAPMqttPort" -t "$ReAPSimSwitchTopic" -q "$ReAPMqttQos" | while true
do
    read Simnum
    "$SimSwitchingScript" "$Interface" "$Simnum"
done
