#!/bin/sh


username=$(uci get remoteconfig.tr069.username)
password=$(uci get remoteconfig.tr069.password)
periodic_interval=$(uci get remoteconfig.tr069.periodic_interval)
tr069enable=$(uci get remoteconfig.tr069.trenable)
periodic_enable=$(uci get remoteconfig.tr069.periodic_enable)
url=$(uci get remoteconfig.tr069.url)
interface=$(uci get remoteconfig.tr069.interface)
RMS=$(uci get remoteconfig.general.rmsoption)

echo "Script Executed"  >> /tmp/TR069

echo "$username"
echo "$password"
echo "$periodic_interval"
echo "$tr069enable"
echo "$periodic_enable"
echo "$url" 

echo "Script Executed"  >> /tmp/TR069


if [ "$RMS" = "tr069" ] && [ "$tr069enable" == "1" ]
then
	     uci set easycwmp.@acs[0].username=$username
	     uci set easycwmp.@acs[0].password=$password
	     uci set easycwmp.@acs[0].url=$url
	     uci set easycwmp.@acs[0].periodic_enable=$periodic_enable
	     uci set easycwmp.@acs[0].periodic_interval=$periodic_interval
	     uci set easycwmp.@local[0].interface=$interface
	     /etc/init.d/easycwmpd start
	     /root/InterfaceManager/script/TR069.sh &
	     uci commit easycwmp
else	
	     /etc/init.d/easycwmpd stop
	     pid=$(pgrep -f TR069.sh)
	     if [ -n "$pid" ]; then
	        kill $pid
	       echo "Script has been killed."
	     else
	       echo "Script is not running."
	     fi
fi


