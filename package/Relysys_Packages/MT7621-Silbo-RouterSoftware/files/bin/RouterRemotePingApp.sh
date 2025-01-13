#!/bin/sh
. /lib/functions.sh
. /root/ConfigFiles/RouterAppConfig/routerappremoteconfig.cfg

#Payload="$1"
echo "Health" >> health.txt

RouterPingTestAppScript="/bin/RouterRemotepingTestApp.sh"
Logfile="/root/ConfigFiles/RouterAppConfig/Logs/RouterAppLogs.txt"
LogrotateConfigFile="/etc/logrotate.d/RouterAppLogrotateConfig"
mkdir -p /root/ConfigFiles/RouterAppConfig/Logs
ModemRestart="/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh"

#maxnoofretries=10
#sleepinterval=1
iretries=0

#HealthRequestinfo=$(echo "$Payload" | awk -F[,] '{ print $1 }')

#if [ "$HealthRequestinfo" = "HealthPeriodicReq" ]
#then
   echo noofretries=$noofretries
    while [ $iretries -le $noofretries ]
	do
        pingtest=$($RouterPingTestAppScript)
        pingres=$(cat /tmp/RouterRemotepingTestApp.txt)

		if [ "$pingres" = "0" ]
		then
			  now=$(date)
			   echo "$date : WAN is up" >> "$Logfile"
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
                 echo "$now : Restarting the modem" >> "$Logfile"
                 res=$(ModemRestart)    
			fi
		fi
		
		    logrotate "$LogrotateConfigFile"
	        
#fi

exit 0 
