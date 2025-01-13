#!/bin/sh

. /lib/functions.sh


########################################################################
#  Description:This script basically drives GPIO498 LOW for 5 seconds
#              before turning it HIGH again. This turns OFF the mini-PCIe 
#              2G/3G/4G modem in slot J5 (USB3) OFF for 5 seconds
########################################################################
ComPort="$1"
ReadSystemGpioFile()                               
{                                                    
        config_load "$SystemGpioConfig"              
        config_get Modem1PowerGpio gpio modem1powergpio
        config_get Modem1PowerOnValue gpio modem1poweronvalue
        config_get Modem1PowerOffValue gpio modem1poweroffvalue
        
		config_get Sim1LedGpio gpio Sim1LedGpio
		config_get Sim1LedGpioOnvalue gpio Sim1LedGpioOnvalue
		config_get Sim1LedGpioOffvalue gpio Sim1LedGpioOffvalue
}

SystemGpioConfig="/etc/config/systemgpio"

LogrotateConfigFile1="/etc/logrotate.d/alllogsmod1"
Logfile1="/root/ConfigFiles/Logs/all_logs_mod1.txt"
#Logfile1="/tmp/all_logs_mod1.txt"

ReadSystemGpioFile

TmpSim1DataFile="/tmp/sim1data"
TmpSim2DataFile="/tmp/sim2data"
TmpSimDataFile="/tmp/simdata"

echo 0 > "$TmpSim1DataFile"
echo 0 > "$TmpSim2DataFile"
echo 0 > "$TmpSimDataFile"

echo " " >> $Logfile1
echo "<Recycle_WAN1_PWR_Script.sh> $ComPort ." >> $Logfile1

pid_AddInterface=$(ps w | grep "AddInterface.sh" | grep -v grep | awk '{print $1}')
kill -9 $pid_AddInterface 

echo "$Sim1LedGpioOffvalue" > /sys/class/gpio/gpio${Sim1LedGpio}/value

sleep 1

status=$(/bin/at-cmd $ComPort at+qpowd | grep -o "POWERED DOWN")

if [ -z "$status" ] || [ "$status" != "POWERED DOWN" ]
then
	echo "<Recycle_WAN1_PWR_Script.sh> REBOOT VIA GPIO ..." >> $Logfile1

	echo "$Modem1PowerOffValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
	sleep 10
	echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
fi
logrotate "$LogrotateConfigFile1"
exit 0


