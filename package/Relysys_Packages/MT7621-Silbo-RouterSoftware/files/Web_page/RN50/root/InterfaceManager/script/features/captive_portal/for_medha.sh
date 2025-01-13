#!/bin/sh

uci set networkinterfaces.SW_LAN.enable_dhcpserver="0"
uci set networkinterfaces.SW_LAN.enable_dns="0"
uci set networkinterfaces.SW_LAN.enable_relay='0'
uci set networkinterfaces.SW_LAN.enable_bridge='0'	

uci set networkinterfaces.EWAN1.protocol='dhcpclient'
uci set networkinterfaces.EWAN1.enable_bridge='1'
uci delete networkinterfaces.EWAN1.bridge_interfaces
uci add_list networkinterfaces.EWAN1.bridge_interfaces='eth0.1'
uci add_list networkinterfaces.EWAN1.bridge_interfaces='ra0'
uci add_list networkinterfaces.EWAN1.bridge_interfaces='wlan0'
uci set networkinterfaces.EWAN1.enable_relay='1'

uci set dhcp.SW_LAN.dhcpv4='disabled'
uci set dhcp.ra0.dhcpv4='disabled'
uci set dhcp.rai0.dhcpv4='disabled'

wirelessdatfile="/etc/wireless/mt7615/mt7615.1.dat"

uci set sysconfig.wificonfig.wifi1ssid='VandebharatInfotainment'
uci set sysconfig.wificonfig.wifi5ssid='VandebharatInfotainment'

uci set wireless.ra0_ap.ssid='VandebharatInfotainment'
uci set wireless.rai0_ap.ssid='VandebharatInfotainment'

ssid=$(grep -w "SSID1" ${wirelessdatfile})
ssid_replace="SSID1=VandebharatInfotainment"
sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"

uci set nodogsplash.nodogsplash.enabled='1'
uci set nodogsplash.nodogsplash.gatewayinterface='br-EWAN1'
uci set nodogsplash.nodogsplash.redirect_enabled='1'
uci set nodogsplash.nodogsplash.redirect_url='http://vandebharat.myinfotain.com'

uci commit networkinterfaces
uci commit dhcp
uci commit sysconfig
uci commit wireless
uci commit nodogsplash

#Check if captive portal is enabled.
cp_check=$(uci get nodogsplash.nodogsplash.enabled)

if [ "$cp_check" = "1" ]
then
	echo "do nothing"
else
	echo -n > /etc/dnsmasq.conf
	
	/etc/init.d/nodogsplash stop
fi
