#!/bin/sh

#Add the below lib to get the subnet of the interface if vty is enabled.
. /lib/functions/network.sh
. /lib/functions.sh

bgp_configfile="/etc/config/bgpconfig"
ospf_configfile="/etc/config/ospfconfig"
frr_configfile="/etc/frr/frr.conf"

# Write the passed parameters to configfile if they are not empty.
xappend(){
	
	#$1 - Any file to which something has to be written. In this case, it's frr config file.
	
	local file="$1"
	
	#Discard the 1st parameter now.
	shift
	
	local empty_var=0
	
	#If the var is not empty, assign 1 to empty_var.
	for var in "$@"; do
		if [ -n "$var" ]; then
			empty_var=1
			break
		fi
	done
	
	#Write the parameters to the file only if they are not empty.
	if [ "$empty_var" -eq 1 ]; then
		echo "$@" >> "$file"
	fi
}

#Check if vty is enabled.
Vty_Enable(){
	
	#$1 - frr config file path
	#$2 - Protocols - BGP/OSPF/RIP
	
	local bgp_enabled_vty
	local bgp_password
	local configfile="$1"
	local routing_proto="$2"
	
	#Check if protocol is bgp.
	if  [ "$routing_proto" = "BGP" ]
	then
		bgp_enabled_vty=$(uci get bgpconfig.general.enabled_vty)
		bgp_password=$(uci get bgpconfig.general.password)
		
	#Check if protocol is ospf.
	elif  [ "$routing_proto" = "OSPF" ]
	then
		ospf_enabled_vty=$(uci get ospfconfig.general.enabled_vty)
		ospf_password=$(uci get ospfconfig.general.password)
	fi
	
	#Add hostname if it is not present.
	if grep -q "hostname" $configfile; then
		echo "hostname configuration found."
	else
		hostname=$(uci get boardconfig.board.serialnum)
		xappend "$configfile" "hostname" "$hostname"
	fi
	
	if [ "$bgp_enabled_vty" = "1" ] || [ "$ospf_enabled_vty" = "1" ]
	then

		xappend "$configfile" "password" "$password"
		xappend "$configfile" "enable password" "$password"

		xappend "$configfile" "line vty"
		xappend "$configfile" "access-class vty"
		xappend "$configfile" "access-list vty seq 1 permit" "127.0.0.1"
		
		#Get ip addr & subnet. that is, 192.168.10.1/24.
		network_get_subnet net "SW_LAN"
		
		#Add this only if SW_LAN is present.
		if [ -n "$net" ]; then
			xappend "$configfile" "access-list vty seq 2 permit" "$net"
		fi
	fi	
	echo "!" >> "$configfile"
}

BGP_Main_Instance(){
	
	#$1 - frr config file path
	local as
	local network
	local networks
	local network_entries
	local redistribute
	local redistributes
	local redistribute_entries
	local router_id
	local ebgp_requires_policy
	local import_check
	
	local configfile="$1"

	config_get as                   "main_instance" as
	config_get router_id            "main_instance" router_id
	config_get ebgp_requires_policy "main_instance" ebgp_requires_policy
	config_get import_check 		"main_instance" import_check
	config_get network_entries 		"main_instance" network
	config_get redistribute_entries "main_instance" redistribute
	
	xappend "$configfile" "router bgp" "$as"
	
	#Add this only if router_id is given.
	if [ -n "$router_id" ]; then
		xappend "$configfile" "bgp router-id" "$router_id"
	fi
	
	#if, ebgp requires policy is selected, have to add policy manually.
	if  [ "$ebgp_requires_policy" = "1" ]
	then
		xappend "$configfile" "bgp ebgp-requires-policy"
	else
		xappend "$configfile" "no bgp ebgp-requires-policy"
	fi
	
	#if, import_check is selected, the networks given should be present in network. Else, they are not advertised.
	if  [ "$import_check" = "1" ]
	then
		xappend "$configfile" "bgp network import-check"
	else
		xappend "$configfile" "no bgp network import-check"
	fi
	
	if [ "$network_entries" != "none" ];then
		#add networks, if present.
		network_entries=$(uci -q show bgpconfig | grep -E '^bgpconfig.main_instance.network=' | cut -d '=' -f 2)
		if [ -n "$network_entries" ]; then
			# Remove leading and trailing single quotes
			network_entries=$(echo "$network_entries" | tr -d "'" | tr -s ' ')
			# Use the tr command to replace spaces with newlines
			networks=$(echo "$network_entries" | tr ' ' '\n')
			for network in $networks; do
				xappend "$configfile" "network" "$network"
			done    
		fi   
	fi
	
	if [ "$redistribute_entries" != "none" ];then
		#add redistribute routes, if present.
		redistribute_entries=$(uci -q show bgpconfig | grep -E '^bgpconfig.main_instance.redistribute=' | cut -d '=' -f 2)
		if [ -n "$redistribute_entries" ]; then
			# Remove leading and trailing single quotes
			redistribute_entries=$(echo "$redistribute_entries" | tr -d "'" | tr -s ' ')
			# Use the tr command to replace spaces with newlines
			redistributes=$(echo "$redistribute_entries" | tr ' ' '\n')
			for redistribute in $redistributes; do
				xappend "$configfile" "redistribute" "$redistribute"
			done    
		fi
	fi
	
}

