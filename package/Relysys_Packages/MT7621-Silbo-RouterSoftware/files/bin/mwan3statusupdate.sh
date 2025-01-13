#!/bin/sh

. /lib/functions.sh

rm /bin/mwan3status.txt
touch /bin/mwan3status.txt
chmod 0777 /bin/mwan3status.txt

rm /bin/mwan3statusoutput.txt
touch /bin/mwan3statusoutput.txt
chmod 0777 /bin/mwan3statusoutput.txt

wanconfigname6="CWAN1"
wanconfigname7="CWAN2"
wanconfigname8="CWAN1_0"
wanconfigname9="CWAN1_1"
wanconfigname12="WIFI_WAN"

#Delete mwan3statusconfig
rm /etc/config/mwan3statusconfig

sleep 1

#Create mwan3statusconfig
touch /etc/config/mwan3statusconfig

mwan3 interfaces | grep -i "Interface" | awk '{if(NR>1)print}' | awk '{$1=$1}1' > /bin/mwan3status.txt

input="/bin/mwan3status.txt"
while IFS= read -r line
do
	#interface
	interface=$(echo "$line" | cut -d " " -f2)
	
	#trackingstatus
	#trackingstatus=$(echo "$line" | cut -d " " -f11)
	
	# Extract tracking status using awk 
    trackingstatus=$(echo "$line" | awk -F "tracking is " '{print $2}' | awk '{print $1}')
	
	if [ "$trackingstatus" != "active" ]; then
		trackingstatus="down"
	fi

	if [ "$trackingstatus" = "not" ]; then
		trackingstatussave="NotEnabled"

	else
		trackingstatussave=$trackingstatus
	fi
	
	#Get ifname for fping.
	ifname=$(uci get network.$interface.ifname)
	
	#Interface_Status - Check online/offline/error.
	interface_status=$(echo "$line" | cut -d " " -f4)
	
	# Initialize internet_status as offline
	internet_status="offline"
	
	#If interface_status is online, then get the trackip from mwan3 config.
	#Fping to this track_ip, to get internet status.
	if [ "$interface_status" = "online" ] || [ "$interface_status" = "error" ]
	then
	
		track_ip=$(uci get mwan3.$interface.track_ip)
		
		if [ -z "$track_ip" ]
		then
			track_ip="8.8.8.8"
		fi
		
		#internet_status
		for ip in $track_ip
		do
			if fping -I "$ifname" -q -c 2 "$ip" &> /dev/null
			then
				internet_status="online"
				# Exit the loop if the internet status is confirmed online even for a single track ip.
				break				
			fi
		done
	fi
	
	uci set mwan3statusconfig."$interface"=redirect
	uci set mwan3statusconfig.$interface.name=$interface
	uci set mwan3statusconfig.$interface.interface_status=$interface_status
	uci set mwan3statusconfig.$interface.internet_status=$internet_status
	uci set mwan3statusconfig.$interface.trackingstatus=$trackingstatussave
  
done < "$input"

uci commit mwan3statusconfig

echo "Status Updated" > /bin/mwan3statusoutput.txt
