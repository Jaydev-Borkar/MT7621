#!/bin/sh

. /lib/functions.sh

Readxl2tpdUCIConfig() {
	config_load "$xl2tpdUCIPath"
	config_foreach xl2tpdConfigParameters service
}

xl2tpdConfigParameters() {

	local xl2tpdConfigSection="$1"

	config_get Name "$xl2tpdConfigSection" name
	
	#Server
	config_get Type "$xl2tpdConfigSection" type
	config_get LocalIP "$xl2tpdConfigSection" localip
	config_get Start "$xl2tpdConfigSection" start
	config_get End "$xl2tpdConfigSection" limit
	config_get Enabled "$xl2tpdConfigSection" enabled
	config_get Password "$xl2tpdConfigSection" password
	config_get UserName "$xl2tpdConfigSection" username
	#Client
	config_get Proto "$xl2tpdConfigSection" proto
	config_get Keepalive "$xl2tpdConfigSection" keepalive
	config_get Metric "$xl2tpdConfigSection" metric
	config_get Serverip "$xl2tpdConfigSection" serverip
	config_get UsserName "$xl2tpdConfigSection" usernamee
	config_get PAssword "$xl2tpdConfigSection" passwordd
	config_get Defaultroute "$xl2tpdConfigSection" defaultroute
	config_get Interface "$xl2tpdConfigSection" interface
	
	#SERVER
	if [ "$Type" == "SERVER" ]; then

		uci set xl2tpd.xl2tpd=service
		uci set xl2tpd.xl2tpd.name=$Name
		uci set xl2tpd.xl2tpd.type=$Type
		uci set xl2tpd.xl2tpd.localip=$LocalIP
		uci set xl2tpd.xl2tpd.start=$Start
		uci set xl2tpd.xl2tpd.limit=$End
		uci set xl2tpd.xl2tpd.enabled=$Enabled

		uci set xl2tpd."xl2tpd_$Name"=login
		uci set xl2tpd."xl2tpd_$Name".password=$Password
		uci set xl2tpd."xl2tpd_$Name".username=$UserName
		
		uci commit xl2tpd
	fi

	if [ "$Enabled" == "1" ]
	then
		disabled=0
	else
		disabled=1
	fi
	
	#CLIENT
	if [ "$Type" == "CLIENT" ]
	then

		#Writes "uci delete network.$Name" to /root/InterfaceManager/script/vpn/l2tp/ucidelete.sh &
		#then deletes that particular name from network config.
		echo uci delete network.$Name

		uci set network.$Name=interface
		uci set network.$Name.proto=$Proto
		uci set network.$Name.keepalive="$Keepalive"
		uci set network.$Name.metric=$Metric
		uci set network.$Name.name=$Name
		uci set network.$Name.ifname="l2tp-$Name"
		uci set network.$Name.server=$Serverip
		uci set network.$Name.username=$UsserName
		uci set network.$Name.password=$PAssword
		uci set network.$Name.defaultroute=$Defaultroute
		uci set network.$Name.disabled=$disabled

		#Set the interface as empty, if any is selected.
		if [ "$Interface" = "any" ]
		then
			Interface=""
		fi
		uci set network.$Name.interface=$Interface

		#Add rule, if it is set as default route.
		#Adding the below rule with precedence 1, will make all the interfaces not route through table 1,2 ... etc,
		#but, via main table.
		if [ "$Defaultroute" = "1" ]
		then
			ip rule add from all lookup main priority 1
		fi
		
		echo uci delete firewall.port_$Name
		
		#Create a firewall rule to open port 1723
		uci set firewall.port_$Name=rule
		uci set firewall.port_$Name.dest_port='1723'
		uci set firewall.port_$Name.src="$Name"
		uci set firewall.port_$Name.name='Allow-pptp-traffic'
		uci set firewall.port_$Name.target='ACCEPT'
		uci set firewall.port_$Name.vpn_type='pptp'
		uci set firewall.port_$Name.proto='tcp'
		uci set firewall.port_$Name.family='ipv4'
		
		echo uci commit firewall
	
	fi
	
	echo uci commit network
}

rm -rf /var/run/mwan3.lock
#MWAN3 STOP
/etc/init.d/mwan3 stop > /dev/null 2>&1
sleep 5
rm -rf /var/run/mwan3.lock
#Kill MWAN3
pids=$(ps w | grep -i "mwan3" | grep -v grep | awk '{print $1}')
kill -9 $pids

xl2tpdUCIPath=/etc/config/l2tp_i_config

##Delete l2tp_i_config Server###
l2tp_name=$(uci get xl2tpd.xl2tpd.name)

uci delete xl2tpd.xl2tpd
uci delete xl2tpd.xl2tpd_$l2tp_name
uci commit xl2tpd

##Delete L2TP names for Client from the network file.###
uci="/root/InterfaceManager/script/vpn/l2tp/ucidelete.sh"
chmod 700 /root/InterfaceManager/script/vpn/l2tp/ucidelete.sh
#Run the "/root/InterfaceManager/script/vpn/l2tp/ucidelete.sh" which deletes the names from the network file.
var = $($uci)
#Delete the ucidelete.sh and then create a new one for every update button pressed.
rm /root/InterfaceManager/script/vpn/l2tp/ucidelete.sh

#l2tp SELECTION CHECK
#Run the script, only if l2tp is enabled in general tab.
l2tp_status=$(uci get vpnconfig1.general.enablel2tpgeneral)
#If l2tp isn't selected, then, exit the script.
if [ "$l2tp_status" = "0" ]
then
	ubus call network reload

	sleep 1

	killall -9 /usr/sbin/pppd > /dev/null 2>&1 &
	
	#fw3 & mwan3 restart in case of delete button pressed/pptp disabled from general page.
	sleep 1
	#Restart firewall
	/sbin/fw3 restart > /dev/null 2>&1

	sleep 1

	#Restart MWAN3
	/usr/sbin/mwan3 restart > /dev/null 2>&1
	/bin/sleep 2
	rm -rf /var/run/mwan3.lock
	
	exit 1
fi

#CALLS THE FUNCTION & ECHO VALUE GOES IN UCIDELETE SCRIPT.
#The echo in "l2tpConfigParameters" fn is writen to the /root/InterfaceManager/script/vpn/l2tp/ucidelete.sh
Readxl2tpdUCIConfig >> /root/InterfaceManager/script/vpn/l2tp/ucidelete.sh

uci commit network
uci commit firewall

sleep 1

#Restart firewall
/sbin/fw3 restart > /dev/null 2>&1

sleep 1

#Restart MWAN3
/usr/sbin/mwan3 restart > /dev/null 2>&1
/bin/sleep 2
rm -rf /var/run/mwan3.lock

sleep 1

#Reload the network for l2tp to restart.
ubus call network reload

sleep 1

#Restart pptp init script
/etc/init.d/xl2tpd restart >/dev/null 2>&1 &
