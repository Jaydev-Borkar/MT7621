#!/bin/sh

. /lib/functions.sh

TaggedBasedVLANFile=/etc/config/taggedportconfig

ReadTaggedBasedVLANConfigFile()
{
	config_load "$TaggedBasedVLANFile"
	config_foreach UpdateTaggedBasedVLANFile rule
}

UpdateTaggedBasedVLANFile()
{

	readtaggedbased="$1"

	config_get name "$readtaggedbased" name	
	config_get type "$readtaggedbased" type
	config_get ifname "$readtaggedbased" ifname

	uci set network.$name="device"
	uci set network.$name.name="$name"
	uci set network.$name.type="8021q"
	uci set network.$name.ifname="$ifname"

	uci commit network
} 
	  
ReadTaggedBasedVLANConfigFile

exit 0
