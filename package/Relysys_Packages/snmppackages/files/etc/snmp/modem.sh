#!/bin/ash -f

# Function to Ckeck AT Port of Modem1 at singlecellulardualsim(scds)
at1_port_scds()
{	
	modem1_enable1=$(uci get modem.CWAN1_0.modemenable)
	modem1_enable2=$(uci get modem.CWAN1_1.modemenable)
	if [ "$modem1_enable1" = 1 ];then 
		modem_comport=$(uci get modem.CWAN1_0.ComPortSymLink)
		#comport=$(echo $modem_comport | cut -d "/" -f3)
		comport=CWAN1_0
		at1=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
		echo "$at1"
		if [ "$at1" = "OK" ];then
			echo "comport is working"
		else
			modem_comport=$(uci get modem.CWAN1_0.AltComPortSymLink)
			comport=$(echo $modem_comport | cut -d "/" -f3)
		fi
	elif [ "$modem1_enable2" = 1 ];then
		modem_comport=$(uci get modem.CWAN1_1.ComPortSymLink)
		#comport=$(echo $modem_comport | cut -d "/" -f3)
		comport=CWAN1_1
		at1=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
		echo "$at1"
		if [ "$at1" = "OK" ];then
			echo "comport is working"
		else
			modem_comport=$(uci get modem.CWAN1_1.AltComPortSymLink)
			comport=$(echo $modem_comport | cut -d "/" -f3)
		fi
	fi
}

# Function to Ckeck AT Port of Modem1 at dualcellularsinglesim(dcss)
at1_port_dcss()
{
	modem_comport=$(uci get modem.CWAN1.ComPortSymLink)
	#comport=$(echo $modem_comport | cut -d "/" -f3)
	comport=CWAN1
	at1=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
	echo "$at1"
	if [ "$at1" = "OK" ];then
		echo "comport is working"
	else
		modem_comport=$(uci get modem.CWAN1.AltComPortSymLink)
		comport=$(echo $modem_comport | cut -d "/" -f3)
	fi
}

# Function to Ckeck AT Port of Modem2 at dualcellularsinglesim
at2_port_dcss()
{
	modem_comport=$(uci get modem.CWAN2.ComPortSymLink)
	#comport=$(echo $modem_comport | cut -d "/" -f3)
	comport=CWAN2
    at2=$(/bin/at-cmd $modem_comport at | awk 'NR==2 {print $1}')
	echo "$at2"
	if [ "$at2" = "OK" ];then
		echo "comport is working"
	else
		modem_comport=$(uci get modem.CWAN2.AltComPortSymLink)
		comport=$(echo $modem_comport | cut -d "/" -f3)
	fi
}

#Function to get and store device information in /etc/snmp/system_info.txt file...
device_info()
{
	#To get deviceUptime...
	#convert_time.sh script convert the time from sec to years/months/days/hours/minutes/seconds...
	sh /bin/convert_time.sh  
	deviceUptime=$(cat /tmp/convert_time) 

	#To get deviceTemperature
	deviceTemperature=NA
	
	#To get deviceNoofModem...
	deviceNoofModem=$(uci get modemstatus.modemstatus.deviceNoofModem)

	#To get deviceInternetStatus...
	internet_status=$(mwan3 interfaces | grep -o online)
	if [ -n "$internet_status" ];then
		deviceInternetStatus="online"
	else
		deviceInternetStatus="offline"
	fi

	#To get device_internet_interface_name...
	deviceActiveInetInterfaceName=$(mwan3 interfaces | grep -i "online" | awk '{print $2}' | tr '\n' ',' | sed 's/,$//')

	#To get deviceWANInternetStatus...
	wan_interfaces=$(mwan3 interfaces | grep -i EWAN)
	wan_interfaces_online=$(echo $wan_interfaces | grep -o online)
	if [ -n "$wan_interfaces_online" ];then
		deviceEWANInternetStatus="online"
	else
		deviceEWANInternetStatus="offline"
	fi
	
	#To get CellularOperationMode...
	deviceCellularOperationMode=$(uci get modemstatus.modemstatus.CellularOperationMode)
	
	#To store Device information of modem1...
	sed -i "/^deviceUptime=/c\deviceUptime=$deviceUptime" /etc/snmp/system_info.txt
	sed -i "/^deviceTemperature=/c\deviceTemperature=$deviceTemperature" /etc/snmp/system_info.txt
	sed -i "/^deviceNoofModem=/c\deviceNoofModem=$deviceNoofModem" /etc/snmp/system_info.txt
	sed -i "/^deviceInternetStatus=/c\deviceInternetStatus=$deviceInternetStatus" /etc/snmp/system_info.txt
	sed -i "/^deviceActiveInetInterfaceName=/c\deviceActiveInetInterfaceName=$deviceActiveInetInterfaceName" /etc/snmp/system_info.txt
	sed -i "/^deviceEWANInternetStatus=/c\deviceEWANInternetStatus=$deviceEWANInternetStatus" /etc/snmp/system_info.txt
	sed -i "/^deviceCellularOperationMode=/c\deviceCellularOperationMode=$deviceCellularOperationMode" /etc/snmp/system_info.txt
}

