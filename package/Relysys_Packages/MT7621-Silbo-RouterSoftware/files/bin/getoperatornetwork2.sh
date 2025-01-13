#!/bin/sh

. /lib/functions.sh

/usr/sbin/mwan3 stop 2>&1

sleep 6
ifconfig usb0 down  2>&1 
ifconfig usb1 down 2>&1
ifconfig wwan0 down 2>&1
ifconfig wwan1 down 2>&1

sleep 2

/etc/init.d/cron stop
echo "Wan down"

sleep 5
  
#Here, we find the comport
Operation_Mode=$(uci get sysconfig.sysconfig.CellularOperationMode)

#for Modem2
ComPort2=$(uci get sysconfig.sysconfig.ComPortSymLink2)

if [ "$Operation_Mode" = "dualcellularsinglesim" ]
then

	response=$(gcom -d $ComPort2 -s /etc/gcom/getnetworkoper2.gcom -v | awk '/OK/{print;exit} NR==2 {print}')
	echo "$response"   
						 
	echo $response | awk -vRS=")" -vFS="(" '{print $2}'| sed 's/\"//g' > /bin/operatorlist2.txt 
							
	cat /bin/operatorlist2.txt | head -n $(($(wc -l < /bin/operatorlist2.txt) - 3)) > /bin/operatorlist2.txt
						   

	input_file="/bin/operatorlist2.txt"
	{
	echo " Available Operators List : "
	echo "-----------------------------------------------------------------------------------------"
	echo "| Status              | Operator Name | Operator Brand | Operator Codes    | Modes      |"
	echo "|---------------------|---------------|----------------|-------------------|------------|"

	while IFS=',' read -r Stat operator_long operator_short operator_code Modes; do


	  case $Stat in
		0) Stat="Unknown";;
		1) Stat="Operator available";;
		2) Stat="Current operator";;
		3) Stat="Operator forbidden";;
		*) Stat="Unknown";;
	  esac
	  case $Modes in
		0) Modes="2G";;
		2) Modes="3G";;
		3) Modes="2G";;
		4) Modes="3G";;
		5) Modes="3G";;
		6) Modes="3G";;
		7) Modes="4G";;
		8) Modes="3G";;
		11) Modes="5G";;
		13) Modes="5G";;
		16) Modes="5G";;
		*) Modes="Unknown";;
	  esac

	current_time=$(date +"%d-%m-%Y %T")
		printf "| %-19s | %-13s | %-14s | %-17s | %-10s |\n"  "$Stat" "$operator_long" "$operator_short" "$operator_code" "$Modes" 
	done < "$input_file"
	echo "-----------------------------------------------------------------------------------------"
	echo " Last Updated Date and Time is : $current_time"                                      

	} > /tmp/operatorshow2.txt

fi

sleep 2

if [ "$Operation_Mode" = "dualcellularsinglesim" ]
then
	at-cmd $comport2 at+qpowd 
fi

sleep 20

/usr/sbin/mwan3 restart

#/etc/init.d/network restart   2>&1

sleep 2

/etc/init.d/cron start

