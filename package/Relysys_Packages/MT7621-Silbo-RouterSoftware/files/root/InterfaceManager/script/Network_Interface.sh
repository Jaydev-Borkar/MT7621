: << COMMENT 
1) UpdateNetworkinterfaceConfigFile
Wans & Lans are stored in their respective txt files.
Get vlanid from ifname for macaddr.Using this vlanid, macaddr can be obtained from macaddr config file.
Delete the interface first, before creating the interface in network file. This is to deal with different protocols.
In port_based_vlan.sh, mac addr is saved in macaddr config file and here it is used if advanced settings isn't enabled.

COMMENT

#######################################################################################################################

#!/bin/sh

. /lib/functions.sh

NetworkInterfacesFile="/etc/config/networkinterfaces"

#STA only for 2.4GHz.
Wifi="wifi"
Wifi5="wifi5"
wifista="WIFI_WAN"

wifiinterface="ra0"
wifi5interface="rai0"

#To change guest name -- 
wifiap1="ra1"
wifiap51="rai1"

Wifi1Enable=$(uci get sysconfig.wificonfig.wifi1enable)
Wifi1Mode=$(uci get sysconfig.wificonfig.wifi1mode)
InternetOverWifi=$(uci get sysconfig.wificonfig.InternetOverWifi)

GetMacAddress()
{
	# Iterate over each line in the macaddr config file
	#IFS= clears the Internal Field Separator variable, which by default includes space, tab, and newline characters. 
	#This ensures that leading and trailing whitespace in mac_address are preserved. 
	#-r ensures that backslashes in the input are treated literally, rather than escaping characters.
	#Read a line from the file /etc/config/macaddr and stores it in the variable mac_address.
	
	while IFS= read -r mac_address; do
		# Append each MAC address stored in mac_address to the mac variable. 
		#$mac contains the previously read MAC addresses separated by spaces. 
		
		mac="$mac $mac_address"
	done < /etc/config/macaddr

	# Remove leading and trailing whitespace from the macaddr variable
	mac=$(echo "$mac" | xargs)
	
	#Empty the config file
	rm /etc/config/macaddr
	
	#Create it again
	touch /etc/config/macaddr
	
}

DeleteinterenetOverInterface()
{
	lanCount=$(cat /etc/internetoverlan.txt | wc -l)
	wanCount=$(cat /etc/waninterface.txt | wc -l)

	for i in $(seq 1 ${lanCount})
	do
		lan=$(cat /etc/internetoverlan.txt | head -${i} | tail -1)
		for j in $(seq 1 ${wanCount})
		do		   
			wan=$(cat /etc/waninterface.txt | head -${j} | tail -1) 
			uci delete firewall.${lan}${wan}  > /dev/null 2>&1
			uci delete firewall.${lan}${sim1} > /dev/null 2>&1
			uci delete firewall.${lan}${sim2} > /dev/null 2>&1
			uci delete firewall.${lan}${singlesim} > /dev/null 2>&1
			uci delete firewall.${lan}${modem1sim1} > /dev/null 2>&1
			uci delete firewall.${lan}${modem2sim1} > /dev/null 2>&1
			uci delete firewall.${lan}${wifista} > /dev/null 2>&1
			uci delete firewall.${Wifi}${wan} > /dev/null 2>&1
			uci delete firewall.${Wifi5}${wan} > /dev/null 2>&1

			uci commit firewall
		done
	done
}

