#!/bin/sh

. /lib/functions.sh

ReadSystemConfigFile()                               
{                                                    
        config_load "$SystemConfigFile"              
        config_get EnableCellular sysconfig enablecellular
        config_get PortType1 sysconfig porttype1
        config_get ComPort1 sysconfig comport1
        config_get SmsEnable1 sysconfig smsenable1
        config_get SmsEnable2 sysconfig smsenable2
        config_load "$BoardConfigfile"
		config_get serialnum  board serialnum
}

ReadSystemGpioFile()                               
{                                                    
        config_load "$SystemGpioConfig"              
        config_get BoardPowerGpio gpio boardpowergpio
        config_get BoardOnValue gpio boardonvalue
        config_get BoardOffValue gpio boardoffvalue
        config_get Modem1PowerGpio gpio modem1powergpio
        config_get Modem1PowerOnValue gpio modem1poweronvalue
        config_get Modem1PowerOffValue gpio modem1poweroffvalue
        config_get Modem2PowerGpio gpio modem2powergpio
        config_get Modem2PowerOnValue gpio modem2poweronvalue
        config_get Modem2PowerOffValue gpio modem2poweroffvalue
        config_get ExternelUsb gpio externelusb
        config_get ExternelUsbGpio gpio externelusbgpio
        config_get ExternelUsbOnValue gpio externelusbonvalue
        config_get ExternelUsbOffValue gpio externelusboffvalue
        config_get SimSelectGpio gpio simselectgpio
        config_get Sim1SelectValue gpio sim1selectvalue
        config_get Sim2SelectValue gpio sim2selectvalue
        config_get NoOfProgramLed gpio noofprogramled
        config_get ProgramLed1Number gpio programled1number
        config_get ProgramLed1OnValue gpio programled1onvalue
        config_get ProgramLed1OffValue gpio programled1offvalue
        config_get ProgramLed2Number gpio programled2number
        config_get ProgramLed2OnValue gpio programled2onvalue
        config_get ProgramLed2OffValue gpio programled2offvalue
        config_get ProgramLed3Number gpio programled3number
        config_get ProgramLed3OnValue gpio programled3onvalue
        config_get ProgramLed3OffValue gpio programled3offvalue
        config_get ProgramLed4Number gpio programled4number
        config_get ProgramLed4OnValue gpio programled4onvalue
        config_get ProgramLed4OffValue gpio programled4offvalue
        config_get SystemResetSwitch gpio systemresetswitch
        config_get Sim1LedGpio gpio Sim1LedGpio
        config_get Sim1LedGpioOnvalue gpio Sim1LedGpioOnvalue
        config_get Sim1LedGpioOffvalue gpio Sim1LedGpioOffvalue
        config_get Sim2LedGpio gpio Sim2LedGpio
        config_get Sim2LedGpioOnvalue gpio Sim2LedGpioOnvalue
        config_get Sim2LedGpioOffvalue gpio Sim2LedGpioOffvalue
        config_get WpsSwitch gpio WpsSwitch
}

Smpirqaffinity()
{
	#Smp IRQ Affinity is used to divide the load of the ethernet and the usb.
	if [ "$smpirqaffinity" = "1" ]
	then
		
		#CPU3
		echo 8 > /proc/irq/`grep ethernet /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
		
		#CPU1
		echo 2 > /proc/irq/`grep xhci /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
		
	else
		
		#all cores
		echo f > /proc/irq/`grep ethernet /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
		
		#all cores
		echo f > /proc/irq/`grep xhci /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
	fi
}

SystemGpioConfig="/etc/config/systemgpio"
SystemConfigFile="/etc/config/sysconfig"
SystemHostnameFile="/etc/config/system"
BoardConfigfile="/etc/config/boardconfig"
GcomScript="/etc/gcom/getcardinfo.gcom"
CellularOperationModelocal=$(uci get sysconfig.sysconfig.CellularOperationMode)

#Check if smp irq affinity is selected or not.
smpirqaffinity=$(uci get sysconfig.sysconfig.smpirqaffinity)

#Run the function
Smpirqaffinity

ReadSystemConfigFile
ReadSystemGpioFile

#update board serial number in deviceid variable
uci set sysconfig.sysconfig.smsdeviceid=$serialnum

# for modem 1 reboot
echo "$Modem1PowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value

# for modem 2 reboot	
echo "$Modem2PowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$Modem2PowerGpio/direction
echo "$Modem2PowerOnValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
	
# for Board recycle initialize
echo "$BoardPowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$BoardPowerGpio/direction
echo "$BoardOnValue" > /sys/class/gpio/gpio$BoardPowerGpio/value

sleep 1

# Sim Select Gpio
echo "$SimSelectGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$SimSelectGpio/direction
echo "$Sim1SelectValue" > /sys/class/gpio/gpio$SimSelectGpio/value