BGP_Peers(){
	
	# $1 - section name (peer name)
    # $2 - config file path
	
	
	local peer_name="$1"
    local configfile="$2"

	local enabled
	local as
	local default_originate
	local soft_reconfiguration
	local egbp_multihop
	local update_source
	local next_hop_self
	local ipaddr
	local password
	local weight
	local keepalive_time
	local hold_time
	local connect_retry_time
	
	#Check if the peer is enabled/disabled
	config_get enabled "$peer_name" enabled

	[ "$enabled" = "0" ] && return 1

	config_get as                     "$peer_name"      as
	config_get default_originate      "$peer_name"      default_originate
	config_get soft_reconfiguration   "$peer_name"   	soft_reconfiguration
	config_get egbp_multihop   		  "$peer_name"   	egbp_multihop
	config_get update_source   		  "$peer_name"   	update_source
	config_get next_hop_self   		  "$peer_name"   	next_hop_self
	config_get ipaddr                 "$peer_name"      ipaddr
	config_get password      		  "$peer_name"      password
	config_get weight      		 	  "$peer_name"      weight
	config_get keepalive_time      	  "$peer_name"      keepalive_time
	config_get hold_time      	  	  "$peer_name"      hold_time
	config_get connect_retry_time     "$peer_name"      connect_retry_time

	[ -n "$as" ] && xappend "$configfile" "neighbor" "$ipaddr" "remote-as" "$as"
	[ -n "$password" ] && xappend "$configfile" "neighbor" "$ipaddr" "password" "$password"
	[ -n "$weight" ] && xappend "$configfile" "neighbor" "$ipaddr" "weight" "$weight"
	[ -n "$egbp_multihop" ] && xappend "$configfile" "neighbor" "$ipaddr" "egbp-multihop" "$egbp_multihop"
	[ -n "$update_source" ] && xappend "$configfile" "neighbor" "$ipaddr" "update-source" "$update_source"
	[ -n "$keepalive_time" ] && [ -n "$hold_time" ] && xappend "$configfile" "neighbor" "$ipaddr" "timers" "$keepalive_time" "$hold_time"
	[ -n "$connect_retry_time" ] && xappend "$configfile" "neighbor" "$ipaddr" "timers connect" "$connect_retry_time"

	if [ "$next_hop_self" = "1" ]
	then
		xappend "$configfile" "neighbor" "$ipaddr" "next-hop-self"
	fi

	if [ "$soft_reconfiguration" = "1" ]
	then
		xappend "$configfile" "neighbor" "$ipaddr" "soft-reconfiguration inbound"
	fi

	if [ "$default_originate" = "1" ]
	then
		xappend "$configfile" "neighbor" "$ipaddr" "default-originate"
	fi
	
}

BGP_Peer_Group(){
	
	# $1 - section name (peer group name)
    # $2 - config file path
	
	
	local peer_group_name="$1"
    local configfile="$2"

	local enabled
	local as
	local soft_reconfiguration
	local ipaddr_entries
	local ipaddrs
	local ipaddr
	local password
	local weight
	local keepalive_time
	local hold_time
	local connect_retry_time
	
	#Check if the peer is enabled/disabled
	config_get enabled "$peer_group_name" enabled

	[ "$enabled" = "0" ] && return 1

	config_get as                     "$peer_group_name"      as
	config_get password      		  "$peer_group_name"      password
	config_get weight      		  	  "$peer_group_name"      weight
	config_get soft_reconfiguration   "$peer_group_name"      soft_reconfiguration
	config_get ipaddr_entries   	  "$peer_group_name"      ipaddr
	config_get keepalive_time      	  "$peer_group_name"      keepalive_time
	config_get hold_time      	  	  "$peer_group_name"      hold_time
	config_get connect_retry_time     "$peer_group_name"      connect_retry_time
	
	xappend "$configfile" "neighbor" "$peer_group_name" "peer-group"
	[ -n "$as" ] && xappend "$configfile" "neighbor" "$peer_group_name" "remote-as" "$as"
	[ -n "$password" ] && xappend "$configfile" "neighbor" "$peer_group_name" "password" "$password"
	[ -n "$weight" ] && xappend "$configfile" "neighbor" "$peer_group_name" "weight" "$weight"
	[ -n "$keepalive_time" ] && [ -n "$hold_time" ] && xappend "$configfile" "neighbor" "$peer_group_name" "timers" "$keepalive_time" "$hold_time"
	[ -n "$connect_retry_time" ] && xappend "$configfile" "neighbor" "$peer_group_name" "timers connect" "$connect_retry_time"
	
	if [ "$soft_reconfiguration" = "1" ]
	then
		xappend "$configfile" "neighbor" "$peer_group_name" "soft-reconfiguration inbound"
	fi
	
	if [ "$ipaddr_entries" != "none" ];then	
		#Created grep_var for ease of use.
		local grep_var
		grep_var="^bgpconfig.$peer_group_name.ipaddr="
		#add neighbor ip addr, if present.
		ipaddr_entries=$(uci -q show bgpconfig | grep -E "$grep_var" | cut -d '=' -f 2)
		if [ -n "$ipaddr_entries" ]; then
			# Remove leading and trailing single quotes
			ipaddr_entries=$(echo "$ipaddr_entries" | tr -d "'" | tr -s ' ')
			# Use the tr command to replace spaces with newlines
			ipaddrs=$(echo "$ipaddr_entries" | tr ' ' '\n')
			for ipaddr in $ipaddrs; do
				xappend "$configfile" "neighbor" "$ipaddr" "peer-group" "$peer_group_name"
			done    
		fi   
	fi
	
}