InternetOverInterface()
{
	lanCount=$(cat /etc/internetoverlan.txt | wc -l)
	wanCount=$(cat /etc/waninterface.txt | wc -l)

	for i in $(seq 1 ${lanCount})
	do
		lan=$(cat /etc/internetoverlan.txt | head -${i} | tail -1)
		
		#When there's no waninterface.txt file, but we still want forwarding from CWANs & lans.
		
		if [ "$wanCount" = "0" ]
		then
			wanCount="1"
		fi
		
		for j in $(seq 1 ${wanCount})
		do

			#Count the number of WANs.
			wan_interfaces=$(cat /etc/config/networkinterfaces | grep -i type | grep -c WAN)
			
			#If there is more than 1 WAN.
			if [ "$wan_interfaces" -gt "0" ]
			then
			
				wan=$(cat /etc/waninterface.txt | head -${j} | tail -1) 
				uci set firewall.${lan}${wan}=forwarding
				uci set firewall.${lan}${wan}.src="$lan"
				uci set firewall.${lan}${wan}.dest="$wan"
			fi
		done
			
		if [ "$Wifi1Enable" = "1" ]
		then
			#STA only for 2.4GHz.
			if [ "$Wifi1Mode" = "sta" ] ||  [ "$Wifi1Mode" = "apsta" ]
			then
				uci set firewall.${lan}${wifista}=forwarding
				uci set firewall.${lan}${wifista}.src="$lan"
				uci set firewall.${lan}${wifista}.dest="$wifista"
			fi
		fi

		if [ "$enablecellular" = "1" ]
		then
			if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
			then
				uci set firewall.${lan}${modem1sim1}=forwarding
				uci set firewall.${lan}${modem1sim1}.src="$lan"
				uci set firewall.${lan}${modem1sim1}.dest="$cellularwan1interface"

				uci set firewall.${lan}${modem2sim1}=forwarding
				uci set firewall.${lan}${modem2sim1}.src="$lan"
				uci set firewall.${lan}${modem2sim1}.dest="$cellularwan2interface"
				
			elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
			then
				uci set firewall.${lan}${sim1}=forwarding
				uci set firewall.${lan}${sim1}.src="$lan"
				uci set firewall.${lan}${sim1}.dest="$cellularwan1sim1interface"

				uci set firewall.${lan}${sim2}=forwarding
				uci set firewall.${lan}${sim2}.src="$lan"
				uci set firewall.${lan}${sim2}.dest="$cellularwan1sim2interface"

			elif [ "$CellularOperationModelocal" = "singlecellularsinglesim" ]
			then 
				uci set firewall.${lan}${singlesim}=forwarding
				uci set firewall.${lan}${singlesim}.src="$lan"
				uci set firewall.${lan}${singlesim}.dest="$cellularwan1interface"
			fi
		fi					
	done
	
	if [ "$Wifi1Enable" = "1" ]
	then
		if [ "$Wifi1Mode" = "ap" ] || [ "$Wifi1Mode" = "apsta" ]
		then
			if [ -n "$wanCount" ]
			then
				if [ "$InternetOverWifi" = "1" ]
				then
					
					#Count the number of WANs.
					wan_interfaces=$(cat /etc/config/networkinterfaces | grep -i type | grep -c WAN)
					
					#If there is more than 1 WAN.
					if [ "$wan_interfaces" -gt "0" ]
					then
										
						for i in $(seq 1 ${wanCount})
						do
							wan=$(cat /etc/waninterface.txt | head -${i} | tail -1)
							
							uci set firewall.${Wifi}${wan}=forwarding
							uci set firewall.${Wifi}${wan}.src="$wifiinterface"
							uci set firewall.${Wifi}${wan}.dest="$wan"
							
							uci set firewall.${Wifi5}${wan}=forwarding
							uci set firewall.${Wifi5}${wan}.src="$wifi5interface"
							uci set firewall.${Wifi5}${wan}.dest="$wan"
							
							guestwifienable2=$(uci get sysconfig.guestwifi.guestwifienable2)	
							guestwifienable5=$(uci get sysconfig.guestwifi.guestwifienable5)	
							
							if [ "$guestwifienable2" = "1" ]
							then 
								uci set firewall.gwifi${wan}=forwarding
								uci set firewall.gwifi${wan}.src="$wifiap1"
								uci set firewall.gwifi${wan}.dest="$wan"
							else
								uci delete firewall.gwifi${wan} > /dev/null 2>&1
							fi
						
							if [ "$guestwifienable5" = "1" ]
							then 
								uci set firewall.gwifi5${wan}=forwarding
								uci set firewall.gwifi5${wan}.src="$wifiap51"
								uci set firewall.gwifi5${wan}.dest="$wan"
							else
								uci delete firewall.gwifi5${wan} > /dev/null 2>&1
							fi 	
						
						done
					fi
				
				else
					uci delete firewall.${Wifi}${wan} > /dev/null 2>&1
					uci delete firewall.${Wifi5}${wan} > /dev/null 2>&1
				fi
			fi
		fi
	fi
	uci commit firewall
}

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
	config_get protocol_lan "$readnetint" protocol_lan
	config_get ifname "$readnetint" ifname
	
	config_get enable_zoneforward "$readnetint" enable_zoneforward
	#config_get zoneinterface "$readnetint" zoneinterface
	config_get macaddress "$readnetint" macaddress
	config_get delegate "$readnetint" delegate
	config_get force_link "$readnetint" force_link
	config_get advanced_settings "$readnetint" advanced_settings
	config_get broadcast "$readnetint" broadcast 
	config_get enable_bridge "$readnetint" enable_bridge
	config_get bridge_interfaces "$readnetint" bridge_interfaces
	config_get noofinterfaces "$readnetint" noofinterfaces
	config_get interface1 "$readnetint" interface1
	config_get interface2 "$readnetint" interface2
	config_get mtu "$readnetint" mtu 

	config_get EthernetClientPppoeUsername "$readnetint" EthernetClientPppoeUsername
	config_get EthernetClientPppoePassword "$readnetint" EthernetClientPppoePassword
	config_get EthernetClientPppoeAccessConcentrator "$readnetint" EthernetClientPppoeAccessConcentrator
	config_get EthernetClientPppoeServiceName "$readnetint" EthernetClientPppoeServiceName
	
	config_get internetoverinterface "$readnetint" internetoverinterface
	config_get type "$readnetint" type
	
	config_get enable_relay "$readnetint" enable_relay
	config_get relay_serverip "$readnetint" relay_serverip
	
	#Save all the WAN interfaces in waninterface.txt
	if [[ "$type" == "WAN" ]]
	then
	
		echo "$Interfacename" >> /etc/waninterface.txt
	fi
	
	#Save all the LAN interfaces in internetoverlan.txt only when that particular interface has internetoverinterface selected.
	if [[ "$type" == "LAN" ]] && [[ "$internetoverinterface" == "1" ]]
	then

		echo "$Interfacename" >> /etc/internetoverlan.txt
	fi
	
	#Save all the LAN interfaces in laninterface.txt
	if [[ "$type" == "LAN" ]] && [[ "$internetoverinterface" == "0" ]]
	then

		echo "$Interfacename" >> /etc/laninterface.txt
	fi
 	
 	#Before deleting the interface from the network config, check if the interface has been assigned with a mac address.
 	#If there's a mac address already assigned, then do not assign a new macaddress unless the macaddress override is selected.
 	
 	old_macaddress=$(uci get network.$Interfacename.macaddr)
 	
 	#Delete the interface first, before creating the interface in network file.
 	uci delete network.$Interfacename
 	
	#STATIC Protocol (LAN)
	if [[ "$protocol_lan" = "static_lan" ]]
	then 
		config_get staticipaddr "$readnetint" staticIP
		config_get staticnetmask "$readnetint" staticnetmask
		config_get custom_DHCP_options "$readnetint" custom_DHCP_options
		config_get enable_dns "$readnetint" enable_dns 
		config_get ServerStaticDnsServer "$readnetint" ServerStaticDnsServer
		config_get enable_gateway "$readnetint" enable_gateway 
		config_get ServerStaticGateways "$readnetint" ServerStaticGateways
		config_get Enable_dhcpserver "$readnetint" enable_dhcpserver
		config_get dhcprange "$readnetint" ServerDHCPrange 
		config_get dhcplimit "$readnetint" ServerDHCPlimit 
		config_get leasetime_duration "$readnetint" leasetime_duration
		config_get leasetime "$readnetint" leasetime
		
		#NETWORK Config
		uci set network.$Interfacename=interface
		uci set network.$Interfacename.ifname=$ifname
		uci set network.$Interfacename.proto='static'
		uci set network.$Interfacename.ipaddr=$staticipaddr
		uci set network.$Interfacename.netmask=$staticnetmask
		
		#DHCP server Config enabled
		if [[ "$Enable_dhcpserver" = "1" ]]
		then 
			uci set dhcp.$Interfacename=dhcp
			uci set dhcp.$Interfacename.interface=$Interfacename
			uci set dhcp.$Interfacename.start=$dhcprange
			uci set dhcp.$Interfacename.limit=$dhcplimit
			uci set dhcp.$Interfacename.leasetime=$leasetime$leasetime_duration
			uci set dhcp.$Interfacename.dhcpv4='server'
			uci set dhcp.$Interfacename.dhcpv6='disabled'
			uci set dhcp.$Interfacename.ra='disabled'
			
			#Delete the old dhcp_options, if present.
			existing_dhcp_options=$(uci get dhcp.$Interfacename.dhcp_option)
			
			if [ -n "$existing_dhcp_options" ]; then
				for option in $existing_dhcp_options; do
					uci del_list dhcp.$Interfacename.dhcp_option="$option"
				done
			fi
			
			#####################
			# CUSTOM DHCP OPTIONS
			#####################
			if [[ "$custom_DHCP_options" = "1" ]]
			then	
				# Configure custom DNS (option 6)
				if [[ "$enable_dns" == "1" && -n "$ServerStaticDnsServer" ]]; then
					local dns_combined="6"
					for dns_ip in $ServerStaticDnsServer; do
						dns_combined="$dns_combined,$dns_ip"
					done
					uci add_list dhcp.$Interfacename.dhcp_option="$dns_combined"
				fi

				# Configure custom Gateway (option 3)
				if [[ "$enable_gateway" == "1" && -n "$ServerStaticGateways" ]]; then
					local gateway_combined="3"
					for gateway_ip in $ServerStaticGateways; do
						gateway_combined="$gateway_combined,$gateway_ip"
					done
					uci add_list dhcp.$Interfacename.dhcp_option="$gateway_combined"
				fi
	
			fi
		#DHCP server Config disabled				
		else
			#disable the ipv4 server.
			uci set dhcp.$Interfacename.dhcpv4='disabled'
		fi
	
	#STATIC Protocol (WAN)	
	elif [[ "$protocol" = "static" ]]
	then 
		config_get staticipaddr "$readnetint" staticIP
		config_get staticnetmask "$readnetint" staticnetmask
		config_get staticgateway "$readnetint" staticgateway

		#NETWORK Config
		uci set network.$Interfacename=interface
		uci set network.$Interfacename.ifname=$ifname
		uci set network.$Interfacename.proto='static'
		uci set network.$Interfacename.ipaddr=$staticipaddr
		uci set network.$Interfacename.netmask=$staticnetmask
		uci set network.$Interfacename.gateway=$staticgateway
		
	#PPPOE Protocol    
	elif [ "$protocol" = "pppoe" ]                                               
	then
		config_get pppoegateway "$readnetint" pppoegateway
		
		uci set network.$Interfacename=interface                         
		uci set network.$Interfacename.ifname=$ifname 
		uci set network.$Interfacename.proto="pppoe"
		uci set network.$Interfacename.username="$EthernetClientPppoeUsername"
		uci set network.$Interfacename.password="$EthernetClientPppoePassword"              
		uci set network.$Interfacename.ac="$EthernetClientPppoeAccessConcentrator"              
		uci set network.$Interfacename.service="$EthernetClientPppoeServiceName"
		uci set network.$Interfacename.gateway=$pppoegateway       
	
	#DHCP Protocol
	else 
		config_get dhcpgateway "$readnetint" dhcpgateway
		config_get mtu "$readnetint" mtu
		
		uci set network.$Interfacename=interface
		uci set network.$Interfacename.ifname=$ifname
		uci set network.$Interfacename.proto='dhcp'
		uci set network.$Interfacename.gateway=$dhcpgateway
	fi
	
	uci commit network
	
	################
	# FIREWALL ZONE
	################
	#Create firewall Zone
	if [[ "$enable_zoneforward" = "1" ]]
	then 
		uci set firewall.$Interfacename=zone
		uci set firewall.$Interfacename.name=$Interfacename
		uci set firewall.$Interfacename.input='ACCEPT'
		uci set firewall.$Interfacename.output='ACCEPT'
		uci set firewall.$Interfacename.forward='ACCEPT'
		uci set firewall.$Interfacename.network=$Interfacename
		uci set firewall.$Interfacename.masq='1'
		uci set firewall.$Interfacename.mtu_fix='1'
		uci set firewall.$Interfacename.extra_src="-m policy --dir in --pol none"
		uci set firewall.$Interfacename.extra_dest="-m policy --dir out --pol none"
		
	else
		uci delete firewall.$Interfacename
	fi
	
	#If the interface already has an old mac address, then, set the same mac address.Do not assign a new macaddress.
	if [ -n "$old_macaddress" ]
	then
		if [ -n "$macaddress" ]
		then
			
			verify_macaddress=$(echo $factorymacaddr | grep -o $old_macaddress)
	
			if [ "$verify_macaddress" = "$old_macaddress" ]
			then
			
				#Send the older mac addr before overriding it with new mac addr to macaddr config file.
				echo "$old_macaddress" >> /etc/config/macaddr
			fi
				
			#Now set the new override mac addr.
			uci set network.$Interfacename.macaddr=$macaddress
			#networkinterfaces is required to display macaddr in GUI.
			uci set networkinterfaces.$Interfacename.macaddr=$macaddress
		else
			uci set network.$Interfacename.macaddr="$old_macaddress"
			#networkinterfaces is required to display macaddr in GUI.
			uci set networkinterfaces.$Interfacename.macaddr="$old_macaddress"
		fi
	#If the interface doesn't have a macaddress by default, then assign it a new macaddress.
	else	
		
		#If override is there, add that. 
		if [ -n "$macaddress" ]
		then
			
			#Now set the new override mac addr.
			uci set network.$Interfacename.macaddr=$macaddress
			#networkinterfaces is required to display macaddr in GUI.
			uci set networkinterfaces.$Interfacename.macaddr=$macaddress
		else	
			
			#Add from macaddr config file.
			#Add the macadress till the variable is empty. (That is, macaddresses from boardconfig.)
			if [ -n "$mac" ]
			then
				
				# Get the first MAC address from the variable
				mac_first=$(echo "$mac" | awk '{print $1}')
				
				# Assign the mac variable to the network interface
				uci set network.$Interfacename.macaddr="$mac_first"
				uci set networkinterfaces.$Interfacename.macaddr="$mac_first"
				
				# Remove the first MAC address from the mac variable, keep the remainig ones.
				mac=$(echo "$mac" | awk '{$1=""; print $0}' | xargs)
			
			fi
		fi
	fi

	#If Override Mac Address is not empty, then override the mac address.
	[ -n "$macaddress" ] && uci set network.$Interfacename.macaddr=$macaddress
	[ -n "$macaddress" ] && uci set networkinterfaces.$Interfacename.macaddr=$macaddress
	
	####################
	# ADVANCED SETTINGS
	####################
	#Check for advanced settings.
	if [[ "$advanced_settings" = "1" ]]
	then
		#Check if the values are not empty.
		[ -n "$mtu" ] && uci set network.$Interfacename.mtu=$mtu
		[ -n "$broadcast" ] && uci set network.$Interfacename.broadcast=$broadcast
		
		if [[ "$delegate" = "1" ]]
		then 
			uci set network.$Interfacename.delegate='1'
		else
			uci set network.$Interfacename.delegate='0'
		fi

		if [[ "$force_link" = "1" ]]
		then 
			uci set network.$Interfacename.force_link='1'
		else
			uci set network.$Interfacename.force_link='0'
		fi

	else		
		uci delete network.$Interfacename.mtu
		uci delete network.$Interfacename.broadcast
	fi
	
	#########
	# METRIC
	#########
	#Get metric from mwan3.
	#Lan interface name isn't there in mwan3. So, only Wan interfaces get the metric.
	#metric=$(uci get mwan3config.$Interfacename.wanpriority)
	metric=$(uci get mwan3.${Interfacename}_member.metric)
	uci set network.$Interfacename.metric="$metric"
	
	#########
	# BRIDGE
	#########
	#Create bridge.
	
	if [ "$enable_bridge" = "1" ]
	then
		uci set network.$Interfacename.type='bridge'
		uci set network.$Interfacename.ifname="$ifname $bridge_interfaces"
		
		for int in $bridge_interfaces 
		do
			if [ "$int" = "ra0" ]
			then
				wifi_iface="ra0_ap"
			elif [ "$int" = "wlan0" ]
			then
				wifi_iface="rai0_ap"
			fi
			if [ "$int" != "wlan0" ]
			then
				uci set wireless.$wifi_iface.network="$Interfacename"
			fi
		done
	fi
	
	#############
	# DHCP-RELAY
	#############
	#If dhcp-relay is enabled.
	if [ "$enable_relay" = "1" ]
	then
		#If bridge is enabled, set the value of masq to zero for other bridged interfaces as well.
		#If bridge is disabled, the entire firewall zone gets deleted in systemstart. Then, masq automatically becomes 1.
		if [ "$enable_bridge" = "1" ]
		then
			#if masq is 1, then it doesn't ping via all the ips from client, hence, lots of packet loss.
			for int in $bridge_interfaces 
			do
				if [ "$int" = "ra0" ]
				then
					int_name="wifi"
				elif [ "$int" = "wlan0" ]
				then
					int_name="wifi5"
				fi
				uci set firewall.$int_name.masq='0'
			done
		fi
		#MANUALLY SET THE MASQ TO 0 FOR EWAN AS WELL FOR RN50 BOARD.
		uci set firewall.$Interfacename.masq='0'
			
		if [ "$protocol_lan" = "static_lan" ] || [ "$protocol" = "static" ]
		then
			local_IP="$staticipaddr"
			relay_server_ip="$relay_serverip"
			
			echo "dhcp-relay=${local_IP},${relay_server_ip}" >> /etc/dnsmasq.conf
			#echo "address=/#/${local_IP}" >> /etc/dnsmasq.conf
		fi
	fi
	
	uci commit network
	uci commit networkinterfaces
	uci commit dhcp
	uci commit firewall
	uci commit wireless
}      	   

