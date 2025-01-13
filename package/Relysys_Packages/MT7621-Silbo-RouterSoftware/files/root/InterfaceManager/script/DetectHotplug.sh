#!/bin/sh

[ "${ACTION}" = "add" ] || [ "${ACTION}" = "remove" ] || exit 0

. /lib/functions.sh

SystemConfigFile="/etc/config/sysconfig"
SimNumFile="/tmp/simnumfile"

ReadSystemConfigFile(){
   	config_load "$SystemConfigFile"
   	config_get CellularOperationModelocal sysconfig CellularOperationMode
   	config_get EnableCellular sysconfig enablecellular	
}

CWAN1_Symlink(){
	prefixlocal="CWAN1_"
	SYMLINKLOCAL="${prefixlocal}$(echo -n ${DEVNAME} | tail -c 1)"
	rm /dev/${SYMLINKLOCAL}
}

CWAN2_Symlink(){
	prefixlocal="CWAN2_"
	SYMLINKLOCAL="${prefixlocal}$(echo -n ${DEVNAME} | tail -c 1)"
	rm /dev/${SYMLINKLOCAL}
}

CWAN1_0_Symlink(){
	prefixlocal="CWAN1_0_"
	SYMLINKLOCAL="${prefixlocal}$(echo -n ${DEVNAME} | tail -c 1)"
	rm /dev/${SYMLINKLOCAL}
}

CWAN1_1_Symlink(){
	prefixlocal="CWAN1_1_"
	SYMLINKLOCAL="${prefixlocal}$(echo -n ${DEVNAME} | tail -c 1)"
	rm /dev/${SYMLINKLOCAL}
}

Create_Delete_Symlink(){
	
	ACTION="$3"
	# Find all ttyUSB devices under the usb1/1-1 or usb1/1-2 path, etc.
	ttyUSBs=$(find $1 -name "ttyUSB*" -type d)

	# Create symlinks for each ttyUSB device in /dev
	for ttyUSB in $ttyUSBs; do
		ttyName=$(basename $ttyUSB)
		SYMLINK=$(echo -n $ttyName | tail -c 1)
		
		logger devpath=$1 action=$ACTION devname=$ttyName symlink=$SYMLINK type=$HOTPLUG_TYPE
		
		if [ "${ACTION}" = "add" ]
		then
			ln -sf $ttyUSB/tty/$ttyName /dev/$2$SYMLINK
			logger -t modem Symlink from /dev/$ttyName to /dev/$2$SYMLINK created
		
		elif [ "${ACTION}" = "remove" ]
		then
			rm /dev/$2$SYMLINK
			logger -t modem Symlink /dev/$2$SYMLINK removed
		fi
	done		
}

EC25E(){
	cellularmodem="QuectelEC25E"
	model="EC25E"
	Manufacturer="Quectel"
	protocol="qmi"
	vendorId="2c7c"
	productId="0125"
	#If comport is 3, we get ttyUSB2
	comport="3"
	
	uci set modem.$1.manufacturer=$Manufacturer	
	uci set modem.$1.model=$model	
	uci set modem.$1.productid=$productId	
	uci set modem.$1.vendorid=$vendorId	
	uci set modem.$1.protocol=$protocol	
	uci set modem.$1.comport=$comport	
	uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
	uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
	uci set sysconfig.genericconfig.model1=$model	
	uci set sysconfig.genericconfig.vendorid1=$vendorId	
	uci set sysconfig.genericconfig.productid1=$productId	
	uci set sysconfig.genericconfig.protocol1=$protocol	
	
	uci commit systemgpio
	uci commit modem
	uci commit sysconfig
	
	if [ "${ACTION}" = "add" ]
	then
		/root/InterfaceManager/script/AddInterface.sh $1 &
	
	elif [ "${ACTION}" = "remove" ]
	then
		/root/InterfaceManager/script/CallUbusInterfaceManager.sh "disable" $1 &
	fi
	
}

