#!/bin/sh

. /lib/functions.sh

wirelessmacfilterUCIPath="/etc/config/wirelessmacfilter"
wirelessdatfile="/etc/wireless/mt7615/mt7615.1.dat"

ReadWirelessMacfilterUCIConfig()
{
	config_load "$wirelessmacfilterUCIPath"
    config_foreach WirelessMacfilterConfigParameters  wirelessmacfilter
}

WirelessMacfilterConfigParameters()
{
    local WirelessMacfilterConfigSection="$1"
    config_get  macidblock      "$WirelessMacfilterConfigSection"   MACID
    config_get MACfiltering "$WirelessMacfilterConfigSection"  Accesspolicy
    config_get Entry "$WirelessMacfilterConfigSection"  EEnable
    config_get Disable "$WirelessMacfilterConfigSection"  MACfilteringSwitch
    config_get NetworkName "$WirelessMacfilterConfigSection"  NetworkMode

## 2.4ghz AP
if [ "$NetworkName" = "1" ]               
then 

	if [ "$MACfiltering" = "whitelist" ] || [ "$MACfiltering" = "blacklist" ] 
	then
	{        

		if [[ -z  $var ]] 
		then
			var=$macidblock
		else
			var="$var;$macidblock"
		fi
		
		if [ "$MACfiltering" = "whitelist" ]
		then
			accesscontrollist0=$(grep -w "AccessControlList0" ${wirelessdatfile})        
			accesscontrollist0_replace="AccessControlList0=$var"
			sed -i "s/${accesscontrollist0}/${accesscontrollist0_replace}/" "$wirelessdatfile"

			accesspolicy0=$(grep -w "AccessPolicy0" ${wirelessdatfile})        
			accesspolicy0_replace="AccessPolicy0=1"
			sed -i "s/${accesspolicy0}/${accesspolicy0_replace}/" "$wirelessdatfile"  

		elif [ "$MACfiltering" = "blacklist" ]
		then 
			accesscontrollist0=$(grep -w "AccessControlList0" ${wirelessdatfile})        
			accesscontrollist0_replace="AccessControlList0=$var"
			sed -i "s/${accesscontrollist0}/${accesscontrollist0_replace}/" "$wirelessdatfile"

			accesspolicy0=$(grep -w "AccessPolicy0" ${wirelessdatfile})        
			accesspolicy0_replace="AccessPolicy0=2"
			sed -i "s/${accesspolicy0}/${accesspolicy0_replace}/" "$wirelessdatfile"  
		fi
	}
	fi

## 5ghz AP
elif [ "$NetworkName" = "2" ]            
then
	if [ "$MACfiltering" = "whitelist" ] || [ "$MACfiltering" = "blacklist" ] 
	then
	{
		if [[ -z  $var1 ]] 
		then
				var1=$macidblock
		else
				var1="$var1;$macidblock"
		fi
		
		if [ "$MACfiltering" = "whitelist" ]                            
		then                                            
			uci set wireless.rai0_ap.macfilter="allow"               
			uci set wireless.rai0_ap.maclist="$var1"               
								
		elif [ "$MACfiltering" = "blacklist" ]      
		then                   
			uci set wireless.rai0_ap.macfilter="deny"               
			uci set wireless.rai0_ap.maclist="$var1"            
		fi                    
	}      
	fi       
fi
}
accesscontrollist0=$(grep -w "AccessControlList0" ${wirelessdatfile})        
accesscontrollist0_replace="AccessControlList0="
sed -i "s/${accesscontrollist0}/${accesscontrollist0_replace}/" "$wirelessdatfile"

accesspolicy0=$(grep -w "AccessPolicy0" ${wirelessdatfile})        
accesspolicy0_replace="AccessPolicy0="
sed -i "s/${accesspolicy0}/${accesspolicy0_replace}/" "$wirelessdatfile" 

uci delete wireless.rai0_ap.macfilter
uci delete wireless.rai0_ap.maclist

ReadWirelessMacfilterUCIConfig 

uci commit wireless
sleep 1
/etc/init.d/network restart

