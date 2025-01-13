#!/bin/sh

. /lib/functions.sh

NetworkInterfacesFile="/etc/config/networkinterfaces"

# Path to the dnsmasq configuration file
DNSMASQ_CONF="/etc/dnsmasq.conf"

ReadNetworkinterfaceConfigFile()
{
	config_load "$NetworkInterfacesFile"
	config_foreach UpdateNetworkinterfaceConfigFile redirect
}

UpdateNetworkinterfaceConfigFile()
{
	readnetint="$1"

	config_get Interfacename "$readnetint" interface
	config_get protocol "$readnetint" protocol
	config_get enable_relay "$readnetint" enable_relay

	#If dhcp-relay is enabled.
	if [ "$enable_relay" = "1" ]
	then			
		if [ "$protocol" = "dhcpclient" ]
		then
			
			# Loop to check the status
			for i in $(seq 1 3); do
				# Fetch the ifstatus and parse with jq
				status=$(ubus call network.interface.$Interfacename status)
				up=$(echo "$status" | jq '.up')
				
				# Check if "up" is true
				if [ "$up" = "true" ]; then
					# Extract IPv4 address
					ipv4_address=$(echo "$status" | jq -r '.["ipv4-address"][0].address')
					break
				else
					# Interface is not up. Retrying in 30 seconds..."
					sleep 30
				fi
			done
			
			if [ -n "$ipv4_address" ]
			then
				
				# Check if the file is not empty
				if [ -s "$DNSMASQ_CONF" ]; then
					# Get the first IP address from dhcp-relay
					FIRST_IP=$(grep 'dhcp-relay=' "$DNSMASQ_CONF" | cut -d'=' -f2 | cut -d',' -f1)
					
					if [ "$FIRST_IP" = "$ipv4_address" ]
					then
						break
					fi
				fi
				
				echo -n > /etc/dnsmasq.conf
				
				local_IP="$ipv4_address"
				
				# Modify the last digit(host portion) in the ip address, since that is fixed.
				relay_server_ip="${ipv4_address%.*}.1"
				
				echo "dhcp-relay=${local_IP},${relay_server_ip}" >> /etc/dnsmasq.conf
				#echo "address=/#/${local_IP}" >> /etc/dnsmasq.conf
				
				/etc/init.d/dnsmasq restart > /dev/null 2>&1
				
			fi
		fi
	fi
}      	   

ReadNetworkinterfaceConfigFile
