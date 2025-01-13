#!/bin/sh

ModeGPIOs() {
	echo $1 > /sys/class/gpio/gpio502/value
	echo $2 > /sys/class/gpio/gpio503/value
}

SSGPIOs() {
	echo $1 > /sys/class/gpio/gpio504/value
	echo $2 > /sys/class/gpio/gpio505/value
}

GSM_MODE() {
	
	QSN=$(gcom -d $1 -s /etc/gcom/getquality.gcom | awk NR==2)
	sa=$(echo "$QSN" | grep -o "NR5G-SA")
	nsa=$(echo "$QSN" | grep -o "NR5G-NSA")
	lte=$(echo "$QSN" | grep -o "LTE")
	wcdma=$(echo "$QSN" | grep -o "WCDMA")
	if [[ -n "$sa" ]] || [[ -n "$nsa" ]]; 
	then
		echo "5G is available "
		
		$2 1 0
		
	elif [[ -n "$lte" ]] && [[ -z "$nsa" ]]; 
	then
		echo "LTE is available "
		
		$2 0 0 
		
	elif [[ "$wcdma"  ]]; 
	then
		echo "WCDMA is available "
		
		$2 0 1 
		
	else
		echo "No signal"
		
		$2 1 1 
	fi
}


Quality_Signal_Noise() {
	comport1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
	QSN=$( gcom -d $comport1 -s /etc/gcom/rssi.gcom | grep "+csq:" | cut -d' ' -f2 | cut -d',' -f1)
	RSSI=$(( -113 + 2 * $QSN ))
	if [[ $RSSI -gt -65 && $RSSI -lt 0 ]]; 
	then
		echo "RSSI is Excellent "
		
		$2 1 0
		
	elif [[ $RSSI -gt -85 && $RSSI -le -64 ]]; 
	then
		echo "RSSI is Good"
		
		$2 0 0 
		
	elif [[ $RSSI -gt -95 && $RSSI -le -84 ]]; 
	then
		echo "RSSI is Poor"
		
		$2 0 1
		
	elif [[ $RSSI =0 ]]; 
	then
		echo "No signal"
		
		$2 1 1 
		
	else
		echo "No signal"
		
		$2 1 1 
	fi
}

comport1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
Modem1() {
	if [ $comport1 ]
	then
		GSM_MODE $comport1 ModeGPIOs
		Quality_Signal_Noise $comport1 SSGPIOs
	else
		#SIM1 is not present. So, turn off all the Modem1 signal str LEDs.
		ModeGPIOs 1 1 	
		#Cpin detected on ttyUSB2
	fi
}

Modem1
