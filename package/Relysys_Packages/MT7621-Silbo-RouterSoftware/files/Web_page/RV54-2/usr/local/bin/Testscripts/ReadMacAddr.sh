#!/bin/sh

echo " "
echo "===================================================================================== 
                                    DEVICE REBOOT TEST
===================================================================================== " 

Reboot="/usr/local/bin/Testscripts/Testresult/reboot_test.txt"
echo > $Reboot

uptime=$(awk '{print $1}' /proc/uptime)
echo "$uptime"
time_stamp=$(date)
res=n
if [ $(awk -v uptime="$uptime" 'BEGIN {print (uptime < 200) ? "1" : "0"}') -eq 1 ]; then
	echo -e "\e[1;32m [$time_stamp]  Reboot Test = PASS \e[0m"
	echo "[$time_stamp] Reboot Test = PASS" >> $Reboot
	reboot_test="PASS"
else
	if [ $(awk -v uptime="$uptime" 'BEGIN {print (uptime < 200) ? "1" : "0"}') -eq 1 ]; then
		echo -e "\e[1;32m [$time_stamp]  Reboot Test = PASS \e[0m"
		echo "[$time_stamp] Reboot Test = PASS" >> $Reboot
		reboot_test="PASS"
	else
	    echo -e "\e[1;31m [$time_stamp]	 Reboot Test = FAIL \e[0m"
		echo "[$time_stamp] Reboot Test = FAIL" >> $Reboot
		reboot_test="FAIL"
	fi
fi

rm -rf /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt

#Check wifi is there or not...
wifi_enable_disable=$(hexdump -v -n 1 -s 0x61 -e '7/1 "%01X:" 1/1 "%01X"' /dev/mtd2 | sed 's/://g')
wifi_enable_disable=$(echo "$wifi_enable_disable" | tr -d '\013\014\015 ')

