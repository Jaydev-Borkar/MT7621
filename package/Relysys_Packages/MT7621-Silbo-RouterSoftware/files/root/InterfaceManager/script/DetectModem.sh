#!/bin/sh

. /lib/functions.sh

#Detects number of modems on board and updates sysconfig & modem configuration files with vid, pid, model, manufacturer, etc.

USB3_5G(){
	if [ "$1" = "dualmodule" ]
	then
		#If USB3 M.2 has 5G
		if [ "2c7c" = "$vendorid1_5g" ] && [ "0800" = "$productid1_5g" ]
		then
			cellularmodem="QuectelRM500Q"
			model="RM500Q"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN1.manufacturer=$Manufacturer	
			uci set modem.CWAN1.model=$model	
			uci set modem.CWAN1.productid=$productid1_5g	
			uci set modem.CWAN1.vendorid=$vendorid1_5g	
			uci set modem.CWAN1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_5g	
			uci set sysconfig.genericconfig.productid1=$productid1_5g	
			uci set sysconfig.genericconfig.protocol1=$protocol	
		elif [ "2c7c" = "$vendorid1_5g" ] && [ "0900" = "$productid1_5g" ]
		then
			cellularmodem="QuectelRM500U"
			model="RM500U"
			Manufacturer="Quectel"
			protocol="cdcether"
			
			uci set modem.CWAN1.manufacturer=$Manufacturer	
			uci set modem.CWAN1.model=$model	
			uci set modem.CWAN1.productid=$productid1_5g	
			uci set modem.CWAN1.vendorid=$vendorid1_5g	
			uci set modem.CWAN1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_5g	
			uci set sysconfig.genericconfig.productid1=$productid1_5g	
			uci set sysconfig.genericconfig.protocol1=$protocol
		fi
	elif [ "$1" = "singlemodule" ]
	then
		#If USB3 M.2 has 5G
		if [ "2c7c" = "$vendorid1_5g" ] && [ "0800" = "$productid1_5g" ]
		then
			cellularmodem="QuectelRM500Q"
			model="RM500Q"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN1_0.manufacturer=$Manufacturer	
			uci set modem.CWAN1_0.model=$model	
			uci set modem.CWAN1_0.productid=$productid1_5g	
			uci set modem.CWAN1_0.vendorid=$vendorid1_5g	
			uci set modem.CWAN1_0.protocol=$protocol	
			uci set modem.CWAN1_1.manufacturer=$Manufacturer	
			uci set modem.CWAN1_1.model=$model	
			uci set modem.CWAN1_1.productid=$productid1_5g	
			uci set modem.CWAN1_1.vendorid=$vendorid1_5g	
			uci set modem.CWAN1_1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_5g	
			uci set sysconfig.genericconfig.productid1=$productid1_5g	
			uci set sysconfig.genericconfig.protocol1=$protocol	
		elif [ "2c7c" = "$vendorid1_5g" ] && [ "0900" = "$productid1_5g" ]
		then
			cellularmodem="QuectelRM500U"
			model="RM500U"
			Manufacturer="Quectel"
			protocol="cdcether"
			
			uci set modem.CWAN1_0.manufacturer=$Manufacturer	
			uci set modem.CWAN1_0.model=$model	
			uci set modem.CWAN1_0.productid=$productid1_5g	
			uci set modem.CWAN1_0.vendorid=$vendorid1_5g	
			uci set modem.CWAN1_0.protocol=$protocol	
			uci set modem.CWAN1_1.manufacturer=$Manufacturer	
			uci set modem.CWAN1_1.model=$model	
			uci set modem.CWAN1_1.productid=$productid1_5g	
			uci set modem.CWAN1_1.vendorid=$vendorid1_5g	
			uci set modem.CWAN1_1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_5g	
			uci set sysconfig.genericconfig.productid1=$productid1_5g	
			uci set sysconfig.genericconfig.protocol1=$protocol
		fi
	fi
}
USB3_4G(){
	if [ "$1" = "dualmodule" ]
	then
		#If USB3 M.2 has 4G
		if [ "2c7c" = "$vendorid1_4g" ] && [ "6005" = "$productid1_4g" ]
		then
			cellularmodem="QuectelEC200A"
			model="EC200A"
			Manufacturer="Quectel"
			protocol="cdcether"
			
			uci set modem.CWAN1.manufacturer=$Manufacturer	
			uci set modem.CWAN1.model=$model	
			uci set modem.CWAN1.productid=$productid1_4g	
			uci set modem.CWAN1.vendorid=$vendorid1_4g	
			uci set modem.CWAN1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_4g	
			uci set sysconfig.genericconfig.productid1=$productid1_4g	
			uci set sysconfig.genericconfig.protocol1=$protocol		
		elif [ "2c7c" = "$vendorid1_4g" ] && [ "0306" = "$productid1_4g" ]
		then
			cellularmodem="QuectelEM06"
			model="EM06"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN1.manufacturer=$Manufacturer	
			uci set modem.CWAN1.model=$model	
			uci set modem.CWAN1.productid=$productid1_4g	
			uci set modem.CWAN1.vendorid=$vendorid1_4g	
			uci set modem.CWAN1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_4g	
			uci set sysconfig.genericconfig.productid1=$productid1_4g	
			uci set sysconfig.genericconfig.protocol1=$protocol	
		elif [ "2c7c" = "$vendorid1_4g" ] && [ "0125" = "$productid1_4g" ]
		then
			cellularmodem1="QuectelEC25E"
			model="EC25E"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN1.manufacturer=$Manufacturer	
			uci set modem.CWAN1.model=$model	
			uci set modem.CWAN1.productid=$productid1_4g	
			uci set modem.CWAN1.vendorid=$vendorid1_4g	
			uci set modem.CWAN1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_4g	
			uci set sysconfig.genericconfig.productid1=$productid1_4g	
			uci set sysconfig.genericconfig.protocol1=$protocol	
		fi
	elif [ "$1" = "singlemodule" ]
	then
		#If USB3 M.2 has 4G
		if [ "2c7c" = "$vendorid1_4g" ] && [ "6005" = "$productid1_4g" ]
		then
			cellularmodem="QuectelEC200A"
			model="EC200A"
			Manufacturer="Quectel"
			protocol="cdcether"
			
			uci set modem.CWAN1_0.manufacturer=$Manufacturer	
			uci set modem.CWAN1_0.model=$model	
			uci set modem.CWAN1_0.productid=$productid1_4g	
			uci set modem.CWAN1_0.vendorid=$vendorid1_4g	
			uci set modem.CWAN1_0.protocol=$protocol	
			uci set modem.CWAN1_1.manufacturer=$Manufacturer	
			uci set modem.CWAN1_1.model=$model	
			uci set modem.CWAN1_1.productid=$productid1_4g	
			uci set modem.CWAN1_1.vendorid=$vendorid1_4g	
			uci set modem.CWAN1_1.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_4g	
			uci set sysconfig.genericconfig.productid1=$productid1_4g	
			uci set sysconfig.genericconfig.protocol1=$protocol		
		elif [ "2c7c" = "$vendorid1_4g" ] && [ "0306" = "$productid1_4g" ]
		then
			cellularmodem="QuectelEM06"
			model="EM06"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN1_0.manufacturer=$Manufacturer	
			uci set modem.CWAN1_0.model=$model	
			uci set modem.CWAN1_0.productid=$productid1_4g	
			uci set modem.CWAN1_0.vendorid=$vendorid1_4g	
			uci set modem.CWAN1_0.protocol=$protocol	
			uci set modem.CWAN1_1.manufacturer=$Manufacturer	
			uci set modem.CWAN1_1.model=$model	
			uci set modem.CWAN1_1.productid=$productid1_4g	
			uci set modem.CWAN1_1.vendorid=$vendorid1_4g	
			uci set modem.CWAN1_1.protocol=$protocol		
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_4g	
			uci set sysconfig.genericconfig.productid1=$productid1_4g	
			uci set sysconfig.genericconfig.protocol1=$protocol	
		elif [ "2c7c" = "$vendorid1_4g" ] && [ "0125" = "$productid1_4g" ]
		then
			cellularmodem1="QuectelEC25E"
			model="EC25E"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN1_0.manufacturer=$Manufacturer	
			uci set modem.CWAN1_0.model=$model	
			uci set modem.CWAN1_0.productid=$productid1_4g	
			uci set modem.CWAN1_0.vendorid=$vendorid1_4g	
			uci set modem.CWAN1_0.protocol=$protocol	
			uci set modem.CWAN1_1.manufacturer=$Manufacturer	
			uci set modem.CWAN1_1.model=$model	
			uci set modem.CWAN1_1.productid=$productid1_4g	
			uci set modem.CWAN1_1.vendorid=$vendorid1_4g	
			uci set modem.CWAN1_1.protocol=$protocol		
			uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
			uci set sysconfig.genericconfig.model1=$model	
			uci set sysconfig.genericconfig.vendorid1=$vendorid1_4g	
			uci set sysconfig.genericconfig.productid1=$productid1_4g	
			uci set sysconfig.genericconfig.protocol1=$protocol	
		fi
	fi
}
USB2_4G(){
	if [ "$1" = "dualmodule" ]
	then
		#If USB2 M.2 has 4G
		if [ "2c7c" = "$vendorid2_4g" ] && [ "6005" = "$productid2_4g" ]
		then
			cellularmodem="QuectelEC200A"
			model="EC200A"
			Manufacturer="Quectel"
			protocol="cdcether"
			
			uci set modem.CWAN2.manufacturer=$Manufacturer	
			uci set modem.CWAN2.model=$model	
			uci set modem.CWAN2.productid=$productid2_4g	
			uci set modem.CWAN2.vendorid=$vendorid2_4g	
			uci set modem.CWAN2.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem2=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer2=$Manufacturer	
			uci set sysconfig.genericconfig.model2=$model	
			uci set sysconfig.genericconfig.vendorid2=$vendorid2_4g	
			uci set sysconfig.genericconfig.productid2=$productid2_4g	
			uci set sysconfig.genericconfig.protocol2=$protocol		
		elif [ "2c7c" = "$vendorid2_4g" ] && [ "0306" = "$productid2_4g" ]
		then
			cellularmodem="QuectelEM06"
			model="EM06"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN2.manufacturer=$Manufacturer	
			uci set modem.CWAN2.model=$model	
			uci set modem.CWAN2.productid=$productid2_4g	
			uci set modem.CWAN2.vendorid=$vendorid2_4g	
			uci set modem.CWAN2.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem2=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer2=$Manufacturer	
			uci set sysconfig.genericconfig.model2=$model	
			uci set sysconfig.genericconfig.vendorid2=$vendorid2_4g	
			uci set sysconfig.genericconfig.productid2=$productid2_4g	
			uci set sysconfig.genericconfig.protocol2=$protocol
		elif [ "2c7c" = "$vendorid2_4g" ] && [ "0125" = "$productid2_4g" ]
		then
			cellularmodem="QuectelEC25E"
			model="EC25E"
			Manufacturer="Quectel"
			protocol="qmi"
			
			uci set modem.CWAN2.manufacturer=$Manufacturer	
			uci set modem.CWAN2.model=$model	
			uci set modem.CWAN2.productid=$productid2_4g	
			uci set modem.CWAN2.vendorid=$vendorid2_4g	
			uci set modem.CWAN2.protocol=$protocol	
			uci set sysconfig.genericconfig.cellularmodem2=$cellularmodem	
			uci set sysconfig.genericconfig.Manufacturer2=$Manufacturer	
			uci set sysconfig.genericconfig.model2=$model	
			uci set sysconfig.genericconfig.vendorid2=$vendorid2_4g	
			uci set sysconfig.genericconfig.productid2=$productid2_4g	
			uci set sysconfig.genericconfig.protocol2=$protocol
		fi
	fi
}

