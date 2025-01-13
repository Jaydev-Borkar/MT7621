#!/bin/sh

. /lib/functions.sh

Sim1DataFile="/etc/sim1data"
TmpSim1DataFile="/tmp/sim1data"
Sim1DataFlagFile="/etc/sim1dataflag"
                                       
NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

                                                               
if [ -f "$TmpSim1DataFile" ]                                            
then              
   echo 0 > "$TmpSim1DataFile"                                         
fi

if [ -f "$Sim1DataFile" ]                                            
then
   flash_data_used=`cat "$Sim1DataFile"` 
   num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)                         
   echo "0,$num_writes_full,0" > "$Sim1DataFile"                                           
fi                            

if [ -f "$Sim1DataFlagFile" ] 
then
   echo 0 > "$Sim1DataFlagFile" 
fi

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)                             

/etc/init.d/mwan3 stop
/root/InterfaceManager/script/SimSwitch.sh CWAN1 1
sleep 4
sleep 10
if [ "$IpsecEnable" = "1" ] ; then
	#Get the default ifname from routing table.
	interfac=$(route -n | awk NR==3 | awk '{print $8}')

	#Ethernet
	wanCount=$(cat /etc/waninterface.txt | wc -l)
	for j in $(seq 1 ${wanCount})
	do		   
		wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)                                                                                                                      
		
		#Get the ifname for every interface name
		match_ifname=$(uci get network.$wan.ifname)
		
		#To get the interface name of the default route ifname, match the ifname from waninterface.txt  
		#with the ifname from routing table .
		
		if [ "$match_ifname" = "$interfac" ]
		then
			interface_name="$match_ifname"
			break
		fi                    
	done

	if [ -n "$interface_name" ]
	then
		uci set ipsec.general.interface="$interface_name"                                                                                     
		uci set firewall.ipsec_rule1.src="$interface_name"                                                                                     
		uci set firewall.ipsec_rule2.src="$interface_name"                                                                                     
		uci set firewall.ipsec_rule3.src="$interface_name" 
	fi

	#STA
	if [ "$interfac" = "apcli0" ]                                                                                               
	then                                                                                                                          
		uci set ipsec.general.interface="WIFI_WAN" 
		uci set firewall.ipsec_rule1.src="WIFI_WAN"                                                                                     
		uci set firewall.ipsec_rule2.src="WIFI_WAN"                                                                                     
		uci set firewall.ipsec_rule3.src="WIFI_WAN"    
	fi

	#Cellular
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]                                                          
	then
		if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ]
		then
			uci set ipsec.general.interface="CWAN1"
			uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule3.src="CWAN1"
		fi
		if [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
		then
			uci set ipsec.general.interface="CWAN2"
			uci set firewall.ipsec_rule1.src="CWAN2"                                                                                     
			uci set firewall.ipsec_rule2.src="CWAN2"                                                                                     
			uci set firewall.ipsec_rule3.src="CWAN2"
		fi
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]                                                          
	then
		if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ] || [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
		then
			simnum=$(cat /tmp/simnumfile)                                                                                         
			if [ "$simnum" = "1" ]                                                                                                
			then 
				uci set ipsec.general.interface="CWAN1_0"
				uci set firewall.ipsec_rule1.src="CWAN1_0"                                                                                     
				uci set firewall.ipsec_rule2.src="CWAN1_0"                                                                                     
				uci set firewall.ipsec_rule3.src="CWAN1_0"
			else
				uci set ipsec.general.interface="CWAN1_1"
				uci set firewall.ipsec_rule1.src="CWAN1_1"                                                                                     
				uci set firewall.ipsec_rule2.src="CWAN1_1"                                                                                     
				uci set firewall.ipsec_rule3.src="CWAN1_1"
			fi
		fi
	else
		if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ] || [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
		then
			uci set ipsec.general.interface="CWAN1"
			uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule3.src="CWAN1"
		fi
	fi  
                                                                                                             
	uci commit ipsec
	uci commit firewall
	sleep 1
	/etc/init.d/firewall reload
																															   
	/etc/init.d/ipsec stop                                                                                                        
	/bin/sleep 1                                                                                                                  
	/etc/init.d/ipsec start                                                                                                       
	/bin/sleep 4                                                                                                                  
	/usr/sbin/ipsec restart                                                                                                       
fi 
if [ "$OpenvpnEnable" = "1" ] ; then                             
   /etc/init.d/openvpn restart                                      
fi
if [ "$NMS_Enable" = "1" ]
then
/etc/init.d/openvpn restart
fi 
[ ! -f /tmp/InterfaceStatus/CWAN1_1Status ] && touch /tmp/InterfaceStatus/CWAN1_1Status                                  
echo "`date` Interface CWAN1_1 DOWN" >> /tmp/InterfaceStatus/CWAN1_1Status  
echo "Sim Switch"
/usr/sbin/mwan3 restart   
