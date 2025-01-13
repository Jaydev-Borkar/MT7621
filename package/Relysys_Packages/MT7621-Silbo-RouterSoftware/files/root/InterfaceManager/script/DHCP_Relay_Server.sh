#!/bin/sh

. /lib/functions.sh

ReadDHCPRelayConfigFile()
{
   config_load "$DHCPRelayFile"
   config_foreach UpdateDHCPRelayConfigFile relay
}

UpdateDHCPRelayConfigFile()
{
	readnetint="$1"

	config_get Interfacename "$readnetint" interface
	config_get endip "$readnetint" endip  
	config_get startip "$readnetint" startip
	config_get netmask "$readnetint" netmask
	config_get leasetime "$readnetint" leasetime

	echo "dhcp-range=${startip},${endip},${netmask},${leasetime}" >> /etc/dnsmasq.conf

	NoOfSectionCount=$((NoOfSectionCount + 1)) 
}

DHCPRelayFile="/etc/config/dhcprelayconfig"

file_size=$(wc -c < "$DHCPRelayFile")

# Check if the file size is greater than 2 bytes
if [ "$file_size" -gt 2 ]; then
	#emptying the file /etc/dnsmasq.conf
	echo -n > /etc/dnsmasq.conf 
    
	ReadDHCPRelayConfigFile    

fi  
exit 0
