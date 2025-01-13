#!/bin/sh

. /lib/functions.sh

#IP=$1
#PingTime=$2
#ping -c $PingTime $IP
#Retval="$?"
#echo "Retval=$Retval"
#echo "$Retval" > "/bin/pingTest.txt"
#PingIP=8.8.8.8
#maxnoofretries=10
#sleepinterval=1

CellularOperationMode=$(uci get sysconfig.sysconfig.CellularOperationMode)

ReadMwanConfigFile()
{ 
   config_load "$MwanConfigFile" 
   config_get Cwan1sim1TrackIp1 "$cellularwan1sim1interface" trackIp1
   config_get Cwan1sim1TrackIp2 "$cellularwan1sim1interface" trackIp2
   config_get Cwan1sim1TrackIp3 "$cellularwan1sim1interface" trackIp3
   config_get Cwan1sim1TrackIp4 "$cellularwan1sim1interface" trackIp4
   config_get Cwan1sim1Validtrackip "$cellularwan1sim1interface" validtrackip
   

   config_get Cwan1sim2TrackIp1 "$cellularwan1sim2interface" trackIp1
   config_get Cwan1sim2TrackIp2 "$cellularwan1sim2interface" trackIp2
   config_get Cwan1sim2TrackIp3 "$cellularwan1sim2interface" trackIp3
   config_get Cwan1sim2TrackIp4 "$cellularwan1sim2interface" trackIp4
   config_get Cwan1sim2Validtrackip "$cellularwan1sim2interface" validtrackip
   
   #IPV6 variables
	config_get Cwan6_1TrackIp1 "$cellular1wan6interface" trackIp1
	config_get Cwan6_1TrackIp2 "$cellular1wan6interface" trackIp2
	config_get Cwan6_1TrackIp3 "$cellular1wan6interface" trackIp3
	config_get Cwan6_1TrackIp4 "$cellular1wan6interface" trackIp4
	config_get Cwan6_1validtrackip "$cellular1wan6interface" validtrackip


	config_get Cwan6_2TrackIp1 "$cellular2wan6interface" trackIp1
	config_get Cwan6_2TrackIp2 "$cellular2wan6interface" trackIp2
	config_get Cwan6_2TrackIp3 "$cellular2wan6interface" trackIp3
	config_get Cwan6_2TrackIp4 "$cellular2wan6interface" trackIp4
	config_get Cwan6_2validtrackip "$cellular2wan6interface" validtrackip
   
}

UpdateRouterApplocalCfgModem1()
{
    echo "Updating Router Application configuration "
    echo "Updating '${RouterApplocalconfigureCfgPath1}.cfg' configuration"
    config_load "$RouterEventfile"
    
    config_get  enablerouterlocalpingapp      "$routerlocalconfigureEventSection1"    enablerouterlocalpingapp
    config_get  timeintervalforpingcheck      "$routerlocalconfigureEventSection1"    timeintervalforpingcheck
    config_get  noofipaddress                 "$routerlocalconfigureEventSection1"    noofipaddress
    config_get  ipaddress1                    "$routerlocalconfigureEventSection1"    ipaddress1
    config_get  ipaddress2                    "$routerlocalconfigureEventSection1"    ipaddress2
    config_get  failurecriteria               "$routerlocalconfigureEventSection1"    failurecriteria
    config_get  failureaction                 "$routerlocalconfigureEventSection1"    failureaction
    config_get  noofretries                   "$routerlocalconfigureEventSection1"    noofretries


   # config_get     
   {
	   echo "enablerouterlocalpingapp=\"$enablerouterlocalpingapp\""
	   echo "timeintervalforpingcheck=\"$timeintervalforpingcheck\""
	   echo "noofipaddress=\"$noofipaddress\""
	   echo "ipaddress1=\"$ipaddress1\""
	   echo "ipaddress2=\"$ipaddress2\""
	   echo "failurecriteria=\"$failurecriteria\""
	   echo "failureaction=\"$failureaction\""
	   echo "noofretries=\"$noofretries\""

   } > "${RouterApplocalconfigureCfgPath1}.cfg"
  
}

