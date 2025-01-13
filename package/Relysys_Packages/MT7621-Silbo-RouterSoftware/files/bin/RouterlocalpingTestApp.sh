#!/bin/sh
#IP=$1
#PingTime=$2
#ping -c $PingTime $IP
#Retval="$?"
#echo "Retval=$Retval"
#echo "$Retval" > "/bin/pingTest.txt"
#PingIP=8.8.8.8
#maxnoofretries=10
#sleepinterval=1
. /root/ConfigFiles/RouterAppConfig/routerapplocalconfig.cfg
. /root/ConfigFiles/RouterAppConfig/routerappremoteconfig.cfg

mkdir /tmp/Log
touch /tmp/Log/RouterlocalpingMsgLog

PacketCount=4
PingDeadline=4
localMinPacketLoss=$localfailurecriteria
localMinPacketLoss2=$localfailurecriteria2
remoteMinPacketLoss=$remotefailurecriteria
remoteMinPacketLoss2=$remotefailurecriteria2
iretries=0
pingres=2

PingTest()
{
	localipaddress=$1
	localipaddress2=$1
	remoteipaddress=$1
	remoteipaddress2=$1
	ifname=$(uci get modem.CWAN1.ifname)
	ifname2=$(uci get modem.CWAN2.ifname)
	Enable464xlatSim1=$(uci get sysconfig.sysconfig.Enable464xlatSim1)
	Enable464xlatSim2=$(uci get sysconfig.sysconfig.Enable464xlatSim2)
	pdp1=$(uci get sysconfig.sysconfig.pdp)
	pdp2=$(uci get sysconfig.sysconfig.sim2pdp)
	if [ "pdp1" = "2" ]
	then 
		if [ "Enable464xlatSim1" = "1" ]
		then
			localipaddress1=$(uci set routerapplicationconfig.routerapplicationlocalconfig.localipaddress1='2001:4860:4860::8888')
			localifname="$ifname"
		fi
	else
		localipaddress1=$(uci set routerapplicationconfig.routerapplicationlocalconfig.localipaddress1='8.8.8.8')
		localifname="$ifname"
	fi
	if [ "pdp2" = "2" ]
	then 
			if [ "Enable464xlatSim2" = "1" ]
		then
			localipaddress1=$(uci set routerapplicationconfig.routerapplicationlocalconfig.localipaddress9='2001:4860:4860::8888')
			localifname="$ifname2"
		fi
	else
		localipaddress1=$(uci set routerapplicationconfig.routerapplicationlocalconfig.localipaddress9='8.8.8.8')
		localifname="$ifname2"
	fi
	localPingOutput=$(ping -I $localifname -c "$PacketCount" -w "$PingDeadline" "$localipaddress" 2>&1)
	localPingOutput2=$(ping -I $localifname2 -c "$PacketCount" -w "$PingDeadline" "$localipaddress2" 2>&1)
	remotePingOutput=$(ping -c "$PacketCount" -w "$PingDeadline" "$remoteipaddress" 2>&1)
	remotePingOutput2=$(ping -c "$PacketCount" -w "$PingDeadline" "$remoteipaddress2" 2>&1)
	
    localPingOutput=$(echo "$localPingOutput" | awk '/packets transmitted|received|packet loss|errors/')
    localPingOutput2=$(echo "$localPingOutput2" | awk '/packets transmitted|received|packet loss|errors/')
    remotePingOutput=$(echo "$remotePingOutput" | awk '/packets transmitted|received|packet loss|errors/')
    remotePingOutput2=$(echo "$remotePingOutput2" | awk '/packets transmitted|received|packet loss|errors/')

    localPacketsTransmitted=$(echo "$localPingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' | awk '/transmitted/' | awk '{ print $1 }')
    localPacketsTransmitted2=$(echo "$localPingOutput2" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' | awk '/transmitted/' | awk '{ print $1 }')
    remotePacketsTransmitted=$(echo "$remotePingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' | awk '/transmitted/' | awk '{ print $1 }')
    remotePacketsTransmitted2=$(echo "$remotePingOutput2" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' | awk '/transmitted/' | awk '{ print $1 }')
    
    localPacketsReceived=$(echo "$localPingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/received/' | awk '{ print $1 }')
    localPacketsReceived2=$(echo "$localPingOutput2" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/received/' | awk '{ print $1 }')
    remotePacketsReceived=$(echo "$remotePingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/received/' | awk '{ print $1 }')
    remotePacketsReceived2=$(echo "$remotePingOutput2" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/received/' | awk '{ print $1 }')
    
    localPacketLoss=$(echo "$localPingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/loss/' | awk '{ print $1 }' | awk -F % '{ print $1 }')
    localPacketLoss2=$(echo "$localPingOutput2" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/loss/' | awk '{ print $1 }' | awk -F % '{ print $1 }')
    remotePacketLoss=$(echo "$remotePingOutput" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/loss/' | awk '{ print $1 }' | awk -F % '{ print $1 }')
    remotePacketLoss2=$(echo "$remotePingOutput2" | awk -F , '{ for(i=1;i<=NF;i++)print $i }' |  awk '/loss/' | awk '{ print $1 }' | awk -F % '{ print $1 }')
    
    if [ "x$PacketLoss" = "x" ] || [ "$localPacketLoss" -ge "$localMinPacketLoss" ]
    then
        pingres=2
        uci set routerapplicationconfig.routerapplicationlocalconfig.modem1ping="1"
    else
        pingres=0
        uci delete routerapplicationconfig.routerapplicationlocalconfig.modem1ping
        break

    fi
    if [ "x$PacketLoss" = "x" ] || [ "$localPacketLoss2" -ge "$localMinPacketLoss2" ]
    then
        pingres=2
        uci set routerapplicationconfig.routerapplicationlocalconfig.modem2ping="2"

    else
        pingres=0
        uci delete routerapplicationconfig.routerapplicationlocalconfig.modem1ping
        break

    fi
    if [ "x$PacketLoss" = "x" ] || [ "$remotePacketLoss" -ge "$remoteMinPacketLoss" ]
    then
        pingres=2
        uci set routerapplicationconfig.routerapplicationRemoteconfig.modem1ping="2"
    else
        pingres=0
        uci delete routerapplicationconfig.routerapplicationRemoteconfig.modem1ping
        break

    fi
    if [ "x$PacketLoss" = "x" ] || [ "$remotePacketLoss2" -ge "$remoteMinPacketLoss2" ]
    then
        pingres=2
        uci set routerapplicationconfig.routerapplicationRemoteconfig.modem2ping="2"
    else
        pingres=0
        uci delete routerapplicationconfig.routerapplicationRemoteconfig.modem2ping
        break

    fi
    if [ "x$PacketLoss" = "x" ]
    then
        CurrentDate=$(date +"%Y-%m-%d %H:%M:%S")
        LogMsg="\"<\",\"Network unreachable,\"$CurrentDate\"\">\""
        echo $LogMsg >> "/tmp/Log/RouterlocalpingMsgLog"
    else	
		CurrentDate=$(date +"%Y-%m-%d %H:%M:%S")
		LogMsg="\"<\",\"localIPaddress:$localipaddress\",\"localIPaddress2:$localipaddress2\",\"remoteIPaddress:$remoteipaddress\",\"remoteIPaddress:$remoteipaddress2\",\"PacketTx:$PacketsTransmitted\",\"localPacketRx:$localPacketsReceived\",\"localPacketRx2:$localPacketsReceived2\",\"remotePacketRx:$remotePacketsReceived\",\"remotePacketRx2:$remotePacketsReceived2\",\"localPacketLoss:$localPacketLoss\",\"localPacketLoss2:$localPacketLoss2\",\"remotePacketLoss:$remotePacketLoss\",\"remotePacketLoss2:$remotePacketLoss2\",\"$CurrentDate\",\">\""
		echo $LogMsg >> "/tmp/Log/RouterlocalpingMsgLog"
	fi
	echo $pingres > "/tmp/RouterlocalpingTestApp.txt"
	return $pingres
}

localping()
{
	case "$nooflocalipaddress" in
    1)
		PingTest "$localipaddress1"
	;;
	
	2)
		PingTest "$localipaddress1"
		ret=$?
		if [ "$ret" == 0 ]
		then
			PingTest "$localipaddress2"
		else
			exit 0
		fi
	;;
	
	3)
		PingTest "$localipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress3"
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	4)
		PingTest "$localipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress4"
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	5)
		PingTest "$localipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress5"
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	6)
		PingTest "$localipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress5"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$localipaddress6"
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	7)
		PingTest "$localipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress5"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$localipaddress6"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$localipaddress7"
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	8)
		PingTest "$localipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress5"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$localipaddress6"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$localipaddress7"
								ret7=$?
								if [ "$ret7" == 0 ]
								then
									PingTest "$localipaddress8"
								else
									exit 0
								fi
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	*)
    ;;
esac
	}

local2()
{
	case "$nooflocalipaddress2" in
    1)
		PingTest "$localipaddress9"
	;;
	
	2)
		PingTest "$localipaddress9"
		ret=$?
		if [ "$ret" == 0 ]
		then
			PingTest "$localipaddress10"
		else
			exit 0
		fi
	;;
	
	3)
		PingTest "$localipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress11"
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	4)
		PingTest "$localipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress12"
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	5)
		PingTest "$localipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress13"
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	6)
		PingTest "$localipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress13"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$localipaddress14"
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	7)
		PingTest "$localipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress13"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$localipaddress14"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$localipaddress15"
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	8)
		PingTest "$localipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$localipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$localipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$localipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$localipaddress13"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$localipaddress14"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$localipaddress15"
								ret7=$?
								if [ "$ret7" == 0 ]
								then
									PingTest "$localipaddress16"
								else
									exit 0
								fi
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	*)
    ;;
