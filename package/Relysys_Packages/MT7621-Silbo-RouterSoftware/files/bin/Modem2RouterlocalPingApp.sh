#!/bin/sh
. /lib/functions.sh
. /root/ConfigFiles/RouterAppConfig/routerapplocalconfig2.cfg

source /tmp/AddIfaceRunningstatus2
if [ "$AddIfaceRunningstatus2" = "1" ] 
then 
    exit 0
fi

RouterPingTestAppScript="/bin/Modem2RouterlocalpingTestApp.sh"
Logfile="/root/ConfigFiles/RouterAppConfig/Logs/LocalRouterAppLogs.txt"

RestartBoardFile="/root/ConfigFiles/RouterAppConfig/Modem2RestartlocalFile.txt"

LogrotateConfigFile="/etc/logrotate.d/RouterAppLogrotateConfig"
mkdir -p /root/ConfigFiles/RouterAppConfig/Logs

[ ! -d  "/tmp/Log" ] && mkdir -p "/tmp/Log"

ModemRestart="/root/usrRPC/script/Recycle_WAN2_PWR_Script.sh"
iretries=0

ReadSystemGpioFile()                               
{                                                    
        config_load "$SystemGpioConfig"              
        config_get Modem2PowerGpio gpio modem2powergpio
        config_get Modem2PowerOnValue gpio modem2poweronvalue
        config_get Modem2PowerOffValue gpio modem2poweroffvalue
}
SystemGpioConfig="/etc/config/systemgpio"


ReadSystemGpioFile

RouterapplicationFile()                                                  
{                                                                        
        config_load "$RouterApplicationconfig"                           
        config_get EnableSecondLevel  routerapplicationlocalconfigModem2  enablesecondlevel
        config_get SecondLevelActionFailure  routerapplicationlocalconfigModem2  secondlevelactiononfailure
        config_get SecondLevelactionthreshold  routerapplicationlocalconfigModem2  secondlevelactionthreshold
}                                                                                                      
RouterApplicationconfig="/etc/config/routerapplicationconfig"                                          
                                                                                                       
RouterapplicationFile                                                                                  
                                                                                                       
echo noofretries=$noofretries
while [ $iretries -le $noofretries ]
do
	pingtest=$($RouterPingTestAppScript)
	pingres=$(cat /tmp/RouterlocalpingTestApp2.txt)

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
		echo "$now : Restarting the modem2" >> "$Logfile"
		if [ "$EnableSecondLevel" = "1" ]                                                     
		then
			var=$(cat /root/ConfigFiles/RouterAppConfig/Modem2RestartlocalFile.txt)                 
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
		echo "$Modem2PowerOffValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
		sleep 5
		echo "$Modem2PowerOnValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
	fi
fi

logrotate "$LogrotateConfigFile"

exit 0 
