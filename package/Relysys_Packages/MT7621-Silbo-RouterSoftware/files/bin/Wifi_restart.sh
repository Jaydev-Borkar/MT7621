#!/bin/sh
wifi1enable=$(uci get sysconfig.wificonfig.wifi1enable)
wifi1mode=$(uci get sysconfig.wificonfig.wifi1mode)

if [ "$wifi1enable" = "0" ] || [ "$wifi1mode" = "ap" ]
then 
	exit 0
fi

interface="WIFI_WAN"  # Change this to your specific network interface

# Check if the interface is down
status=$(ifstatus $interface show | grep -i "up"  | awk -F: '/"up":/ {gsub(/,/, "", $2); print $2}')

#The output of status has <space>. hence, <space> has been given false.
if [ "$status" = " false" ]; then
	
	#fetching channel...
	
	#for station mode the channel for both server board and the client board which is set to sta should be same.
	iwpriv ra0 set SiteSurvey=0
	
	#It takes time to load. Hence, sleep is used. 
	#The channel will be replaced according to device that provides AP to this device.
	#Because both the boards must have same channel, otherwise it will not connect.
	sleep 2
	
	#geting ssid from sysconfig
	wifistassid=$(uci get sysconfig.wificonfig.wifistassid)
	WifiDevicesChannel=$(iwpriv ra0 get_site_survey | grep -i "$wifistassid" | awk '{print $1}')
	sleep 2

	#Update the channel only when the server is up. Do not update the channel when the server is off;
	#keep the previous channel as it is.
	if [ "$wifi1mode" =  "sta" ]; then
		#Update the channel only when the server is up. Do not update the channel when the server is off;
		#keep the previous channel as it is.
		if [ -n "$WifiDevicesChannel" ]; then 
			#updating channel to dat file
			wirelessdatfile="/etc/wireless/mt7615/mt7615.1.dat"
			
			#channel
			channel=$(grep -w "Channel" ${wirelessdatfile})        
			Channel_replace="Channel=$WifiDevicesChannel"
			echo "$WifiDevicesChannel"
			sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"
			
			ifconfig ra0 down > /dev/null 2>&1			
			ifconfig apcli0 down > /dev/null 2>&1
			sleep 2		
			ifconfig apcli0 up > /dev/null 2>&1
		fi		
	else
		if [ -n "$WifiDevicesChannel" ]; then 
		
			#updating channel to dat file
			wirelessdatfile="/etc/wireless/mt7615/mt7615.1.dat"
			
			#channel
			channel=$(grep -w "Channel" ${wirelessdatfile})        
			Channel_replace="Channel=$WifiDevicesChannel"
			echo "$WifiDevicesChannel"
			sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"
			
			ifconfig ra0 down > /dev/null 2>&1
			ifconfig apcli0 down > /dev/null 2>&1

			#Interface WIFI_WAN is down. Running specific commands..."
			
			sleep 2		
			
			ifconfig ra0 up > /dev/null 2>&1
			ifconfig apcli0 up > /dev/null 2>&1
		fi
	fi
fi

exit 0
