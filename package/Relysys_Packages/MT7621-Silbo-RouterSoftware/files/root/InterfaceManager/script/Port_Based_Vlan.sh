: << COMMENT
This script is used to add "config switch_vlan" in network file.
For every iteration of "for", ports are addded to the port_num variable.

COMMENT

#######################################################################################################################

#!/bin/sh

. /lib/functions.sh

PortBasedVLANFile=/etc/config/portbasedvlanconfig
NoOfSectionCount=0

ReadPortBasedVLANConfigFile()
{
   config_load "$PortBasedVLANFile"
   config_foreach UpdatePortBasedVLANConfigFile redirect
}

UpdatePortBasedVLANConfigFile()
{	
	readportbased="$1"

	config_get vlanid "$readportbased" vlanid	
	config_get port0 "$readportbased" port0
	config_get port1 "$readportbased" port1
	config_get port2 "$readportbased" port2
	config_get port3 "$readportbased" port3
	config_get port4 "$readportbased" port4
	
	#Create switch_vlan with vlan id.
	uci set network.$vlanid="switch_vlan"
	uci set network.$vlanid.device="switch0"
	uci set network.$vlanid.vlan="$vlanid"

	port_num=""

	#Add "t" to the port number if it's tagged.
	#Also, space is given at the end, so that the next port number can be written along side the previous port numbers.
	for i in $(seq 0 4) 
	do 
		port=$(uci get portbasedvlanconfig.@redirect[$NoOfSectionCount].port${i})
		
		if [ "$port" = "tagged" ]
		then
			#Add portnumber with "t"
			port_num=$(echo "$port_num${i}t ")
		elif [ "$port" = "untagged" ]
		then
			#Add portnumber without "t"
			port_num=$(echo "$port_num${i} ")
		else
			#For "OFF"
			port_num=$(echo "$port_num")
		fi
	done
	
	uci set network.$vlanid.ports="$port_num 6t"
	
	NoOfSectionCount=$((NoOfSectionCount + 1))
	
	uci commit network
} 
 
ReadPortBasedVLANConfigFile	  

exit 0
