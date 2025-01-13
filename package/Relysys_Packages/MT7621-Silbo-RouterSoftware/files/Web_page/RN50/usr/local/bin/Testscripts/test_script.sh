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
lan1="/usr/local/bin/Testscripts/Testresult/lan1.txt"
wan="/usr/local/bin/Testscripts/Testresult/wan.txt"
gpio="/usr/local/bin/Testscripts/Testresult/GPIO.txt"
reset="/usr/local/bin/Testscripts/Testresult/Reset.txt"
wi_fi="/usr/local/bin/Testscripts/Testresult/wi_fi.txt"
Reboot="/usr/local/bin/Testscripts/Testresult/reboot_test.txt"

#clear the files if it is already exist
echo > $lan1
echo > $wan
echo > $gpio
echo > $reset
echo > $wi_fi

#Remove test file if serial number is same.
rm /usr/local/bin/Testscripts/Testresult/$filename.txt
rm /usr/local/bin/Testscripts/Testresult/Fail/*
rm /usr/local/bin/Testscripts/Testresult/Pass/*

echo " "
echo "Open Wifi-man in your mobile"
sleep 2
echo " "

# Function to perform Ethernet1 ping test 
lan_ping_test()
{
echo "
=============================================================================== 
                           LAN1 PING TEST
======================================================================= "
echo " "
		
echo "Connect to the lan1 port."
echo " lan1 port speed test"
port_speed=$(swconfig dev switch0 port 1 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
echo "The speed of port 0 is $port_speed"

if [ "$port_speed" = "1000" ]
then
	echo -e "\e[1;32m [$time_stamp] lan1 port speed=PASS \e[0m" 
	echo "[$time_stamp] lan1 port speed=PASS" >> "$lan1" 
	res1=y
	echo " "
else
	echo -e "\e[1;31m [$time_stamp] lan1 port speed=FAIL \e[0m" 
	echo "[$time_stamp] lan1 port speed=FAIL" >> "$lan1" 
	res1=n
fi
}

# Function to perform Ethernet5 ping test 
wan_ping_test()
{
echo "
=============================================================================== 
                           WAN PING TEST
======================================================================= "
echo " "
	
echo "Connect to the wan port."
echo "wan port speed test"
port_speed=$(swconfig dev switch0 port 2 get link | cut -d ':' -f 4 | cut -d 'b' -f 1) 
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
		res2=y
	else
		echo -e "\e[1;31m [$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=FAIL \e[0m" 
		echo "[$time_stamp] WAN:$packet_loss% packet loss. Ethernet eth0.5 Ping Test=FAIL" >> "$wan"
		res2=n
		echo "Ethernet is down! Please check the ethernet connection .. "
	fi
	
else
	echo -e "\e[1;31m [$time_stamp] wan port speed=FAIL \e[0m"
	echo "[$time_stamp] wan port speed=FAIL" >> "$wan" 
	res2=n
fi
echo " "
}

#Function to Perform Pgrm LED Test
wifi_led_test()
{
echo " "
echo "========================================================================
					           Wifi Led Test
======================================================================="
echo " "

echo "Testing 2.4GHz LED..."

echo " "
while true; do
    echo "Is the Wifi_2.4GHz_LED Glowing...? Press 'y' for YES and 'n' for NO. yn"
	read -p " Is the Wifi_2.4GHz_LED Glowing...? Press 'y' for YES and 'n' for NO." yn
		
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
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] Wifi_2.4GHz_LED Test=PASS \e[0m"; echo "[$time_stamp] Wifi_2.4GHz_LED Test=PASS" >> $gpio ; res3=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] Wifi_2.4GHz_LED Test=FAIL \e[0m"; echo "[$time_stamp] Wifi_2.4GHz_LED Test=FAIL" >> $gpio ; res3=n;;
	* ) echo "Invalid input";;
esac

echo "Testing 5GHz LED..."

echo 480 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio480/direction

for i in $(seq 1 3)
do
echo 0 > /sys/class/gpio/gpio480/value
sleep 2

echo 1 > /sys/class/gpio/gpio480/value
sleep 2
done

echo " "
while true; do
    echo "Is the Wifi_5GHz_LED Glowing...? Press 'y' for YES and 'n' for NO. yn"
	read -p " Is the Wifi_5GHz_LED Glowing...? Press 'y' for YES and 'n' for NO." yn

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
	[Yy]* ) echo -e "\e[1;32m [$time_stamp] Wifi_5GHz_LED Test=PASS \e[0m"; echo "[$time_stamp] Wifi_5GHz_LED Test=PASS" >> $gpio ; res4=y;;
	[Nn]* ) echo -e "\e[1;31m [$time_stamp] Wifi_5GHz_LED Test=FAIL \e[0m"; echo "[$time_stamp] Wifi_5GHz_LED Test=FAIL" >> $gpio ; res4=n;;
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
    res5=y
else
    echo "The Reset Button is not working."
    echo -e "\e[1;31m [$time_stamp]	Reset Button Test = FAIL \e[0m"
    echo "[$time_stamp]	Reset Button Test = FAIL" >> "$reset"
    res5=n
fi
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
lan_ping_test
wan_ping_test
wifi_led_test
reset_test
wifi

echo " "
echo "DISPLAYING REPORT" 
	cat /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
	cat $lan1
	cat $wan
	cat $gpio
	cat $reset
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
			echo "1)LAN1 ping test "
			echo "2)WAN ping test "
			echo "3)wifi led test"
			echo "4)Reset_test"
			echo "5)wifi"
			
			echo "Enter the number..."
			read number

			case $number in
				1)
					echo > $lan1
					lan_ping_test
					;;
				2)
					echo > $wan
					wan_ping_test
					;;
				3)
					echo > $gpio
					wifi_led_test
					;;
				4)
					echo > $reset
					reset_test
					;;
				5)
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
	cat $lan1 >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $wan >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $gpio >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $reset >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $wi_fi >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	cat $Reboot >> /usr/local/bin/Testscripts/Testresult/$filename.txt
	
echo " "
echo "DISPLAYING REPORT" 
cat /usr/local/bin/Testscripts/Testresult/$filename.txt
echo " "

reboot_test=$(cat $Reboot | cut -d "=" -f2 | tr -d '\011\012\013\014\015\040')

if [ "$res1" = "y" ] && [ "$res2" = "y" ] && [ "$res3" = "y" ] && [ "$res4" = "y" ] && [ "$res5" = "y" ] && [ "$reboot_test" = "PASS" ];then
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

#Update new macaddress
uci delete network.EWAN1.macaddr
uci delete network.SW_LAN.macaddr
uci commit network

/root/InterfaceManager/script/Port_Based_Vlan.sh &
/root/InterfaceManager/script/Network_Interface.sh &
/etc/init.d/network restart
