#!/bin/sh

#mwan3 stop
uci set mwan3.EWAN5.enabled=0
uci set mwan3.CWAN1.enabled=0
uci set mwan3.CWAN2.enabled=0
uci commit mwan3

mv /bin/qnetdevctl.sh /usr/

#According to device name we get working comport.
model_path="/tmp/sysinfo/model"
device_model=$(cat "$model_path" | sed 's/Invendis//g')
device_name=$(cat "$model_path" | sed 's/Invendis Silbo-//g')

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

#echo "Enter wlan0 MAC address - " 
#read wlan0mac

#echo "Enter wlan1 MAC address - " 
#read wlan1mac

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

    read Value
   case $Value in 
      1)
        cp  /Web_page/custom_logo/Silbo/custom_logo.svg /www/luci2/icons/
        # Uncomment the logo image tag in luci2.html
        echo "Uncommenting the logo image tag in luci2.html..."
        sed -i 's|<!--<img src="/luci2/icons/custom_logo.svg" class="logoimg1" />-->|<img src="/luci2/icons/custom_logo.svg" class="logoimg1" />|g' /www/luci2.html

        # Uncomment the logo appending line in ui.js
        echo "Uncommenting the logo appending line in ui.js..."
        sed -i 's|//\.append('\''<img src="/luci2/icons/custom_logo.svg"/>'\'')|\.append('\''<img src="/luci2/icons/custom_logo.svg"/>'\'')|g' /www/luci2/ui.js
                            
		/etc/init.d/uhttpd restart
       
        break
	;;
      2)	
		comment=$(cat /www/luci2.html | grep -o "<!--<img src=")
		if [ "$comment" = "<!--<img src=" ]; then
			echo "already commented"
			break
		else
			# Comment out the logo image tag in luci2.html if it's not already commented
			echo "Commenting out the logo image tag in luci2.html..."
			sed -i 's|<img src="/luci2/icons/custom_logo.svg" class="logoimg1" />|<!--<img src="/luci2/icons/custom_logo.svg" class="logoimg1" />-->|g' /www/luci2.html
		fi	
			# Comment out the logo appending line in ui.js if it's not already commented
			echo "Commenting out the logo appending line in ui.js..."
			sed -i 's|\.append('\''<img src="/luci2/icons/custom_logo.svg"/>'\'')|//\.append('\''<img src="/luci2/icons/custom_logo.svg"/>'\'')|g' /www/luci2/ui.js
      	                     
		/etc/init.d/uhttpd restart
        break
	;;
	  3)   
		# Uncomment the logo image tag in luci2.html
        echo "Uncommenting the logo image tag in luci2.html..."
        sed -i 's|<!--<img src="/luci2/icons/custom_logo.svg" class="logoimg1" />-->|<img src="/luci2/icons/custom_logo.svg" class="logoimg1" />|g' /www/luci2.html

        # Uncomment the logo appending line in ui.js
        echo "Uncommenting the logo appending line in ui.js..."
        sed -i 's|//\.append('\''<img src="/luci2/icons/custom_logo.svg"/>'\'')|\.append('\''<img src="/luci2/icons/custom_logo.svg"/>'\'')|g' /www/luci2/ui.js
                          
		/etc/init.d/uhttpd restart
        break
	;;
    * )
    echo "Invalid option"
    ;;
	esac
else
    echo "Skipping logo customization."
fi

uci commit system
uci commit boardconfig

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
 
#at-cmd $modem1_comport at
 
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
	if [ "2c7c" = "$Vendorid1" ] && [ "6005" = "$Productid1" ];then
		#For EC200A Modem 
		status2=$(at-cmd $modem1_comport at+qcfg=\"nat\",1 | grep -o "OK")
	else
		status2=$(at-cmd $modem1_comport at+qcfg=\"nat\",0 | grep -o "OK")
	fi
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
	
#at-cmd modem2_comport at
 
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
	if [ "2c7c" = "$Vendorid2" ] && [ "6005" = "$Productid2" ];then
		#For EC200A Modem
		status4=$(at-cmd $modem2_comport at+qcfg=\"nat\",1 | grep -o "OK")
	else
		status4=$(at-cmd $modem2_comport at+qcfg=\"nat\",0 | grep -o "OK")
	fi
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
	#Wlan0MAC
	#Wlan1MAC
	#IMEI1
	#sleep 2
	#IMEI2
	#sleep 2
	LOGO
	#Setapn

#This is only for testing...!
cp /usr/local/bin/Testscripts/test/network /etc/config/
cp /usr/local/bin/Testscripts/test/dhcp /etc/config/

	mtd -r write /tmp/factory.bin factory
else
	echo "Please enter the correct values"
fi
