#!/bin/sh

. /usr/share/libubox/jshn.sh
. /lib/functions.sh

webserverconfigUCIPath="/etc/config/webserverconfig"
webservertconfigsection="webserverconfig"
webserverconfigfile="/etc/config/uhttpd"

config_load "$webserverconfigUCIPath"
config_get Enable_http "$webservertconfigsection" enable_http
config_get http_port "$webservertconfigsection" http_port
config_get Enable_https "$webservertconfigsection" enable_https
config_get https_port "$webservertconfigsection" https_port
config_get rfc1918_filter "$webservertconfigsection" rfc1918_filter
config_get NtpSyncInterval "$webservertconfigsection" ntpsyncinterval
config_get redirect_https "$webservertconfigsection" redirect_https
config_get sessiontimeout "$webservertconfigsection" sessiontimeout
if [[ "$Enable_http" = '1' ]]                    
then 
	uci set webserverconfig.webserverconfig.http_port="$http_port"
	uci set uhttpd.main.listen_http="0.0.0.0:$http_port"
else
        uci delete uhttpd.main.listen_http
fi
if [[ "$Enable_https" = '1' ]]                         
then
	uci set webserverconfig.webserverconfig.https_port="$https_port"  
	uci set uhttpd.main.listen_https="0.0.0.0:$https_port"  
else                                                  
        uci delete uhttpd.main.listen_https
fi

uci set uhttpd.main.rfc1918_filter="$rfc1918_filter"

if [[ "$redirect_https" = '1' ]]
then
        uci set uhttpd.main.redirect_https="$redirect_https"
else
        uci set uhttpd.main.redirect_https="0"
fi

#Converting the time in min obtained from webpage to millisec.
sessiontimeoutinsec="$sessiontimeout"
result=$((sessiontimeoutinsec * 60000))

uci set uhttpd.main.sessiontimeout="$result"

timeout=$(uci get webserverconfig.webserverconfig.sessiontimeout)
luci2=/www/luci2.html
duration=$(grep -m 1 'var timeoutDuration' ${luci2})   
 
duration_replace="var timeoutDuration = $result;"
sed -i "s/${duration}/${duration_replace}/" "$luci2"

uci commit uhttpd
uci commit webserverconfig

#Needs sleep of 1 sec before restarting, else save button doesn't work in webpage.
sleep 1

/etc/init.d/uhttpd restart
sed -i '/TimeSync.sh/d' /etc/crontabs/root
echo "*/$NtpSyncInterval * * * * /root/InterfaceManager/script/TimeSync.sh" >> /etc/crontabs/root

/etc/init.d/cron restart
exit 0