factorymacaddr=$(cat /etc/config/factorymacaddr)

#Clear the previous dnsmaq config set by dhcp-relay.
echo -n > /etc/dnsmasq.conf 

#Check if cellular is enabled.
enablecellular=$(uci get sysconfig.sysconfig.enablecellular)
if [ "$enablecellular" = "1" ]
then
	#Get the Cellular operation mode.
	CellularOperationModelocal=$(uci get sysconfig.sysconfig.CellularOperationMode)
	
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
		modem1sim1="cwan1"
		modem2sim1="cwan2"
		cellularwan1interface="CWAN1"
		cellularwan2interface="CWAN2"

	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
	
		sim1="cwan1_0"
		cellularwan1sim1interface="CWAN1_0"
		sim2="cwan1_1"
		cellularwan1sim2interface="CWAN1_1"
	
	else

		singlesim="cwan1"
		cellularwan1interface="CWAN1"
	fi
fi

DeleteinterenetOverInterface

#Create a fresh txt file so that the interfacenames do not match.
rm -rf /etc/waninterface.txt
rm -rf /etc/internetoverlan.txt
rm -rf /etc/laninterface.txt

GetMacAddress
ReadNetworkinterfaceConfigFile
InternetOverInterface

#Send the remaining mac address to macaddr config file.
# Create a temporary file to store the MAC addresses
temp_file="/tmp/freemacaddr"

# Split the mac variable into an array based on space delimiter
echo "$mac" | tr ' ' '\n' > "$temp_file"

# Write each MAC address to the config file
while IFS= read -r address; do
	echo "$address" >> /etc/config/macaddr
done < "$temp_file"

# Remove the temporary file
rm "$temp_file"
   
exit 0