# Programable led1
echo "$ProgramLed1Number" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$ProgramLed1Number/direction
echo "$ProgramLed1OffValue" > /sys/class/gpio/gpio$ProgramLed1Number/value

# Programable led2
echo "$ProgramLed2Number" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$ProgramLed2Number/direction
echo "$ProgramLed2OffValue" > /sys/class/gpio/gpio$ProgramLed2Number/value

# Programable led3
#echo "$ProgramLed3Number" > /sys/class/gpio/export 
#echo out > /sys/class/gpio/gpio$ProgramLed3Number/direction
#echo "$ProgramLed3OffValue" > /sys/class/gpio/gpio$ProgramLed3Number/value

# Programable led4
#echo "$ProgramLed4Number" > /sys/class/gpio/export 
#echo out > /sys/class/gpio/gpio$ProgramLed4Number/direction
#echo "$ProgramLed4OffValue" > /sys/class/gpio/gpio$ProgramLed4Number/value

# Sim1 LedGpio
#echo "$Sim1LedGpio" > /sys/class/gpio/export 
#echo out > /sys/class/gpio/gpio$Sim1LedGpio/direction
#echo "$Sim1LedGpioOffvalue" > /sys/class/gpio/gpio$Sim1LedGpio/value

# Sim2 LedGpio
#echo "$Sim2LedGpio" > /sys/class/gpio/export 
#echo out > /sys/class/gpio/gpio$Sim2LedGpio/direction
#echo "$Sim2LedGpioOffvalue" > /sys/class/gpio/gpio$Sim2LedGpio/value

# WPS button
echo "$WpsSwitch" > /sys/class/gpio/export 
echo in > /sys/class/gpio/gpio$WpsSwitch/direction

sleep 1

board_name=$(cat /tmp/sysinfo/board_name | cut -d "-" -f 2 | sed 's/[^a-zA-Z].*//')
if [ "$board_name" = "RK" ]
then
	gpio_path="/sys/class/gpio/export"
	for i in $(seq 384 393)
	do
		echo $i > $gpio_path
		echo "out" > "/sys/class/gpio/gpio$i/direction"
		echo "1" > "/sys/class/gpio/gpio$i/value"
	done
elif [ "$board_name" = "RS" ]
then
	gpio_path="/sys/class/gpio/export"
	for i in $(seq 406 409)
	do
		echo $i > $gpio_path
		echo "out" > "/sys/class/gpio/gpio$i/direction"
		echo "1" > "/sys/class/gpio/gpio$i/value"
	done
elif [ "$board_name" = "RQ" ]
then
	gpio_path="/sys/class/gpio/export"
	for i in $(seq 407 410)
	do
		echo $i > $gpio_path
		echo "out" > "/sys/class/gpio/gpio$i/direction"
		echo "1" > "/sys/class/gpio/gpio$i/value"
	done
fi

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)

/root/InterfaceManager/script/TimeSync.sh

#/bin/ReadMacAddr.sh

sleep 2

