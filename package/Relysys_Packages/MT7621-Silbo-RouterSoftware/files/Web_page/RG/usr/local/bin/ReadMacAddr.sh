#serialnumber
serial_n=$(hexdump -v -n 6 -s 0xe030 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
serial_number="${serial_n:1}"

#imei
imei_n1=$(hexdump -v -n 8 -s 0xe040 -e '7/1 "%02X:" 1/1 "%01X"' /dev/mtd2 | sed 's/://g')
imei1="${imei_n1:1}"
imei_n2=$(hexdump -v -n 8 -s 0xe050 -e '7/1 "%02X:" 1/1 "%01X"' /dev/mtd2 | sed 's/://g')
imei2="${imei_n2:1}"

#wan
wan_mac_addr=$(hexdump -v -n 6 -s 0xe000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

#lan
lan1_mac_addr=$(hexdump -v -n 6 -s 0xe006 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan2_mac_addr=$(hexdump -v -n 6 -s 0xe00c -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan3_mac_addr=$(hexdump -v -n 6 -s 0xe012 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan4_mac_addr=$(hexdump -v -n 6 -s 0xe018 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

#wlan0 
#wifi2ghz_mac_addr=$(hexdump -v -n 6 -s 0x0080 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
#wlan1 
#wifi5ghz_mac_addr=$(hexdump -v -n 6 -s 0x8000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

uci set boardconfig.board.serialnum=$serial_number
uci set boardconfig.board.wanmacid=$wan_mac_addr
uci set boardconfig.board.lan1macid=$lan1_mac_addr
uci set boardconfig.board.lan2macid=$lan2_mac_addr
uci set boardconfig.board.lan3macid=$lan3_mac_addr
uci set boardconfig.board.lan4macid=$lan4_mac_addr
#uci set boardconfig.board.wifi2ghzmacid=$wifi2ghz_mac_addr
#uci set boardconfig.board.wifi5ghzmacid=$wifi5ghz_mac_addr
uci set boardconfig.board.imei=$imei1
uci set boardconfig.board.imei2=$imei2
uci commit boardconfig

sleep 1

uci set system.system.hostname=$serial_number
uci set sysconfig.sysconfig.port1macid=$lan1_mac_addr
uci set sysconfig.sysconfig.port2macid=$lan2_mac_addr
uci set sysconfig.sysconfig.port3macid=$lan3_mac_addr
uci set sysconfig.sysconfig.port4macid=$lan4_mac_addr
uci set sysconfig.sysconfig.port5macid=$wan_mac_addr
#uci set sysconfig.sysconfig.wifi2ghzmacid=$wifi2ghz_mac_addr
#uci set sysconfig.sysconfig.wifi5ghzmacid=$wifi5ghz_mac_addr
uci set sysconfig.sysconfig.imei=$imei1
uci set sysconfig.sysconfig.imei2=$imei2

board_name=$(uci get boardconfig.board.boardname)

sleep 1

#wifissid_2="${board_name}_${serial_number}_2G"
#wifissid_5="${board_name}_${serial_number}_5G"

#uci set sysconfig.sysconfig.wifi1ssid=${wifissid_2}
#uci set sysconfig.sysconfig.wifi5ssid=${wifissid_5}

#update serial number,firmware version,wifi ssid in easycwmp config file

Firmwareversion=$(uci get boardconfig.board.FirmwareVer)
Applicationversion=$(uci get boardconfig.board.ApplicationSwVer)
#wifi_passwd=$(uci get sysconfig.sysconfig.wifi1key)
Model=$(uci get boardconfig.board.model)
#Get starting 3 values of mac addr without ":"
var=${wan_mac_addr:0:8}
OUI=$( echo $var | sed 's/://g' )

uci set easycwmp.@device[0].serial_number=$serial_number
uci set easycwmp.@device[0].software_version=${Firmwareversion}_${Applicationversion}
uci set easycwmp.@device[0].product_class=$Model
uci set easycwmp.@device[0].oui=$OUI

#uci set remote.tr.ssid=$wifissid_2
#uci set remote.tr.passwd=$wifi_passwd

#uci commit wireless
uci commit easycwmp
uci commit remote
uci commit system
uci commit sysconfig

/etc/init.d/system restart > /dev/null 2>&1

sleep 1

cp /etc/config/* /root/InterfaceManager/config

echo "Starting SystemStart..."
/root/InterfaceManager/script/SystemStart.sh
echo " "
echo "SystemStart script has ended...!"