#Checking if it's single/dual modem. Works for both xhci and usb.
#Using grep on dmesg brings a lot of uncertainity, so it's easier to use lsusb to determine the number of modems.
#noofmodem=$(dmesg | grep -c "usb-1e1c0000.*")

#Check for quectel modems.
noofmodem=$(lsusb | grep -c "2c7c")

if [ $noofmodem = "2" ]
then
	cellularmodule="dualmodule"
	echo $cellularmodule > /tmp/cellularmodule.txt
	
	productid1_4g=$(cat /sys/devices/platform/1e1c0000.*/usb1/1-1/idProduct)
	vendorid1_4g=$(cat /sys/devices/platform/1e1c0000.*/usb1/1-1/idVendor)
	productid1_5g=$(cat /sys/devices/platform/1e1c0000.*/usb2/2-1/idProduct)
	vendorid1_5g=$(cat /sys/devices/platform/1e1c0000.*/usb2/2-1/idVendor)
	productid2_4g=$(cat /sys/devices/platform/1e1c0000.*/usb1/1-2/idProduct)
	vendorid2_4g=$(cat /sys/devices/platform/1e1c0000.*/usb1/1-2/idVendor)
	
	echo "$Modem1PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
	echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
	sleep 1
	echo "$Modem2PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem2PowerGpio/direction
	echo "$Modem2PowerOnValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
	#5G modem & 4G modem
	if [ -n "$productid1_5g" ] && [ -n "$productid2_4g" ]
	then
		usbbuspath1_5g="/sys/devices/platform/1e1c0000.*/usb2/2-1/"
		usbbuspath2_4g="/sys/devices/platform/1e1c0000.*/usb1/1-2/"
		
		uci set modem.CWAN1.usbbuspath=$usbbuspath1_5g
		uci set modem.CWAN2.usbbuspath=$usbbuspath2_4g
		#Go to USB3_5G & USB2_4G fn
		USB3_5G $cellularmodule
		USB2_4G $cellularmodule
	
	#4G modem & 4G modem	
	elif [ -n "$productid1_4g" ] && [ -n "$productid2_4g" ]
	then
		usbbuspath1_4g="/sys/devices/platform/1e1c0000.*/usb1/1-1/"
		usbbuspath2_4g="/sys/devices/platform/1e1c0000.*/usb1/1-2/"
		
		uci set modem.CWAN1.usbbuspath=$usbbuspath1_4g
		uci set modem.CWAN2.usbbuspath=$usbbuspath2_4g
		#Go to USB3_4G & USB2_4G fn
		USB3_4G $cellularmodule
		USB2_4G	$cellularmodule
	fi
	
