#!/bin/sh

. /lib/functions.sh

portbasedvlanscript="/root/InterfaceManager/script/Port_Based_Vlan.sh"

rm -rf /bin/vlanid.txt
touch /bin/vlanid.txt
chmod 0777 /bin/vlanid.txt

ReadVlanid()
{
 readportbased=$1
  config_get vlanid "$readportbased" vlanid	
  echo $vlanid >> /bin/vlanid.txt
  
}

rm -rf /bin/vlanidvalidationoutput.txt
touch  /bin/vlanidvalidationoutput.txt
chmod 0777 /bin/vlanidvalidationoutput.txt

#portbasedvlanconfig to save port based vlan's config.
config_load "/etc/config/portbasedvlanconfig" 
config_foreach ReadVlanid redirect


output=$(sort /bin/vlanid.txt | uniq -d)
echo "output=$output"

if [ -z "$output" ]  
then 
   echo "Unique VLAN ID's. Updating Configurations " > /bin/vlanidvalidationoutput.txt
   flag=1
   $portbasedvlanscript
    
else
	 echo "Duplicate VLAN ID's.Cannot update Configurations,Please Edit or Add with Unique VLAN ID" > /bin/vlanidvalidationoutput.txt
	 flag=0
fi

exit 1
