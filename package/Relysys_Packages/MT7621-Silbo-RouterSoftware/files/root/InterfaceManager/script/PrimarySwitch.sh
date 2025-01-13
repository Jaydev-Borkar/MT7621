#!/bin/sh

sleeptime=$1
sleeptime=`expr "$sleeptime" \* 60`
sim=$3
interface=$2
SimNumFile="/tmp/simnumfile"

killall sleep $sleeptime
sleep 1
/bin/sleep $sleeptime

#echo "$sim" > "$SimNumFile"
/root/InterfaceManager/script/SimSwitch.sh $interface $sim
