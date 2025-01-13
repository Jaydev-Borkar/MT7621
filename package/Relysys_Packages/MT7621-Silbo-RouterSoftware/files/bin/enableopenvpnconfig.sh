#!/bin/sh

. /usr/share/libubox/jshn.sh
. /lib/functions.sh

config_load vpnconfig1
config_get enableopenvpngeneral 'general' enableopenvpngeneral

if [ "$enableopenvpngeneral" = "1" ]
then   
      uci set openvpn.custom_config.enabled=1
      sleep 1
      /etc/init.d/openvpn start
else
	  uci set openvpn.custom_config.enabled=0
	  sleep 1
	  /etc/init.d/openvpn stop
fi
	uci commit openvpn	


exit 0