BGP_Config(){

	local enabled
	
	#Load bgp config file
	config_load "$bgp_configfile"
	config_get enabled "general" enable_bgp
	
	#Exit if bgp is not enabled. 
	if [ "$enabled" != "1" ]
	then
		#Don't check the bgpd value in daemons file & just change the value to no.
		sed -i 's/^bgpd=.*/bgpd=no/' /etc/frr/daemons
		
		sleep 1
		#Kill bgpd daemon.
		killall -9 bgpd
				
		return 1
	else
		
		#Don't check the bgpd value in daemons file & just change the value to no.
		sed -i 's/^bgpd=.*/bgpd=yes/' /etc/frr/daemons
		
		#Check if vty is enabled for bgp and add it in frr config file.
		Vty_Enable "$frr_configfile" "BGP"
		
		xappend "$frr_configfile" "!"
		
		#Go to main instance
		BGP_Main_Instance "$frr_configfile"
		
		xappend "$frr_configfile" "!"
		
		#Check for each peer group.
		config_foreach BGP_Peer_Group bgp_peer_group "$frr_configfile"
		
		xappend "$frr_configfile" "!"
		
		#Check for each peer.
		config_foreach BGP_Peers bgp_peer "$frr_configfile"
		
		xappend "$frr_configfile" "!"

	fi	
}

OSPF_Main_Instance(){
	
	#$1 - frr config file path
	local passive_interface
	local passive_interfaces
	local passiveinterface
	local redistribute
	local redistributes
	local redistribute_entries
	local router_id
	
	local configfile="$1"

	config_get router_id            "main_instance" router_id
	config_get passive_interface 	"main_instance" passive_interface
	config_get redistribute_entries "main_instance" redistribute
	
	xappend "$configfile" "router ospf"
	
	#Add this only if router_id is given.
	if [ -n "$router_id" ]; then
		xappend "$configfile" "ospf router-id" "$router_id"
	fi
	
	if [ "$passive_interface" != "none" ];then
		#add passive interfaces, if present.
		passive_interface=$(uci -q show ospfconfig | grep -E '^ospfconfig.main_instance.passive_interface=' | cut -d '=' -f 2)
		if [ -n "$passive_interface" ]; then
			# Remove leading and trailing single quotes
			passive_interface=$(echo "$passive_interface" | tr -d "'" | tr -s ' ')
			# Use the tr command to replace spaces with newlines
			passiveinterface=$(echo "$passive_interface" | tr ' ' '\n')
			for passive_interfaces in $passiveinterface; do
				xappend "$configfile" "passive-interface" "$passive_interfaces"
			done    
		fi   
	fi
	
	if [ "$redistribute_entries" != "none" ];then
		#add redistribute routes, if present.
		redistribute_entries=$(uci -q show ospfconfig | grep -E '^ospfconfig.main_instance.redistribute=' | cut -d '=' -f 2)
		if [ -n "$redistribute_entries" ]; then
			# Remove leading and trailing single quotes
			redistribute_entries=$(echo "$redistribute_entries" | tr -d "'" | tr -s ' ')
			# Use the tr command to replace spaces with newlines
			redistributes=$(echo "$redistribute_entries" | tr ' ' '\n')
			for redistribute in $redistributes; do
				xappend "$configfile" "redistribute" "$redistribute"
			done    
		fi
	fi
	
}

