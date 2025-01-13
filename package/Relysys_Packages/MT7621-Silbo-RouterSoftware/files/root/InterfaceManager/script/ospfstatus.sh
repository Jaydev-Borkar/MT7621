
#!/bin/bash
. /lib/functions.sh


i=1

DeleteOSPF()
{
     readvalue="$1"
     
     config_get ospf "$readvalue" ospf
    
      uci delete ospfdisplay.ospf${i}
     
      uci commit ospfdisplay
      i=$((i+1))     
}

OSPFConfigFile="/etc/config/ospfdisplay"
config_load "$OSPFConfigFile" 
config_foreach DeleteOSPF ospf




i=0
filename="/tmp/ospfoutput.txt"
vtysh -c "show ip ospf neighbor" > "$filename"

while IFS= read -r line; do
    # Check if the line contains an IP address (IPv4)
    if echo "$line" | grep -E -q "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"; then
        i=$((i+1))
        uci set ospfdisplay.ospf${i}=ospf

        # Extract values using awk
        neighborid=$(echo "$line" | awk '{print $1}')
        if [ ! -z "$neighborid" ]; then
            uci set ospfdisplay.ospf${i}.neighborid="$neighborid"
        fi

        
       
        priority=$(echo "$line" | awk '{print $2}')
        if [ ! -z "$priority" ]; then
            uci set ospfdisplay.ospf${i}.priority="$priority"
        fi

        state=$(echo "$line" | awk '{print $3}')
        if [ ! -z "$state" ]; then
            uci set ospfdisplay.ospf${i}.state="$state"
        fi
        
        dead_time=$(echo "$line" | awk '{print $4}')
        if [ ! -z "$dead_time" ]; then
            uci set ospfdisplay.ospf${i}.deadtime="$dead_time"
        fi
        
        neighboraddress=$(echo "$line" | awk '{print $5}')
        if [ ! -z "$neighboraddress" ]; then
            uci set ospfdisplay.ospf${i}.neighboraddress="$neighboraddress"
        fi
     
       interface=$(echo "$line" | awk '{split($6, a, ":"); print a[1]}')
        if [ ! -z "$interface" ]; then
            uci set ospfdisplay.ospf${i}.interface="$interface"
        fi

       interfaceaddress=$(echo "$line" | awk '{split($6, a, ":"); print a[2]}')
        if [ ! -z "$interfaceaddress" ]; then
            uci set ospfdisplay.ospf${i}.interfaceaddress="$interfaceaddress"
        fi
        
        RXmtL=$(echo "$line" | awk '{print $7}')
         if [ ! -z "$RXmtL" ]; then
            uci set ospfdisplay.ospf${i}.RXmtL="$RXmtL"
        fi
        
        RqstL=$(echo "$line" | awk '{print $8}')
         if [ ! -z "$RqstL" ]; then
            uci set ospfdisplay.ospf${i}.RqstL="$RqstL"
        fi
        
        DBsmL=$(echo "$line" | awk '{print $9}')
         if [ ! -z "$DBsmL" ]; then
            uci set ospfdisplay.ospf${i}.DBsmL="$DBsmL"
        fi
    fi
done < "$filename"

uci commit ospfdisplay
