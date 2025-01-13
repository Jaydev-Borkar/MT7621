#!/bin/sh
#IP=$1
#PingTime=$2
#ping -c $PingTime $IP
#Retval="$?"
#echo "Retval=$Retval"
#echo "$Retval" > "/bin/pingTest.txt"
#PacketCount=4
#PingDeadline=4
#PingIP=8.8.8.8
#MinPacketLoss=60
#maxnoofretries=10
#sleepinterval=1
. /root/ConfigFiles/RouterAppConfig/routerappremoteconfig2.cfg

PacketCount=4
PingDeadline=4
MinPacketLoss=$failurecriteria
iretries=0
pingres=2

PingTest()
{
	ipaddress=$1
	PingOutput=$(ping -c "$PacketCount" -w "$PingDeadline" "$ipaddress" 2>&1)
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
	echo $pingres > "/tmp/RouterRemotepingTestApp2.txt"
	return $pingres
}
 
case "$noofipaddress" in
    1)
		PingTest "$ipaddress1"
	;;
	
	2)
		PingTest "$ipaddress1"
		ret=$?
		if [ "$ret" == 0 ]
		then
			PingTest "$ipaddress2"
		else
			exit 0
		fi
	;;
	
	*)
    ;;
esac
exit 0       