RouterConfigFileUpdate()
{
	cellularwan1sim1interface="CWAN1_0"
	cellularwan1sim2interface="CWAN1_1"
	
	#IPV6 Variables 
	cellular1wan6interface="wan6c1"
	cellular2wan6interface="wan6c2"
	
	MwanConfigFile="/etc/config/mwan3config"
	SystemConfigFile="/etc/config/sysconfig"
	RouterApplocalconfigureCfgPath1="/root/ConfigFiles/RouterAppConfig/routerapplocalconfig1"
	RouterEventfile="routerapplicationconfig"
	routerlocalconfigureEventSection1="routerapplicationlocalconfigModem1"

	ReadMwanConfigFile
	
	Pdp1=$(uci get sysconfig.sysconfig.pdp)
	sim2pdp=$(uci get sysconfig.sysconfig.sim2pdp)
	
	
	simnum=$(cat /tmp/simnumfile)
	
	if [ "$CellularOperationMode" = "singlecellulardualsim" ]
	then		
		if [ "$simnum" = "1" ]                                                                                                
		then 		
			#CWAN1_0
			#If pdp1 is ipv4 or ipv4v6
			if [ "$Pdp1" = "1" ]  || [ "$Pdp1" = "3" ]
			then
				if [ "$Cwan1sim1Validtrackip" =  "1" ]
				then 
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1sim1TrackIp1"
				fi
				if [ "$Cwan1sim1Validtrackip" =  "2" ]
				then 
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1sim1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan1sim1TrackIp2"
				fi
		
			fi
			
			#If pdp1 is ipv6
			if [ "$Pdp1" = "2" ]
			then
				
				if [ "$Cwan6_1validtrackip" = "1" ]
				then                 
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_1TrackIp1"
				fi
				if [ "$Cwan6_1validtrackip" = "2" ]
				then
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan6_1TrackIp2"
				fi
			fi 
		elif [ "$simnum" = "2" ]
		then
			#CWAN1_1
			#If pdp2 is ipv4 or ipv4v6
			if [ "$sim2pdp" = "1" ]  || [ "$sim2pdp" = "3" ]
			then				
				
				if [ "$Cwan1sim2Validtrackip" =  "1" ]
				then 
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1sim2TrackIp1"
				fi
				if [ "$Cwan1sim2Validtrackip" =  "2" ]
				then 
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1sim2TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan1sim2TrackIp2"
				fi				
			fi
			
			#If pdp2 is ipv6
			if [ "$sim2pdp" = "2" ]
			then
				
				if [ "$Cwan6_2validtrackip" = "1" ]
				then
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_2TrackIp1"
				fi
				if [ "$Cwan6_2validtrackip" = "2" ]
				then
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_2TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan6_2TrackIp2"
				fi
			fi 
		fi
		uci commit routerapplicationconfig
	
	fi

	UpdateRouterApplocalCfgModem1
	sleep 1
}


RouterConfigFileUpdate
. /root/ConfigFiles/RouterAppConfig/routerapplocalconfig1.cfg

PacketCount=4
PingDeadline=4
MinPacketLoss=$failurecriteria
iretries=0
pingres=2

PingTest()
{
	ipaddress=$1
	ifname=$2
	
	PingOutput=$(ping -I $ifname -c "$PacketCount" -w "$PingDeadline" "$ipaddress" 2>&1)
    PingOutput=$(echo "$PingOutput" | awk '/packets transmitted|received|packet loss|errors/')

    PacketsTransmitted=$(echo "$PingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' | awk '/transmitted/' | awk '{ print $1 }')
    PacketsReceived=$(echo "$PingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/received/' | awk '{ print $1 }')
    PacketLoss=$(echo "$PingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/loss/' | awk '{ print $1 }' | awk -F % '{ print $1 }')
    
    if [ "x$PacketLoss" = "x" ] || [ "$PacketLoss" -ge "$MinPacketLoss" ]
    then
        pingres=2
    else
        pingres=0
        break
    fi
    
    if [ "x$PacketLoss" = "x" ]
    then
        CurrentDate=$(date +"%Y-%m-%d %H:%M:%S")
        LogMsg="\"<\",\"Network unreachable,\"$CurrentDate\"\">\""
    else	
		CurrentDate=$(date +"%Y-%m-%d %H:%M:%S")
		LogMsg="\"<\",\"IPaddress:$ipaddress\",\"PacketTx:$PacketsTransmitted\",\"PacketRx:$PacketsReceived\",\"PacketLoss:$PacketLoss\",\"$CurrentDate\",\">\""
	fi
	
	echo $pingres > "/tmp/RouterlocalpingTestApp1.txt"
	return $pingres
}



if [ "$CellularOperationMode" = "dualcellularsinglesim" ]
then
	interface="CWAN1"

elif [ "$CellularOperationMode" = "singlecellulardualsim" ]
then
	#Check which interface is enabled
	modemenable1=$(uci get modem.CWAN1_0.modemenable)
	modemenable2=$(uci get modem.CWAN1_1.modemenable)
	if [ "$modemenable1" = "1" ]
	then
		interface="CWAN1_0"
	else
		interface="CWAN1_1"
	fi
else
	interface="CWAN1"
	
fi

ifname=$(uci get modem.${interface}.ifname)

case "$noofipaddress" in
	1)
		PingTest "$ipaddress1" "$ifname"
	;;
	
	2)
		PingTest "$ipaddress1" "$ifname"
		ret=$?
		if [ "$ret" == 0 ]
		then
			PingTest "$ipaddress2" "$ifname"
		else
			exit 0
		fi
	;;
	
	*)
	;;
esac


exit 0
