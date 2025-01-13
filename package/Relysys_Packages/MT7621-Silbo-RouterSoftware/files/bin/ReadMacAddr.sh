#serialnumber
serial_n=$(hexdump -v -n 6 -s 0xe030 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2 | sed 's/://g')
serial_number="${serial_n:1}"

#imei
imei_n=$(hexdump -v -n 8 -s 0xe040 -e '7/1 "%02X:" 1/1 "%01X"' /dev/mtd2 | sed 's/://g')
imei="${imei_n:1}"

#wan
wan_mac_addr=$(hexdump -v -n 6 -s 0xe000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

#lan
lan1_mac_addr=$(hexdump -v -n 6 -s 0xe006 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan2_mac_addr=$(hexdump -v -n 6 -s 0xe00c -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan3_mac_addr=$(hexdump -v -n 6 -s 0xe012 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
lan4_mac_addr=$(hexdump -v -n 6 -s 0xe018 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

#wlan0 
wifi2ghz_mac_addr=$(hexdump -v -n 6 -s 0x0000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)
#wlan1 
wifi5ghz_mac_addr=$(hexdump -v -n 6 -s 0x8000 -e '5/1 "%02X:" 1/1 "%02X"' /dev/mtd2)

uci set boardconfig.board.serialnum=$serial_number
uci set boardconfig.board.wanmacid=$wan_mac_addr
uci set boardconfig.board.lan1macid=$lan1_mac_addr
uci set boardconfig.board.lan2macid=$lan2_mac_addr
uci set boardconfig.board.lan3macid=$lan3_mac_addr
uci set boardconfig.board.lan4macid=$lan4_mac_addr
uci set boardconfig.board.wifi2ghzmacid=$wifi2ghz_mac_addr
uci set boardconfig.board.wifi5ghzmacid=$wifi5ghz_mac_addr
uci set boardconfig.board.imei=$imei
uci commit boardconfig

cp /etc/config/boardconfig /root/InterfaceManager/config/boardconfig

sleep 1

uci set system.system.hostname=$serial_number
uci set sysconfig.sysconfig.port1macid=$lan1_mac_addr
uci set sysconfig.sysconfig.port2macid=$lan2_mac_addr
uci set sysconfig.sysconfig.port3macid=$lan3_mac_addr
uci set sysconfig.sysconfig.port4macid=$lan4_mac_addr
uci set sysconfig.sysconfig.port5macid=$wan_mac_addr
uci set sysconfig.sysconfig.wifi2ghzmacid=$wifi2ghz_mac_addr
uci set sysconfig.sysconfig.wifi5ghzmacid=$wifi5ghz_mac_addr
uci set sysconfig.sysconfig.imei=$imei

sleep 1

uci commit system
uci commit sysconfig

/etc/init.d/system restart > /dev/null 2>&1
