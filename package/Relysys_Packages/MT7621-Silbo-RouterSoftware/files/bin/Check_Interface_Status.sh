#!/bin/sh

. /lib/functions.sh

ReadSystemConfigFile()
{
   	config_load "$SystemConfigFile"
   	config_get CellularOperationModelocal sysconfig CellularOperationMode
   	config_get EnableCellular sysconfig enablecellular
}

SystemConfigFile="/etc/config/sysconfig"

ReadSystemConfigFile

if [ "$EnableCellular" = "1" ]
then

	if [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
	
	  simnum=$(cat /tmp/simnumfile)                                                                                         
      if [ "$simnum" = "1" ]                                                                                                
      then      
	        InterfaceStatus=$(mwan3 interfaces | grep CWAN1_0 | cut -d " " -f 5) 
	        echo "InterfaceStatus=$InterfaceStatus"
	         if [ $InterfaceStatus == "online" ]
	         then
	             echo 0 > /tmp/InterfaceStatus.txt
		         
	         else
	             echo 1 > /tmp/InterfaceStatus.txt
	         
	         fi
	        
      else  

	        InterfaceStatus=$(mwan3 interfaces | grep CWAN1_1 | cut -d " " -f 5) 
	        
	        if [ $InterfaceStatus == "online" ]
	         then
	             echo 0 > /tmp/InterfaceStatus.txt
		         
	         else
	             echo 1 > /tmp/InterfaceStatus.txt
	         
	         fi
	        
	 fi       
	 
	else
	        InterfaceStatus=$(mwan3 interfaces | grep CWAN1 | cut -d " " -f 5) 
	        if [ $InterfaceStatus == "online" ]
	         then
	             echo 0 > /tmp/InterfaceStatus.txt
		         
	         else
	             echo 1 > /tmp/InterfaceStatus.txt
	         
	         fi

	fi
	
else

	echo 2 > /tmp/InterfaceStatus.txt
	
fi

