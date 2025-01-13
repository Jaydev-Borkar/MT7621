#!/bin/sh

while true
do
	enable_wifi=$(uci get sysconfig.wificonfig.wifi1enable)
	
	if [ "$enable_wifi" = "1" ] 				
	then	
		ipv4=$(ifconfig "wlan0" | awk '/inet addr/{print substr($2,6)}')
		
		if [ -z "$ipv4" ]
		then
			wifi
			sleep 1
		fi
	fi

	/bin/Wifi_restart.sh
	sleep 10
done
