#!/bin/sh

. /lib/functions.sh

Openvpnmain="/root/InterfaceManager/script/vpn/openvpn/openvpn_handler.sh"

ReadSystemConfigFile()
{
   	config_load "$SystemConfigFile"
   	config_get CellularOperationModelocal sysconfig CellularOperationMode
   	config_get EnableCellular sysconfig enablecellular
   	config_get Service sysconfig service
	config_get Sim2Service sysconfig sim2service
	config_get SmsEnable1 sysconfig smsenable1
	config_get SmsEnable2 sysconfig smsenable2
	config_get Wifi1Mode sysconfig wifi1mode
   	
}


ReadSystemGpioFile()
{
   	config_load "$SystemGpioConfig"
	config_get SimSelectGpio gpio simselectgpio
	config_get Sim1SelectValue gpio sim1selectvalue
	config_get Sim2SelectValue gpio sim2selectvalue
}

cellularwan1interface="CWAN1"
cellularwan2interface="CWAN2"
cellularwan1sim1interface="CWAN1_0"
cellularwan1sim2interface="CWAN1_1"
wifiap="WIFI"
wifista="WIFI_WAN"

SystemGpioConfig="/etc/config/systemgpio"
SystemConfigFile="/etc/config/sysconfig"

MwanConfigFile="/etc/config/mwan3config"

Gcom2Gonly="/etc/gcom/set2gonly.gcom"
Gcom4Gonly="/etc/gcom/set4gonly.gcom"
GcomAutoonly="/etc/gcom/setauto.gcom"

ReadSystemConfigFile
ReadSystemGpioFile


simtmpfile="/tmp/simnumfile"
SimSwitchingGpio="/sys/class/gpio/gpio$SimSelectGpio/value"

#Call this bin, so that it updates the cfg files according to the trackips from systemstart.
/bin/UpdateConfigurationsRouterApp ucitoappcfg

sleep 1

