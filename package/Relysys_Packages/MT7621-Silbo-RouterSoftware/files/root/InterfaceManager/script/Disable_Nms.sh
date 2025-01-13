#!/bin/sh

. /lib/functions.sh


NMS_Enable=$(uci get remoteconfig.nms.nmsenable)
RMS=$(uci get remoteconfig.general.rmsoption)
#NMS_URL=$(uci get nmsconfig.nmsconfig.httpurl)
#OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)
#FileName=$(uci get openvpn.custom_config.config)

#if [ "$OpenvpnEnable" = "1" ]
#then
   #if [ ! -f "$FileName" ]
   #then
      #uci set openvpn.custom_config.enabled=0
   #else 
      #uci set openvpn.custom_config.enabled=1
   #fi
#else
   #uci set openvpn.custom_config.enabled=0
#fi

#uci commit openvpn

#TmpSecretKeyFile="/tmp/nmssecuritykey"

if [ "$RMS" = "nms" ]
then
     if [ "${NMS_Enable}" = "0" ]
       then
          uci set openwisp.http.uuid=''
          uci set openwisp.http.key=''
          uci commit openwisp
          /etc/init.d/openwisp_config stop
          sleep 2
          /etc/init.d/openwisp-monitoring stop
          VPN_NAME=$(cat /etc/openwisp/remote/etc/config/openvpn | awk NR==1 | cut -d " " -f 3 | tr -d "'")
          uci delete openvpn.$VPN_NAME
          uci commit openvpn
          sleep 2
         /etc/init.d/openvpn restart
      fi
fi      
exit 0

