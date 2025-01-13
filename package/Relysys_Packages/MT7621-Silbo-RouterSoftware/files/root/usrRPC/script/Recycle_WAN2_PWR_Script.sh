#!/bin/sh

. /lib/functions.sh


########################################################################
#  Description:This script basically drives GPIO497 LOW for 5 seconds
#              before turning it HIGH again. This turns OFF the mini-PCIe 
#              2G/3G/4G modem in slot J2 (USB4) OFF for 5 seconds
########################################################################
ComPort="$1"

ReadSystemGpioFile()                               
{                                                    
        config_load "$SystemGpioConfig"              
        config_get Modem2PowerGpio gpio modem2powergpio
        config_get Modem2PowerOnValue gpio modem2poweronvalue
        config_get Modem2PowerOffValue gpio modem2poweroffvalue
        
        config_get Sim2LedGpio gpio Sim2LedGpio
		config_get Sim2LedGpioOnvalue gpio Sim2LedGpioOnvalue
		config_get Sim2LedGpioOffvalue gpio Sim2LedGpioOffvalue
}

SystemGpioConfig="/etc/config/systemgpio"

LogrotateConfigFile2="/etc/logrotate.d/alllogsmod2"
Logfile2="/root/ConfigFiles/Logs/all_logs_mod2.txt"
#Logfile2="/tmp/all_logs_mod2.txt"

ReadSystemGpioFile

echo " " >> $Logfile2
echo "<Recycle_WAN2_PWR_Script.sh> $ComPortSymLink ..." >> $Logfile2

pid_AddInterface=$(ps w | grep "AddInterface.sh" | grep -v grep | awk '{print $1}')
kill -9 $pid_AddInterface 

echo "$Sim2LedGpioOffvalue" > /sys/class/gpio/gpio${Sim2LedGpio}/value

sleep 1

status=$(/bin/at-cmd $ComPort at+qpowd | grep -o "POWERED DOWN")

if [ -z "$status" ] || [ "$status" != "POWERED DOWN" ]
then
	echo "<Recycle_WAN2_PWR_Script.sh> REBOOT VIA GPIO ..." >> $Logfile2

	echo "$Modem2PowerOffValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
	sleep 10
	echo "$Modem2PowerOnValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
fi
logrotate "$LogrotateConfigFile2"

exit 0


