#!/bin/sh

#sleep for 10s
#sleep 10

# /tmp/simnotready file is created when the status is not ready and deleted if the status is ready.
# If this file is present, /bin/checkinterfaces.sh doesn't run during systemboot.sh

LogrotateConfigFile1="/etc/logrotate.d/alllogsconfig"
Logfile1="/root/ConfigFiles/Logs/all_logs.txt"
#Logfile1="/tmp/all_logs.txt"
logrotate "$LogrotateConfigFile1"

[ ! -e /tmp/simnotready ] || exit 0

# grep -v grep; using this, we won't get the grep pid.
check_addinterface() {
    ps w | grep "AddInterface.sh" | grep -v grep
}

# Wait for addinterface.sh to finish
for i in 1 2
do
	while check_addinterface; do
		sleep 3
	done
	
	interfaces=$(ifconfig | awk '/^(wwan|usb)/{print $1}' | tr -d '\011\012\013\014\015\040')
	
	#If the "interfaces" variable is empty; that is, ifconfig doesn't have usb0. That is, modem isn't up yet.
	if [ -z "$interfaces" ]; then
		echo "<checkinterfaces> Interface $interfaces isn't UP yet." >> $Logfile1
		sleep 60
	else
		echo "<checkinterfaces> Interface $interfaces is UP." >> $Logfile1
		echo "<checkinterfaces> Now checking if the interface $interfaces has an IP address..." >> $Logfile1
		sleep 60
	fi
done
  
interfaces=$(ifconfig -a | awk '/^(wwan|usb)/{print $1}')

if [ -z "$interfaces" ]; then
    echo "No USB interfaces found." >> /tmp/checkinterfaces.txt 
    echo "<checkinterfaces> No USB interfaces found." >> $Logfile1
else
	for interface in $interfaces; do
		name=$(echo "$interface" | awk '{print $1}')
		ip=$(ifconfig "$name" | awk '/inet addr/{print substr($2,6)}')
		ipv6=$(ifconfig usb0 | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
		
		#If either ip or ipv6 isn't there, then, do nothing.
		if [ -z "$ip" ] && [ -z "$ipv6" ]; then
			echo "$name" "$ip" "$ipv6" > /dev/null 2>&1

			ip="No IP assigned"
			echo "$name" "$ip" "$ipv6" >> /tmp/checkinterfaces.txt
			echo "Rebooting the modem " >> /tmp/checkinterfaces.txt
			echo "<checkinterfaces>  $name" "$ip" "$ipv6" >> $Logfile1
			echo "<checkinterfaces>  Rebooting the modem " >> $Logfile1

			if [ $name = "wwan0" ] || [ $name = "usb0" ]
			then
				ComPortSymLink1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
				comport1=$(readlink -f "$ComPortSymLink1")

				#if [ -z "$comport1" ]; then
				#       comport1="/dev/ttyUSB2"
				#fi

				echo "Rebooting the modem with comport - $comport1 " >> /tmp/checkinterfaces.txt
				echo "<checkinterfaces>  Rebooting the modem with comport - $comport1 " >> $Logfile1
				
				pid=$(pgrep -f "/root/InterfaceManager/script/AddInterface.sh CWAN1*")                                                     
				kill -9 "$pid" > /dev/null 2>&1
				sleep 1
				kill -9 "$pid" > /dev/null 2>&1
				
				#Delete the lockfile to run Addinterface.sh
				#CWAN1AddIface.lockfile
				rm -f /var/run/CWAN1*
				
				#Reboot the modem.
				/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh $comport1

			elif [ $name = "wwan1" ] || [ $name = "usb1" ]
			then
				ComPortSymLink2=$(uci get sysconfig.sysconfig.ComPortSymLink2)
				comport2=$(readlink -f "$ComPortSymLink2")

				echo "Rebooting the modem with comport - $comport2 " >> /tmp/checkinterfaces.txt
				echo "<checkinterfaces>  Rebooting the modem with comport - $comport2 " >> $Logfile1
								
				pid=$(pgrep -f "/root/InterfaceManager/script/AddInterface.sh CWAN2")                                                     
				kill -9 "$pid" > /dev/null 2>&1
				sleep 1
				kill -9 "$pid" > /dev/null 2>&1
				
				#Delete the lockfile to run Addinterface.sh
				#CWAN2AddIface.lockfile
				rm -f /var/run/CWAN2*
				
				#Reboot the modem.
				/root/usrRPC/script/Recycle_WAN2_PWR_Script.sh $comport2
			fi
		else
			echo "$name" "$ip" "$ipv6" > /dev/null 2>&1
			echo "$name" "$ip" "$ipv6" >> /tmp/checkinterfaces.txt
			echo "<checkinterfaces> $name" "$ip" "$ipv6" >> $Logfile1
		fi
	done
fi