elif [ $noofmodem = "1" ]
then
	cellularmodule="singlemodule"
	echo $cellularmodule > /tmp/cellularmodule.txt
	
	productid1_4g=$(cat /sys/devices/platform/1e1c0000.*/usb1/1-1/idProduct)
	vendorid1_4g=$(cat /sys/devices/platform/1e1c0000.*/usb1/1-1/idVendor)
	productid1_5g=$(cat /sys/devices/platform/1e1c0000.*/usb2/2-1/idProduct)
	vendorid1_5g=$(cat /sys/devices/platform/1e1c0000.*/usb2/2-1/idVendor)
	
	echo "$Modem1PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
	echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
	
	#5G modem
	if [ -n "$productid1_5g" ]
	then
		usbbuspath1_5g="/sys/devices/platform/1e1c0000.*/usb2/2-1/"
		
		uci set modem.CWAN1_0.usbbuspath=$usbbuspath1_5g
		uci set modem.CWAN1_1.usbbuspath=$usbbuspath1_5g
		#Go to USB3_5G fn
		USB3_5G $cellularmodule
	
	#4G modem	
	elif [ -n "$productid1_4g" ]
	then
		usbbuspath1_4g="/sys/devices/platform/1e1c0000.*/usb1/1-1/"
				
		uci set modem.CWAN1_0.usbbuspath=$usbbuspath1_4g
		uci set modem.CWAN1_1.usbbuspath=$usbbuspath1_4g
		#Go to USB3_4G fn
		USB3_4G $cellularmodule
	fi
	
else
	echo "No cellular module found" > /tmp/cellularmodule.txt
fi	

uci set systemgpio.gpio.noofmodem=$noofmodem
uci commit systemgpio
uci commit modem
uci commit sysconfig

exit 0
