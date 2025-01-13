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
}

ReadSystemGpioFile()                               
{                                                    
        config_load "$SystemGpioConfig"              
        config_get BoardPowerGpio gpio boardpowergpio
        config_get BoardOnValue gpio boardonvalue
        config_get BoardOffValue gpio boardoffvalue
        config_get NoOfModem gpio noofmodem
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
}

SystemGpioConfig="/etc/config/systemgpio"
SystemConfigFile="/etc/config/sysconfig"
SystemHostnameFile="/etc/config/system"
BoardConfigfile="/etc/config/boardconfig"
GcomScript="/etc/gcom/getcardinfo.gcom"

ReadSystemConfigFile
ReadSystemGpioFile


# for Board recycle initialize gpio 07 of pca9539
echo "$BoardPowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$BoardPowerGpio/direction
echo "$BoardOnValue" > /sys/class/gpio/gpio$BoardPowerGpio/value

if [ "$NoOfModem" = "1" ]
then
# for onboard Modem power recycle gpio initialization (or its mini-PCIe slot J5 / USB3 , USB3_ENABLE)
echo "$Modem1PowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
fi

if [ "$NoOfModem" = "2" ]
then
# for onboard Modem power recycle gpio initialization (or its mini-PCIe slot J5 / USB3 , USB3_ENABLE)
echo "$Modem1PowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
sleep 1
# for 2nd mini-PCIe slot power recycle gpio initialization (or its mini-PCIe slot J2 / USB4, USB2_ENABLE)
echo "$Modem2PowerGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$Modem2PowerGpio/direction
echo "$Modem2PowerOnValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
fi

if [ "$ExternelUsb" = "1" ]
then
# for external USB connector power enable / disable (USB2 and USB1_ENABLE)
echo "$ExternelUsbGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$ExternelUsbGpio/direction
echo "$ExternelUsbOnValue" > /sys/class/gpio/gpio$ExternelUsbGpio/value
fi

# Sim Select Gpio
echo "$SimSelectGpio" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$SimSelectGpio/direction
echo "$Sim1SelectValue" > /sys/class/gpio/gpio$SimSelectGpio/value

if [ "$NoOfProgramLed" = "1" ]
then
# Programmable led1
echo "$ProgramLed1Number" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$ProgramLed1Number/direction
echo "$ProgramLed1OnValue" > /sys/class/gpio/gpio$ProgramLed1Number/value
fi

if [ "$NoOfProgramLed" = "2" ]
then
# Programable led1
echo "$ProgramLed1Number" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$ProgramLed1Number/direction
echo "$ProgramLed1OnValue" > /sys/class/gpio/gpio$ProgramLed1Number/value
sleep 1
# Programable led2
echo "$ProgramLed2Number" > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio$ProgramLed2Number/direction
echo "$ProgramLed2OnValue" > /sys/class/gpio/gpio$ProgramLed2Number/value
fi

# System Reset Button
source /root/ConfigFiles/ResetGpioValue.cfg
echo "$SystemResetSwitch" > /sys/class/gpio/export 
echo in > /sys/class/gpio/gpio$SystemResetSwitch/direction

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)
EnablePptp=$(uci get vpnconfig1.general.enablepptp)

uci set sysconfig.smsconfig.smsdeviceid="$Serial"
uci commit sysconfig

/root/InterfaceManager/script/GPIO_Polling_nvp_int_wo_Print_w_script "$SystemResetSwitch" /root/InterfaceManager/script/Restore.sh &

uci set testappenable.testappen.enable="1"

uci commit testappenable

/bin/sleep 30

/root/InterfaceManager/script/TimeSync.sh

sleep 1

/etc/init.d/mwan3 start

if [ "$EnablePptp" = "1" ]
then
/root/InterfaceManager/script/Pptp_start.sh
fi

if [ "$IpsecEnable" = "1" ] ; then 
	#Get the default ifname from routing table.
	interfac=$(route -n | awk NR==3 | awk '{print $8}')

	#Ethernet
	wanCount=$(cat /etc/waninterface.txt | wc -l)
	for j in $(seq 1 ${wanCount})
	do		   
		wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)                                                                                                                      
		
		#Get the ifname for every interface name
		match_ifname=$(uci get network.$wan.ifname)
		
		#To get the interface name of the default route ifname, match the ifname from waninterface.txt  
		#with the ifname from routing table .
		
		if [ "$match_ifname" = "$interfac" ]
		then
			interface_name="$match_ifname"
			break
		fi                    
	done

	if [ -n "$interface_name" ]
	then
		uci set ipsec.general.interface="$interface_name"                                                                                     
		uci set firewall.ipsec_rule1.src="$interface_name"                                                                                     
		uci set firewall.ipsec_rule2.src="$interface_name"                                                                                     
		uci set firewall.ipsec_rule3.src="$interface_name" 
	fi
	
	#STA
	if [ "$interfac" = "apcli0" ]                                                                                               
	then                                                                                                                          
		uci set ipsec.general.interface="WIFI_WAN" 
		uci set firewall.ipsec_rule1.src="WIFI_WAN"                                                                                     
		uci set firewall.ipsec_rule2.src="WIFI_WAN"                                                                                     
		uci set firewall.ipsec_rule3.src="WIFI_WAN"    
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

if [ "$EnablePptp" = "1" ]
then
ifdown PPTP > /dev/null 2>&1
sleep 5
ifup PPTP > /dev/null 2>&1
else
uci delete network.PPTP > /dev/null 2>&1
ifdown PPTP > /dev/null 2>&1
uci commit network
fi

sleep 4

if [ "$SmsEnable1" = "1" ] || [ "SmsEnable2" = "1" ]
then
  /root/InterfaceManager/script/SMS_Incomming_event.sh &
fi

BordType=$(uci get boardconfig.board.moduletype)

if [ "$BordType" = "2" ] || [ "$BordType" = "3" ] || [ "$BordType" = "6" ]
then
atnetworkinfo1=$(gcom -d /dev/"${PortType1}""${ComPort1}" -s /etc/gcom/atnetworkinfo1.gcom | awk 'NR==2')
atnetworklatchinfo=$(echo "$atnetworkinfo1" | cut -d ":" -f 2 | cut -d "," -f 4 | tr -d '\011\012\013\014\015\040')

if [ $atnetworklatchinfo -eq 7 ] || [ $atnetworklatchinfo -eq 8 ]
then
echo "$ProgramLed1OnValue" > /sys/class/gpio/gpio$ProgramLed1Number/value
else
echo "$ProgramLed1OffValue" > /sys/class/gpio/gpio$ProgramLed1Number/value
fi
fi

HealthSendEnabled=$(uci get siaserverconfig.siaserverconfig.enablehealthpacketpublish)

/bin/ReAP_MT7628_SIASenderApp &

sleep 2

if [ "$HealthSendEnabled" = "1" ]
then
/bin/HealthPeriodic.sh

fi

/usr/sbin/mwan3 restart

NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

if [ "${NMS_Enable}" = "1" ]
then
	/etc/init.d/openwisp_config start
	sleep 3
	/etc/init.d/openvpn start
	sleep 2
	/etc/init.d/openwisp-monitoring start
else
	/etc/init.d/openwisp_config disable
	sleep 2
	/etc/init.d/openwisp-monitoring disable
fi

uci set sysconfig.smsconfig.smsdeviceid=$serialnum
uci commit sysconfig

/bin/cellulardatausagemanagerscript.sh

/root/InterfaceManager/script/Update_Analytics_data.sh

exit 0
