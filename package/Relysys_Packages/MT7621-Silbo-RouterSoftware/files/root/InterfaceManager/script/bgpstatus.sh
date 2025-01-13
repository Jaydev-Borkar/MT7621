#!/bin/bash
. /lib/functions.sh

i=1

DeleteBGPPeer()
{
     readint="$1"
     
     config_get bgp "$readint" bgp
    
      uci delete bgpdisplay.bgp${i}
     
      uci commit bgpdisplay
      i=$((i+1))     
}

BGPConfigFile="/etc/config/bgpdisplay"
config_load "$BGPConfigFile" 
config_foreach DeleteBGPPeer bgp


filename="/tmp/bgpoutput.txt"
vtysh -c "show bgp neighbors" > "$filename"

i=0

while IFS= read -r line; do
   
    if echo "$line" | grep -q "BGP neighbor is"; then
		i=$((i+1))
		uci set bgpdisplay.bgp${i}=bgp
		uci set bgpdisplay.bgp${i}.uptime="N/A"
	fi
	
	Bgpneighbor=$(echo "$line" | grep "BGP neighbor is" | tr -s " " | cut -d " " -f 4 | tr -d ",")
	if [ ! -z $Bgpneighbor ]
	then
		uci set bgpdisplay.bgp${i}.bgpneighbor="$Bgpneighbor"
	fi
	
	remoteAS=$(echo "$line" | grep "remote AS" | tr -s " " | cut -d " " -f 7 | tr -d ",")
	if [ ! -z $remoteAS ]
	then
		uci set bgpdisplay.bgp${i}.remoteAS="$remoteAS"
	fi
	
	
	localAS=$(echo "$line" | grep "local AS" | tr -s " " | cut -d " " -f 10 | tr -d ",")
	if [ ! -z $localAS ]
	then
		uci set bgpdisplay.bgp${i}.localAS="$localAS"
	fi
	
	BGPState=$(echo "$line" | grep "BGP state" | tr -s " " | cut -d " " -f 5 | tr -d ",")
	if [ ! -z $BGPState ]
	then
		uci set bgpdisplay.bgp${i}.state="$BGPState"
	fi
	
	TxUpdates=$(echo "$line" | grep "Updates" | tr -s " " | cut -d " " -f 3 | tr -d ",")
	if [ ! -z $TxUpdates ]
	then
		uci set bgpdisplay.bgp${i}.txupdates="$TxUpdates"
	fi
	
	RxUpdates=$(echo "$line" | grep "Updates" | tr -s " " | cut -d " " -f 4 | tr -d ",")
	if [ ! -z $RxUpdates ]
	then
		uci set bgpdisplay.bgp${i}.rxupdates="$RxUpdates"
	fi
	
	TotalTx=$(echo "$line" | grep "Total" | tr -s " " | cut -d " " -f 3 | tr -d ",")
	if [ ! -z $TotalTx ]
	then
		uci set bgpdisplay.bgp${i}.totaltx="$TotalTx"
	fi
	
	TotalRx=$(echo "$line" | grep "Total" | tr -s " " | cut -d " " -f 4 | tr -d ",")
	if [ ! -z $TotalRx ]
	then
		uci set bgpdisplay.bgp${i}.totalrx="$TotalRx"
	fi
	
	RemoteID=$(echo "$line" | grep "remote router ID" | tr -s " " | cut -d " " -f 8 | tr -d ",")
	if [ ! -z $RemoteID ]
	then
		uci set bgpdisplay.bgp${i}.remote_id="$RemoteID"
	fi
	
	localID=$(echo "$line" | grep "local router ID" | tr -s " " | cut -d " " -f 12 | tr -d ",")
	if [ ! -z $localID ]
	then
		uci set bgpdisplay.bgp${i}.local_host="$localID"
	fi
	
	Prefixes=$(echo "$line" | grep "accepted prefixes" | tr -s " " | cut -d " " -f 2 | tr -d ",")
	if [ ! -z $Prefixes ]
	then
		uci set bgpdisplay.bgp${i}.accepted_prefixes="$Prefixes" 	
	fi
	
	Uptime=$(echo "$line" | grep "up for" | tr -s " " | cut -d " " -f 8 | tr -d ",")
	if [ ! -z "$Uptime" ]
	then
		uci set bgpdisplay.bgp${i}.uptime="$Uptime"         		
	fi
   
   ConnectTimer=$(echo "$line" | grep "Retry Timer in" | tr -s " " | cut -d " " -f 7 | tr -d ",")
	if [ ! -z "$ConnectTimer" ]
	then
		uci set bgpdisplay.bgp${i}.connect_timer="$ConnectTimer"         		
	fi
   
   HoldTime=$(echo "$line" | grep "Hold time is" | tr -s " " | cut -d " " -f 5 | tr -d ",")
	if [ ! -z "$HoldTime" ]
	then
		uci set bgpdisplay.bgp${i}.hold_time="$HoldTime"         		
	fi
   
   KeepAliveInterval=$(echo "$line" | grep "keepalive interval is" | tr -s " " | cut -d " " -f 9 | tr -d ",")
	if [ ! -z "$KeepAliveInterval" ]
	then
		uci set bgpdisplay.bgp${i}.keepalive_time="$KeepAliveInterval"         		
	fi
   
   Bgpversion=$(echo "$line" | grep "BGP version" | tr -s " " | cut -d " " -f 4 | tr -d ",")
	if [ ! -z "$Bgpversion" ]
	then
		uci set bgpdisplay.bgp${i}.bgpversion="$Bgpversion"
	fi
	
	HostName=$(echo "$line" | grep "Hostname:" | tr -s " " | cut -d " " -f 2 | tr -d ",")
	if [ ! -z "$HostName" ]
	then
		uci set bgpdisplay.bgp${i}.hostname="$HostName"
	fi
	
	KeepalivesTx=$(echo "$line" | grep "Keepalives" | tr -s " " | cut -d " " -f 3 | tr -d ",")
	if [ ! -z "$KeepalivesTx" ]
	then
		uci set bgpdisplay.bgp${i}.keepalive_tx="$KeepalivesTx"
	fi
  
    KeepalivesRx=$(echo "$line" | grep "Keepalives" | tr -s " " | cut -d " " -f 4 | tr -d ",")
	if [ ! -z "$KeepalivesRx" ]
	then
		uci set bgpdisplay.bgp${i}.keepalive_rx="$KeepalivesRx"
	fi
  
done < "$filename"

uci commit bgpdisplay