esac
	}

remoteping()
{
	case "$noofremoteipaddress" in
    1)
		PingTest "$remoteipaddress1"
	;;
	
	2)
		PingTest "$remoteipaddress1"
		ret=$?
		if [ "$ret" == 0 ]
		then
			PingTest "$remoteipaddress2"
		else
			exit 0
		fi
	;;
	
	3)
		PingTest "$remoteipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress3"
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	4)
		PingTest "$remoteipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress4"
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	5)
		PingTest "$remoteipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress5"
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	6)
		PingTest "$remoteipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress5"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$remoteipaddress6"
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	7)
		PingTest "$remoteipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress5"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$remoteipaddress6"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$remoteipaddress7"
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	8)
		PingTest "$remoteipaddress1"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress2"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress3"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress4"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress5"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$remoteipaddress6"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$remoteipaddress7"
								ret7=$?
								if [ "$ret7" == 0 ]
								then
									PingTest "$remoteipaddress8"
								else
									exit 0
								fi
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	*)
    ;;
esac
	}

remote2()
{
	case "$noofremoteipaddress2" in
    1)
		PingTest "$remoteipaddress9"
	;;
	
	2)
		PingTest "$remoteipaddress9"
		ret=$?
		if [ "$ret" == 0 ]
		then
			PingTest "$remoteipaddress10"
		else
			exit 0
		fi
	;;
	
	3)
		PingTest "$remoteipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress11"
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	4)
		PingTest "$remoteipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress12"
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	5)
		PingTest "$remoteipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress13"
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	6)
		PingTest "$remoteipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress13"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$remoteipaddress14"
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	7)
		PingTest "$remoteipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress13"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$remoteipaddress14"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$remoteipaddress15"
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	8)
		PingTest "$remoteipaddress9"
		ret1=$?
		if [ "$ret1" == 0 ]
		then
			PingTest "$remoteipaddress10"
			ret2=$?
			if [ "$ret2" == 0 ]
			then
				PingTest "$remoteipaddress11"
				ret3=$?
				if [ "$ret3" == 0 ]
				then
					PingTest "$remoteipaddress12"
					ret4=$?
					if [ "$ret4" == 0 ]
					then
						PingTest "$remoteipaddress13"
						ret5=$?
						if [ "$ret5" == 0 ]
						then
							PingTest "$remoteipaddress14"
							ret6=$?
							if [ "$ret6" == 0 ]
							then
								PingTest "$remoteipaddress15"
								ret7=$?
								if [ "$ret7" == 0 ]
								then
									PingTest "$remoteipaddress16"
								else
									exit 0
								fi
							else
								exit 0
							fi
						else
							exit 0
						fi
					else
						exit 0
					fi
				else
					exit 0
				fi
			else
				exit 0
			fi
		else
			exit 0
		fi
	;;
	
	*)
    ;;
esac
	}

localping
local2
remoteping
remote2

exit 0      