EC200A(){
	cellularmodem="QuectelEC200A"
	model="EC200A"
	Manufacturer="Quectel"
	protocol="cdcether"
	vendorId="2c7c"
	productId="6005"
	comport="2"
	
	uci set modem.$1.manufacturer=$Manufacturer	
	uci set modem.$1.model=$model	
	uci set modem.$1.productid=$productId	
	uci set modem.$1.vendorid=$vendorId	
	uci set modem.$1.protocol=$protocol	
	uci set modem.$1.comport=$comport	
	uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
	uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
	uci set sysconfig.genericconfig.model1=$model	
	uci set sysconfig.genericconfig.vendorid1=$vendorId	
	uci set sysconfig.genericconfig.productid1=$productId	
	uci set sysconfig.genericconfig.protocol1=$protocol	
	
	uci commit systemgpio
	uci commit modem
	uci commit sysconfig
	
	if [ "${ACTION}" = "add" ]
	then
		/root/InterfaceManager/script/AddInterface.sh $1 &
	
	elif [ "${ACTION}" = "remove" ]
	then
		/root/InterfaceManager/script/CallUbusInterfaceManager.sh "disable" $1 &
	fi
}

EM06(){
	cellularmodem="QuectelEM06"
	model="EM06"
	Manufacturer="Quectel"
	protocol="qmi"
	vendorId="2c7c"
	productId="0306"
	comport="3"
	
	uci set modem.$1.manufacturer=$Manufacturer	
	uci set modem.$1.model=$model	
	uci set modem.$1.productid=$productId	
	uci set modem.$1.vendorid=$vendorId	
	uci set modem.$1.protocol=$protocol	
	uci set modem.$1.comport=$comport	
	uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
	uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
	uci set sysconfig.genericconfig.model1=$model	
	uci set sysconfig.genericconfig.vendorid1=$vendorId	
	uci set sysconfig.genericconfig.productid1=$productId	
	uci set sysconfig.genericconfig.protocol1=$protocol
	
	uci commit systemgpio
	uci commit modem
	uci commit sysconfig
	
	if [ "${ACTION}" = "add" ]
	then
		/root/InterfaceManager/script/AddInterface.sh $1 &
	
	elif [ "${ACTION}" = "remove" ]
	then
		/root/InterfaceManager/script/CallUbusInterfaceManager.sh "disable" $1 &
	fi
}

RM500Q(){
	cellularmodem="QuectelRM500Q"
	model="RM500Q"
	Manufacturer="Quectel"
	protocol="qmi"
	vendorId="2c7c"
	productId="0800"
	comport="3"
	
	uci set modem.$1.manufacturer=$Manufacturer	
	uci set modem.$1.model=$model	
	uci set modem.$1.productid=$productId	
	uci set modem.$1.vendorid=$vendorId	
	uci set modem.$1.protocol=$protocol	
	uci set modem.$1.comport=$comport	
	uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
	uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
	uci set sysconfig.genericconfig.model1=$model	
	uci set sysconfig.genericconfig.vendorid1=$vendorId	
	uci set sysconfig.genericconfig.productid1=$productId	
	uci set sysconfig.genericconfig.protocol1=$protocol
	
	uci commit systemgpio
	uci commit modem
	uci commit sysconfig
	
	if [ "${ACTION}" = "add" ]
	then
		/root/InterfaceManager/script/AddInterface.sh $1 &
	
	elif [ "${ACTION}" = "remove" ]
	then
		/root/InterfaceManager/script/CallUbusInterfaceManager.sh "disable" $1 &
	fi
}

RM500U{
	cellularmodem="QuectelRM500U"
	model="RM500U"
	Manufacturer="Quectel"
	protocol="cdcether"
	vendorId="2c7c"
	productId="0900"
	comport="3"
	
	uci set modem.$1.manufacturer=$Manufacturer	
	uci set modem.$1.model=$model	
	uci set modem.$1.productid=$productId	
	uci set modem.$1.vendorid=$vendorId	
	uci set modem.$1.protocol=$protocol	
	uci set modem.$1.comport=$comport	
	uci set sysconfig.genericconfig.cellularmodem1=$cellularmodem	
	uci set sysconfig.genericconfig.Manufacturer1=$Manufacturer	
	uci set sysconfig.genericconfig.model1=$model	
	uci set sysconfig.genericconfig.vendorid1=$vendorId	
	uci set sysconfig.genericconfig.productid1=$productId	
	uci set sysconfig.genericconfig.protocol1=$protocol
	
	uci commit systemgpio
	uci commit modem
	uci commit sysconfig
	
	if [ "${ACTION}" = "add" ]
	then
		/root/InterfaceManager/script/AddInterface.sh $1 &
	
	elif [ "${ACTION}" = "remove" ]
	then
		/root/InterfaceManager/script/CallUbusInterfaceManager.sh "disable" $1 &
	fi
}

ReadSystemConfigFile

