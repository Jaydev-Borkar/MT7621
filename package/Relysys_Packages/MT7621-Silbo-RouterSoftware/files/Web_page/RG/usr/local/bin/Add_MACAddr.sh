#!/bin/sh

echo "Enter serial number"
read serial_number

echo "Enter WAN MAC address - " 
read wanmac

echo "Enter lan1 MAC address - " 
read lan1mac

echo "Enter lan2 MAC address - " 
read lan2mac

echo "Enter lan3 MAC address - " 
read lan3mac

echo "Enter lan4 MAC address - " 
read lan4mac

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

Lan3MAC()
{
	local var1=${lan3mac:0:2}
	local var2=${lan3mac:3:2}
	local var3=${lan3mac:6:2}
	local var4=${lan3mac:9:2}
	local var5=${lan3mac:12:2}
	local var6=${lan3mac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe012))
}

Lan4MAC()
{
	local var1=${lan4mac:0:2}
	local var2=${lan4mac:3:2}
	local var3=${lan4mac:6:2}
	local var4=${lan4mac:9:2}
	local var5=${lan4mac:12:2}
	local var6=${lan4mac:15:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe018))
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
IMEI2()
{
	for i in $(seq 1 2);
	do
		Imei2_num=$(gcom -d /dev/ttyUSB4 -s /etc/gcom/atgsn_test.gcom | awk 'NR==2' | tr -d '\011\012\013\014\015\040')
	done
	echo "The IMEI number is -- $Imei2_num"
	Imei2=B$Imei2_num
	local var1=${Imei2:0:2}
	local var2=${Imei2:2:2}
	local var3=${Imei2:4:2}
	local var4=${Imei2:6:2}
	local var5=${Imei2:8:2}
	local var6=${Imei2:10:2}
	local var7=${Imei2:12:2}
	local var8=${Imei2:14:2}
	printf "\x$var1\x$var2\x$var3\x$var4\x$var5\x$var6\x$var7\x$var8" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0xe050))
	
}

if [ $serial_number ]
then
	dd if=/dev/mtd2 of=/tmp/factory.bin
	SerialNumber
	WanMAC
	Lan1MAC
	Lan2MAC
	Lan3MAC
	Lan4MAC
	IMEI1
	IMEI2
	mtd -r write /tmp/factory.bin factory
else
	echo "Please enter the correct values"
fi