# Function to get and store modem1 information in /etc/snmp/modem1_info.txt
modem1_info() {
	
	#To get modem1 information...
    ModemRevision=$(uci get modemstatus.modemstatus.ModemRevision)
    Manufacturer=$(uci get modemstatus.modemstatus.Manufacturer)
    IMSI=$(uci get modemstatus.modemstatus.IMSI)
    Model=$(uci get modemstatus.modemstatus.Model)
    Imei=$(uci get modemstatus.modemstatus.Imei)
    
    #To store modem1 information...
    {
        echo "modem1Revision=$ModemRevision"
        echo "modem1Manufacturer=$Manufacturer"
        echo "modem1IMSI=$IMSI"
        echo "modem1Model=$Model"
        echo "modem1IMEI=$Imei"
        echo "modem1ActiveSim=$ActiveSim"
    } | tr -d '\r' > /etc/snmp/modem1_info.txt
}

# Function to get and store modem1 sim information in /etc/snmp/modem1_sim${sim_num}_info.txt...
#sim_num value is depend on active sim...
#If sim_num is 1 then values are store in /etc/snmp/modem1_sim1_info.txt file...
#If sim_num is 2 then values are store in /etc/snmp/modem1_sim2_info.txt file...
modem1_sim_info() {
	
	sim_num="$1"
	file=$(echo /etc/snmp/modem1_sim${sim_num}_info.txt)
		
	#To get modem1 sim information...
	sim_Reg_State=$(uci get modemstatus.modemstatus.sim_Reg_State)
    PinState=$(uci get modemstatus.modemstatus.PinState)
    SignalStrength=$(uci get modemstatus.modemstatus.SignalStrength)
    Operator=$(uci get modemstatus.modemstatus.Operator)
    OperatorCode=$(uci get modemstatus.modemstatus.OperatorCode)
    CellID=$(uci get modemstatus.modemstatus.CellID)
    SentToday=$(uci get modemstatus.modemstatus.SentToday)
    ReceivedToday=$(uci get modemstatus.modemstatus.ReceivedToday)
    Sent_till_date_this_month=$(uci get modemstatus.modemstatus.msent)
    Received_till_date_this_month=$(uci get modemstatus.modemstatus.mreceived)
	ConnectionState=$(mwan3 interfaces |grep "$comport" | awk '{print $4}')
    ConnectionMode=$(uci get modemstatus.modemstatus.Connected)
    SINR=$(uci get modemstatus.modemstatus.SINR)
    RSRP=$(uci get modemstatus.modemstatus.RSRP)
    RSRQ=$(uci get modemstatus.modemstatus.RSRQ)
    RSSI=$(uci get modemstatus.modemstatus.RSSI)
    IP=$(cat /tmp/modem1_IP | tr ' ' ',' | sed 's/,$//')   
    QCCID=$(uci get modemstatus.modemstatus.QCCID)
    FDDIMode=$(uci get modemstatus.modemstatus.MODE)
    BandNumber=$(uci get modemstatus.modemstatus.BAND)
    pinstate
    
    #To store modem1 sim information...
    {
		echo "modem1sim${sim_num}RegState=$sim_Reg_State"
        echo "modem1sim${sim_num}PinState=$PinState"
        echo "modem1sim${sim_num}SignalStrengthCSQ=$SignalStrength"
        echo "modem1sim${sim_num}Operator=$Operator"
        echo "modem1sim${sim_num}OperatorCode=$OperatorCode"
        echo "modem1sim${sim_num}CellID=$CellID"
        echo "modem1sim${sim_num}SentToday=$SentToday"
        echo "modem1sim${sim_num}ReceivedToday=$ReceivedToday"
        echo "modem1sim${sim_num}SentTillDateThisMonth=$Sent_till_date_this_month"
        echo "modem1sim${sim_num}ReceivedTDateTMonth=$Received_till_date_this_month"
        echo "modem1sim${sim_num}ConnectionState=$ConnectionState"
        echo "modem1sim${sim_num}ConnectionMode=$ConnectionMode"
        echo "modem1sim${sim_num}SINR=$SINR"
        echo "modem1sim${sim_num}RSRP=$RSRP"
        echo "modem1sim${sim_num}RSRQ=$RSRQ"
        echo "modem1sim${sim_num}RSSI=$RSSI"
        echo "modem1sim${sim_num}IP=$IP"
        echo "modem1sim${sim_num}QCCID=$QCCID"
        echo "modem1sim${sim_num}FDDIMode=$FDDIMode"
        echo "modem1sim${sim_num}BandNumber=$BandNumber"
    } > $file
}

