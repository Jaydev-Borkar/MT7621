#!/bin/sh

. /lib/functions.sh

#Add Modem1 Related Output in /etc/config/modemstaus for snmp agent

# Function to Ckeck AT Port of Modem1 at singlecellulardualsim(scds)
at1_port_scds()
{	
	modem1_enable1=$(uci get modem.CWAN1_0.modemenable)
	modem1_enable2=$(uci get modem.CWAN1_1.modemenable)
	if [ "$modem1_enable1" = 1 ];then 
		modem_comport=$(uci get modem.CWAN1_0.ComPortSymLink)
		at1=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
		echo "$at1"
		if [ "$at1" = "OK" ];then
			echo "comport is working"
		else
			modem_comport=$(uci get modem.CWAN1_0.AltComPortSymLink)
		fi
	elif [ "$modem1_enable2" = 1 ];then
		modem_comport=$(uci get modem.CWAN1_1.ComPortSymLink)
		at1=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
		echo "$at1"
		if [ "$at1" = "OK" ];then
			echo "comport is working"
		else
			modem_comport=$(uci get modem.CWAN1_1.AltComPortSymLink)
		fi
	fi
}

# Function to Ckeck AT Port of Modem1 at dualcellularsinglesim(dcss)
at1_port_dcss()
{
	modem_comport=$(uci get modem.CWAN1.ComPortSymLink)
	at1=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
	echo "$at1"
	if [ "$at1" = "OK" ];then
		echo "comport is working"
	else
		modem_comport=$(uci get modem.CWAN1.AltComPortSymLink)
	fi
}

get_at_value_1() {
	at-cmd $modem_comport "$1" | awk NR==2 | tr -d '\011\012\013\014\015\040'
}	

get_modem_info1() {	
	#ModemRevision,Manufacturer and Model is store in modem1_detail file through ATI...
	at-cmd $modem_comport ATI > /tmp/modem1_detail
	ModemRevision=$(cat /tmp/modem1_detail | awk '/Revision:/ {print $2}')
	Manufacturer=$(cat /tmp/modem1_detail | awk NR==2)
	Model=$(cat /tmp/modem1_detail | awk NR==3)
	IMSI=$(get_at_value_1 'AT+CIMI')
	for i in $(seq 1 3)
	do
		len_IMSI=$(echo ${#IMSI})
		if [ "$len_IMSI" -eq "15" ];then
			break
		else
			IMSI=$(get_at_value_1 'AT+CIMI')
		fi
	done
	Imei=$(get_at_value_1 'AT+GSN')
	for i in $(seq 1 3)
	do
		len_Imei=$(echo ${#Imei})
		if [ "$len_Imei" -eq "15" ];then
			break
		else
			Imei=$(get_at_value_1 'AT+GSN')
		fi
	done
}

check_get_modem_info1()
{
for i in $(seq 1 3)
do
	if [ -z "$ModemRevision" ] || [ -z "$Manufacturer" ] || [ -z "$IMSI" ] || [ -z "$Model" ] || [ -z "$Imei" ]
	then
		echo "Attempt $i: trying to get modem info..."
		get_modem_info1
	else
		echo "All information are gathered..."
		break
	fi
done
}

# Function to store Modem1 values in a file (/bin/snmp/modem1_version)
modem1_value() {
	{
		echo ModemRevision=$ModemRevision 
		echo Manufacturer=$Manufacturer 
		echo IMSI=$IMSI 
		echo Model=$Model 
		echo Imei=$Imei 
	} | tr -d '\r' > /bin/snmp/modem1_version
}

touch /bin/snmp/modem1_version
touch /bin/snmp/modem2_version

enablecellular=$(uci get sysconfig.sysconfig.enablecellular)
cellularmode=$(uci get sysconfig.sysconfig.CellularOperationMode)

if [ $enablecellular = 0 ]
then 
	exit 0
fi

if [ "$cellularmode" = singlecellularsinglesim ];then
	# Function to Ckeck AT Port of Modem1 at singlecellularsinglesim(scss) is same as dualcellularsinglesim(dcss) i.e. at1_port_dcss
	at1_port_dcss
    get_modem_info1
    at1_port_dcss
    check_get_modem_info1
    modem1_value
    
elif [ "$cellularmode" = singlecellulardualsim ];then
	at1_port_scds
    get_modem_info1
    at1_port_scds
    check_get_modem_info1
    modem1_value

elif [ "$cellularmode" = dualcellularsinglesim ];then
	at1_port_dcss
    get_modem_info1
    at1_port_dcss
    check_get_modem_info1
    modem1_value
    
fi
			
exit 0
