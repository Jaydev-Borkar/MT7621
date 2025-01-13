#!/bin/sh                                                                                                                                   

. /lib/functions.sh

#for Modem1
ComPort1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
selectionmode1=$(uci get sysconfig.bandlock.selectionmode1)
Enableoperator1=$(uci get sysconfig.bandlock.enableoperator1)

#for Modem2
ComPort2=$(uci get sysconfig.sysconfig.ComPortSymLink2)
selectionmode2=$(uci get sysconfig.bandlock.selectionmode2)
Enableoperator2=$(uci get sysconfig.bandlock.enableoperator2)

date=$(date)

LogrotateConfigFile1="/etc/logrotate.d/alllogsmod1"
Logfile1="/root/ConfigFiles/Logs/all_logs_mod1.txt"
#Logfile1="/tmp/all_logs_mod1.txt"
LogrotateConfigFile2="/etc/logrotate.d/alllogsmod2"
Logfile2="/root/ConfigFiles/Logs/all_logs_mod2.txt"
#Logfile2="/tmp/all_logs_mod2.txt"

#Run operatorlock script  
Updateoperatorlock="/root/InterfaceManager/script/operatorlock.sh"

CheckOperatorLock1(){
	if [ "$selectionmode1" = "manual-auto" ]
	then
		echo "$date: The selection mode is $selectionmode1" >> $Logfile1
		Status=$(at-cmd "$ComPort1" at+cops? | awk -F ',' '{print $3}')
    
		if [ -n "$Status" ]
		then
			echo "$date: Manual-Auto mode is set" >> $Logfile1
			break
		else
			echo "$date: Entered wrong Operator code" >> $Logfile1
			$Updateoperatorlock "AddInterface_mod1"
		fi
	else
		exit 0
	fi																																																																																																													
}

CheckOperatorLock2(){
	if [ "$selectionmode2" = "manual-auto" ]
	then
		echo "$date: The selection mode is $selectionmode2" >> $Logfile2
		Status=$(at-cmd "$ComPort2" at+cops? | awk -F ',' '{print $3}')
    
		if [ -n "$Status" ]
		then
			echo "$date: Manual-Auto mode is set" >> $Logfile2
			break
		else
			echo "$date: Entered wrong Operator code" >> $Logfile2
			$Updateoperatorlock "AddInterface_mod2"
		fi
	else
		exit 0
	fi																																																																																																													
}

#For 1st Modem & for AddInterface_mod1
if [ "$Enableoperator1" = "1" ] && [ "$1" = "AddInterface_mod1" ]
then
	sleep 25
	echo "----------<check_operatorlock.sh> -----------" >> $Logfile1
	CheckOperatorLock1
fi																																																																																																		  

#For 2nd Modem & for AddInterface_mod2
if [ "$Enableoperator2" = "1" ] && [ "$1" = "AddInterface_mod2" ]
then
	sleep 25
	echo "----------<check_operatorlock.sh> -----------" >> $Logfile2
	CheckOperatorLock2
fi

logrotate "$LogrotateConfigFile1"
logrotate "$LogrotateConfigFile2"

exit 0
