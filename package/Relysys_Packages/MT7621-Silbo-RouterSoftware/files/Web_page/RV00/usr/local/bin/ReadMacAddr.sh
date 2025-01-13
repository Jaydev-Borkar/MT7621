#!/bin/sh

rm -rf /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt

#serialnumber
serial_n=$(hexdump -v -n 6 -s 0xe030 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
serial_number="${serial_n:1}"

#wan
wan_mac_addr=$(hexdump -v -n 6 -s 0xe000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

#lan
lan1_mac_addr=$(hexdump -v -n 6 -s 0xe006 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan2_mac_addr=$(hexdump -v -n 6 -s 0xe00c -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan3_mac_addr=$(hexdump -v -n 6 -s 0xe012 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan4_mac_addr=$(hexdump -v -n 6 -s 0xe018 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

uci set boardconfig.board.serialnum=$serial_number
uci set boardconfig.board.macaddress1=$wan_mac_addr
uci set boardconfig.board.macaddress2=$lan1_mac_addr
uci set boardconfig.board.macaddress3=$lan2_mac_addr
uci set boardconfig.board.macaddress4=$lan3_mac_addr
uci set boardconfig.board.macaddress5=$lan4_mac_addr
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

board_name=$(uci get boardconfig.board.boardname | cut -d "-" -f2)

sleep 1

#update serial number,firmware version in easycwmp config file

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
echo "The lan1 mac addr is - $lan1_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan2 mac addr is - $lan2_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan3 mac addr is - $lan3_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The lan4 mac addr is - $lan4_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "The wan mac addr is - $wan_mac_addr" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo "======================================" | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt
echo " " | tee -a /usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt

/etc/init.d/system restart > /dev/null 2>&1

sleep 1

#Copy the boardconfig and system in user data partition
mkdir -p /mnt/image
mkfs.vfat /dev/mtdblock7
mount -t vfat /dev/mtdblock7 /mnt/image/ 
cp /etc/config/boardconfig /mnt/image/
cp /etc/config/system /mnt/image/
umount /dev/mtdblock7

cp /etc/config/* /root/InterfaceManager/config

echo "Starting Network_Interface..."
/root/InterfaceManager/script/Port_Based_Vlan.sh

sleep 1

/root/InterfaceManager/script/Network_Interface.sh
echo " "
echo "Network_Interface script has ended...!"

/etc/init.d/network restart > /dev/null 2>&1
