#!/bin/sh
. /lib/functions.sh

echo "$1"

Hostnm=$(uci get system.system.ipkname)

if [ "$1" = "install" ]
then 
response=$(opkg remove BasicRouterSoftware)
sleep 5
response=$(opkg --force-overwrite install /tmp/${Hostnm}_RouterSoftware*.ipk)
    if [ "$?" -ne 0 ]
	then
	
		echo "{\"code\":1,\"output\":\"FAILURE :${Hostnm} Router Software Install\"}"
		exit 1
	else
			Appver=$(opkg list | grep -i "${Hostnm}_RouterSoftwareEC" | awk '{ print $3 }')
			echo "Appver=$Appver"
			uci set boardconfig.board.ApplicationSwVer="$Appver"
			uci commit boardconfig
			
			MACID=$(uci get boardconfig.board.macid)
			MACID1=$(uci get boardconfig.board.macid1)
			MACID2=$(uci get boardconfig.board.macid2)
			Serialnum=$(uci get boardconfig.board.serialnum)
			
			swlaninterface="SW_LAN"
			ethwan2interface="EWAN2"
			wifiinetrface="WIFI"
			
			uci set network."${swlaninterface}".macaddr="$MACID"
			uci set network."${ethwan2interface}".macaddr="$MACID1"
			uci set network."${wifiinetrface}".macaddr="$MACID2"
			uci set sysconfig.sysconfig.swlanmacid="$MACID"
			uci set sysconfig.sysconfig.port5macid="$MACID1"
			uci set sysconfig.sysconfig.wifi1ssid="Penguin_G300_$Serialnum"

			uci commit sysconfig
			
			uci set siaserverconfig.siaserverconfig.serialnum="$Serialnum"
			uci set boardconfigfile.boardconfigfile.serialnum="$Serialnum"
			uci set wireless.ap.ssid="Penguin_G300_$Serialnum"
			
			
			uci commit network
			uci commit wireless
			
			uci commit siaserverconfig
			uci commit boardconfigfile
		
		echo "{\"code\":0,\"output\":\"SUCCESS :${Hostnm} Router Software Uninstall\"}"
		
	fi
	exit 0
fi

if [ "$1" = "uninstall" ]
then 
response=$(opkg remove ${Hostnm}_RouterSoftware*)
sleep 5
response=$(opkg --force-overwrite install /root/BasicRouterSoftware*.ipk)
sleep 5

    if [ "$?" -ne 0 ]
	then
		echo "{\"code\":1,\"output\":\"FAILURE :${Hostnm} Router Software Uninstall\"}"
		exit 1
	else
		echo "{\"code\":0,\"output\":\"SUCCESS :${Hostnm} Router Software Uninstall\"}"
		exit 0
	fi
fi


	
														 
	
