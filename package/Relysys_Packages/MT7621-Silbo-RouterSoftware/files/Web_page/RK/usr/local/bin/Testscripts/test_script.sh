#!/bin/sh

time_stamp=$(date)

#Serial Number Check
while true; do
    echo "ENTER BOARD SERIAL NUMBER:"
    read serial_number

    # Validate input: ensure it's not empty
    if [ -z "$serial_number" ]; then
        echo "Invalid input: Serial number cannot be blank. Please try again."
    else
        echo "You entered serial number: $serial_number"
        break  # Exit loop when valid input is received
    fi
done

serial_n=$(hexdump -v -n 6 -s 0xe030 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
serial_num="${serial_n:1}"

filename=$serial_num

if [ "$serial_num" != "$serial_number" ]
then
	echo "Board serial number is not matching with the entered serial number "
	echo "exiting script"
	exit 0
fi

echo "Serial number verified"

#Assign variable to the path of each file
modem1_at="/usr/local/bin/Testscripts/Testresult/Modem1_at.txt"
modem2_at="/usr/local/bin/Testscripts/Testresult/Modem2_at.txt"
lan1="/usr/local/bin/Testscripts/Testresult/lan1.txt"
lan2="/usr/local/bin/Testscripts/Testresult/lan2.txt"
lan3="/usr/local/bin/Testscripts/Testresult/lan3.txt"
lan4="/usr/local/bin/Testscripts/Testresult/lan4.txt"
wan="/usr/local/bin/Testscripts/Testresult/wan.txt"
modem1_ping="/usr/local/bin/Testscripts/Testresult/Modem1_ping.txt"
modem2_ping="/usr/local/bin/Testscripts/Testresult/Modem2_ping.txt"
sim_sw="/usr/local/bin/Testscripts/Testresult/Sim_Sw.txt"
gpio="/usr/local/bin/Testscripts/Testresult/GPIO.txt"
reset="/usr/local/bin/Testscripts/Testresult/Reset.txt"
modem_gpio="/usr/local/bin/Testscripts/Testresult/Modem_GPIO.txt"
wi_fi="/usr/local/bin/Testscripts/Testresult/wi_fi.txt"
Reboot="/usr/local/bin/Testscripts/Testresult/reboot_test.txt"

#clear the files if it is already exist
echo > $modem1_at
echo > $modem2_at
echo > $lan1
echo > $lan2
echo > $lan3
echo > $lan4
echo > $wan
echo > $modem1_ping
echo > $modem2_ping
echo > $sim_sw
echo > $gpio
echo > $reset
echo > $modem_gpio
echo > $wi_fi

#Remove test file if serial number is same.
rm /usr/local/bin/Testscripts/Testresult/$filename.txt
rm /usr/local/bin/Testscripts/Testresult/Fail/*
rm /usr/local/bin/Testscripts/Testresult/Pass/*

echo " "
echo "Open Wifi-man in your mobile"
sleep 2
echo " "


# Function to Ckeck AT Port of Modem1
at1_port()
{
modem1_enable=$(uci get modem.CWAN1.modemenable)
if [ "$modem1_enable" = 1 ];then 
	modem1_ifname=$(uci get modem.CWAN1.ifname)
	modem1_comport=$(uci get modem.CWAN1.ComPortSymLink)
	model_1=$(uci get modem.CWAN1.model)
	at1=$(/bin/at-cmd $modem1_comport at | awk 'NR==2 {print $1}')
	echo "$at1"
	if [ "$at1" = "OK" ];then
		echo "comport is working"
	else
		modem1_comport=$(uci get modem.CWAN1.AltComPortSymLink)
	fi
fi
#at-cmd /dev/modem1_comport at+qnetdevctl=3,1,1
#sleep 1
}

# Function to Ckeck AT Port of Modem2
at2_port()
{
modem2_enable=$(uci get modem.CWAN2.modemenable)
if [ "$modem2_enable" = 1 ];then 
	modem2_ifname=$(uci get modem.CWAN2.ifname)
	modem2_comport=$(uci get modem.CWAN2.ComPortSymLink)
	model_2=$(uci get modem.CWAN2.model)
	at2=$(/bin/at-cmd $modem2_comport at | awk 'NR==2 {print $1}')
	echo "$at2"
	if [ "$at2" = "OK" ];then
		echo "comport is working"
	else
		modem2_comport=$(uci get modem.CWAN2.AltComPortSymLink)
	fi
fi	
#at-cmd /dev/modem2_comport at+qnetdevctl=3,1,1
#sleep 1
}

# Function to perform Modem1 AT Command
modem1_at_command()
{
#Check comport
at1_port
echo " "
echo "==============================================================================
			FW_VERSION , SIGNAL STRENGTH , IMEI NUMBER & SIM1 QCCID for Modem 1
================================================================================ "
echo " "
echo "MODEM 1 Output-" | tee -a $modem1_at
echo " " | tee -a $modem1_at

echo "FW_VERSION for modem 1 -- "

Status=$(/bin/at-cmd $modem1_comport ati | awk NR==4 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "Firmware_Version_1=$Status" | tee -a $modem1_at
sleep 1

Status=$(/bin/at-cmd $modem1_comport ati | awk NR==2 | tr -d '\011\012\013\014\015\040')
       echo "Modem1_name=$Status" | tee -a $modem1_at
sleep 1

Status=$(/bin/at-cmd $modem1_comport ati | awk NR==3 | tr -d '\011\012\013\014\015\040')
       echo "Modem1_model=$Status" | tee -a $modem1_at
sleep 1

echo "Signal strength for modem 1 -- "

Status=$(/bin/at-cmd $modem1_comport at+csq | awk NR==2 | cut -d ":" -f 2 | cut -d "," -f 1 | tr -d '\011\012\013\014\015\040')
       echo "Signal Strength_1=$Status" | tee -a $modem1_at
sleep 1

if [ "$Status" -lt "32" ]
then
	res1="y"
	echo -e "\e[1;32m [$time_stamp] Signal Strength Status=PASS \e[0m" 
	echo "[$time_stamp] Signal Strength Status=PASS" >> $modem1_at
else
	res1="n"
	echo -e "\e[1;31m [$time_stamp] Signal Strength Status=FAIL \e[0m" 
	echo "[$time_stamp] Signal Strength Status=FAIL" >> $modem1_at
fi
	
echo "IMEI number for modem 1 -- "

Status=$(/bin/at-cmd $modem1_comport at+gsn | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "IMEI Number_1=$Status" | tee -a $modem1_at
sleep 1

len_imei1=$(echo ${#Status})
	if [ $len_imei1 -eq 15 ]
	then
		res2="y"
		echo -e "\e[1;32m [$time_stamp] IMEI Number Status=PASS \e[0m" 
		echo "[$time_stamp] IMEI Number Status=PASS" >> $modem1_at
	else
		res2="n"
		echo -e "\e[1;31m [$time_stamp] IMEI Number Status=FAIL \e[0m" 
		echo "[$time_stamp] IMEI Number Status=FAIL" >> $modem1_at
	fi
	
echo "QCCID Number of the SIM card for modem 1 -- "

Status=$(/bin/at-cmd $modem1_comport at+qccid | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "QCCID Number_1=$Status" | tee -a $modem1_at	   
sleep 1

len_qccid=$(echo ${#Status})
	if [ $len_qccid -eq 20 ]
	then
		res3="y"
		echo -e "\e[1;32m [$time_stamp] QCCID Number Status=PASS \e[0m" 
		echo "[$time_stamp] QCCID Number Status=PASS" >> $modem1_at
	else
		res3="n"
		echo -e "\e[1;31m [$time_stamp] QCCID Number Status=FAIL \e[0m" 
		echo "[$time_stamp] QCCID Number Status=FAIL" >> $modem1_at
	fi
	
qccid1=$Status
echo "==================================================" | tee -a $modem1_at
}	

# Function to perform Modem2 AT Command
modem2_at_command()
{
#Check comport
at2_port
echo "===============================================================================
		     FW_VERSION , SIGNAL STRENGTH , IMEI NUMBER & SIM2 QCCID for Modem 2
================================================================================"
echo " "
echo "MODEM 2 Output-" | tee -a $modem2_at
echo " " | tee -a $modem2_at

echo "FW_VERSION for modem 2 -- "

Status=$(/bin/at-cmd $modem2_comport ati | awk NR==4 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "Firmware_Version_2=$Status" | tee -a $modem2_at
sleep 1

Status=$(/bin/at-cmd $modem2_comport ati | awk NR==2 | tr -d '\011\012\013\014\015\040')
       echo "Modem2_name=$Status" | tee -a $modem2_at
sleep 1

Status=$(/bin/at-cmd $modem2_comport ati | awk NR==3 | tr -d '\011\012\013\014\015\040')
       echo "Modem2_model=$Status" | tee -a $modem2_at
sleep 1

echo "Signal strength for modem 2 -- "

Status=$(/bin/at-cmd $modem2_comport at+csq | awk NR==2 | cut -d ":" -f 2 | cut -d "," -f 1 | tr -d '\011\012\013\014\015\040')
       echo "Signal Strength_2=$Status" | tee -a $modem2_at	   
sleep 1

if [ "$Status" -lt "32" ]
then
	res4="y"
	echo -e "\e[1;32m [$time_stamp] Signal Strength Status=PASS \e[0m" 
	echo "[$time_stamp] Signal Strength Status=PASS" >> $modem2_at
else
	res4="n"
	echo -e "\e[1;31m [$time_stamp] Signal Strength Status=FAIL \e[0m" 
	echo "[$time_stamp] Signal Strength Status=FAIL" >> $modem2_at
fi

echo "IMEI number for modem 2 -- "

Status=$(/bin/at-cmd $modem2_comport at+gsn | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "IMEI Number_2=$Status" | tee -a $modem2_at
sleep 1

len_imei2=$(echo ${#Status})
	if [ $len_imei2 -eq 15 ]
	then
		res5="y"
		echo -e "\e[1;32m [$time_stamp] IMEI Number Status=PASS \e[0m" 
		echo "[$time_stamp] IMEI Number Status=PASS" >> $modem2_at
	else
		res5="n"
		echo -e "\e[1;31m [$time_stamp] IMEI Number Status=FAIL \e[0m" 
		echo "[$time_stamp] IMEI Number Status=FAIL" >> $modem2_at
	fi
		
echo "QCCID Number of the SIM card for modem 2 -- "

Status=$(/bin/at-cmd $modem2_comport at+qccid | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "QCCID Number_2=$Status" | tee -a $modem2_at
sleep 1

len_qccid=$(echo ${#Status})
	if [ $len_qccid -eq 20 ]
	then
		res6="y"
		echo -e "\e[1;32m [$time_stamp] QCCID Number Status=PASS \e[0m" 
		echo "[$time_stamp] QCCID Number Status=PASS" >> $modem2_at
	else
		res6="n"
		echo -e "\e[1;31m [$time_stamp] QCCID Number Status=FAIL \e[0m" 
		echo "[$time_stamp] QCCID Number Status=FAIL" >> $modem2_at
	fi
echo "=================================================" | tee -a $modem2_at
}

# Function to perform Ethernet1 ping test 
ethernet1_ping_test()
{
echo "
=============================================================================== 
                           LAN1 PING TEST
======================================================================= "
echo " "
		
echo "Connect to the lan1 port."
echo " lan1 port speed test"
port_speed=$(swconfig dev switch0 port 0 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
echo "The speed of port 0 is $port_speed"

if [ "$port_speed" = "1000" ]
then
	echo -e "\e[1;32m [$time_stamp] lan1 port speed=PASS \e[0m" 
	echo "[$time_stamp] lan1 port speed=PASS" >> "$lan1" 
	res7=y
	echo " "
else
	echo -e "\e[1;31m [$time_stamp] lan1 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan1 port speed=FAIL" >> "$lan1" 
	res7=n
fi
}

# Function to perform Ethernet2 ping test 
ethernet2_ping_test()
{
echo "
=============================================================================== 
                           LAN2 PING TEST
======================================================================= "
echo " "
	
echo "Connect to the lan2 port."
echo " lan2 port speed test"
port_speed=$(swconfig dev switch0 port 1 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
echo "The speed of port 1 is $port_speed"

if [ "$port_speed" = "1000" ]
then
	echo -e "\e[1;32m [$time_stamp] lan2 port speed=PASS \e[0m" 
	echo "[$time_stamp] lan2 port speed=PASS" >> "$lan2" 
	echo " "

	sleep 1
	
	echo "Pinging to 192.168.11.1 ...."

	packet_loss=$(ping -I eth0.2 -c 4 192.168.11.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=PASS \e[0m" 
		echo "[$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=PASS" >> "$lan2" 
		res8=y
	else
		echo -e "\e[1;31m [$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=FAIL \e[0m"
		echo "[$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=FAIL" >> "$lan2"
		res8=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] lan2 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan2 port speed=FAIL" >> "$lan2" 
	res8=n
fi
}

# Function to perform Ethernet3 ping test 
ethernet3_ping_test()
{
echo "
=============================================================================== 
                           LAN3 PING TEST
======================================================================= "
echo " "
	
echo "Connect to the lan3 port."
echo " lan3 port speed test"
port_speed=$(swconfig dev switch0 port 2 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
echo "The speed of port 2 is $port_speed"

if [ "$port_speed" = "1000" ]
then
	echo -e "\e[1;32m [$time_stamp] lan3 port speed=PASS \e[0m" 
	echo "[$time_stamp] lan3 port speed=PASS" >> "$lan3" 
	echo " "

	sleep 1
	
	echo "Pinging to 192.168.12.1 ...."

	packet_loss=$(ping -I eth0.3 -c 4 192.168.12.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=PASS \e[0m"  
		echo "[$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=PASS" >> "$lan3" 
		res9=y
	else
		echo -e "\e[1;31m [$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=FAIL" >> "$lan3"
		res9=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] lan3 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan3 port speed=FAIL" >> "$lan3" 
	res9=n
fi
}

# Function to perform Ethernet4 ping test 
ethernet4_ping_test()
{
echo "
=============================================================================== 
                           LAN4 PING TEST
======================================================================= "
echo " "
	
echo "Connect to the lan4 port."
echo " lan4 port speed test"
port_speed=$(swconfig dev switch0 port 3 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
echo "The speed of port 3 is $port_speed"

if [ "$port_speed" = "1000" ]
then
	echo -e "\e[1;32m [$time_stamp] lan4 port speed=PASS \e[0m" 
	echo "[$time_stamp] lan4 port speed=PASS" >> "$lan4" 
	echo " "

	sleep 1
	
	echo "Pinging to 192.168.13.1 ...."

	packet_loss=$(ping -I eth0.4 -c 4 192.168.13.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=PASS \e[0m" 
		echo "[$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=PASS" >> "$lan4" 
		res10=y
	else
		echo -e "\e[1;31m [$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=FAIL" >> "$lan4"
		res10=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] lan4 port speed=FAIL \e[0m"  
	echo "[$time_stamp] lan4 port speed=FAIL" >> "$lan4" 
	res10=n
fi
}

# Function to perform Ethernet5 ping test 
ethernet5_ping_test()
{
echo "
=============================================================================== 
                           WAN PING TEST
======================================================================= "
echo " "
	
echo "Connect to the wan port."
echo "wan port speed test"
port_speed=$(swconfig dev switch0 port 4 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
echo "The speed of port 4 is $port_speed"

if [ "$port_speed" = "1000" ]
then
	echo -e "\e[1;32m [$time_stamp] wan port speed=PASS \e[0m"
	echo "[$time_stamp] wan port speed=PASS" >> "$wan" 
	echo " "

	sleep 1
	
	echo "Pinging to 192.168.14.1 ...."

	packet_loss=$(ping -I eth0.5 -c 4 192.168.14.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=PASS \e[0m" 
		echo "[$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=PASS" >> "$wan" 
		res11=y
	else
		echo -e "\e[1;31m [$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=FAIL" >> "$wan"
		res11=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] wan port speed=FAIL \e[0m"
	echo "[$time_stamp] wan port speed=FAIL" >> "$wan" 
	res11=n
fi
echo " "
}

# Function to perform Modem1 ping test
modem1_ping_test()
{
#Check comport
at1_port
echo " "
echo "========================================================================
				    MODEM 1 PING TEST
========================================================================"
echo " "

sleep 2
echo "Pinging $modem1_ifname to 8.8.8.8 ...."
echo " "
packet_loss=$(ping -I $modem1_ifname -c 4 8.8.8.8 | grep "packet loss" | awk -F ',' '{print $3}' | awk '{print $1}' | sed 's/.\{1\}$//')

if [ $packet_loss = 0 ]; then	
	echo -e "\e[1;32m [$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 Ping Test=PASS \e[0m" 
	echo "[$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 Ping Test=PASS" >> "$modem1_ping" 
	res12=y
else
	echo -e "\e[1;31m [$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 Ping Test=FAIL \e[0m" 
	echo "[$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 Ping Test=FAIL" >> "$modem1_ping"
	res12=n
fi
echo " "
}

# Function to perform Modem2 Ping Test
modem2_ping_test()
{
#Check comport
at2_port
echo " "
echo "========================================================================
				    MODEM 2 PING TEST
========================================================================"
echo " "

sleep 2
echo "Pinging $modem2_ifname to 8.8.8.8 ...."
echo " "
packet_loss=$(ping -I $modem2_ifname -c 4 8.8.8.8 | grep "packet loss" | awk -F ',' '{print $3}' | awk '{print $1}' | sed 's/.\{1\}$//')

if [ $packet_loss = 0 ]; then	
	echo -e "\e[1;32m [$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 Ping Test=PASS \e[0m" 
	echo "[$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 Ping Test=PASS" >> "$modem2_ping" 
	res13=y
else
	echo -e "\e[1;31m [$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 Ping Test=FAIL \e[0m" 
	echo "[$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 Ping Test=FAIL" >> "$modem2_ping"
	res13=n
fi
echo " "
}

# Function to perform Sim Switching test
sim_switch()
{
echo "=======================================================================
			 Sim Switching  TEST for Modem 1 
======================================================================="
echo " "
echo "Sim Switch from 1st slot to 2nd..."

#/root/InterfaceManager/script/SimSwitch.sh CWAN1 2 
#sleep 40

usb_path_1_1=$(cat /sys/bus/usb/devices/usb1/1-1/product)
usb_path_2_1=$(cat /sys/bus/usb/devices/usb2/2-1/product)

if [ -n "$usb_path_1_1" ];then
	echo 1 > /sys/class/gpio/gpio414/value
	echo " "
	/bin/at-cmd $modem1_comport at+qpowd 
	echo " "
	sleep 50
elif [ -n "$usb_path_2_1" ];then
    /bin/at-cmd $modem1_comport AT+QUIMSLOT=2
	echo " "
    /bin/at-cmd $modem1_comport AT+QUIMSLOT=2
	echo " "
	sleep 10
else
	echo "Insert Modem"
fi

#Check comport
at1_port

echo "QCCID Number of the SIM card (2nd slot)for modem 1 -- "
#echo "Waiting for modem to register -- "
#sleep 10
Status=$(/bin/at-cmd $modem1_comport at+qccid | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "[$time_stamp] QCCID of SIM card (2nd slot) for modem 1=$Status" | tee -a $sim_sw
	   sleep 1

	   len_qccid=$(echo ${#Status})
	   if [ $len_qccid -eq 20 ] && [ "$res3" = "y" ]
	   then
			if [ $Status = $qccid1 ]
			then
				echo -e "\e[1;31m [$time_stamp] Sim Switching TEST for Modem 1=FAIL \e[0m" 
				echo "[$time_stamp] Sim Switching TEST for Modem 1=FAIL" >> $sim_sw ;res14=n;
			else
				echo -e "\e[1;32m [$time_stamp] Sim Switching TEST for Modem 1=PASS \e[0m" 
				echo "[$time_stamp] Sim Switching TEST for Modem 1=PASS" >> $sim_sw ;res14=y;
			fi
	   else
			echo -e "\e[1;31m [$time_stamp] Sim Switching TEST for Modem 1=FAIL \e[0m" 
			echo "[$time_stamp] Sim Switching TEST for Modem 1=FAIL" >> $sim_sw ;res14=n;
	   fi	

#Swich back to sim1	   
#/root/InterfaceManager/script/SimSwitch.sh CWAN1 1 

if [ -n "$usb_path_1_1" ];then
	echo 0 > /sys/class/gpio/gpio414/value
elif [ -n "$usb_path_2_1" ];then
	/bin/at-cmd $modem1_comport AT+QUIMSLOT=1
	sleep 1
	/bin/at-cmd $modem1_comport AT+QUIMSLOT=1
fi
echo " "
}

#Function to Perform Pgrm LED Test
gpio_test()
{
echo " "
echo "========================================================================
					           GPIO Test
======================================================================="
echo " "

echo " "
echo "========================================================================
					  Pgrm LED GPIO Test
======================================================================="
echo " "

#Pgrm LED Test
echo "Testing pgrm_LED..."
for i in $(seq 1 3)
do
	echo 1 > /sys/class/gpio/gpio480/value
	echo 1 > /sys/class/gpio/gpio403/value
	echo 0 > /sys/class/gpio/gpio492/value
	echo 0 > /sys/class/gpio/gpio394/value
	echo 1 > /sys/class/gpio/gpio413/value
	echo 1 > /sys/class/gpio/gpio412/value
	sleep 2
	echo 0 > /sys/class/gpio/gpio480/value
	echo 0 > /sys/class/gpio/gpio403/value
	echo 1 > /sys/class/gpio/gpio492/value
	echo 1 > /sys/class/gpio/gpio394/value
	echo 0 > /sys/class/gpio/gpio413/value
	echo 0 > /sys/class/gpio/gpio412/value
	sleep 2
done
echo " "

while true; do
    echo "Is the Pgrm_LED Glowing...? Press 'y' for YES and 'n' for NO. yn"
    read -p "Is the Pgrm_LED Glowing...? Press 'y' for YES and 'n' for NO: " yn
		
    # Convert to lowercase and validate input
    yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')

    if [ "$yn" = "y" ]; then
        echo "You pressed YES. The LED is glowing."
        break  # Exit loop on valid input
    elif [ "$yn" = "n" ]; then
        echo "You pressed NO. The LED is not glowing."
        break  # Exit loop on valid input
    else
        echo "Invalid input. Please press 'y' for YES or 'n' for NO."
    fi
done

case $yn in
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] pgrm_LED Test=PASS \e[0m"; echo "[$time_stamp] pgrm_LED Test=PASS" >> $gpio ; res15=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] pgrm_LED Test=FAIL \e[0m"; echo "[$time_stamp] pgrm_LED Test=FAIL" >> $gpio ; res15=n;;
	* ) echo "Invalid input";;
esac

#signal strength LED Test
echo " "
echo "========================================================================
				  Signal Strength LED Test
======================================================================="
echo " "

echo "Testing Signal strength LEDs"
for i in $(seq 1 3)
do
	echo 0 > /sys/class/gpio/gpio389/value
	echo 0 > /sys/class/gpio/gpio390/value
	echo 0 > /sys/class/gpio/gpio391/value
	echo 0 > /sys/class/gpio/gpio392/value
	echo 0 > /sys/class/gpio/gpio384/value
	echo 0 > /sys/class/gpio/gpio385/value
	echo 0 > /sys/class/gpio/gpio386/value
	echo 0 > /sys/class/gpio/gpio387/value
	sleep 2

	echo 1 > /sys/class/gpio/gpio389/value
	echo 1 > /sys/class/gpio/gpio390/value
	echo 1 > /sys/class/gpio/gpio391/value
	echo 1 > /sys/class/gpio/gpio392/value
	echo 1 > /sys/class/gpio/gpio384/value
	echo 1 > /sys/class/gpio/gpio385/value
	echo 1 > /sys/class/gpio/gpio386/value
	echo 1 > /sys/class/gpio/gpio387/value
	sleep 2
done
echo " "

while true; do
	echo " "  # Print a blank line for readability
	echo "Is the Signal Strength LED Glowing ...? Press 'y' for YES and 'n' for NO. yn"
	read -p " Is the Signal Strength LED Glowing ...? Press 'y' for YES and 'n' for NO." yn
	
	# Convert to lowercase and validate input
	yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')

	if [ "$yn" = "y" ]; then
		echo "You pressed YES. The LED is glowing."
		break  # Exit loop on valid input
	elif [ "$yn" = "n" ]; then
		echo "You pressed NO. The LED is not glowing."
		break  # Exit loop on valid input
	else
		echo "Invalid input. Please press 'y' for YES or 'n' for NO."
	fi
done

case $yn in
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] Signal Strength LED Test=PASS \e[0m"; echo "[$time_stamp] Signal Strength LED Test=PASS" >> $gpio ; res16=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] Signal Strength LED Test=FAIL \e[0m"; echo "[$time_stamp] Signal Strength LED Test=FAIL" >> $gpio ; res16=n;;
	* ) echo "Invalid input";;
esac
echo " "
}

#Function to Perform Reset Button Test
reset_test()
{
echo " "
echo "=====================================================================================
									Reset Button Test 
===================================================================================== "
echo " "

rm /tmp/resetbutton_test

echo "Testing Reset Button"
echo "Press and hold Reset Button"
for i in $(seq 1 10); do
	sleep 1
    if [ -f "/tmp/resetbutton_test" ]; then
        reset_flag="1"
        break
    else
        reset_flag="0"
    fi
done

if [ "$reset_flag" = "1" ]; then
    echo "The Reset Button is working."
    echo -e "\e[1;32m [$time_stamp]	Reset Button Test = PASS \e[0m"
    echo "[$time_stamp]	Reset Button Test = PASS" >> "$reset"
    res17=y
else
    echo "The Reset Button is not working."
    echo -e "\e[1;31m [$time_stamp]	Reset Button Test = FAIL \e[0m"
    echo "[$time_stamp]	Reset Button Test = FAIL" >> "$reset"
    res17=n
fi
echo " "
}
	
#Function to Perform Modem GPIO Test
modem_gpio_test()
{
echo " "
echo "========================================================================
				 Modem GPIO TEST 
======================================================================= "
echo " "

echo "Testing MODEM1 & MODEM2 ..."
echo "MODEM1 - Power OFF..."
echo 1 > /sys/class/gpio/gpio404/value
sleep 3
echo " "
echo "MODEM2 - Power OFF..."
echo 1 > /sys/class/gpio/gpio405/value
sleep 3
echo " "
echo "MODEM1 - Power ON..."
echo 0 > /sys/class/gpio/gpio404/value
sleep 3
echo " "
echo "MODEM2 - Power ON..."
echo 0 > /sys/class/gpio/gpio405/value
echo " "

while true; do
    echo " "  # Print a blank line for readability
    echo "Is the Modem GPIO test successful? Press 'y' for YES and 'n' for NO. yn"
    read -p " Is the Modem GPIO test successful? Press 'y' for YES and 'n' for NO." yn
	
    # Convert to lowercase and validate input
    yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')

    if [ "$yn" = "y" ]; then
        echo "You pressed YES. The LED is glowing."
        break  # Exit loop on valid input
    elif [ "$yn" = "n" ]; then
        echo "You pressed NO. The LED is not glowing."
        break  # Exit loop on valid input
    else
        echo "Invalid input. Please press 'y' for YES or 'n' for NO."
    fi
done

case $yn in
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] Modem GPIO Test=PASS \e[0m"; echo "[$time_stamp] Modem GPIO Test=PASS" >> $modem_gpio ; res18=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] Modem GPIO Test=FAIL \e[0m"; echo "[$time_stamp] Modem GPIO Test=FAIL" >> $modem_gpio ; res18=n;;
	* ) echo "Invalid input";;
esac
echo " "
}

#Function to Perform WiFi Test
wifi()
{
echo " "
echo "=======================================================================
						WiFi TEST 
======================================================================= "
echo " "
echo "Check the wifi-man for signal strength"

echo "Enter the signal strength of wifi 2ghz"
read wifi2
echo "[$time_stamp] the signal strength of wifi 2ghz is=$wifi2" | tee -a $wi_fi
echo " "

echo "Enter the signal strength of wifi 5ghz"
read wifi5
echo "[$time_stamp] the signal strength of wifi 5ghz is=$wifi5" | tee -a $wi_fi
echo " "
}

#perform all function
modem1_at_command
modem2_at_command
ethernet1_ping_test
ethernet2_ping_test
ethernet3_ping_test
ethernet4_ping_test
ethernet5_ping_test
modem1_ping_test 
modem2_ping_test 
sim_switch
gpio_test
reset_test
modem_gpio_test
wifi

echo " "
echo "DISPLAYING REPORT" 
	cat /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
	cat $modem1_at
	cat $modem2_at
	cat $lan1
	cat $lan2
	cat $lan3
	cat $lan4
	cat $wan
	cat $modem1_ping
	cat $modem2_ping
	cat $sim_sw
	cat $gpio
	cat $reset
	cat $modem_gpio
	cat $wi_fi
	cat $Reboot
echo " "
	
while [ 1 ]; do
	echo " "
	
	if [ "$result" = "n" ];then
		echo "Exiting..."
		break
	else
		echo "Do you want to run any Test again...?(y/n)"
		read result
	fi
	
	if [ "$result" = "y" ]; then

		while [ 1 ]; do
			echo "Please choose below option"
			echo "1)Modem1 at command"
			echo "2)Modem2 at command"
			echo "3)LAN1 ping test "
			echo "4)LAN2 ping test "
			echo "5)LAN3 ping test "
			echo "6)LAN4 ping test "
			echo "7)WAN ping test "
			echo "8)Modem1 ping test "
			echo "9)Modem2 ping test"
			echo "10)sim_switch"
			echo "11)GPIO_test"
			echo "12)Reset_test"
			echo "13)Modem_GPIO_test"
			echo "14)wifi"
			
			echo "Enter the number..."
			read number

			case $number in
				1)
					echo > $modem1_at
					modem1_at_command
					;;
				2)
					echo > $modem2_at
					modem2_at_command
					;;
				3)
					echo > $lan1
					ethernet1_ping_test
					;;
				4)
					echo > $lan2
					ethernet2_ping_test
					;;
				5)
					echo > $lan3
					ethernet3_ping_test
					;;
				6)
					echo > $lan4
					ethernet4_ping_test
					;;
				7)
					echo > $wan
					ethernet5_ping_test
					;;
				8)
					echo > $modem1_ping
					modem1_ping_test 
					;;
				9)
					echo > $modem2_ping
					modem2_ping_test 
					;;
				10)
					echo > $sim_sw
                    sim_switch
                    ;;
				11)
					echo > $gpio
					gpio_test
					;;
				12)
					echo > $reset
					reset_test
					;;
				13)
					echo > $modem_gpio
					modem_gpio_test
					;;
				14)
					echo > $wi_fi
					wifi
					;;
				*)
					echo "Invalid choice."
					;;
			esac

			echo "Do you want to run any other Test again...?(y/n)"
			read result

			if [ "$result" != "y" ]; then
				break
			fi
		done
	else
		echo "Exiting..."
		break
	fi
done


# Copy all the Test File in final Report
    
    cat /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $modem1_at >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $modem2_at >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $lan1 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $lan2 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $lan3 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $lan4 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $wan >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $modem1_ping >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $modem2_ping >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $sim_sw >> /usr/local/bin/Testscripts/Testresult/$filename.txt	
	cat $gpio >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $reset >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $modem_gpio >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $wi_fi >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $Reboot >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	
echo " "
echo "DISPLAYING REPORT" 
cat /usr/local/bin/Testscripts/Testresult/$filename.txt
echo " "

reboot_test=$(cat $Reboot | cut -d "=" -f2 | tr -d '\011\012\013\014\015\040')

if [ "$res1" = "y" ] && [ "$res2" = "y" ] && [ "$res3" = "y" ] && [ "$res4" = "y" ] && [ "$res5" = "y" ] && [ "$res6" = "y" ] && [ "$res7" = "y" ] && [ "$res8" = "y" ] && [ "$res9" = "y" ] && [ "$res10" = "y" ] && [ "$res11" = "y" ] && [ "$res12" = "y" ] && [ "$res13" = "y" ] && [ "$res14" = "y" ] && [ "$res15" = "y" ] && [ "$res16" = "y" ] && [ "$res17" = "y" ] && [ "$res18" = "y" ] && [ "$reboot_test" = "PASS" ];then
	echo "=============================================="

	echo "
	 ____   _    ____ ____  
	|  _ \ / \  / ___/ ___| 
	| |_) / _ \ \___ \___ \ 
	|  __/ ___ \ ___) |__) |
	|_| /_/   \_\____/____/ 
							
	" 
	 echo "==============================================" 
						   
else
	echo "==============================================" 
	 
	echo "
	 _____ _    ___ _     
	|  ___/ \  |_ _| |    
	| |_ / _ \  | || |    
	|  _/ ___ \ | || |___ 
	|_|/_/   \_\___|_____|
						  
	" 
	 echo "==============================================" 

fi  

echo " "
echo " "

while [ 1 ]; do
	echo "Please disconnect the cable from the WAN port and connect the WAN cable through which internet is coming. Are you ready?(y/n)"
	read connection
	if [ "$connection" = "y" ]
	then
		break
	else
		echo " "
	fi
done

#This is only for testing...!
cp /usr/local/bin/Testscripts/original/network /etc/config/
cp /usr/local/bin/Testscripts/original/dhcp /etc/config/

/root/InterfaceManager/script/Port_Based_Vlan.sh &
/root/InterfaceManager/script/Network_Interface.sh &
/etc/init.d/network restart

sleep 3

#mwan3 start
uci set mwan3.EWAN5.enabled=1
uci set mwan3.CWAN1.enabled=1
uci set mwan3.CWAN2.enabled=1
uci commit mwan3

mv /usr/qnetdevctl.sh /bin/