if [ "$EnableCellular" = "1" ]
then
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
		ubus call interfacemanager update {\"interface\":\"$cellularwan1interface\"} 2>&1
		ubus call interfacemanager update {\"interface\":\"$cellularwan2interface\"} 2>&1

	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
		simnum=$(cat /tmp/simnumfile)                                                                                         
		
		if [ ! -f "$simtmpfile" ]
		then 
			touch "$simtmpfile"
			echo 1 > "$simtmpfile"
			echo "$Sim1SelectValue" > "$SimSwitchingGpio"
			simnum=1                      
		fi
		
		if [ "$simnum" = "1" ]                                                                                                
		then
			ubus call interfacemanager update {\"interface\":\"$cellularwan1sim1interface\"}
			#Add CWAN2 to down the CWAN2 and remove from network file
			#Earlier it wouldn't get removed when switched from dual cellular to single cellular.
			ubus call interfacemanager update {\"interface\":\"$cellularwan2interface\"} 2>&1
		else
			ubus call interfacemanager update {\"interface\":\"$cellularwan1sim2interface\"}
			#Add CWAN2 to down the CWAN2 and remove from network file
			#Earlier it wouldn't get removed when switched from dual cellular to single cellular.
			ubus call interfacemanager update {\"interface\":\"$cellularwan2interface\"} 2>&1
		fi

	else	
		ubus call interfacemanager update {\"interface\":\"$cellularwan1interface\"}
		#Add CWAN2 to down the CWAN2 and remove from network file
		#Earlier it wouldn't get removed when switched from dual cellular to single cellular.
		ubus call interfacemanager update {\"interface\":\"$cellularwan2interface\"} 2>&1
	fi

else
	uci delete network."${cellularwan1interface}" > /dev/null 2>&1
	uci delete network."${cellularwan2interface}" > /dev/null 2>&1
	uci delete network."${cellularwan3interface}" > /dev/null 2>&1
	uci delete network."${cellularwan1sim1interface}" > /dev/null 2>&1
	uci delete network."${cellularwan1sim2interface}" > /dev/null 2>&1
	uci commit network
fi


sleep 1

#create DHCP relay server if it is enabled...
/root/InterfaceManager/script/DHCP_Relay_Server.sh

sleep 1

#Restart 5GHZ wifi
/sbin/wifi

sleep 2

/etc/init.d/dnsmasq restart
 
/bin/sleep 10                          
                                                   
/etc/init.d/network restart > /dev/null 2>&1
                                                       
/bin/sleep 10

/etc/init.d/firewall restart > /dev/null 2>&1

/bin/sleep 10

#pids=$(ps w | grep -i "mwan3" | awk '{print $1}')
#kill -9 $pids

#sleep 1

sleep 1

rm -rf /var/run/mwan3.lock

sleep 1

/usr/sbin/mwan3 restart

/bin/sleep 2

rm -rf /var/run/mwan3.lock

sleep 1

if [ "$Wifi1Mode" = "sta" ]
then
     iwpriv ra0 set HideSSID=1
	 iwpriv ra1 set HideSSID=1
fi
#~ IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)


#~ if [ "$IpsecEnable" = "1" ] ; then
#~ /usr/sbin/ipsec restart
#~ else
#~ /usr/sbin/ipsec stop
#~ fi

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)

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

#if [ "$OpenvpnEnable" = "1" ] ; then
response=$($Openvpnmain)
# #/etc/init.d/openvpn restart
sleep 2
#uci set vpnconfig1.general.openvpnrunning=1
#uci commit vpnconfig1
#else
#uci set vpnconfig1.general.openvpnrunning=0
#uci commit vpnconfig1
#fi

NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

/bin/sleep 2

if [ "${NMS_Enable}" = "1" ]
then
response=$($Openvpnmain)
#/etc/init.d/openvpn restart
fi

Enablezerotire=$(uci get vpnconfig1.general.enablezerotiergeneral)

/bin/sleep 2                                                                                                             
                                                                                                                         
if [ "${Enablezerotire}" = "1" ]                                                                                             
then                                                                                                                     
	/root/InterfaceManager/script/vpn/zerotier/zerotier_handler.sh
fi

Enablewireguard=$(uci get vpnconfig1.general.enablewireguardgeneral)

/bin/sleep 2                                                                                                             
                                                                                                                         
if [ "${Enablewireguard}" = "1" ]                                                                                         
then                                                                                                                     
	/root/InterfaceManager/script/vpn/wireguard/wireguard_handler.sh
fi 

sleep 1   

EnableVRRP=$(uci get vrrpd.general.enablevrrpd)                                                       
                                                                                                      
if [ "${EnableVRRP}" = "1" ]                                                                          
then                                                                                                  
        /root/InterfaceManager/script/vrrp/vrrp_handler.sh &                                                                
fi                                                                                                    
                                                                                                      
sleep 1     


if [ "$SmsEnable1" = "1" ] || [ "SmsEnable2" = "1" ]
then
	inotifywait /var/spool/sms/incoming/ -e create &
	sleep 2
	/root/InterfaceManager/script/SMS_Incomming_event.sh &
fi

if [ "$EnableCellular" = "0" ]
then
   sed -i '/Reset_data_usage/d' /etc/crontabs/root
   sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
   sed -i '/Data_Cap/d' /etc/crontabs/root
fi

######################################################
#If the server is restarted, then, the channel changes. 
#STA and APSTA mode needs same channel as that of the server. 
#Hence, using Wifi_monitor.sh, we call "Wifi_restart.sh" every 10 seconds to update the channel if the mode is STA/APSTA.

#Kill any earlier Wifi_monitor.sh, if present.
Wifi_monitor_pid=$(ps w | grep -i "Wifi_monitor.sh" | grep -v grep | awk '{print $1}')
kill $Wifi_monitor_pid

sleep 1

/root/InterfaceManager/script/Wifi_monitor.sh &

#Run static routing because on network restart the static routes will get deleted from route -n 
/bin/routing.sh &

#Set dhcp-relay in case of dynamic protocol.
/root/InterfaceManager/script/dynamic_relay.sh

#Check for nodogsplash changes
/root/InterfaceManager/script/features/captive_portal/nodogsplash.sh

exit 0
