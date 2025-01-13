#!/bin/sh

. /lib/functions.sh


ReadSystemConfigFile()
{
   	config_load "$SystemConfigFile"
   	config_get EnableCellular sysconfig enablecellular
   	config_get model1 sysconfig model1
}

ReadSystemGpioFile()
{
   	config_load "$SystemGpioConfig"
	config_get SimSelectGpio gpio simselectgpio
	config_get Sim1SelectValue gpio sim1selectvalue
	config_get Sim2SelectValue gpio sim2selectvalue
	config_get Sim1LedGpio gpio Sim1LedGpio
	config_get Sim1LedGpioOnvalue gpio Sim1LedGpioOnvalue
	config_get Sim1LedGpioOffvalue gpio Sim1LedGpioOffvalue
	config_get Sim2LedGpio gpio Sim2LedGpio
	config_get Sim2LedGpioOnvalue gpio Sim2LedGpioOnvalue
	config_get Sim2LedGpioOffvalue gpio Sim2LedGpioOffvalue
}
#stop mwan3. Else, it will interfere with bootup. Doesn't allow to switch to sim 1. 
#/usr/sbin/mwan3 stop

sleep 5

Interface="$1"
Simnum="$2"

SystemGpioConfig="/etc/config/systemgpio"
SimNumFile="/tmp/simnumfile"
SystemConfigFile="/etc/config/sysconfig"

LogrotateConfigFile1="/etc/logrotate.d/alllogsmod1"
Logfile1="/root/ConfigFiles/Logs/all_logs_mod1.txt"
#Logfile1="/tmp/all_logs_mod1.txt"

ReadSystemConfigFile
ReadSystemGpioFile

SimSwitchingGpio="/sys/class/gpio/gpio$SimSelectGpio/value"

if [ "$EnableCellular" = "1" ]
then
	uci delete  network.CWAN1_0
	uci delete  network.CWAN1_1
	uci delete  network.CWAN1
	uci delete  network.CWAN2
	uci commit network
	uci network reload
	
	echo "$Simnum" > "$SimNumFile"
	
	#Since bus path is same, just take it from sysconfig. Take the comport, not the symlink.
	ComPortSymLink1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
	comport=$(readlink -f "$ComPortSymLink1")
	
	echo " " >> $Logfile1
	echo "<SimSwitch.sh> comport=$comport ..." >> $Logfile1
	
	#Simnum=1
	if [ "$Simnum" = "1" ]
	then
		echo 1 > "$SimNumFile"
		uci set modem.CWAN1_0.modemenable=1                             
		uci set modem.CWAN1_1.modemenable=0                         
		uci set modem.CWAN1.modemenable=0                           
		uci commit modem
		
		echo "<SimSwitch.sh> Simnum=$Simnum. Switching to sim $Simnum." >> $Logfile1
		echo "<SimSwitch.sh> CWAN1_0.modemenable=1" >> $Logfile1
		echo "<SimSwitch.sh> CWAN1_1.modemenable=0" >> $Logfile1
		
		if [ "$model1" = "EC25E" ] || [ "$model1" = "EC200A" ]
		then
			#switch to 1st sim
			echo "$Sim1SelectValue" > "$SimSwitchingGpio"
			
			echo "<SimSwitch.sh> model1=$model1" >> $Logfile1
			echo "<SimSwitch.sh> Sim1SelectValue=$Sim1SelectValue" >> $Logfile1
		
		#RM500Q & RM500U uses 1 for sim1 and 2 for sim2
		elif [ "$model1" = "RM500Q" ] || [ "$model1" = "RM500U" ]
		then
			/bin/at-cmd $comport AT+QUIMSLOT=1
			
			for i in 1 2 3
			do	
				Status=$(/bin/at-cmd $comport AT+QUIMSLOT?)
				
				# Extract QUIMSLOT value using awk
				quimslot=$(echo "$Status" | awk '/\+QUIMSLOT:/ {print $2}')

				# Extract OK response
				ok_response=$(echo "$Status" | grep -o 'OK[[:space:]]*$')
				
				if [ "$quimslot" = "1" ]
				then
					break
				else
					/bin/at-cmd $comport AT+QUIMSLOT=1
					
					sleep 2
				fi
			done
			
			
			echo "<SimSwitch.sh> model1=$model1" >> $Logfile1
			echo "<SimSwitch.sh> The response of AT+QUIMSLOT=1 $comport is: $quimslot" >> $Logfile1
		
		#EM06 uses 0 for sim1 and 1 for sim2
		else
			/bin/at-cmd $comport AT+QDSIM=0
			
			echo "<SimSwitch.sh> model1=$model1" >> $Logfile1
			echo "<SimSwitch.sh> AT+QDSIM=0 comport=$comport" >> $Logfile1
		fi
	
	#Simnum=2
	else
		echo 2 > "$SimNumFile"
		uci set modem.CWAN1_0.modemenable=0               
		uci set modem.CWAN1_1.modemenable=1            
		uci set modem.CWAN1.modemenable=0            
		uci commit modem 
		
		echo "<SimSwitch.sh> Simnum=$Simnum. Switching to sim $Simnum." >> $Logfile1
		echo "<SimSwitch.sh> CWAN1_0.modemenable=0 " >> $Logfile1
		echo "<SimSwitch.sh> CWAN1_1.modemenable=1 " >> $Logfile1
		
		if [ "$model1" = "EC25E" ] || [ "$model1" = "EC200A" ]
		then
			#switch to 2nd sim
			echo "$Sim2SelectValue" > "$SimSwitchingGpio"
			
			echo "<SimSwitch.sh> model1=$model1" >> $Logfile1
			echo "<SimSwitch.sh> Sim2SelectValue=$Sim2SelectValue" >> $Logfile1
		
		#RM500Q & RM500U uses 1 for sim1 and 2 for sim2	
		elif [ "$model1" = "RM500Q" ] || [ "$model1" = "RM500U" ]
		then
			/bin/at-cmd $comport AT+QUIMSLOT=2
			
			for i in 1 2                                                                                                                  
			do	
				Status=$(/bin/at-cmd $comport AT+QUIMSLOT?)
				
				# Extract QUIMSLOT value using awk
				quimslot=$(echo "$Status" | awk '/\+QUIMSLOT:/ {print $2}')

				# Extract OK response
				ok_response=$(echo "$Status" | grep -o 'OK[[:space:]]*$')
				
				if [ "$quimslot" = "2" ]
				then
					break
				else
					/bin/at-cmd $comport AT+QUIMSLOT=2
					
					sleep 2
				fi
			done
			
			echo "<SimSwitch.sh> model1=$model1" >> $Logfile1
			echo "<SimSwitch.sh> The response of AT+QUIMSLOT=2 $comport is: $quimslot" >> $Logfile1
		
		#EM06 uses 0 for sim1 and 1 for sim2
		else
			/bin/at-cmd $comport AT+QDSIM=1
			
			echo "<SimSwitch.sh> model1=$model1" >> $Logfile1
			echo "<SimSwitch.sh> AT+QDSIM=1 comport=$comport" >> $Logfile1
		fi
	fi
	
	#Power ON-OFF the modem.
	/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh $comport	
	        
	uci commit firewall 
	/etc/init.d/firewall reload
fi
logrotate "$LogrotateConfigFile1"
exit 0