#serialnumber
serial_n=$(hexdump -v -n 6 -s 0xe030 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
serial_number="${serial_n:1}"

#imei
imei_n1=$(hexdump -v -n 8 -s 0xe040 -e '7/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
imei1="${imei_n1:1}"
imei_n2=$(hexdump -v -n 8 -s 0xe050 -e '7/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
imei2="${imei_n2:1}"

#wan
wan_mac_addr=$(hexdump -v -n 6 -s 0xe000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

#lan
lan1_mac_addr=$(hexdump -v -n 6 -s 0xe006 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan2_mac_addr=$(hexdump -v -n 6 -s 0xe00c -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan3_mac_addr=$(hexdump -v -n 6 -s 0xe012 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan4_mac_addr=$(hexdump -v -n 6 -s 0xe018 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

if [ "$wifi_enable_disable" = "1" ] || [ "$wifi_enable_disable" = "FF" ]; then
	#wlan0 
	wifi2ghz_mac_addr=$(hexdump -v -n 6 -s 0x0004 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
	#wlan1 
	wifi5ghz_mac_addr=$(hexdump -v -n 6 -s 0x8004 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
fi

uci set boardconfig.board.serialnum=$serial_number
uci set boardconfig.board.macaddress1=$wan_mac_addr
uci set boardconfig.board.macaddress2=$lan1_mac_addr
uci set boardconfig.board.macaddress3=$lan2_mac_addr
uci set boardconfig.board.macaddress4=$lan3_mac_addr
uci set boardconfig.board.macaddress5=$lan4_mac_addr
if [ "$wifi_enable_disable" = "1" ] || [ "$wifi_enable_disable" = "FF" ]; then
	uci set boardconfig.board.wifi2ghzmacid=$wifi2ghz_mac_addr
	uci set boardconfig.board.wifi5ghzmacid=$wifi5ghz_mac_addr
else
	uci delete boardconfig.board.wifi2ghzmacid
	uci delete boardconfig.board.wifi5ghzmacid
fi
uci set boardconfig.board.imei=$imei1
uci set boardconfig.board.imei2=$imei2
uci commit boardconfig

sleep 1

echo " " > /etc/config/factorymacaddr

#Add macaddr to factorymacaddr config file.
echo $wan_mac_addr >> /etc/config/factorymacaddr
echo $lan1_mac_addr >> /etc/config/factorymacaddr
echo $lan2_mac_addr >> /etc/config/factorymacaddr
echo $lan3_mac_addr >> /etc/config/factorymacaddr
echo $lan4_mac_addr >> /etc/config/factorymacaddr

echo " " > /etc/config/macaddr

#Add macaddr to macaddr config file.
echo $wan_mac_addr >> /etc/config/macaddr
echo $lan1_mac_addr >> /etc/config/macaddr
echo $lan2_mac_addr >> /etc/config/macaddr
echo $lan3_mac_addr >> /etc/config/macaddr
echo $lan4_mac_addr >> /etc/config/macaddr

sleep 1

uci set system.system.hostname=$serial_number
uci set sysconfig.sysconfig.port1macid=$lan1_mac_addr
uci set sysconfig.sysconfig.port2macid=$lan2_mac_addr
uci set sysconfig.sysconfig.port3macid=$lan3_mac_addr
uci set sysconfig.sysconfig.port4macid=$lan4_mac_addr
uci set sysconfig.sysconfig.port5macid=$wan_mac_addr
if [ "$wifi_enable_disable" = "1" ] || [ "$wifi_enable_disable" = "FF" ]; then
	uci set sysconfig.sysconfig.wifi2ghzmacid=$wifi2ghz_mac_addr
	uci set sysconfig.sysconfig.wifi5ghzmacid=$wifi5ghz_mac_addr
	uci set wireless.rai0_ap.macaddr=$wifi5ghz_mac_addr
else
	uci delete sysconfig.sysconfig.wifi2ghzmacid
	uci delete sysconfig.sysconfig.wifi5ghzmacid
	uci delete wireless.rai0_ap.macaddr
fi
uci set sysconfig.sysconfig.imei=$imei1
uci set sysconfig.sysconfig.imei2=$imei2

#According to board name we set ssid .
model_path="/tmp/sysinfo/model"
board_name=$(cat "$model_path" | sed 's/Invendis Silbo-//g')

sleep 1

if [ "$wifi_enable_disable" = "1" ] || [ "$wifi_enable_disable" = "FF" ]; then
	#ssid
	wirelessdatfile="/etc/wireless/mt7615/mt7615.1.dat"

	wifissid_2="${board_name}_${serial_number}_2.4"
	wifissid_5="${board_name}_${serial_number}_5"

	uci set sysconfig.wificonfig.wifi1ssid=${wifissid_2}
	uci set sysconfig.wificonfig.wifi5ssid=${wifissid_5}

	uci set wireless.ra0_ap.ssid=${wifissid_2}

	uci set wireless.rai0_ap.ssid=${wifissid_5}
	 
	ssid=$(grep -w "SSID1" ${wirelessdatfile})        

	ssid_replace="SSID1=$wifissid_2"

	sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"
	
	wifi_passwd=$(uci get sysconfig.wificonfig.wifi1key)
	uci set remote.tr.ssid=$wifissid_2
	uci set remote.tr.passwd=$wifi_passwd
	uci commit wireless
fi
#update serial number,firmware version,wifi ssid in easycwmp config file

Firmwareversion=$(uci get boardconfig.board.FirmwareVer)
Applicationversion=$(uci get boardconfig.board.ApplicationSwVer)
Model=$(uci get boardconfig.board.model)
#Get starting 3 values of mac addr without ":"
var=${wan_mac_addr:0:8}
OUI=$( echo $var | sed 's/://g' )

uci set easycwmp.@device[0].serial_number=$serial_number
uci set easycwmp.@device[0].software_version=${Firmwareversion}_${Applicationversion}
uci set easycwmp.@device[0].product_class=$Model
uci set easycwmp.@device[0].oui=$OUI

uci commit easycwmp
uci commit remote
uci commit system
uci commit sysconfig

sleep 1
 
echo " " | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "======================================" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The serial number is - $serial_number" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The IMEI1 number is - $imei1" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The IMEI2 number is - $imei2" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan1 mac addr is - $lan1_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan2 mac addr is - $lan2_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan3 mac addr is - $lan3_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan4 mac addr is - $lan4_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The wan mac addr is - $wan_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
if [ "$wifi_enable_disable" = "1" ] || [ "$wifi_enable_disable" = "FF" ]; then
	echo "The wlan0 mac addr is - $wifi2ghz_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
	echo "The wlan1 mac addr is - $wifi5ghz_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
fi
echo "======================================" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo " " | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt

/etc/init.d/system restart > /dev/null 2>&1

sleep 1

#Copy the boardconfig and system in user data partition
mkdir -p /mnt/image
#mkfs.vfat /dev/mtdblock7
mount -t vfat /dev/mtdblock7 /mnt/image/ 
cp /etc/config/boardconfig /mnt/image/
cp /etc/config/system /mnt/image/
cp /etc/config/rpcd /mnt/image/
cp /etc/config/sysconfig /mnt/image/
if [ "$wifi_enable_disable" = "1" ] || [ "$wifi_enable_disable" = "FF" ]; then
	cp /usr/local/bin/Testscripts/original/network /mnt/image/
	cp /usr/local/bin/Testscripts/original/dhcp /mnt/image/
else
	cp /usr/local/bin/Testscripts/original/without_wifi/network /mnt/image/
	cp /usr/local/bin/Testscripts/original/without_wifi/dhcp /mnt/image/
fi
#cp /www/luci2/view/configuration.network.js /mnt/image/
umount /dev/mtdblock7

cp /etc/config/* /root/InterfaceManager/config

