#!/bin/sh

cp /usr/local/bin/Testscripts/test/network /etc/config/
cp /usr/local/bin/Testscripts/test/dhcp /etc/config/
cp /usr/local/bin/Testscripts/test/reset /etc/rc.button/
cp /usr/local/bin/Testscripts/test/ReadMacAddr.sh /usr/local/bin/Testscripts/

#Here, we find the comport  
modem1_enable=$(uci get modem.CWAN1.modemenable)
if [ "$modem1_enable" = 1 ];then 
	modem1_comport=$(uci get modem.CWAN1.ComPortSymLink)
fi

modem2_enable=$(uci get modem.CWAN2.modemenable)
if [ "$modem2_enable" = 1 ];then 
	modem2_comport=$(uci get modem.CWAN2.ComPortSymLink)
fi

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

echo "Enter serial number"
read serial_number
serial_number=0$serial_number

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

echo "======================================================================
 Whitelabel_logo
======================================================================= "
echo " "
echo "Do you want Whitelabel_logo ?(y/n)"
read logo 

if [ $logo = "y" ]
then 
    echo "Please choose below option"
    echo "1)Web page with Default Silbo logo"
    echo "2)Web page without logo"
    echo "3)Web page with Custom logo"
fi
    read Value
   case $Value in 
      1)
        cp  /usr/local/bin/Testscripts/silbo_logo/custom_logo.svg /www/luci2/icons/
		cp  /usr/local/bin/Testscripts/with_custom_logo/ui.js /www/luci2/                                  
		cp  /usr/local/bin/Testscripts/with_custom_logo/luci2.html /www/  
                            
		/etc/init.d/uhttpd restart
        break
	;;
      2)
		cp  /usr/local/bin/Testscripts/without_logo/ui.js /www/luci2/                                  
		cp  /usr/local/bin/Testscripts/without_logo/luci2.html /www/  
			                          
		/etc/init.d/uhttpd restart
        break
	;;
	   3)
        cp  /usr/local/bin/Testscripts/with_custom_logo/ui.js /www/luci2/                                  
        cp  /usr/local/bin/Testscripts/with_custom_logo/luci2.html /www/                            
       
	 /etc/init.d/uhttpd restart
        break
	;;
    * );;
esac

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
	at1_port
	for i in $(seq 1 3); do 
		Imei1_num=$(/bin/at-cmd $modem1_comport at+gsn | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
		len_imei1=$(echo ${#Imei1_num})
		
		if [ $len_imei1 -eq 15 ]
		then
			echo "The IMEI number of Modem1 is -- $Imei1_num"
			break
		else
			echo "Checking IMEI number of Modem1"
			sleep 2
		fi
	done
	
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
	at2_port
	for i in $(seq 1 3); do 
		Imei2_num=$(/bin/at-cmd $modem2_comport at+gsn | awk NR==2 | cut -d ":" -f 2 | tr -d '\011\012\013\014\015\040')
		len_imei2=$(echo ${#Imei2_num})
		
		if [ $len_imei2 -eq 15 ]
		then
			echo "The IMEI number of Modem2 is -- $Imei2_num"
			break
		else
			echo "Checking IMEI number of Modem2"
			sleep 2
		fi
	done

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

LOGO()
{
    local var1=${Value:0:2}	
    	printf "\x$var1" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x60))

}

Setapn()
{
 
at-cmd $modem1_comport at
 
for i in 1 2 3 
do
	echo ""
	echo "Setting Apn for modem 1"
	status1=$(at-cmd $modem1_comport at+qicsgp=1,1,\"airtelgprs.com\",\"\",\"\" | grep -o "OK")
	echo "$status1"
	sleep 1
	if [ "$status1" = "OK" ]
	then
		echo "The APN is set for Modem 1."
		break
 
	else
		sleep 2
	fi
done
 
for i in 1 2 3 
do
	echo ""
	echo "Setting RAW  for modem 1"
	status2=$(at-cmd $modem1_comport at+qcfg=\"nat\",1 | grep -o "OK")
	echo "$status2"
	sleep 1
	if [ "$status2" = "OK" ]
	then
		echo "The RAW IP is set for Modem 1."
		break
	else
		sleep 2
	fi
done
	
at-cmd modem2_comport at
 
for i in 1 2 3 
do	
	echo ""
	echo "Setting Apn for modem 2"
	status3=$(at-cmd $modem2_comport at+qicsgp=1,1,\"airtelgprs.com\",\"\",\"\" | grep -o "OK")
	echo "$status3"
	sleep 1
	if [ "$status3" = "OK" ]
	then
		echo "The Apn is set for Modem 2."
		break
	else
		sleep 2
	fi
done
 
for i in 1 2 3 
do
	echo ""
	echo "Setting RAW  for modem 2"
	status4=$(at-cmd $modem2_comport at+qcfg=\"nat\",1 | grep -o "OK")
	echo "$status4"
	sleep 1
	if [ "$status4" = "OK" ]
	then
		echo "The RAW IP is set for Modem 2."
		break
	else
		sleep 2
	fi
done
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
	sleep 2
	IMEI2
	sleep 2
	LOGO
	Setapn
	
while [ 1 ]; do
	echo "If the IMEI number of Modem1 is not displaying, would you like to run a check on it...?(y/n)"
	read m1
	if [ "$m1" = "y" ];then
		IMEI1
		sleep 1
	else
		break
	fi
done

while [ 1 ]; do
	echo "If the IMEI number of Modem2 is not displaying, would you like to run a check on it...?(y/n)"
	read m2
	if [ "$m2" = "y" ];then
		IMEI2
		sleep 1
	else
		break
	fi
done

	mtd -r write /tmp/factory.bin factory
else
	echo "Please enter the correct values"
fi
