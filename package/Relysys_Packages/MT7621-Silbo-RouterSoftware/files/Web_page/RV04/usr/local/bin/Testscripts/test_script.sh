#!/bin/sh

time_stamp=$(date)

#Serial Number Check
echo "ENTER BOARD SERIAL NUMBER"
read serial_number

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
gpio="/usr/local/bin/Testscripts/Testresult/GPIO.txt"
reset="/usr/local/bin/Testscripts/Testresult/Reset.txt"
modem_gpio="/usr/local/bin/Testscripts/Testresult/Modem_GPIO.txt"

#clear the files if it is already exist
echo > modem1_at
echo > modem2_at
echo > lan1
echo > lan2
echo > lan3
echo > lan4
echo > wan
echo > modem1_ping
echo > modem2_ping
echo > gpio
echo > reset
echo > modem_gpio

rm /usr/local/bin/Testscripts/Testresult/$filename.txt
rm /usr/local/bin/Testscripts/Testresult/Fail/$filename.txt
rm /usr/local/bin/Testscripts/Testresult/Pass/$filename.txt

#Here, we find the comport, ifname and Modem name 
modem1_enable=$(uci get modem.CWAN1.modemenable)
if [ "$modem1_enable" = 1 ];then 
	modem1_comport=$(uci get modem.CWAN1.ComPortSymLink)
	modem1_ifname=$(uci get modem.CWAN1.ifname)
fi

modem2_enable=$(uci get modem.CWAN2.modemenable)
if [ "$modem2_enable" = 1 ];then 
	modem2_comport=$(uci get modem.CWAN2.ComPortSymLink)
	modem2_ifname=$(uci get modem.CWAN2.ifname)
fi

at-cmd /dev/modem1_comport at+qnetdevctl=3,1,1
sleep 1
at-cmd /dev/modem2_comport at+qnetdevctl=3,1,1
sleep 1

# Function to Ckeck AT Port of Modem1
at1_port()
{
	modem1_comport=$(uci get modem.CWAN1.ComPortSymLink)
	at1=$(/bin/at-cmd $modem1_comport at | awk 'NR==2 {print $1}')
	echo "$at1"
	if [ "$at1" = "OK" ];then
		echo "comport is working"
	else
		modem1_comport=$(uci get modem.CWAN1.AltComPortSymLink)
	fi
}

