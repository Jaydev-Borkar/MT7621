#!/bin/sh

. /lib/functions.sh
. /usr/share/libubox/jshn.sh
lte_signal()
{
	echo $1 > /sys/class/gpio/gpio480/value
	
	echo $2 > /sys/class/gpio/gpio481/value

	echo $3 > /sys/class/gpio/gpio482/value
	
	echo $4 > /sys/class/gpio/gpio483/value

	echo $5 > /sys/class/gpio/gpio484/value
	}
FiveG_signal()
{
	echo $1 > /sys/class/gpio/gpio485/value
	
	echo $2 > /sys/class/gpio/gpio486/value

	echo $3 > /sys/class/gpio/gpio487/value
	
	echo $4 > /sys/class/gpio/gpio488/value

	echo $5 > /sys/class/gpio/gpio489/value
	}

ComPortSymLink1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
comport1=$(readlink -f "$ComPortSymLink1")
ComPortSymLink2=$(uci get sysconfig.sysconfig.ComPortSymLink2)
comport2=$(readlink -f "$ComPortSymLink2")

rssi()
{
	if [[ $RSSI2 -gt -65 && $RSSI2 -lt 0 ]]; 
	then
		echo "RSSI is Excellent "
		FiveG_signal 0 0 0 0 0
				
	elif [[ $RSSI2 -gt -75 && $RSSI2 -le -64 ]]; 
	then
		echo "RSSI is Good"
		FiveG_signal 1 0 0 0 0
				
	elif [[ $RSSI2 -gt -85 && $RSSI2 -le -74 ]]; 
	then
		echo "RSSI is Fair"
		FiveG_signal 1 1 0 0 0
		
	elif [[ $RSSI2 -gt -95 && $RSSI2 -le -84 ]]; 
	then
		echo "RSSI is Poor"
		FiveG_signal 1 1 1 0 0
		
	elif [[ $RSSI2 =0 ]]; 
	then
		echo "No signal"
		FiveG_signal 1 1 1 1 1
	else
		echo "No signal"	
		FiveG_signal 1 1 1 1 1
	fi		
}

if [ $comport1 ]
then 
	Quality_Signal_Noisem2=$(gcom -d $comport1 -s /etc/gcom/rssi.gcom | awk '/\+CSQ:/ {print $2}' | cut -d',' -f1)
	if [ -n Quality_Signal_Noisem2 ]
	then
		Quality_Signal_Noisem2=$(gcom -d $comport1 -s /etc/gcom/rssi.gcom | awk '/\+csq:/ {print $2}' | cut -d',' -f1)
	fi
	RSSI2=$(( -113 + 2 * $Quality_Signal_Noisem2 ))
	rssi
fi
if [ $comport2 ]
then 
	Quality_Signal_Noisem2=$(gcom -d $comport2 -s /etc/gcom/rssi.gcom | awk '/\+CSQ:/ {print $2}' | cut -d',' -f1)
	RSSI2=$(( -113 + 2 * $Quality_Signal_Noisem2 ))
	if [[ $RSSI2 -gt -65 && $RSSI2 -lt 0 ]]; 
	then
		echo "RSSI is Excellent "
		lte_signal 0 0 0 0 0
				
	elif [[ $RSSI2 -gt -75 && $RSSI2 -le -64 ]]; 
	then
		echo "RSSI is Good"
		lte_signal 1 0 0 0 0
				
	elif [[ $RSSI2 -gt -85 && $RSSI2 -le -74 ]]; 
	then
		echo "RSSI is Fair"
		lte_signal 1 1 0 0 0
		
	elif [[ $RSSI2 -gt -95 && $RSSI2 -le -84 ]]; 
	then
		echo "RSSI is Poor"
		lte_signal 1 1 1 0 0
		
	elif [[ $RSSI2 =0 ]]; 
	then
		echo "No signal"
		lte_signal 1 1 1 1 1
	else
		echo "No signal"	
		lte_signal 1 1 1 1 1
	fi	
fi
