#!/bin/sh

#Restart wifi because on bootup, wlan0 isn't showing up in brctl show br-EWAN1.
wifi

wifi1enable=$(uci get sysconfig.wificonfig.wifi1enable)
wifi1mode=$(uci get sysconfig.wificonfig.wifi1mode)

if [ "$wifi1enable" = "0" ]
then 
    echo "1" > /sys/class/gpio/gpio480/value
	exit 0
fi

# Gpio toggle loop
while true; do
		current_value=$(cat /sys/class/gpio/gpio480/value)
		if [ "$current_value" -eq "1" ]; then
			echo "0" > /sys/class/gpio/gpio480/value
		else
			echo "1" > /sys/class/gpio/gpio480/value
		fi
usleep 100000
done
