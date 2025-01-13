#!/bin/sh
. /lib/functions.sh
. /root/ConfigFiles/RouterAppConfig/routerapplocalconfig.cfg
. /root/ConfigFiles/RouterAppConfig/routerappremoteconfig.cfg 

#Payload="$1"
enablecellular=$(uci get sysconfig.sysconfig.enablecellular)

if [ "$enablecellular" = "0" ] 
then 
    exit 0
fi
#source /tmp/AddIfaceRunningstatus
#if [ "$AddIfaceRunningstatus" = "1" ] 
#then 
    #exit 0
#fi

RouterPingTestAppScript="/bin/RouterlocalpingTestApp.sh"
Logfile="/root/ConfigFiles/RouterAppConfig/Logs/RouterAppLogs.txt"
LogrotateConfigFile="/etc/logrotate.d/RouterAppLogrotateConfig"
mkdir -p /root/ConfigFiles/RouterAppConfig/Logs
ModemRestart="/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh"
ModemRestart2="/root/usrRPC/script/Recycle_WAN2_PWR_Script.sh"

iretries=0

echo nooflocalretries=$nooflocalretries
echo noofremoteretries=$noofremoteretries
echo nooflocalretries2=$nooflocalretries2
echo noofremoteretries2=$noofremoteretries2

for i in $(seq 1 "$nooflocalretries"); do
	
	pingtest=$($RouterPingTestAppScript)
	pingres=$(cat /tmp/RouterlocalpingTestApp.txt)
	
done


while [ $iretries -le $nooflocalretries ]
do
	pingres=$(cat /tmp/RouterlocalpingTestApp.txt)

	if [ "$pingres" = "0" ]
	then
		now=$(date)
		break
	else
		sleep $sleepinterval
	fi
	iretries=$(( $iretries + 1 ))
done 
while [ $iretries -le $noofremoteretries ]
do
	pingres=$(cat /tmp/RouterlocalpingTestApp.txt)

	if [ "$pingres" = "0" ]
	then
		now=$(date)
		break
	else
		sleep $sleepinterval
	fi
	iretries=$(( $iretries + 1 ))
done 
while [ $iretries -le $nooflocalretries2 ]
do
	pingres=$(cat /tmp/RouterlocalpingTestApp.txt)

	if [ "$pingres" = "0" ]
	then
		now=$(date)
		break
	else
		sleep $sleepinterval
	fi
	iretries=$(( $iretries + 1 ))
done 
while [ $iretries -le $noofremoteretries2 ]
do
	pingres=$(cat /tmp/RouterlocalpingTestApp.txt)

	if [ "$pingres" = "0" ]
	then
		now=$(date)
		break
	else
		sleep $sleepinterval
	fi
	iretries=$(( $iretries + 1 ))
done 
comport1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
comport2=$(uci get sysconfig.sysconfig.ComPortSymLink2)
if [ "$pingres" = "2" ]
then        
	if [ "$localfailureaction" = "restartipsec" ] || [ "$localfailureaction2" = "restartipsec" ] || [ "$remotefailureaction" = "restartipsec" ] || [ "$remotefailureaction2" = "restartipsec" ] 
	then 
		now=$(date)
		res=$(/root/usrRPC/script/Board_Recycle_12V_Script.sh)
	elif [ "$localfailureaction" = "restartipsec" ] || [ "$localfailureaction2" = "restartipsec" ] || [ "$remotefailureaction" = "restartipsec" ] || [ "$remotefailureaction2" = "restartipsec" ] 
	then
		now=$(date)
		res=$(/bin/RouterIPsec.sh)   
	elif [ "$localfailureaction" = "restartmodem1" ]
	then
	localping1=$(uci get routerapplicationconfig.routerapplicationlocalconfig.modem1ping)
		if [ "$localping1" = "1" ]
		then
			now=$(date)
			res=$(/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh $comport1)    
		fi
	elif [ "$localfailureaction2" = "restartmodem2" ]
	then
	localping2=$(uci get routerapplicationconfig.routerapplicationlocalconfig.modem2ping)
		if [ "$localping2" = "2" ]
		then
		now=$(date)
		res=$(/root/usrRPC/script/Recycle_WAN2_PWR_Script.sh.sh $comport2)    
		fi
	elif [ "$remotefailureaction" = "restartmodem1" ]
	then
	remoteping1=$(uci get routerapplicationconfig.routerapplicationlocalconfig.modem1ping)
		if [ "$remoteping1" = "1" ]
		then
			now=$(date)
			res=$(/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh $comport1)    
		fi  
	elif [ "$remotefailureaction2" = "restartmodem2" ]
	then
	remoteping2=$(uci get routerapplicationconfig.routerapplicationlocalconfig.modem2ping)
		if [ "$remoteping2" = "2" ]
		then
		now=$(date)
		res=$(/root/usrRPC/script/Recycle_WAN2_PWR_Script.sh.sh $comport2)    
		fi
	fi
fi
		
logrotate "$LogrotateConfigFile"
	        
#fi

exit 0 
