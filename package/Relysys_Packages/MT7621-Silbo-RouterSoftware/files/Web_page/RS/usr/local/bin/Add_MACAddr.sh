#!/bin/sh

echo "Enter serial number"
read serial_number

echo "Enter WAN MAC address - " 
read wanmac

echo "Enter lan1 MAC address - " 
read lan1mac

echo "Enter lan2 MAC address - " 
read lan2mac

echo "Enter wlan0 MAC address - " 
read wlan0mac

echo "Enter wlan1 MAC address - " 
read wlan1mac

SerialNumber()
{
	local var1=${serial_number:0:2}
	local var2=${serial_number:2:2}
	local var3=${serial_number:4:2}
	local var4=${serial_number:6:2}
	local var5=${serial_number:8:2}
	local var6=${serial_number:10:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe030))
}

WanMAC()
{
	local var1=${wanmac:0:2}
	local var2=${wanmac:3:2}
	local var3=${wanmac:6:2}
	local var4=${wanmac:9:2}
	local var5=${wanmac:12:2}
	local var6=${wanmac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe000))
}

Lan1MAC()
{
	local var1=${lan1mac:0:2}
	local var2=${lan1mac:3:2}
	local var3=${lan1mac:6:2}
	local var4=${lan1mac:9:2}
	local var5=${lan1mac:12:2}
	local var6=${lan1mac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe006))
}

Lan2MAC()
{
	local var1=${lan2mac:0:2}
	local var2=${lan2mac:3:2}
	local var3=${lan2mac:6:2}
	local var4=${lan2mac:9:2}
	local var5=${lan2mac:12:2}
	local var6=${lan2mac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe00c))
}
Wlan0MAC()
{
	local var1=${wlan0mac:0:2}
	local var2=${wlan0mac:3:2}
	local var3=${wlan0mac:6:2}
	local var4=${wlan0mac:9:2}
	local var5=${wlan0mac:12:2}
	local var6=${wlan0mac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x0004))
}
Wlan1MAC()
{
	local var1=${wlan1mac:0:2}
	local var2=${wlan1mac:3:2}
	local var3=${wlan1mac:6:2}
	local var4=${wlan1mac:9:2}
	local var5=${wlan1mac:12:2}
	local var6=${wlan1mac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x8004))
}

IMEI1()
{
	for i in $(seq 1 2);
	do
		Imei1_num=$(gcom -d /dev/ttyUSB2 -s /etc/gcom/atgsn_test.gcom | awk 'NR==2' | tr -d '\011\012\013\014\015\040')
	done
	echo "The IMEI number is -- $Imei1_num"
	Imei1=B$Imei1_num
	local var1=${Imei1:0:2}
	local var2=${Imei1:2:2}
	local var3=${Imei1:4:2}
	local var4=${Imei1:6:2}
	local var5=${Imei1:8:2}
	local var6=${Imei1:10:2}
	local var7=${Imei1:12:2}
	local var8=${Imei1:14:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6\x$var7\x$var8" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe040))
	
}

if [ $serial_number ]
then
	dd if=/dev/mtd2 of=/tmp/factory.bin
	SerialNumber
	WanMAC
	Lan1MAC
	Lan2MAC
	Wlan0MAC
	Wlan1MAC
	IMEI1

	mtd -r write /tmp/factory.bin factory
else
	echo "Please enter the correct values"
fi
