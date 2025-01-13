#!/bin/sh 

# File containing the HTML form
HTML_FILE="/etc/nodogsplash/htdocs/splash.html"

enable_nodogsplash=$(uci get nodogsplash.nodogsplash.enabled)

if [ "$enable_nodogsplash" = "1" ]
then
	redirect_enabled=$(uci get nodogsplash.nodogsplash.redirect_enabled)
	redirect_url=$(uci get nodogsplash.nodogsplash.redirect_url)
	
	if [ "$redirect_enabled" = "1" ]
	then
		
		#Keep backup of original splash
		cp /etc/nodogsplash/htdocs/splash.html /root/InterfaceManager/script/features/captive_portal/backup_splash.html
		
		sleep 1 
		
		#Copy redirect splash to original splash dir.
		cp /root/InterfaceManager/script/features/captive_portal/splash.html /etc/nodogsplash/htdocs/splash.html
		
		# Replace the current redir value with the new URL (simple string matching)
		sed -i '/name="redir"/ s|value="[^"]*"|value="'"$redirect_url"'"|' $HTML_FILE
		
		sed -i '/http-equiv="refresh"/ s|url=[^"]*|url='"$redirect_url"'|' $HTML_FILE
		
		/etc/init.d/nodogsplash restart
	fi
	
	if [ "$redirect_enabled" = "1" ]
	then
	
		sleep 2
	
		iptables -D ndsNET -j REJECT --reject-with icmp-port-unreachable
		iptables -D ndsNET -j REJECT --reject-with icmp-port-unreachable
		iptables -D ndsRTR -j REJECT --reject-with icmp-port-unreachable
		iptables -D ndsRTR -j REJECT --reject-with icmp-port-unreachable
	fi
	
	#When redirect isn't enabled, if there's a backup, then move it to the original splash path.
	if [ "$redirect_enabled" = "0" ]
	then
		
		cp /root/InterfaceManager/script/features/captive_portal/backup_splash.html /etc/nodogsplash/htdocs/splash.html
		
		/etc/init.d/nodogsplash restart
	fi
else
	/etc/init.d/nodogsplash stop
fi