# Function to Ckeck AT Port of Modem2
at2_port()
{
	modem2_comport=$(uci get modem.CWAN2.ComPortSymLink)
	at2=$(/bin/at-cmd $modem2_comport at | awk 'NR==2 {print $1}')
	echo "$at2"
	if [ "$at2" = "OK" ];then
		echo "comport is working"
	else
		modem2_comport=$(uci get modem.CWAN2.AltComPortSymLink)
	fi
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
echo "MODEM 1 Output-" | tee -a modem1_at
echo " " | tee -a modem1_at

echo "FW_VERSION for modem 1 -- "

/bin/at-cmd $modem1_comport ati
Status=$(/bin/at-cmd $modem1_comport ati | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "Firmware_Version=$Status" | tee -a modem1_at
sleep 1

echo "Signal strength for modem 1 -- "

/bin/at-cmd $modem1_comport at+csq
Status=$(/bin/at-cmd $modem1_comport at+csq | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "Signal Strength=$Status" | tee -a modem1_at
sleep 1

echo "IMEI number for modem 1 -- "

/bin/at-cmd $modem1_comport at+gsn
Status=$(/bin/at-cmd $modem1_comport at+gsn | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "IMEI Number=$Status" | tee -a modem1_at
sleep 1

len_imei1=$(echo ${#Status})
	if [ $len_imei1 -eq 15 ]
	then
		res1="y"
		echo -e "\e[1;32m [$time_stamp] IMEI Number Status=PASS \e[0m" 
		echo "[$time_stamp] IMEI Number Status=PASS" >> modem1_at
	else
		res1="n"
		echo -e "\e[1;31m [$time_stamp] IMEI Number Status=FAIL \e[0m" 
		echo "[$time_stamp] IMEI Number Status=FAIL" >> modem1_at
	fi
	
echo "QCCID Number of the SIM card for modem 1 -- "

/bin/at-cmd $modem1_comport at+qccid
Status=$(/bin/at-cmd $modem1_comport at+qccid | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "QCCID Number=$Status" | tee -a modem1_at	   
sleep 1

len_qccid=$(echo ${#Status})
	if [ $len_qccid -eq 20 ]
	then
		res2="y"
		echo -e "\e[1;32m [$time_stamp] QCCID Number Status=PASS \e[0m" 
		echo "[$time_stamp] QCCID Number Status=PASS" >> modem1_at
	else
		res2="n"
		echo -e "\e[1;31m [$time_stamp] QCCID Number Status=FAIL \e[0m" 
		echo "[$time_stamp] QCCID Number Status=FAIL" >> modem1_at
	fi
	
qccid1=$Status
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
echo " " > modem2_at	
echo "MODEM 2 Output-" | tee -a modem2_at
echo " " | tee -a modem2_at

echo "FW_VERSION for modem 2 -- "

/bin/at-cmd $modem2_comport ati
Status=$(/bin/at-cmd $modem2_comport ati | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "Firmware_Version=$Status" | tee -a modem2_at
sleep 1

echo "Signal strength for modem 2 -- "

/bin/at-cmd $modem2_comport at+csq
Status=$(/bin/at-cmd $modem2_comport at+csq | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "Signal Strength=$Status" | tee -a modem2_at	   
sleep 1

echo "IMEI number for modem 2 -- "

/bin/at-cmd $modem2_comport at+gsn
Status=$(/bin/at-cmd $modem2_comport at+gsn | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "IMEI Number=$Status" | tee -a modem2_at
sleep 1

len_imei2=$(echo ${#Status})
	if [ $len_imei2 -eq 15 ]
	then
		res3="y"
		echo -e "\e[1;32m [$time_stamp] IMEI Number Status=PASS \e[0m" 
		echo "[$time_stamp] IMEI Number Status=PASS" >> modem2_at
	else
		res3="n"
		echo -e "\e[1;31m [$time_stamp] IMEI Number Status=FAIL \e[0m" 
		echo "[$time_stamp] IMEI Number Status=FAIL" >> modem2_at
	fi
		
echo "QCCID Number of the SIM card for modem 2 -- "

/bin/at-cmd $modem2_comport at+qccid
Status=$(/bin/at-cmd $modem2_comport at+qccid | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
       echo "QCCID Number=$Status" | tee -a modem2_at
sleep 1

len_qccid=$(echo ${#Status})
	if [ $len_qccid -eq 20 ]
	then
		res4="y"
		echo -e "\e[1;32m [$time_stamp] QCCID Number Status=PASS \e[0m" 
		echo "[$time_stamp] QCCID Number Status=PASS" >> modem2_at
	else
		res4="n"
		echo -e "\e[1;31m [$time_stamp] QCCID Number Status=FAIL \e[0m" 
		echo "[$time_stamp] QCCID Number Status=FAIL" >> modem2_at
	fi
echo "=================================================" | tee -a modem2_at
}
echo " "

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
	echo "[$time_stamp] lan1 port speed=PASS" >> "lan1"  
	res5=y
	echo " "
else
	echo -e "\e[1;31m [$time_stamp] lan1 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan1 port speed=FAIL" >> "lan1" 
	res5=n
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
	echo "[$time_stamp] lan2 port speed=PASS" >> "lan2" 
	echo " "

	sleep 3
	
	echo "Pinging to 192.168.11.1 ...."

	packet_loss=$(ping -I eth0.2 -c 4 192.168.11.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=PASS \e[0m" 
		echo "[$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=PASS" >> "lan2" 
		res6=y
	else
		echo -e "\e[1;31m [$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] LAN2:$packet_loss% packet loss. Ethernet eth0.2 Ping Test=FAIL" >> "lan2"
		res6=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] lan2 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan2 port speed=FAIL" >> "lan2" 
	res6=n
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
	echo "[$time_stamp] lan3 port speed=PASS" >> "lan3" 
	echo " "

	sleep 3
	
	echo "Pinging to 192.168.12.1 ...."

	packet_loss=$(ping -I eth0.3 -c 4 192.168.12.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=PASS \e[0m"  
		echo "[$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=PASS" >> "lan3" 
		res7=y
	else
		echo -e "\e[1;31m [$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] LAN3:$packet_loss% packet loss. Ethernet eth0.3 Ping Test=FAIL" >> "lan3"
		res7=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] lan3 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan3 port speed=FAIL" >> "lan3" 
	res7=n
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
	echo "[$time_stamp] lan4 port speed=PASS" >> "lan4" 
	echo " "

	sleep 3
	
	echo "Pinging to 192.168.13.1 ...."

	packet_loss=$(ping -I eth0.4 -c 4 192.168.13.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=PASS \e[0m" 
		echo "[$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=PASS" >> "lan4" 
		res8=y
	else
		echo -e "\e[1;31m [$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] LAN4:$packet_loss% packet loss. Ethernet eth0.4 Ping Test=FAIL" >> "lan4"
		res8=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] lan4 port speed=FAIL \e[0m"  
	echo "[$time_stamp] lan4 port speed=FAIL" >> "lan4" 
	res8=n
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
	echo "[$time_stamp] wan port speed=PASS" >> "wan" 
	echo " "

	sleep 3
	
	echo "Pinging to 192.168.14.1 ...."

	packet_loss=$(ping -I eth0.5 -c 4 192.168.14.1 | grep "packet loss" |cut -d "," -f 3| tr -d " "| cut -d "%" -f 1)
	if [ $packet_loss -lt 20 ]; then	
		echo -e "\e[1;32m [$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=PASS \e[0m" 
		echo "[$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=PASS" >> "wan" 
		res9=y
	else
		echo -e "\e[1;31m [$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=FAIL" >> "wan"
		res9=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] wan port speed=FAIL \e[0m"  
	echo "[$time_stamp] wan port speed=FAIL" >> "wan" 
	res9=n
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
	echo -e "\e[1;32m [$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 : $modem1_ifname Ping Test=PASS \e[0m" 
	echo "[$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 : $modem1_ifname Ping Test=PASS" >> "modem1_ping" 
	res10=y
else
	echo -e "\e[1;31m [$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 : $modem1_ifname Ping Test=FAIL \e[0m" 
	echo "[$time_stamp] $modem1_ifname:$packet_loss% packet loss. Modem1 : $modem1_ifname Ping Test=FAIL" >> "modem1_ping"
	res10=n
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
	echo -e "\e[1;32m [$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 : $modem2_ifname Ping Test=PASS \e[0m" 
	echo "[$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 : $modem2_ifname Ping Test=PASS" >> "modem2_ping" 
	res11=y
else
	echo -e "\e[1;31m [$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 : $modem2_ifname Ping Test=FAIL \e[0m" 
	echo "[$time_stamp] $modem2_ifname:$packet_loss% packet loss. Modem2 : $modem2_ifname Ping Test=FAIL" >> "modem2_ping"
	res11=n
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

echo "Testing pgrm_LED..."
for i in $(seq 1 3)
do
echo 1 > /sys/class/gpio/gpio480/value
echo 0 > /sys/class/gpio/gpio411/value
echo 0 > /sys/class/gpio/gpio412/value
sleep 2
echo 0 > /sys/class/gpio/gpio480/value
echo 1 > /sys/class/gpio/gpio411/value
echo 1 > /sys/class/gpio/gpio412/value
sleep 2
done
echo " "

echo " "
echo "Is the Pgrm_LED Glowing...? Press 'y' for YES and 'n' for NO. yn"
read -p " Is the Pgrm_LED Glowing...? Press 'y' for YES and 'n' for NO." yn

case $yn in
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] pgrm_LED Test=PASS \e[0m"; echo "[$time_stamp] pgrm_LED Test=PASS" >> gpio ; res12=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] pgrm_LED Test=FAIL \e[0m"; echo "[$time_stamp] pgrm_LED Test=FAIL" >> gpio ; res12=n;;
	* ) echo "Invalid input";;
esac

echo " "
echo "========================================================================
					  Signal Strength LED Test
======================================================================="
echo " "
	
echo "Testing Signal strength LEDs"
for i in $(seq 1 3)
do
echo 0 > /sys/class/gpio/gpio400/value
echo 0 > /sys/class/gpio/gpio401/value
echo 0 > /sys/class/gpio/gpio402/value
echo 0 > /sys/class/gpio/gpio403/value
echo 0 > /sys/class/gpio/gpio404/value
echo 0 > /sys/class/gpio/gpio405/value
echo 0 > /sys/class/gpio/gpio406/value
echo 0 > /sys/class/gpio/gpio407/value
sleep 2

echo 1 > /sys/class/gpio/gpio400/value
echo 1 > /sys/class/gpio/gpio401/value
echo 1 > /sys/class/gpio/gpio402/value
echo 1 > /sys/class/gpio/gpio403/value
echo 1 > /sys/class/gpio/gpio404/value
echo 1 > /sys/class/gpio/gpio405/value
echo 1 > /sys/class/gpio/gpio406/value
echo 1 > /sys/class/gpio/gpio407/value
sleep 2
done
echo " "
echo " "
echo "Is the Signal Strength LED Glowing ...? Press 'y' for YES and 'n' for NO. yn"
read -p " Is the Signal Strength LED Glowing ...? Press 'y' for YES and 'n' for NO." yn

case $yn in
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] Signal Strength LED Test=PASS \e[0m"; echo "[$time_stamp] Signal Strength LED Test=PASS" >> gpio ; res13=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] Signal Strength LED Test=FAIL \e[0m"; echo "[$time_stamp] Signal Strength LED Test=FAIL" >> gpio ; res13=n;;
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
    echo "[$time_stamp]	Reset Button Test = PASS" >> "reset"
    res14=y
else
    echo "The Reset Button is not working."
    echo -e "\e[1;31m [$time_stamp]	Reset Button Test = FAIL \e[0m"
    echo "[$time_stamp]	Reset Button Test = FAIL" >> "reset"
    res14=n
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
echo 1 > /sys/class/gpio/gpio408/value
sleep 3
echo " "
echo "MODEM2 - Power OFF..."
echo 1 > /sys/class/gpio/gpio409/value
sleep 3
echo " "
echo "MODEM1 - Power ON..."
echo 0 > /sys/class/gpio/gpio408/value
sleep 3
echo " "
echo "MODEM2 - Power ON..."
echo 0 > /sys/class/gpio/gpio409/value
echo " "

echo " "
echo "Is the Modem GPIO test successful? Press 'y' for YES and 'n' for NO. yn"
read -p " Is the Modem GPIO test successful? Press 'y' for YES and 'n' for NO." yn

case $yn in
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] Modem GPIO Test=PASS \e[0m"; echo "[$time_stamp] Modem GPIO Test=PASS" >> modem_gpio ; res15=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] Modem GPIO Test=FAIL \e[0m"; echo "[$time_stamp] Modem GPIO Test=FAIL" >> modem_gpio ; res15=n;;
	* ) echo "Invalid input";;
esac
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
gpio_test
reset_test
modem_gpio_test

echo " "
echo "DISPLAYING REPORT" 
	
	cat /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
	cat modem1_at
	cat modem2_at
	cat lan1
	cat lan2
	cat lan3
	cat lan4
	cat wan
	cat modem1_ping
	cat modem2_ping
	cat gpio
	cat reset
	cat modem_gpio
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
            echo "10)GPIO_test"
			echo "11)Reset_test"
            echo "12)Modem_GPIO_test"
			
			echo "Enter the number..."
            read number

            case $number in
                1)
					echo > modem1_at
                    modem1_at_command
                    ;;
                2)
					echo > modem2_at
                    modem2_at_command
                    ;;
                3)
					echo > lan1
                    ethernet1_ping_test
                    ;;
                4)
					echo > lan2
                    ethernet2_ping_test
                    ;;
                5)
					echo > lan3
                    ethernet3_ping_test
                    ;;
                6)
					echo > lan4
                    ethernet4_ping_test
                    ;;
                7)
					echo > wan
                    ethernet5_ping_test
                    ;;
                8)
					echo > modem1_ping
                    modem1_ping_test 
                    ;;
                9)
					echo > modem2_ping
                    modem2_ping_test 
                    ;;
                10)
					echo > gpio
                    gpio_test
                    ;;
				11)
					echo > reset
                    reset_test
                    ;;
                12)
					echo > modem_gpio
                    modem_gpio_test
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
	cat modem1_at >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat modem2_at >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat lan1 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat lan2 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat lan3 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat lan4 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat wan >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat modem1_ping >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat modem2_ping >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat gpio >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat reset >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat modem_gpio >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	
echo " "
echo "DISPLAYING REPORT" 
cat /usr/local/bin/Testscripts/Testresult/$filename.txt
echo " "

echo " "
echo "Enter PC username"
read username
echo " "

if [ "$res1" = "y" ] && [ "$res2" = "y" ] && [ "$res3" = "y" ] && [ "$res4" = "y" ] && [ "$res5" = "y" ] && [ "$res6" = "y" ] && [ "$res7" = "y" ] && [ "$res8" = "y" ] && [ "$res9" = "y" ] && [ "$res10" = "y" ] && [ "$res11" = "y" ] && [ "$res12" = "y" ] && [ "$res13" = "y" ] && [ "$res14" = "y" ] && [ "$res15" = "y" ];then
echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt

echo "
 ____   _    ____ ____  
|  _ \ / \  / ___/ ___| 
| |_) / _ \ \___ \___ \ 
|  __/ ___ \ ___) |__) |
|_| /_/   \_\____/____/ 
                        
" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
 echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
                       
	mv /usr/local/bin/Testscripts/Testresult/$filename.txt /usr/local/bin/Testscripts/Testresult/Pass/$filename.txt
else
echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
 
echo "
 _____ _    ___ _     
|  ___/ \  |_ _| |    
| |_ / _ \  | || |    
|  _/ ___ \ | || |___ 
|_|/_/   \_\___|_____|
                      
" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
 echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt

	mv /usr/local/bin/Testscripts/Testresult/$filename.txt /usr/local/bin/Testscripts/Testresult/Fail/$filename.txt
fi  

cp /usr/local/bin/Testscripts/original/network /etc/config/
cp /usr/local/bin/Testscripts/original/dhcp /etc/config/
cp /usr/local/bin/Testscripts/original/reset /etc/rc.button/
cp /usr/local/bin/Testscripts/original/ReadMacAddr.sh /usr/local/bin/Testscripts

#Run ReadmacAddr.sh
/usr/local/bin/Testscripts/ReadMacAddr.sh 
sleep 3

echo "=====================================================================================
                                 BOARD POWERING OFF 
====================================================================================="
sleep 1
echo "board_powering_off1"
sleep 3

echo 1 > /sys/class/gpio/gpio458/value
