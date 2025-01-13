#!/bin/sh                                                                                                                                   

. /lib/functions.sh

enablecellular=$(uci get sysconfig.sysconfig.enablecellular)

if [ "$enablecellular" = "0" ]
then
	exit 0
fi

#for Modem1
ComPort1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
selectionmode1=$(uci get sysconfig.bandlock.selectionmode1)
Enableoperator1=$(uci get sysconfig.bandlock.enableoperator1)
code1=$(uci get sysconfig.bandlock.Code1)

#for Modem2
ComPort2=$(uci get sysconfig.sysconfig.ComPortSymLink2)
selectionmode2=$(uci get sysconfig.bandlock.selectionmode2)
Enableoperator2=$(uci get sysconfig.bandlock.enableoperator2)
code2=$(uci get sysconfig.bandlock.Code2)

date=$(date)

LogrotateConfigFile1="/etc/logrotate.d/alllogsmod1"
Logfile1="/root/ConfigFiles/Logs/all_logs_mod1.txt"
#Logfile1="/tmp/all_logs_mod1.txt"
LogrotateConfigFile2="/etc/logrotate.d/alllogsmod2"
Logfile2="/root/ConfigFiles/Logs/all_logs_mod2.txt"
#Logfile2="/tmp/all_logs_mod2.txt"

echo "----------<operatorlock.sh> -----------" >> $Logfile1

SetOperatorLock1(){
	echo "$date: Setting operator lock ..." >> $Logfile1
	if [ "$1" = "auto" ]
	then
		Status=$(/bin/at-cmd $ComPort1 at+cops=$x,$c | tail -1)
		Status=${Status:0:2}                                                  
	else
		echo "$date: The PLMN code entered is $code1" >> $Logfile1
		Status=$(/bin/at-cmd $ComPort1 at+cops=$x,$c,\"$code1\" | tail -1)
		Status=${Status:0:2}
	fi
	
	if [ "$Status" = "OK" ]                                                                                                                       
	then
		break
	else
		continue
	fi
}

SetOperatorLock2(){
	echo "$date: Setting operator lock ..." >> $Logfile2
	if [ "$1" = "auto" ]
	then
		Status=$(/bin/at-cmd $ComPort2 at+cops=$x,$c | tail -1)
		Status=${Status:0:2}                                                  
	else
		echo "$date: The PLMN code entered is $code2" >> $Logfile2
		Status=$(/bin/at-cmd $ComPort2 at+cops=$x,$c,\"$code2\" | tail -1)
		Status=${Status:0:2}
	fi
	
	if [ "$Status" = "OK" ]                                                                                                                       
	then
		break
	else
		continue
	fi
}

#For 1st Modem & for AddInterface_mod1
if [ "$Enableoperator1" = "1" ] && [ "$1" = "AddInterface_mod1" ]
then
	echo "$date: Operatorlock is enabled for Modem1." >> $Logfile1
	
	if [ "$selectionmode1" = "auto" ]
	then
		echo "$date: The Selected operator mode for Modem1 is $selectionmode1 ." >> $Logfile1
		x=0
		c=0
		SetOperatorLock1 "auto"
																	  
	elif [ "$selectionmode1" = "manual" ] && [ "$Enableoperator1" = "1" ]
	then
		echo "$date: The Selected operator mode for Modem1 is $selectionmode1 ." >> $Logfile1
		x=1
		c=2
		SetOperatorLock1 "manual"	

	elif [ "$selectionmode1" = "manual-auto" ] && [ "$Enableoperator1" = "1" ]
	then
		echo "$date: The Selected operator mode for Modem1 is $selectionmode1 ." >> $Logfile1
		x=4
		c=2
		SetOperatorLock1 "manual-auto"
		
	fi
fi																																																																																																		  

#For 2nd Modem & for AddInterface_mod2
if [ "$Enableoperator2" = "1" ] && [ "$1" = "AddInterface_mod2" ]
then
	echo "$date: Operatorlock is enabled for Modem2." >> $Logfile2
	
	if [ "$selectionmode2" = "auto" ]
	then
		echo "$date: The Selected operator mode for Modem2 is $selectionmode2 ." >> $Logfile2
		x=0
		c=0
		SetOperatorLock2 "auto"
																	  
	elif [ "$selectionmode2" = "manual" ] && [ "$Enableoperator2" = "1" ]
	then
		echo "$date: The Selected operator mode for Modem2 is $selectionmode2 ." >> $Logfile2
		x=1
		c=2
		SetOperatorLock2 "manual"	

	elif [ "$selectionmode2" = "manual-auto" ] && [ "$Enableoperator2" = "1" ]
	then
		echo "$date: The Selected operator mode for Modem2 is $selectionmode2 ." >> $Logfile2
		x=4
		c=2
		SetOperatorLock2 "manual-auto"
		
	fi
fi

logrotate "$LogrotateConfigFile1"
logrotate "$LogrotateConfigFile2"

exit 0
