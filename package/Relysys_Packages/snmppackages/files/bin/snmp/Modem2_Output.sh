#!/bin/sh

. /lib/functions.sh

#Add Modem2 Related Output in /etc/config/modemstaus for snmp agent

# Function to Ckeck AT Port of Modem2 at dualcellularsinglesim
at2_port_dcss()
{
	modem_comport=$(uci get modem.CWAN2.ComPortSymLink)
    at2=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
	echo "$at2"
	if [ "$at2" = "OK" ];then
		echo "comport is working"
	else
		modem_comport=$(uci get modem.CWAN2.AltComPortSymLink)
	fi
}

get_at_value_1() {
	at-cmd $modem_comport "$1" | awk NR==2 | tr -d '\011\012\013\014\015\040'
}	

get_modem_info2() {	
	#ModemRevision2,Manufacturer2 and Model2 is store in modem1_detail file through ATI...
	at-cmd $modem_comport ATI > /tmp/modem2_detail
	ModemRevision2=$(cat /tmp/modem2_detail | awk '/Revision:/ {print $2}')
	Manufacturer2=$(cat /tmp/modem2_detail | awk NR==2)
	Model2=$(cat /tmp/modem2_detail | awk NR==3)
	IMSI2=$(get_at_value_1 'AT+CIMI')
	for i in $(seq 1 3)
	do
		len_IMSI2=$(echo ${#IMSI2})
		if [ "$len_IMSI2" -eq "15" ];then
			break
		else
			IMSI2=$(get_at_value_1 'AT+CIMI')
		fi
	done
	Imei2=$(get_at_value_1 'AT+GSN')
	for i in $(seq 1 3)
	do
		len_Imei2=$(echo ${#Imei2})
		if [ "$len_Imei" -eq "15" ];then
			break
		else
			Imei2=$(get_at_value_1 'AT+GSN')
		fi
	done
}

check_get_modem_info2()
{
for i in $(seq 1 3)
do
	if [ -z "$ModemRevision2" ] || [ -z "$Manufacturer2" ] || [ -z "$IMSI2" ] || [ -z "$Model2" ] || [ -z "$Imei2" ]
	then
		echo "Attempt $i: trying to get modem info..."
		get_modem_info2
	else
		echo "All information are gathered..."
		break
	fi
done
}

# Function to store Modem2 values in a file (/bin/snmp/modem2_version)
modem2_value() {
	{
		echo ModemRevision2=$ModemRevision2 
		echo Manufacturer2=$Manufacturer2 
		echo IMSI2=$IMSI2 
		echo Model2=$Model2 
		echo Imei2=$Imei2 
	} | tr -d '\r' > /bin/snmp/modem2_version
}

touch /bin/snmp/modem2_version

enablecellular=$(uci get sysconfig.sysconfig.enablecellular)
cellularmode=$(uci get sysconfig.sysconfig.CellularOperationMode)

if [ $enablecellular = 0 ]
then 
	exit 0
fi

if [ "$cellularmode" = dualcellularsinglesim ];then   
    at2_port_dcss
    get_modem_info2
    at2_port_dcss
    check_get_modem_info2
    modem2_value   
fi
			
exit 0
