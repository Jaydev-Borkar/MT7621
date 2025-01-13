#!/bin/sh
. /lib/functions.sh
. /root/ConfigFiles/RouterAppConfig/routerappremoteconfig1.cfg

#Payload="$1"

RouterPingTestAppScript="/bin/Modem1RouterRemotepingTestApp.sh"
Logfile="/root/ConfigFiles/RouterAppConfig/Logs/RemoteRouterAppLogs.txt"

RestartBoardFile="/root/ConfigFiles/RouterAppConfig/Modem1RestartRemoteFile.txt"

LogrotateConfigFile="/etc/logrotate.d/RouterAppLogrotateConfig"
mkdir -p /root/ConfigFiles/RouterAppConfig/Logs

 [ ! -d  "/tmp/Log" ] && mkdir -p "/tmp/Log"

ModemRestart="/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh"
iretries=0

RouterapplicationFile()                                                  
{                                                                        
        config_load "$RouterApplicationconfig"                           
        config_get EnableSecondLevel  routerapplicationRemoteconfigModem1 enablesecondlevel
        config_get SecondLevelActionFailure  routerapplicationRemoteconfigModem1  secondlevelactiononfailure
        config_get SecondLevelactionthreshold  routerapplicationRemoteconfigModem1  secondlevelactionthreshold
}                                                                                                      
RouterApplicationconfig="/etc/config/routerapplicationconfig"                                          
                                                                                                       
RouterapplicationFile                                                                                  

echo noofretries=$noofretries
while [ $iretries -le $noofretries ]
do
	pingtest=$($RouterPingTestAppScript)
	pingres=$(cat /tmp/RouterRemotepingTestApp1.txt)

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
		res=$($ModemRestart) 
		if [ "$EnableSecondLevel" = "1" ]                                                     
		then 
			var=$(cat /root/ConfigFiles/RouterAppConfig/Modem1RestartRemoteFile.txt)                 
			let "var++"                                                                     
			echo "$var" > "$RestartBoardFile"
			#cat "$RestartBoardFile"
			if [ "$var" = "$SecondLevelactionthreshold" ]                                  
			then
				now=$(date)                                                                       
				echo "$now : WAN is down" >> "$Logfile"                                            
				echo "$now : Restarting the Board" >> "$Logfile"             
				echo 0 > "$RestartBoardFile"                                           
				res=$(/root/usrRPC/script/Board_Recycle_12V_Script.sh)  
			fi                                                           
		fi   
	fi
fi

logrotate "$LogrotateConfigFile"

exit 0 
