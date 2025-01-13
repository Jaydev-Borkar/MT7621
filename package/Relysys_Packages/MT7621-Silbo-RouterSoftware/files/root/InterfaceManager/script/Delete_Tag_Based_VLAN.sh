#!/bin/sh

. /lib/functions.sh

TaggedBasedVLANFile=/etc/config/taggedportconfig

ReadTaggedBasedVLANConfigFile()
{
	config_load "$TaggedBasedVLANFile"
	config_foreach DeleteTagBased rule
}

#Read the taggedportconfig file and delete all "device" based on name.
#Then run "Tag_based_VLAN.sh" to add the devices back in network config.

DeleteTagBased()
{
	readtagbased="$1"

	config_get name "$readtagbased" name

	uci delete network.$name

	uci commit network
}

ReadTaggedBasedVLANConfigFile

exit 0
