#!/bin/sh

. /lib/functions.sh


NMS_Enable=$(uci get remoteconfig.nms.nmsenable)
NMS_URL=$(uci get remoteconfig.nms.httpurl)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)
FileName=$(uci get openvpn.custom_config.config)
RebootBoard="/root/usrRPC/script/Board_Recycle_12V_Script.sh"
RMS=$(uci get remoteconfig.general.rmsoption)
echo "$RMS"

if [ "$RMS" = "nms" ]
then
     if [ "$OpenvpnEnable" = "1" ]
       then
        if [ ! -f "$FileName" ]
         then
      uci set openvpn.custom_config.enabled=0
   else 
      uci set openvpn.custom_config.enabled=1
   fi
else
   uci set openvpn.custom_config.enabled=0
fi

uci commit openvpn

TmpSecretKeyFile="/tmp/nmssecuritykey"

     if [ "${NMS_Enable}" = "1" ]
      then
         uci set openwisp.http.url="${NMS_URL}"
         SecurityKey=$(cat "$TmpSecretKeyFile")
         uci set openwisp.http.shared_secret="$SecurityKey"
         uci commit openwisp
         #we are restarting the openwisp-monitoring, openwisp_config and openvpn twice,
         #for geting the management ip properly.
         #by running this we will be able to get proper charts and the status tab in the NMS server.
         sleep 5
         /etc/init.d/openwisp_config restart
         sleep 1
         /etc/init.d/openwisp_config restart
         sleep 10
         /etc/init.d/openvpn restart
         sleep 1
         /etc/init.d/openvpn restart
         sleep 10
         /etc/init.d/openwisp-monitoring restart
         sleep 1
         /etc/init.d/openwisp-monitoring restart
      else
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


while true                             
do                                                                                                
  sleep 20                   
  UUID=$(uci get openwisp.http.uuid)    
  KEY=$(uci get openwisp.http.key)     
  if [ ! -z "$UUID" ] && [ ! -z "$KEY" ]           
  then                                                                                            
     echo "Device registered"                                                                     
     $RebootBoard                       
     break         
  fi                                 
done

fi
exit 0 