# Function to get and store modem2 information in /etc/snmp/modem2_info.txt
modem2_info() {
	
	#To get modem2 information...
    ModemRevision=$(uci get modemstatus.modemstatus.ModemRevision2)
    Manufacturer=$(uci get modemstatus.modemstatus.Manufacturer2)
    IMSI=$(uci get modemstatus.modemstatus.IMSI2)
    Model=$(uci get modemstatus.modemstatus.Model2)
    Imei=$(uci get modemstatus.modemstatus.Imei2)
    
    #To store modem2 information...
    {
        echo "modem2Revision=$ModemRevision"
        echo "modem2Manufacturer=$Manufacturer"
        echo "modem2IMSI=$IMSI"
        echo "modem2Model=$Model"
        echo "modem2IMEI=$Imei"
        echo "modem2ActiveSim=$ActiveSim"
    } | tr -d '\r' > /etc/snmp/modem2_info.txt
}

# Function to get and store modem2 sim information in /etc/snmp/modem2_sim${sim_num}_info.txt...
#sim_num value is depend on active sim...
#If sim_num is 1 then values are store in /etc/snmp/modem2_sim1_info.txt file...
#If sim_num is 2 then values are store in /etc/snmp/modem2_sim2_info.txt file...
modem2_sim_info() {
	
	sim_num="$1"
	file=$(echo /etc/snmp/modem2_sim${sim_num}_info.txt)
		
	#To get modem1 sim information...
	sim_Reg_State=$(uci get modemstatus.modemstatus.sim_Reg_State2)
    PinState=$(uci get modemstatus.modemstatus.PinState2)
    SignalStrength=$(uci get modemstatus.modemstatus.SignalStrength2)
    Operator=$(uci get modemstatus.modemstatus.Operator2)
    OperatorCode=$(uci get modemstatus.modemstatus.OperatorCode2)
    CellID=$(uci get modemstatus.modemstatus.CellID2)
    SentToday=$(uci get modemstatus.modemstatus.SentToday2)
    ReceivedToday=$(uci get modemstatus.modemstatus.ReceivedToday2)
    Sent_till_date_this_month=$(uci get modemstatus.modemstatus.msent2)
    Received_till_date_this_month=$(uci get modemstatus.modemstatus.mreceived2)
	ConnectionState=$(mwan3 interfaces |grep "$comport" | awk '{print $4}')
    ConnectionMode=$(uci get modemstatus.modemstatus.Connected2)
    SINR=$(uci get modemstatus.modemstatus.SINR2)
    RSRP=$(uci get modemstatus.modemstatus.RSRP2)
    RSRQ=$(uci get modemstatus.modemstatus.RSRQ2)
    RSSI=$(uci get modemstatus.modemstatus.RSSI2)
    IP=$(cat /tmp/modem2_IP | tr ' ' ',' | sed 's/,$//')   
    QCCID=$(uci get modemstatus.modemstatus.QCCID2)
    FDDIMode=$(uci get modemstatus.modemstatus.MODE2)
    BandNumber=$(uci get modemstatus.modemstatus.BAND2)
    pinstate
    
    #To store modem1 sim information...
    {
		echo "modem2sim${sim_num}RegState=$sim_Reg_State"
        echo "modem2sim${sim_num}PinState=$PinState"
        echo "modem2sim${sim_num}SignalStrengthCSQ=$SignalStrength"
        echo "modem2sim${sim_num}Operator=$Operator"
        echo "modem2sim${sim_num}OperatorCode=$OperatorCode"
        echo "modem2sim${sim_num}CellID=$CellID"
        echo "modem2sim${sim_num}SentToday=$SentToday"
        echo "modem2sim${sim_num}ReceivedToday=$ReceivedToday"
        echo "modem2sim${sim_num}SentTillDateThisMonth=$Sent_till_date_this_month"
        echo "modem2sim${sim_num}ReceivedTDateTMonth=$Received_till_date_this_month"
        echo "modem2sim${sim_num}ConnectionState=$ConnectionState"
        echo "modem2sim${sim_num}ConnectionMode=$ConnectionMode"
        echo "modem2sim${sim_num}SINR=$SINR"
        echo "modem2sim${sim_num}RSRP=$RSRP"
        echo "modem2sim${sim_num}RSRQ=$RSRQ"
        echo "modem2sim${sim_num}RSSI=$RSSI"
        echo "modem2sim${sim_num}IP=$IP"
        echo "modem2sim${sim_num}QCCID=$QCCID"
        echo "modem2sim${sim_num}FDDIMode=$FDDIMode"
        echo "modem2sim${sim_num}BandNumber=$BandNumber"
    } > $file
}

