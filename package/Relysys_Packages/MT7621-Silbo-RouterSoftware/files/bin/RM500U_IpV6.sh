#!/bin/sh

. /lib/functions.sh

InterfaceName=$1

simtype=$(uci get modem.$InterfaceName.simtype)

if [ $simtype = "singlestack" ]
then
	uci set network."$InterfaceName".proto="dhcpv6"
	uci set network."$InterfaceName".reqaddress="try"
	uci set network."$InterfaceName".reqprefix="auto"

	uci set firewall.udp_DHCPv6_replies.src="$InterfaceName"

	uci set mwan3."$InterfaceName".family="ipv6"
	uci set mwan3.default_rule.dest_ip='::/0'
	uci set mwan3.default_rule.family='ipv6'
else
	uci set network."$InterfaceName".proto="dhcp"
	
	uci set mwan3."$InterfaceName".family="ipv4"
	uci set mwan3.default_rule.dest_ip='0.0.0.0/0'
	uci delete mwan3.default_rule.family
fi
