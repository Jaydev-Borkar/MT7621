#!/bin/sh

. /lib/functions.sh

PortBasedVLANFile=/etc/config/portbasedvlanconfig

ReadPortBasedVLANConfigFile()
{
   config_load "$PortBasedVLANFile"
   config_foreach DeletePortBased redirect
}

#Read the portbasedvlanconfig file and delete all "switch_vlan" based on vlan ids.
#Then run "Port_Based_Vlan.sh" to add the switch_vlans back in network config.
DeletePortBased()
{
	readportbased="$1"

	config_get vlanid "$readportbased" vlanid

	uci delete network.$vlanid

	uci commit network
}

ReadPortBasedVLANConfigFile

exit 0