if [ "$IpsecEnable" = "1" ] ; then 
	
	interfac=$(route -n | awk NR==3 | awk '{print $8}')

	#Ethernet                                                                 
	if [ "$interfac" = "eth0.1" ]                                                                                                 
	then                                                                                                                          
		uci set ipsec.general.interface="EWAN1"                                                                                     
		uci set firewall.ipsec_rule1.src="EWAN1"                                                                                     
		uci set firewall.ipsec_rule2.src="EWAN1"                                                                                     
		uci set firewall.ipsec_rule3.src="EWAN1"                                                                                     
	elif [ "$interfac" = "eth0.2" ]                                                                                               
	then                                                                                                                          
		uci set ipsec.general.interface="EWAN2" 
		uci set firewall.ipsec_rule1.src="EWAN2"                                                                                     
		uci set firewall.ipsec_rule2.src="EWAN2"                                                                                     
		uci set firewall.ipsec_rule3.src="EWAN2" 
	elif [ "$interfac" = "eth0.3" ]                                                                                               
	then                                                                                                                          
		uci set ipsec.general.interface="EWAN3" 
		uci set firewall.ipsec_rule1.src="EWAN3"                                                                                     
		uci set firewall.ipsec_rule2.src="EWAN3"                                                                                     
		uci set firewall.ipsec_rule3.src="EWAN3" 
	elif [ "$interfac" = "eth0.4" ]                                                                                               
	then                                                                                                                          
		uci set ipsec.general.interface="EWAN4" 
		uci set firewall.ipsec_rule1.src="EWAN4"                                                                                     
		uci set firewall.ipsec_rule2.src="EWAN4"                                                                                     
		uci set firewall.ipsec_rule3.src="EWAN4" 
	elif [ "$interfac" = "eth0.5" ]                                                                                               
	then                                                                                                                          
		uci set ipsec.general.interface="EWAN5" 
		uci set firewall.ipsec_rule1.src="EWAN5"                                                                                     
		uci set firewall.ipsec_rule2.src="EWAN5"                                                                                     
		uci set firewall.ipsec_rule3.src="EWAN5" 
	fi

	#Cellular
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]                                                          
	then
		if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ]
		then
			uci set ipsec.general.interface="CWAN1"
			uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule3.src="CWAN1"
		fi
		if [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
		then
			uci set ipsec.general.interface="CWAN2"
			uci set firewall.ipsec_rule1.src="CWAN2"                                                                                     
			uci set firewall.ipsec_rule2.src="CWAN2"                                                                                     
			uci set firewall.ipsec_rule3.src="CWAN2"
		fi
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]                                                          
	then
		if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ] || [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
		then
			simnum=$(cat /tmp/simnumfile)                                                                                         
			if [ "$simnum" = "1" ]                                                                                                
			then 
				uci set ipsec.general.interface="CWAN1_0"
				uci set firewall.ipsec_rule1.src="CWAN1_0"                                                                                     
				uci set firewall.ipsec_rule2.src="CWAN1_0"                                                                                     
				uci set firewall.ipsec_rule3.src="CWAN1_0"
			else
				uci set ipsec.general.interface="CWAN1_1"
				uci set firewall.ipsec_rule1.src="CWAN1_1"                                                                                     
				uci set firewall.ipsec_rule2.src="CWAN1_1"                                                                                     
				uci set firewall.ipsec_rule3.src="CWAN1_1"
			fi
		fi
	else
		if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ] || [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
		then
			uci set ipsec.general.interface="CWAN1"
			uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
			uci set firewall.ipsec_rule3.src="CWAN1"
		fi
	fi
																  
	uci commit ipsec
	uci commit firewall
	
	sleep 1
	
	/etc/init.d/firewall reload
	/etc/init.d/ipsec stop
	
	/bin/sleep 1
	
	/etc/init.d/ipsec start
	
	/bin/sleep 4                                                                    
	
	/usr/sbin/ipsec restart
fi

if [ "$OpenvpnEnable" = "1" ] ; then
	/etc/init.d/openvpn start
	uci set vpnconfig1.general.openvpnrunning=1
	uci commit vpnconfig1
else
	uci set vpnconfig1.general.openvpnrunning=0
	uci commit vpnconfig1
	uci set openvpn.custom_config.enabled=0
fi

uci commit openvpn

sleep 4

if [ "$SmsEnable1" = "1" ] || [ "SmsEnable2" = "1" ]
then
	inotifywait /var/spool/sms/incoming/ -e create &
	sleep 2
	/root/InterfaceManager/script/SMS_Incomming_event.sh &
fi

BordType=$(uci get boardconfig.board.moduletype)

#pids=$(ps w | grep -i "mwan3" | grep -v grep | awk '{print $1}')
#kill -9 $pids

sleep 1

rm -rf /var/run/mwan3.lock

sleep 1

/usr/sbin/mwan3 start

sleep 1

rm -rf /var/run/mwan3.lock

sleep 1

NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

if [ "$NMS_Enable" = "1" ]
then
	/etc/init.d/openwisp_config start
	sleep 2
	/etc/init.d/openwisp_config stop
	sleep 2
	/etc/init.d/openwisp_config restart
	sleep 3
	/etc/init.d/openvpn start
	sleep 2
	/etc/init.d/openvpn stop
	sleep 2
	/etc/init.d/openvpn restart
	sleep 2
	/etc/init.d/openwisp-monitoring start
	sleep 2
	/etc/init.d/openwisp-monitoring stop
	sleep 2
	/etc/init.d/openwisp-monitoring restart
else
	/etc/init.d/openwisp_config disable
	sleep 2
	/etc/init.d/openwisp-monitoring disable
fi

uci commit sysconfig

#/bin/cellulardatausagemanagerscript.sh

/root/InterfaceManager/script/Update_Analytics_data.sh &

sleep 1

#This will disable tr069 on bootup.
/bin/TR069_launch.sh &

sleep 1

#/bin/checkinterfaces.sh &

######################################################
#change the Modem Status and Monitor Application depending on the cellularmode. 	
#below line is included in systemboot.sh as well. 	
if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]                                                          
then
	cp /www/luci2/view/modemstatus1 /www/luci2/view/diagnostics.modemstatus.js
	cp /www/luci2/view/system.routerapplication_dual /www/luci2/view/system.routerapplication.js
else
	cp /www/luci2/view/modemstatus2 /www/luci2/view/diagnostics.modemstatus.js
	cp /www/luci2/view/system.routerapplication_single /www/luci2/view/system.routerapplication.js
fi
#Restart this because of above .js change
/etc/init.d/uhttpd restart
######################################################
#On reboot, the added static route will dissapper from route -n. So, run the routing.sh script.
/bin/routing.sh &

exit 0
