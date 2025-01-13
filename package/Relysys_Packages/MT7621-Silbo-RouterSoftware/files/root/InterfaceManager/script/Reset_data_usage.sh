#!/bin/sh

. /lib/functions.sh

SimNumFile="/tmp/simnumfile"
TmpSim1DataFile="/tmp/sim1data"
TmpSim2DataFile="/tmp/sim2data"
                                                                                                 
if [ -f "$TmpSim1DataFile" ]                                            
then              
   echo 0,0,0,0 MB > "$TmpSim1DataFile"                                         
fi

if [ -f "$TmpSim2DataFile" ]                                            
then   
   echo 0,0,0,0 MB > "$TmpSim2DataFile"                                         
fi      

sysconfigUCIPath="/etc/config/sysconfig"
simswitchconfigUCIPath="/etc/config/simswitchconfig"

#Load sysconfig file
config_load "$sysconfigUCIPath"
config_get Cellular_Mode sysconfig CellularOperationMode
config_get Protocol sysconfig protocol1
config_get EnableCellular sysconfig enablecellular

#Load simswitchconfig file
config_load "$simswitchconfigUCIPath"
config_get Sim1DataLimit simswitchconfig sim1datausagelimit 
config_get Sim2DataLimit simswitchconfig sim2datausagelimit

if [ "$EnableCellular" = "1" ]
then
	if [ "$Cellular_Mode" = "singlecellulardualsim" ]
	then
		sim=`cat "$SimNumFile"`
		if [ "$sim" = "1" ]
		then
		    if [ ! -f "$TmpSim1DataFile" ]
		    then
		      touch "$TmpSim1DataFile"
		      echo 0,0,0,0 MB > "$TmpSim1DataFile"
		    fi
    	    
			if [ "$Protocol" = "cdcether" ]                           
			then  
			    tx_data=$(cat /sys/class/net/usb0/statistics/tx_bytes)
			    rx_data=$(cat /sys/class/net/usb0/statistics/rx_bytes)
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    echo "${tx_data},${rx_data},${sum},${data_used} MB" > "$TmpSim1DataFile"
			    tmp_data_used=`cat "$TmpSim1DataFile"`
			    
			    if [ $data_used -ge $Sim1DataLimit ]
	            then
	                /bin/simswitch 2  
	            fi          
						
			elif [ "$Protocol" = "qmi" ]
			then
				tx_data=$(cat /sys/class/net/wwan0/statistics/tx_bytes) 
				rx_data=$(cat /sys/class/net/wwan0/statistics/rx_bytes) 
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    echo "${tx_data},${rx_data},${sum},${data_used} MB" > "$TmpSim1DataFile"
			    tmp_data_used=`cat "$TmpSim1DataFile"`
				
			    if [ $data_used -ge $Sim1DataLimit ]
	            then
	                /bin/simswitch 2
	            fi
	                
		    else
				echo "Connect Modem"
			fi				                                                                       
					                                                                                     		    
		elif [ "$sim" = "2" ]
		then
		    if [ ! -f "$TmpSim2DataFile" ]
		    then
		      touch "$TmpSim2DataFile"
		      echo 0,0,0,0 MB > "$TmpSim2DataFile"
		    fi
    	    
			if [ "$Protocol" = "cdcether" ]                           
			then  
			    tx_data=$(cat /sys/class/net/usb0/statistics/tx_bytes)
			    rx_data=$(cat /sys/class/net/usb0/statistics/rx_bytes)
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    echo "${tx_data},${rx_data},${sum},${data_used} MB" > "$TmpSim2DataFile"
			    tmp_data_used=`cat "$TmpSim2DataFile"`
			    
			    if [ $data_used -ge $Sim2DataLimit ]
	            then
	                /bin/simswitch 1  
	            fi          
						
			elif [ "$Protocol" = "qmi" ]
			then
				tx_data=$(cat /sys/class/net/wwan0/statistics/tx_bytes) 
				rx_data=$(cat /sys/class/net/wwan0/statistics/rx_bytes) 
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    echo "${tx_data},${rx_data},${sum},${data_used} MB" > "$TmpSim2DataFile"
			    tmp_data_used=`cat "$TmpSim2DataFile"`
				
			    if [ $data_used -ge $Sim2DataLimit ]
	            then
	                /bin/simswitch 1
	            fi
	                
		    else
				echo "Connect Modem"
			fi			
						               								                                                                                                                 
		else                                                           
			 echo "simnum file is empty..."   
		fi
	
	else
		echo "Cellular_Mode is not set as singlecellulardualsim..."
	fi
	
else
	echo "EnableCellular is not enabled..."
fi
