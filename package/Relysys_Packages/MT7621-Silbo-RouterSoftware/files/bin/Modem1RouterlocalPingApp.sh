#!/bin/sh
. /lib/functions.sh
. /root/ConfigFiles/RouterAppConfig/routerapplocalconfig1.cfg

source /tmp/AddIfaceRunningstatus1
if [ "$AddIfaceRunningstatus1" = "1" ] 
then 
    exit 0
fi

RouterPingTestAppScript="/bin/Modem1RouterlocalpingTestApp.sh"
Logfile="/root/ConfigFiles/RouterAppConfig/Logs/LocalRouterAppLogs.txt"

RestartBoardFile="/root/ConfigFiles/RouterAppConfig/Modem1RestartlocalFile.txt"

LogrotateConfigFile="/etc/logrotate.d/RouterAppLogrotateConfig"
mkdir -p /root/ConfigFiles/RouterAppConfig/Logs

[ ! -d  "/tmp/Log" ] && mkdir -p "/tmp/Log"

ModemRestart="/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh"
iretries=0

ReadSystemGpioFile()                               
{                                                    
        config_load "$SystemGpioConfig"              
        config_get Modem1PowerGpio gpio modem1powergpio
        config_get Modem1PowerOnValue gpio modem1poweronvalue
        config_get Modem1PowerOffValue gpio modem1poweroffvalue
}
SystemGpioConfig="/etc/config/systemgpio"


ReadSystemGpioFile

RouterapplicationFile()                                                  
{                                                                        
        config_load "$RouterApplicationconfig"                           
        config_get EnableSecondLevel  routerapplicationlocalconfigModem1  enablesecondlevel
        config_get SecondLevelActionFailure  routerapplicationlocalconfigModem1  secondlevelactiononfailure
        config_get SecondLevelactionthreshold  routerapplicationlocalconfigModem1  secondlevelactionthreshold
}                                                                                                      
RouterApplicationconfig="/etc/config/routerapplicationconfig"                                          
                                                                                                       
RouterapplicationFile                                                                                  
                                                                                                       
echo noofretries=$noofretries
while [ $iretries -le $noofretries ]
do
	pingtest=$($RouterPingTestAppScript)
	pingres=$(cat /tmp/RouterlocalpingTestApp1.txt)

	if [ "$pingres" = "0" ]
	then
		now=$(date)
		echo "$now : WAN is up" >> "$Logfile"

		if [ "$EnableSecondLevel" = "1" ]                                                       
		then
			echo 0 > "$RestartBoardFile"
		fi
	break
	else
		sleep $sleepinterval
	fi

iretries=$(( $iretries + 1 ))
done 

if [ "$pingres" = "2" ]
then        
	if [ "$failureaction" = "restart" ] 
	then 
		now=$(date)
		echo "$now : WAN is down" >> "$Logfile"
		echo "$now : Restarting the board" >> "$Logfile"
		res=$(/root/usrRPC/script/Board_Recycle_12V_Script.sh)
	elif [ "$failureaction" = "restartipsec" ]
	then
		now=$(date)
		echo "$now : WAN is down" >> "$Logfile"
		echo "$now : Restarting the board" >> "$Logfile"
		res=$(/bin/RouterIPsec.sh)
	elif [ "$failureaction" = "restartmodem" ]
	then
		now=$(date)
		echo "$now : WAN is down" >> "$Logfile"
		echo "$now : Restarting the modem1" >> "$Logfile"
		if [ "$EnableSecondLevel" = "1" ]                                                     
		then
			var=$(cat /root/ConfigFiles/RouterAppConfig/Modem1RestartlocalFile.txt)                 
			let "var++"                                                                     
			echo "$var" > "$RestartBoardFile"
			if [ "$var" = "$SecondLevelactionthreshold" ]                                  
			then
			now=$(date)                                                                           
			echo "$now : WAN is down" >> "$Logfile"                                               
			echo "$now : Restarting the Board" >> "$Logfile"                                                                            
			echo 0 > "$RestartBoardFile"                                           
			res=$(/root/usrRPC/script/Board_Recycle_12V_Script.sh)               
			fi                                                           
		fi   
		echo "$Modem1PowerOffValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
		sleep 5
		echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
	fi
fi

logrotate "$LogrotateConfigFile"

exit 0 
