#!/bin/sh

. /lib/functions.sh

deleted_interface="$1"

factory_macaddr=$(cat /etc/config/factorymacaddr)

#Before deleting the interface from the network config, check if the interface has been assigned with a mac address.
#Take that freed mac addr and add it to macaddr config file.

old_macaddress=$(uci get network.$deleted_interface.macaddr)

if [ -n "$old_macaddress" ]
then
	verify_macaddress=$(echo $factorymacaddr | grep -o $old_macaddress)
	
	if [ "$verify_macaddress" = "$old_macaddress" ]
	then
		echo "$old_macaddress" >> /etc/config/macaddr
	fi
fi

#Now delete the interface from Network, dhcp & firewall config.
uci delete network.$deleted_interface
uci delete dhcp.$deleted_interface
uci delete firewall.$deleted_interface

uci commit network
uci commit dhcp
uci commit firewall

exit 0
