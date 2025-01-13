#!/bin/sh
. /lib/functions.sh

enablecellular=$(uci get sysconfig.sysconfig.enablecellular)

if [ $enablecellular = 0 ]
then 
	exit 0
fi

LogrotateConfigFile1="/etc/logrotate.d/alllogsmod1"
Logfile1="/root/ConfigFiles/Logs/all_logs_mod1.txt"

LogrotateConfigFile2="/etc/logrotate.d/alllogsmod2"
Logfile2="/root/ConfigFiles/Logs/all_logs_mod2.txt"

modem1 ()
{	
echo "------------BANDLOCKING Modem1-------------" >> $Logfile1

	#Here, we take ComportSymlink1 value...for ex- comport_1=/dev/CWAN1_0_2 and check_comport1=CWAN1_0_2... 
	comport_1=$(uci get sysconfig.sysconfig.ComPortSymLink1)
	check_comport1=$(echo "$comport_1" | cut -d'/' -f3)
	echo "$check_comport1"

	#Here, we check that this ComportSymlink1 value is OK or not...
	at=$(/bin/at-cmd /dev/$check_comport1 at | awk 'NR==2 {print $1}')
	echo "$at"

	#Here, we take Alternate AltComportSymlink1 value...for ex- altcomport_1=/dev/CWAN1_0_3 and check_altcomport1=CWAN1_0_3... 
	altcomport_1=$(uci get sysconfig.sysconfig.AltComPortSymLink1)
	check_altcomport1=$(echo "$altcomport_1" | cut -d'/' -f3)
	echo "$check_altcomport1"

	#Here, we check that this AltComportSymlink1 value is OK or not...
	alt=$(/bin/at-cmd /dev/$check_altcomport1 at | awk 'NR==2 {print $1}')
	echo "$alt"

	#Here, we Check which comport is working ...
	if [ $at = "OK" ]; then
		comport1="$check_comport1"
	elif [ $alt = "OK" ]; then
		comport1="$check_altcomport1"
	else
		exit 0
	fi

	#EC200A, EM06 and EC25E has no NR5G support, kindly do not enable NR5G bands in the web page
	#Here, we write code for first modem in singlecellulardualsim, singlecellularsinglesim and dualcellularsinglesim 
	#where we use ComPortSymLink1 value...
		
	#echo "******************************Band locking started*****************************************"

	#Network1 Mode selected by the user in Webpage either AUTOMATIC,LTE Only,NR5G Only and NR5G & LTE...
	Network1=$(uci get sysconfig.bandlock.bandselectenable1)
	echo "User Selected Network1 is \"$Network1\""  
	#Modem1 selected automatically when you insert in board 
	Modem1=$(uci get sysconfig.sysconfig.model1)
	i=0

	#Selecting Auto bands
	if [ "$Network1" = "auto" ]; then
	#echo "*******************************Band locking Automatic******************************************"
				
		#Selecting Auto band in RM500U
		if [ "$Modem1" = "RM500U" ]; then
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
		
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",AUTO)	
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
			sleep 1
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
				
			sleep 1
				
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
							
		#Selecting Auto band in RM500Q
		elif [ "$Modem1" = "RM500Q" ]; then
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1

			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",AUTO)
				
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",1:2:3:4:5:7:8:12:13:14:17:18:19:20:25:26:28:29:30:32:34:38:39:40:41:42:43:46:48:66:71)
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
			
			sleep 1
			
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",1:2:3:4:5:7:8:12:13:14:17:18:19:20:25:26:28:29:30:32:34:38:39:40:41:42:43:46:48:66:71)
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
			Auto1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				
			sleep 1
				
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
						
		else
			
			#Selecting Auto band in EC200A, EM06 or EC25E			
			while [[ $i -lt 5 ]]; do
				Network1latch=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"nwscanmode\",0 | awk 'NR==2 {print $1}')
				
				if [ "$Modem1" = "EC200A" ]; then
					echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
					Auto1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",0,0 | awk 'NR==2 {print $1}')
				elif [ "$Modem1" = "EM06" ]; then
					echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
					Auto1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",8d0,1a0880800d5 | awk 'NR==2 {print $1}')
				elif [ "$Modem1" = "EC25E" ]; then
					echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
					Auto1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",d3,1a0000800d5 | awk 'NR==2 {print $1}')
				else
					echo "select Modem"
				fi
								
				sleep 1
				
				if [ "$Auto1" = "OK" ]; then
					Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo | awk -F'"' '{print $6}')
					break
				else
					i=$((i+1))
				fi
			done
			
			echo "Band latched for $Modem1: $Band1latched" >> $Logfile1
		fi
	fi	

	#Selecting NR5G & LTE band in RM500U or RM500Q model
	if [ "$Network1" = "5g4g" ]; then
		#Fetching user enabled 5G and lte bands from the sysconfig file
		enabled_5g_bands=$(uci get sysconfig.bandlock.5g)
		enabled_lte_bands=$(uci get sysconfig.bandlock.lte)
				
		if [ "$Modem1" = "RM500U" ]; then
		
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
			echo "The selected NR5G Bands are $enabled_5g_bands" >> $Logfile1
			echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
			
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",NR5G:LTE)
		
			#5G BANDS	
			if [ $enabled_5g_bands = all_5g_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
			else
				band=$(echo $enabled_5g_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
			fi
			
			sleep 1
			
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
						
			#LTE BANDS
					
			if [ $enabled_lte_bands = all_lte_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
			else
				band=$(echo $enabled_lte_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
			fi
			
			sleep 1
			
			Bandlatched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
		
		elif [ "$Modem1" = "RM500Q" ]; then
		
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
			echo "The selected NR5G Bands are $enabled_5g_bands" >> $Logfile1
			echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
			
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",NR5G:LTE)
			
			#5G BANDS	
			if [ $enabled_5g_bands = all_5g_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
			else
				band=$(echo $enabled_5g_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",$band)
			fi
			
			sleep 1
			
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
						
			#LTE BANDS
					
			if [ $enabled_lte_bands = all_lte_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",1:2:3:4:5:7:8:12:13:14:17:18:19:20:25:26:28:29:30:32:34:38:39:40:41:42:43:46:48:66:71)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",1:2:3:4:5:7:8:12:13:14:17:18:19:20:25:26:28:29:30:32:34:38:39:40:41:42:43:46:48:66:71)
			else
				band=$(echo $enabled_lte_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
			fi
			
			sleep 1
			
			Bandlatched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
		
		else
			echo "Select 5G Modem"
		fi
	fi
			
	#Selecting NR5G Only bands in RM500U or RM500Q model
	if [ "$Network1" = "5g" ]; then
	
		#echo "********************************Band locking NR5G*******************************************"
		#Fetching user enabled 5G bands from the sysconfig file
		enabled_5g_bands=$(uci get sysconfig.bandlock.5g)
		
		if [ "$Modem1" = "RM500U" ]; then
			Band=0
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
			echo "The selected NR5G Bands are $enabled_5g_bands" >> $Logfile1
						
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",NR5G)
			if [ $enabled_5g_bands = all_5g_bands  ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
			else
				band=$(echo $enabled_5g_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
			fi
			
				sleep 1
				
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
			
		elif [ "$Modem1" = "RM500Q" ]; then
			Band=0
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
			echo "The selected NR5G Bands are $enabled_5g_bands" >> $Logfile1
						
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",NR5G)
			
			if [ $enabled_5g_bands = all_5g_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",1:2:3:5:7:8:12:20:25:28:38:40:41:48:66:71:77:78:79)
			else
				band=$(echo $enabled_5g_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nr5g_band\",$band)
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"nsa_nr5g_band\",$band)
			fi
			
			sleep 1
			
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
			
		else
			echo "select 5G Modem"
		fi		
	fi

	#Selecting LTE Bands		
	if [ "$Network1" = "lte" ]; then
			
		echo "********************************Band locking LTE*******************************************"
		#Fetching user enabled LTE bands from the sysconfig file
		enabled_lte_bands=$(uci get sysconfig.bandlock.lte)
			
		if [ "$Modem1" = "RM500U" ]; then
			Band=0
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
			echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
        	
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",LTE)
			
			if [ $enabled_lte_bands = all_lte_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"all_band_reset\")
			else
				band=$(echo $enabled_lte_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
			fi
			
				sleep 1
				
			Bandlatched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
			
		elif [ "$Modem1" = "RM500Q" ]; then
			Band=0
			echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
			echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
        	
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"mode_pref\",LTE)
			
			if [ $enabled_lte_bands = all_lte_bands ];then
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",1:2:3:4:5:7:8:12:13:14:17:18:19:20:25:26:28:29:30:32:34:38:39:40:41:42:43:46:48:66:71)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",1:2:3:4:5:7:8:12:13:14:17:18:19:20:25:26:28:29:30:32:34:38:39:40:41:42:43:46:48:66:71)
			else
				band=$(echo $enabled_lte_bands | tr ' ' ':')
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qnwprefcfg=\"lte_band\",$band)
			fi
			
			sleep 1
			
			Bandlatched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
					
		else
	
			#BANDLOCKINGLTE(EC200A, EM06 and EC25E)
			#echo "********************************Band locking LTE*******************************************"
			#Fetching user enabled LTE bands from the sysconfig file
			enabled_lte_bands=$(uci get sysconfig.bandlock.lte)
			Band=0
			
			Network1latch=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"nwscanmode\",3 | awk 'NR==2 {print $1}')
			if [ $enabled_lte_bands = all_lte_bands ];then
				if [ "$Modem1" = "EC200A" ]; then
					echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
					echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
					Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",0,0 | awk 'NR==2 {print $1}')
					sleep 1
					Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",0,0 | awk 'NR==2 {print $1}')
				elif [ "$Modem1" = "EM06" ]; then
					echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
					echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
					Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",8d0,1a0880800d5 | awk 'NR==2 {print $1}')
					sleep 1
					Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",8d0,1a0880800d5 | awk 'NR==2 {print $1}')
				elif [ "$Modem1" = "EC25E" ]; then
					echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
					echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
					Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",d3,1a0000800d5 | awk 'NR==2 {print $1}')
					sleep 1
					Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",d3,1a0000800d5 | awk 'NR==2 {print $1}')
				else
					echo "Select LTE Modem"
				fi
			else
				echo "Setting \"$Network1\" mode for \"$Modem1\" ." >> $Logfile1
				echo "The selected LTE Bands are $enabled_lte_bands" >> $Logfile1
				for band in $enabled_lte_bands; do
					#Finding the band value
					echo "selected bands $band"
					bit_pos=$((band - 1))
					band_val=$((2**(bit_pos)))
					hex_val=$(printf '%x\n' $band_val)
					Band=$((Band+hex_val))
				done
				echo "hexadecimal value = $Band"
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",0,$Band | awk 'NR==2 {print $1}')
				sleep 1
				Bandlock1=$(/bin/at-cmd /dev/$comport1 at+qcfg=\"band\",0,$Band | awk 'NR==2 {print $1}')
			fi
			
			sleep 1
				
			Band1latched=$(/bin/at-cmd /dev/$comport1 at+qnwinfo)
		fi
	fi
}

modem2 ()
{	
echo "------------BANDLOCKING Modem2-------------" >> $Logfile2

#Here, we write code for second modem in dualcellularsinglesim where we use ComPortSymLink2 value...
#for ex- comport_2=/dev/CWAN2_1 and check_comport2=CWAN2_1
comport_2=$(uci get sysconfig.sysconfig.ComPortSymLink2)
check_comport2=$(echo "$comport_2" | cut -d'/' -f3)
echo "$check_comport2"

#Here, we check that this ComportSymlink2 value is OK or not...
at2=$(/bin/at-cmd /dev/$check_comport2 at | awk 'NR==2 {print $1}')
echo "$at2"

#Here, we take Alternate AltComportSymlink2 value...for ex- altcomport_2=/dev/CWAN2_0 and check_altcomport2=CWAN2_0... 
altcomport_2=$(uci get sysconfig.sysconfig.AltComPortSymLink2)
check_altcomport2=$(echo "$altcomport_2" | cut -d'/' -f3)
echo "$check_altcomport2"

#Here, we check that this AltComportSymlink2 value is OK or not...
alt2=$(/bin/at-cmd /dev/$check_altcomport2 at | awk 'NR==2 {print $1}')
echo "$alt2"

#Here, we Check which comport is working ...
if [ $at2 = "OK" ]; then
comport2="$check_comport2"
elif [ $alt2 = "OK" ]; then
comport2="$check_altcomport2"
else 
	exit 0
fi	

#echo "******************************Band locking started*****************************************"

#Network2 Mode selected by the user
Network2=$(uci get sysconfig.bandlock.bandselectenable2)
echo "User Selected Network2 is \"$Network2\""
#Modem2 selected automatically when you insert in board
Modem2=$(uci get sysconfig.sysconfig.model2)
i=0

	#Selecting Auto bands
	if [ "$Network2" = "auto2" ]; then
	#echo "*******************************Band locking Automatic******************************************"
		#Selecting Auto band in EC200A, EM06 and EC25E
			while [[ $i -lt 5 ]]; do
				Network2latch=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"nwscanmode\",0 | awk 'NR==2 {print $1}')
				
				if [ "$Modem2" = "EC200A" ]; then
					echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
					Auto2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",0,0 | awk 'NR==2 {print $1}')
				elif [ "$Modem2" = "EM06" ]; then
					echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
					Auto2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",8d0,1a0880800d5 | awk 'NR==2 {print $1}')
				elif [ "$Modem2" = "EC25E" ]; then
					echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
					Auto2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",d3,1a0000800d5 | awk 'NR==2 {print $1}')
				else
					echo "Select LTE Modem"
				fi
				
				sleep 1
				if [ "$Auto2" = "OK" ]; then
					Band2latched=$(/bin/at-cmd /dev/$comport2 at+qnwinfo | awk -F'"' '{print $6}')
					break
				else
					i=$((i+1))
				fi
			done
			
			echo "Band latched for $Modem2: $Band2latched" >> $Logfile2
	fi

	#Selecting LTE Bands	
	if [ "$Network2" = "lte2" ]; then
		#echo "********************************Band locking LTE*******************************************"
		#Fetching user enabled LTE bands from the sysconfig file
		enabled_lte_bands=$(uci get sysconfig.bandlock.4g)
		Band=0
		
		Network2latch=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"nwscanmode\",3 | awk 'NR==2 {print $1}')
		if [ $enabled_lte_bands = all_lte_bands ];then
			if [ "$Modem2" = "EC200A" ]; then
				echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
				echo "The selected LTE Band is $enabled_lte_bands" >> $Logfile2
				Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",0,0 | awk 'NR==2 {print $1}')
				sleep 1
				Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",0,0 | awk 'NR==2 {print $1}')
			elif [ "$Modem2" = "EM06" ]; then
				echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
				echo "The selected LTE Band is $enabled_lte_bands" >> $Logfile2
				Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",8d0,1a0880800d5 | awk 'NR==2 {print $1}')
				sleep 1
				Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",8d0,1a0880800d5 | awk 'NR==2 {print $1}')
			elif [ "$Modem2" = "EC25E" ]; then
				echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
				echo "The selected LTE Band is $enabled_lte_bands" >> $Logfile2
				Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",d3,1a0000800d5 | awk 'NR==2 {print $1}')
				sleep 1
				Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",d3,1a0000800d5 | awk 'NR==2 {print $1}')
			else
				echo "Select LTE Modem"
			fi
		else
			echo "Setting \"$Network2\" mode for \"$Modem2\" ." >> $Logfile2
			echo "The selected LTE Band is $enabled_lte_bands" >> $Logfile2
			for band in $enabled_lte_bands; do
				#Finding the band value
				echo "selected bands $band"
				bit_pos=$((band - 1))
				band_val=$((2**(bit_pos)))
				hex_val=$(printf '%x\n' $band_val)
				Band=$((Band+hex_val))
			done
			echo "hexadecimal value = $Band"
			Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",0,$Band | awk 'NR==2 {print $1}')
			sleep 1
			Bandlock2=$(/bin/at-cmd /dev/$comport2 at+qcfg=\"band\",0,$Band | awk 'NR==2 {print $1}')
		fi
		
		sleep 1
			
		Band2latched=$(/bin/at-cmd /dev/$comport2 at+qnwinfo)

	fi
}

if [ "$1" = "AddInterface_mod1" ];then
	modem1
fi

if [ "$1" = "AddInterface_mod2" ];then
	modem2
fi
    
logrotate "$LogrotateConfigFile1"												
logrotate "$LogrotateConfigFile2"	

exit 0											