if [ "$EnableCellular" != "1" ]
then
	exit 0
fi

#Checking if it's single/dual modem. Works for both xhci and usb.
#Using grep on dmesg brings a lot of uncertainity, so it's easier to use lsusb to determine the number of modems.
#noofmodem=$(dmesg | grep -c "usb-1e1c0000.*")

#Check for quectel modems.
noofmodem=$(lsusb | grep -c "2c7c")

uci set systemgpio.gpio.noofmodem=$noofmodem

#dualmodule
#if [ $noofmodem = "2" ]
if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
then
	cellularmodule="dualmodule"
	echo $cellularmodule > /tmp/cellularmodule.txt
	
	echo "$Modem1PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
	echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value
	sleep 1
	echo "$Modem2PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem2PowerGpio/direction
	echo "$Modem2PowerOnValue" > /sys/class/gpio/gpio$Modem2PowerGpio/value
	
	# Since it is dual module, extract the product IDs of both the modems.
	idProduct=$(lsusb | grep "ID 2c7c" | awk '{print $6}' | cut -d ":" -f 2)
	productId1=$(echo "$idProduct" | head -1)
	productId2=$(echo "$idProduct" | tail -1)
	
	#Find all files named idProduct under /sys/bus/usb/devices/*/, & search for the value of <idProduct_value> within each file,
	#and outputs the file path(s) without the idProduct suffix.
	usb_path1=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId1 {} \; | sed 's|/idProduct$||' | head -1)
	usb_path2=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId2 {} \; | sed 's|/idProduct$||' | head -1)

	#The ${usb_path##*/} expression extracts the characters after the last slash (/) in the string, leaving only devname ("1-1").
	devname1="${usb_path1##*/}"
	devname2="${usb_path2##*/}"
	
	#Get path in /sys/devices using readlink
	
	path1=$(readlink -f $usb_path1)
	path2=$(readlink -f $usb_path2)
	
	#FOR 1st modem
	if [ "$devname1" = "1-1" ]
	then
		uci set modem.CWAN1.usbbuspath=$path1
		
		#find the interface name from the usbpath
		net=$(find $path1 -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path1 -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=1
		uci set modem.CWAN2.modemenable=0
		uci commit modem
		
		prefix="CWAN1_"
		CWAN1_0_Symlink
		CWAN1_1_Symlink
		CWAN2_Symlink
		
		#/sys/devices/platform/1e1c0000.usb/usb1/1-1/1-1:1.0/ttyUSB0/tty/ttyUSB0 ... We get ttyUSB0 from here.
		#devname=$(find $path1 -name ttyUSB* -path "$DEVPATH/*" | cut -d '/' -f 11)
		
		#SYMLINK="${prefix}$(echo -n ${devname} | tail -c 1)"
		#ln -s /dev/${DEVNAME} /dev/${SYMLINK}
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path1 $prefix $ACTION
		
		if [ "$productId1" = "0125" ]
		then
			EC25E CWAN1
	
		elif [ "$productId1" = "6005" ]
		then
			EC200A CWAN1
			
		elif [ "$productId1" = "0306" ]
		then
			EM06 CWAN1
		fi
	
	elif [ "$devname1" = "1-2" ]
	then
		uci set modem.CWAN2.usbbuspath=$path1
		
		#find the interface name from the usbpath
		net=$(find $path1 -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN2.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path1 -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN2.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=0
		uci set modem.CWAN2.modemenable=1
		uci commit modem
		
		prefix="CWAN2_"
		CWAN1_0_Symlink
		CWAN1_1_Symlink
		CWAN1_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path1 $prefix $ACTION
		
		if [ "$productId1" = "0125" ]
		then
			EC25E CWAN2
	
		elif [ "$productId1" = "6005" ]
		then
			EC200A CWAN2
			
		elif [ "$productId1" = "0306" ]
		then
			EM06 CWAN2
		fi
	
	elif [ "$devname1" = "2-1" ]
	then
		uci set modem.CWAN1.usbbuspath=$path1
		
		#find the interface name from the usbpath
		net=$(find $path1 -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path1 -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=1
		uci set modem.CWAN2.modemenable=0
		uci commit modem
		
		prefix="CWAN1_"
		CWAN1_0_Symlink
		CWAN1_1_Symlink
		CWAN2_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path1 $prefix $ACTION
		
		if [ "$productId1" = "0800" ]
		then
			RM500Q CWAN1
	
		elif [ "$productId1" = "0900" ]
		then
			RM500U CWAN1
		fi
	fi
	
	#FOR 2nd modem
	if [ "$devname2" = "1-1" ]
	then
		uci set modem.CWAN1.usbbuspath=$path2
		
		#find the interface name from the usbpath
		net=$(find $path2 -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path2 -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=1
		uci set modem.CWAN2.modemenable=0
		uci commit modem
		
		prefix="CWAN1_"
		CWAN1_0_Symlink
		CWAN1_1_Symlink
		CWAN2_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path2 $prefix $ACTION
		
		if [ "$productId2" = "0125" ]
		then
			EC25E CWAN1
	
		elif [ "$productId2" = "6005" ]
		then
			EC200A CWAN1
			
		elif [ "$productId2" = "0306" ]
		then
			EM06 CWAN1
		fi
	
	elif [ "$devname2" = "1-2" ]
	then
		uci set modem.CWAN2.usbbuspath=$path2
		
		#find the interface name from the usbpath
		net=$(find $path2 -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN2.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path2 -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN2.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=0
		uci set modem.CWAN2.modemenable=1
		uci commit modem
		
		prefix="CWAN2_"
		CWAN1_0_Symlink
		CWAN1_1_Symlink
		CWAN1_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path2 $prefix $ACTION
		
		if [ "$productId2" = "0125" ]
		then
			EC25E CWAN2
	
		elif [ "$productId2" = "6005" ]
		then
			EC200A CWAN2
			
		elif [ "$productId2" = "0306" ]
		then
			EM06 CWAN2
		fi
	
	elif [ "$devname2" = "2-1" ]
	then
		uci set modem.CWAN1.usbbuspath=$path1
		
		#find the interface name from the usbpath
		net=$(find $path2 -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path2 -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=1
		uci set modem.CWAN2.modemenable=0
		uci commit modem
		
		prefix="CWAN1_"
		CWAN1_0_Symlink
		CWAN1_1_Symlink
		CWAN2_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path2 $prefix $ACTION
		
		if [ "$productId2" = "0800" ]
		then
			RM500Q CWAN1
	
		elif [ "$productId2" = "0900" ]
		then
			RM500U CWAN1
		fi
	fi

#singlemodule
#elif [ $noofmodem = "1" ]
elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
then
	cellularmodule="singlemodule"
	echo $cellularmodule > /tmp/cellularmodule.txt
	
	echo "$Modem1PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
	echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value	
	
	#Check if there's only 1 module or if there are 2 but user wants to run only 1.
	if [ $noofmodem != "1" ]
	then	
		idProduct=$(lsusb | grep "ID 2c7c" | awk '{print $6}' | cut -d ":" -f 2)
		productId1=$(echo "$idProduct" | head -1)
		productId2=$(echo "$idProduct" | tail -1)
		
		usb_path1=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId1 {} \; | sed 's|/idProduct$||' | head -1)
		usb_path2=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId2 {} \; | sed 's|/idProduct$||' | head -1)

		devname1="${usb_path1##*/}"
		devname2="${usb_path2##*/}"
		
		if [ $"devname1" = "1-1" ] || [ $"devname1" = "2-1" ]
		then
			devname=$devname1
			usb_path=$usb_path1
		elif [ $"devname2" = "1-1" ] || [ $"devname2" = "2-1" ]
		then
			devname=$devname2
			usb_path=$usb_path2
		fi
		
		#Get path in /sys/devices using readlink
		path=$(readlink -f $usb_path)	
		
	else
		# Since it is single module, extract the product ID of the modem.
		idProduct=$(lsusb | grep "ID 2c7c" | awk '{print $6}' | cut -d ":" -f 2)
		productId=$idProduct

		#Find all files named idProduct under /sys/bus/usb/devices/*/, & search for the value of <idProduct_value> within each file,
		#and outputs the file path(s) without the idProduct suffix.
		usb_path=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId {} \; | sed 's|/idProduct$||' | head -1)

		#The ${usb_path##*/} expression extracts the characters after the last slash (/) in the string, leaving only devname ("1-1").
		devname="${usb_path##*/}"
		
		#Get path in /sys/devices using readlink	
		path=$(readlink -f $usb_path)
	fi
	
	if [ "$devname" = "1-1" ]
	then
		uci set modem.CWAN1_0.usbbuspath=$path
		uci set modem.CWAN1_1.usbbuspath=$path

		#find the interface name from the usbpath
		net=$(find $path -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1_0.ifname=$ifname
		uci set modem.CWAN1_1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1_0.device=$device
			uci set modem.CWAN1_1.device=$device
		fi
		
		if [ ! -f "$SimNumFile" ]
		then
			touch "$SimNumFile"
			echo "1" > "$SimNumFile"
			uci set modem.CWAN1_0.modemenable=1
			uci set modem.CWAN1_1.modemenable=0
			uci set modem.CWAN1.modemenable=0
			uci set modem.CWAN2.modemenable=0
			uci commit modem
			
			prefix="CWAN1_0_"
			CWAN1_1_Symlink
			CWAN1_Symlink
			CWAN2_Symlink
			
			#Create/delete Symlink 
			Create_Delete_Symlink $path $prefix $ACTION

		else
			sim=`cat "$SimNumFile"`
			if [ "$sim" = "1" ]
			then
				uci set modem.CWAN1_0.modemenable=1
				uci set modem.CWAN1_1.modemenable=0
				uci set modem.CWAN1.modemenable=0
				uci set modem.CWAN2.modemenable=0
				uci commit modem
				
				prefix="CWAN1_0_"
				CWAN1_1_Symlink
				CWAN1_Symlink
				CWAN2_Symlink
				
				#Create/delete Symlink 
				Create_Delete_Symlink $path $prefix $ACTION

			else
				uci set modem.CWAN1_0.modemenable=0
				uci set modem.CWAN1_1.modemenable=1
				uci set modem.CWAN1.modemenable=0
				uci set modem.CWAN2.modemenable=0
				uci commit modem
				
				prefix="CWAN1_1_"
				CWAN1_0_Symlink
				CWAN1_Symlink
				CWAN2_Symlink
				
				#Create/delete Symlink 
				Create_Delete_Symlink $path $prefix $ACTION
				
			fi
		fi
		
		if [ "$productId" = "0125" ]
		then
			EC25E CWAN1_0
			EC25E CWAN1_1
	
		elif [ "$productId" = "6005" ]
		then
			EC200A CWAN1_0
			EC200A CWAN1_1
			
		elif [ "$productId" = "0306" ]
		then
			EM06 CWAN1_0
			EM06 CWAN1_1
		fi
	elif [ "$devname" = "2-1" ]
	then
		uci set modem.CWAN1_0.usbbuspath=$path
		uci set modem.CWAN1_1.usbbuspath=$path
		
		#find the interface name from the usbpath
		net=$(find $path -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1_0.ifname=$ifname
		uci set modem.CWAN1_1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1_0.device=$device
			uci set modem.CWAN1_1.device=$device
		fi
		
		if [ ! -f "$SimNumFile" ]
		then
			touch "$SimNumFile"
			echo "1" > "$SimNumFile"
			uci set modem.CWAN1_0.modemenable=1
			uci set modem.CWAN1_1.modemenable=0
			uci set modem.CWAN1.modemenable=0
			uci set modem.CWAN2.modemenable=0
			uci commit modem
			
			prefix="CWAN1_0_"
			CWAN1_1_Symlink
			CWAN1_Symlink
			CWAN2_Symlink
			
			#Create/delete Symlink 
			Create_Delete_Symlink $path $prefix $ACTION
		
		else
			sim=`cat "$SimNumFile"`
			if [ "$sim" = "1" ]
			then
				uci set modem.CWAN1_0.modemenable=1
				uci set modem.CWAN1_1.modemenable=0
				uci set modem.CWAN1.modemenable=0
				uci set modem.CWAN2.modemenable=0
				uci commit modem
				
				prefix="CWAN1_0_"
				CWAN1_1_Symlink
				CWAN1_Symlink
				CWAN2_Symlink
				
				#Create/delete Symlink 
				Create_Delete_Symlink $path $prefix $ACTION
				
			else
				uci set modem.CWAN1_0.modemenable=0
				uci set modem.CWAN1_1.modemenable=1
				uci set modem.CWAN1.modemenable=0
				uci set modem.CWAN2.modemenable=0
				uci commit modem
				
				prefix="CWAN1_1_"
				CWAN1_0_Symlink
				CWAN1_Symlink
				CWAN2_Symlink
				
				#Create/delete Symlink 
				Create_Delete_Symlink $path $prefix $ACTION

			fi
		fi
		
		if [ "$productId" = "0800" ]
		then
			RM500Q CWAN1_0
			RM500Q CWAN1_1
	
		elif [ "$productId" = "0900" ]
		then
			RM500U CWAN1_0
			RM500U CWAN1_1
		fi
	fi

#singlecellularsinglesim	
else
	cellularmodule="singlemodule"
	echo $cellularmodule > /tmp/cellularmodule.txt
	
	echo "$Modem1PowerGpio" > /sys/class/gpio/export 
	echo out > /sys/class/gpio/gpio$Modem1PowerGpio/direction
	echo "$Modem1PowerOnValue" > /sys/class/gpio/gpio$Modem1PowerGpio/value	
	
	#Check if there's only 1 module or if there are 2 but user wants to run only 1.
	if [ $noofmodem != "1" ]
	then	
		idProduct=$(lsusb | grep "ID 2c7c" | awk '{print $6}' | cut -d ":" -f 2)
		productId1=$(echo "$idProduct" | head -1)
		productId2=$(echo "$idProduct" | tail -1)
		
		usb_path1=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId1 {} \; | sed 's|/idProduct$||' | head -1)
		usb_path2=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId2 {} \; | sed 's|/idProduct$||' | head -1)

		devname1="${usb_path1##*/}"
		devname2="${usb_path2##*/}"
		
		if [ $"devname1" = "1-1" ] || [ $"devname1" = "2-1" ]
		then
			devname=$devname1
			usb_path=$usb_path1
		elif [ $"devname2" = "1-1" ] || [ $"devname2" = "2-1" ]
		then
			devname=$devname2
			usb_path=$usb_path2
		fi
		
		#Get path in /sys/devices using readlink
		path=$(readlink -f $usb_path)
			
	else
		# Since it is single module, extract the product ID of the modem.
		idProduct=$(lsusb | grep "ID 2c7c" | awk '{print $6}' | cut -d ":" -f 2)
		productId=$idProduct

		#Find all files named idProduct under /sys/bus/usb/devices/*/, & search for the value of <idProduct_value> within each file,
		#and outputs the file path(s) without the idProduct suffix.
		usb_path=$(find /sys/bus/usb/devices/*/ -name idProduct -type f -exec grep -l $productId {} \; | sed 's|/idProduct$||' | head -1)

		#The ${usb_path##*/} expression extracts the characters after the last slash (/) in the string, leaving only devname ("1-1").
		devname="${usb_path##*/}"
		
		#Get path in /sys/devices using readlink
		
		path=$(readlink -f $usb_path)
	fi	
		
	if [ "$devname" = "1-1" ]
	then
		uci set modem.CWAN1.usbbuspath=$path
		
		#find the interface name from the usbpath
		net=$(find $path -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=1
		uci set modem.CWAN2.modemenable=0
		uci commit modem
		
		prefix="CWAN1_"
		CWAN1_1_Symlink
		CWAN1_0_Symlink
		CWAN2_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path $prefix $ACTION
		
		if [ "$productId" = "0125" ]
		then
			EC25E CWAN1
	
		elif [ "$productId" = "6005" ]
		then
			EC200A CWAN1
			
		elif [ "$productId" = "0306" ]
		then
			EM06 CWAN1
		fi
	elif [ "$devname" = "2-1" ]
	then
		uci set modem.CWAN1.usbbuspath=$path
		
		#find the interface name from the usbpath
		net=$(find $path -name net -type d)
		ifname=$(ls $net)
		uci set modem.CWAN1.ifname=$ifname
		
		#find the device created in /dev if the modem is in qmi mode. That is, cdc-wdm
		usbmisc=$(find $path -name usbmisc -type d)
		if [ -n $usbmisc ]
		then
			device=$(ls $usbmisc)
			uci set modem.CWAN1.device=$device
		fi
		
		uci set modem.CWAN1_0.modemenable=0
		uci set modem.CWAN1_1.modemenable=0
		uci set modem.CWAN1.modemenable=1
		uci set modem.CWAN2.modemenable=0
		uci commit modem
		
		prefix="CWAN1_"
		CWAN1_1_Symlink
		CWAN1_0_Symlink
		CWAN2_Symlink
		
		#Create/delete Symlink 
		Create_Delete_Symlink $path $prefix $ACTION
		
		if [ "$productId" = "0800" ]
		then
			RM500Q CWAN1
			
		elif [ "$productId" = "0900" ]
		then
			RM500U CWAN1
		fi
	fi
fi	