#For snmp agent "ActiveSim" is fixed with the help of QCCID...
Sim_info()
{
	sim="$1"
	if [ "$sim" = "modem2sim1" ];then
		QCCID=$(uci get modemstatus.modemstatus.QCCID2)
		sim=1
	else
		QCCID=$(uci get modemstatus.modemstatus.QCCID)
	fi
	
	QCCID=$(uci get system.system.qccid | tr -d '\011\012\013\014\015\040')
	for i in $(seq 1 3)
    do
		len_qccid=$(echo ${#QCCID})
		if [ "$len_qccid" -eq "20" ]
		then
			ActiveSim=$sim
			break
		else
			ActiveSim=0
			QCCID=$(at-cmd $modem_comport at+qccid | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
		fi
		echo "$i"
	done
}

pinstate() {
	for i in $(seq 1 3)
    do
		if [ -z "$PinState" ]
		then
			PinState=$(at-cmd $modem_comport at+cpin? | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
		fi
		echo "$i"
	done
}

enablecellular=$(uci get sysconfig.sysconfig.enablecellular)
cellularmode=$(uci get sysconfig.sysconfig.CellularOperationMode)

if [ $enablecellular = 0 ]
then 
	exit 0
fi

#Call the function to get device information
device_info

if [ "$cellularmode" = "singlecellularsinglesim" ];then
	# Function to Ckeck AT Port of Modem1 at singlecellularsinglesim(scss) is same as dualcellularsinglesim(dcss) i.e. at1_port_dcss
	at1_port_dcss
	Sim_info 1
	modem1_info
	modem1_sim_info 1
    
elif [ "$cellularmode" = "singlecellulardualsim" ];then
	sim_up=$(cat /tmp/simnumfile)
	at1_port_scds
	if [ "$sim_up" = "1" ];then
		Sim_info 1
		modem1_info
		modem1_sim_info 1
	elif [ "$sim_up" = "2" ];then
		Sim_info 2
		modem1_info
		modem1_sim_info 2
	fi
    
elif [ "$cellularmode" = dualcellularsinglesim ];then	
	#call function for Modem1
	at1_port_dcss
	Sim_info 1
	modem1_info
	modem1_sim_info 1
    
    #call function for Modem2
    at2_port_dcss
    Sim_info modem2sim1
    modem2_info
	modem2_sim_info 1
	
fi