OSPF_Network(){
	
	# $1 - network name
    # $2 - config file path
	
	local network_name="$1"
    local configfile="$2"

	local enabled
	local network
	local area
	
	#Check if the network is enabled/disabled
	config_get enabled "$network_name" enabled

	[ "$enabled" = "0" ] && return 1

	config_get network          "$network_name"      network
	config_get area      		"$network_name"      area

	[ -n "$network" ] && xappend "$configfile" "network" "$network" "area" "$area"
	
}

OSPF_Interface(){
	
	# $1 - interface name
    # $2 - config file path
	
	local interface_name="$1"
    local configfile="$2"

	local enabled
	local interface
	local priority
	local cost
	local hello_interval
	local dead_interval
	local retransmit_interval
	local network_type
	local authentication
	local authentication_id
	local authentication_key
	
	#Check if the network is enabled/disabled
	config_get enabled "$interface_name" enabled

	[ "$enabled" = "0" ] && return 1

	config_get interface          	"$interface_name"      interface
	config_get priority      	  	"$interface_name"      priority
	config_get cost      	  		"$interface_name"      cost
	config_get hello_interval      	"$interface_name"      hello_interval
	config_get dead_interval      	"$interface_name"      dead_interval
	config_get retransmit_interval  "$interface_name"      retransmit_interval
	config_get network_type  		"$interface_name"      network_type
	config_get authentication  		"$interface_name"      authentication
	config_get authentication_id  	"$interface_name"      authentication_id
	config_get authentication_key  	"$interface_name"      authentication_key

	[ -n "$interface" ] && xappend "$configfile" "interface" "$interface"
	[ -n "$priority" ] && xappend "$configfile" "ip ospf priority" "$priority"
	[ -n "$cost" ] && xappend "$configfile" "ip ospf cost" "$cost"
	[ -n "$hello_interval" ] && xappend "$configfile" "ip ospf hello-interval" "$hello_interval"
	[ -n "$dead_interval" ] && xappend "$configfile" "ip ospf dead-interval" "$dead_interval"
	[ -n "$retransmit_interval" ] && xappend "$configfile" "ip ospf retransmit-interval" "$retransmit_interval"
	[ -n "$network_type" ] && xappend "$configfile" "ip ospf network" "$network_type"
	
	if [ "$authentication" != "none" ];then
		#add authentication, if present.
		if [ "$authentication" = "md5" ]; then
			xappend "$configfile" "ip ospf authentication message-digest"
			xappend "$configfile" "ip ospf message-digest-key" "$authentication_id" "md5" "$authentication_key"
		elif [ "$authentication" = "general_key" ]; then
			xappend "$configfile" "ip ospf authentication"	
			xappend "$configfile" "ip ospf authentication-key" "$authentication_key"
		fi   
	fi
	
}

OSPF_Config(){

	local enabled
	
	#Load ospf config file
	config_load "$ospf_configfile"
	config_get enabled "general" enable_ospf
	
	#Exit if bgp is not enabled. 
	if [ "$enabled" != "1" ]
	then
		#Don't check the ospfd value in daemons file & just change the value to no.
		sed -i 's/^ospfd=.*/ospfd=no/' /etc/frr/daemons
		
		sleep 1
		#Kill ospfd daemon.
		killall -9 ospfd
				
		return 1
	else
		
		#Don't check the ospfd value in daemons file & just change the value to no.
		sed -i 's/^ospfd=.*/ospfd=yes/' /etc/frr/daemons
		
		#Check if vty is enabled for ospf and add it in frr config file.
		Vty_Enable "$frr_configfile" "OSPF"
		
		xappend "$frr_configfile" "!"
		
		#Go to main instance
		OSPF_Main_Instance "$frr_configfile"
		
		xappend "$frr_configfile" "!"
		
		#Check for each ospf_network.
		config_foreach OSPF_Network ospf_network "$frr_configfile"
		
		xappend "$frr_configfile" "!"
		
		#Check for each ospf_interface.
		config_foreach OSPF_Interface ospf_interface "$frr_configfile"
		
		xappend "$frr_configfile" "!"

	fi	
}

upload_custom_file=$(uci get routingcustomfile.uploadfile.upload_custom_file)

if [ "$upload_custom_file" = "1" ]
then
	#mv /etc/frr/custom_file/* /etc/frr/frr.conf
	
	#sleep 1
	
	/etc/init.d/frr restart > /dev/null 2>&1
else
	#Empty the file, before writing anything.
	echo > /etc/frr/frr.conf

	BGP_Config
	
	OSPF_Config
	
	xappend "$frr_configfile" "!"		
	xappend "$frr_configfile" "address-family ipv4 unicast"
	xappend "$frr_configfile" "exit-address-family"
	
	/etc/init.d/frr restart > /dev/null 2>&1
fi
