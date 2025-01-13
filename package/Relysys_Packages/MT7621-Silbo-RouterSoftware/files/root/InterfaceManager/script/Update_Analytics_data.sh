#!/bin/sh

. /lib/functions.sh

IMEI=$(uci get boardconfig.board.imei)

cellularwan1interface="CWAN1"
cellularwan2interface="CWAN2"
cellularwan3interface="CWAN3"
cellularwan1sim1interface="CWAN1_0"
cellularwan1sim2interface="CWAN1_1"

SystemConfigFile="/etc/config/sysconfig"
Simswitchbasedon=$(uci get simswitchconfig.simswitchconfig.simswitch)

ReadSystemConfigFile()
{
   	config_load "$SystemConfigFile"
   	config_get CellularOperationModelocal sysconfig CellularOperationMode
   	config_get EnableCellular sysconfig enablecellular
}

Signal_strength(){
	
	ComPort="$1"
	modem_number="$2"
	ModemAnalyticsFile="/tmp/ModemAnalytics${modem_number}.txt"
	Connected="nil"
	count=0
	while [ "$Connected" = "nil" ]
	do
		Operator_Code=$(gcom -d "$ComPort" -s /etc/gcom/getcarrier.gcom | awk NR==2)

		Operator=$(echo "$Operator_Code" | cut -d "," -f 2 | tr -d '\011\012\013\014\015\040')

		Operator=$(echo "$Operator" | tr -d '"')

		#Quality_Signal_Noise=$(gcom -d "$ComPort" -s /etc/gcom/getquality.gcom | awk NR==2)
		#Connected=$(echo "$Quality_Signal_Noise" | cut -d "," -f 3 | tr -d '\011\012\013\014\015\040')
		
		Quality_Signal_Noise_Full=$(gcom -d "$ComPort" -s /etc/gcom/getquality.gcom)
		Connected_LTE=$(echo "$Quality_Signal_Noise_Full" | grep -o LTE | tr -d '\011\012\013\014\015\040')
		Connected_NSA=$(echo "$Quality_Signal_Noise_Full" | grep -o NR5G-NSA | tr -d '\011\012\013\014\015\040')
		Connected_SA=$(echo "$Quality_Signal_Noise_Full" | grep -o NR5G-SA | tr -d '\011\012\013\014\015\040')
		Connected_EDGE=$(echo "$Quality_Signal_Noise_Full" | grep -o EDGE | tr -d '\011\012\013\014\015\040')
		Connected_GPRS=$(echo "$Quality_Signal_Noise_Full" | grep -o GPRS | tr -d '\011\012\013\014\015\040')
		Connected_CDMA=$(echo "$Quality_Signal_Noise_Full" | grep -o CDMA | tr -d '\011\012\013\014\015\040')
		
		if [ "$Connected_LTE" = "LTE" ] && [ "$Connected_NSA" = "NR5G-NSA" ]
		then
			Connected="NSA"
			Quality_Signal_Noise1=$(echo "$Quality_Signal_Noise_Full" | awk NR==3)
			Quality_Signal_Noise2=$(echo "$Quality_Signal_Noise_Full" | awk NR==4)
		
		elif [ "$Connected_LTE" = "LTE" ]
		then
			Connected="LTE"
			Quality_Signal_Noise=$(echo "$Quality_Signal_Noise_Full" | awk NR==2)
			
		elif [ "$Connected_SA" = "NR5G-SA" ]
		then
			Connected="SA"
			Quality_Signal_Noise=$(echo "$Quality_Signal_Noise_Full" | awk NR==2)
		elif [ "$Connected_EDGE" = "EDGE" ]
		then
			Connected="EDGE"
			Quality_Signal_Noise=$(echo "$Quality_Signal_Noise_Full" | awk NR==2)
		elif [ "$Connected_GPRS" = "GPRS" ]
		then
			Connected="GPRS"
			Quality_Signal_Noise=$(echo "$Quality_Signal_Noise_Full" | awk NR==2)
		elif [ "$Connected_CDMA" = "CDMA" ]
		then
			Connected="CDMA"
			Quality_Signal_Noise=$(echo "$Quality_Signal_Noise_Full" | awk NR==2)
		fi
		
		if [ "$Connected" = "SA" ] 
		then
			MODE=$(echo "$Quality_Signal_Noise" | cut -d "," -f 4 | tr -d '\011\012\013\014\015\040')
			MODE=$(echo "$MODE" | tr -d '"')
			MCC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')
			MNC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 6 | tr -d '\011\012\013\014\015\040')
			LAC="-"
			CELLID=$(echo "$Quality_Signal_Noise" | cut -d "," -f 7 | tr -d '\011\012\013\014\015\040')
			BSIC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 8 | tr -d '\011\012\013\014\015\040')
			ARFCN=$(echo "$Quality_Signal_Noise" | cut -d "," -f 10 | tr -d '\011\012\013\014\015\040')
			BAND=$(echo "$Quality_Signal_Noise" | cut -d "," -f 11 | tr -d '\011\012\013\014\015\040')
			ULBAND="-"
			
			DLBAND_VAL=$(echo "$Quality_Signal_Noise" | cut -d "," -f 12 | tr -d '\011\012\013\014\015\040')
			
			if [ "${DLBAND_VAL}" = "1" ]                                                                    
			then                                                                                            
				DLBAND="3 MHz"                                                                               
			elif [ "${DLBAND_VAL}" = "2" ]                                                                  
			then                                                                                            
				DLBAND="5 MHz"                                                                                                                             
			elif [ "${DLBAND_VAL}" = "3" ]                                                                                                                
			then                                                                                                                                          
				DLBAND="10 MHz"                                                                                                                            
			elif [ "${DLBAND_VAL}" = "4" ]                                                                                                                
			then                                                                                                                                          
				DLBAND="15 MHz"                                                                                                                            
			else                                                                                                                                          
				DLBAND="20 MHz"                                                                                                                            
			fi 
			
			TAC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 9 | tr -d '\011\012\013\014\015\040')
			RSRP=$(echo "$Quality_Signal_Noise" | cut -d "," -f 13 | tr -d '\011\012\013\014\015\040')
			RSRQ=$(echo "$Quality_Signal_Noise" | cut -d "," -f 14 | tr -d '\011\012\013\014\015\040')
			RSSI="-"
			SINR=$(echo "$Quality_Signal_Noise" | cut -d "," -f 15 | tr -d '\011\012\013\014\015\040')
			echo "$Operator,$Connected,$MODE,$MCC,$MNC,$LAC,$CELLID,$BSIC,$ARFCN,$BAND,$ULBAND,$DLBAND,$TAC,$RSRP,$RSRQ,$RSSI,$SINR" > $ModemAnalyticsFile

			#signal status controller and simswitch signal 
			sh /root/InterfaceManager/script/signal_strength_led_controller.sh "$Connected" "$RSRP" "$modem_number"
			
			if [[ "$Simswitchbasedon" = "signalstren" ]] 
			then
				sh /root/InterfaceManager/script/Simswitchsignal.sh "$RSRP" "$SINR"
			fi
			
		elif [ "$Connected" = "LTE" ] 
		then
			MODE=$(echo "$Quality_Signal_Noise" | cut -d "," -f 4 | tr -d '\011\012\013\014\015\040')
			MODE=$(echo "$MODE" | tr -d '"')
			MCC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')
			MNC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 6 | tr -d '\011\012\013\014\015\040')
			LAC="-"
			CELLID=$(echo "$Quality_Signal_Noise" | cut -d "," -f 7 | tr -d '\011\012\013\014\015\040')
			BSIC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 8 | tr -d '\011\012\013\014\015\040')
			ARFCN=$(echo "$Quality_Signal_Noise" | cut -d "," -f 9 | tr -d '\011\012\013\014\015\040')
			BAND=$(echo "$Quality_Signal_Noise" | cut -d "," -f 10 | tr -d '\011\012\013\014\015\040')
			ULBAND_VAL=$(echo "$Quality_Signal_Noise" | cut -d "," -f 11 | tr -d '\011\012\013\014\015\040')
			
			if [ "${ULBAND_VAL}" = "1" ]
			then
				ULBAND="3 MHz"
			elif [ "${ULBAND_VAL}" = "2" ]
			then
				ULBAND="5 MHz"
			elif [ "${ULBAND_VAL}" = "3" ]                                                                                                                
			then
				ULBAND="10 MHz"
			elif [ "${ULBAND_VAL}" = "4" ]                                                                                                                
			then 
				ULBAND="15 MHz"
			else
				ULBAND="20 MHz"
			fi 
			
			DLBAND_VAL=$(echo "$Quality_Signal_Noise" | cut -d "," -f 12 | tr -d '\011\012\013\014\015\040')
			
			if [ "${DLBAND_VAL}" = "1" ]                                                                    
			then                                                                                            
				DLBAND="3 MHz"                                                                               
			elif [ "${DLBAND_VAL}" = "2" ]                                                                  
			then                                                                                            
				DLBAND="5 MHz"                                                                                                                             
			elif [ "${DLBAND_VAL}" = "3" ]                                                                                                                
			then                                                                                                                                          
				DLBAND="10 MHz"                                                                                                                            
			elif [ "${DLBAND_VAL}" = "4" ]                                                                                                                
			then                                                                                                                                          
				DLBAND="15 MHz"                                                                                                                            
			else                                                                                                                                          
				DLBAND="20 MHz"                                                                                                                            
			fi 
			
			TAC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 13 | tr -d '\011\012\013\014\015\040')
			RSRP=$(echo "$Quality_Signal_Noise" | cut -d "," -f 14 | tr -d '\011\012\013\014\015\040')
			RSRQ=$(echo "$Quality_Signal_Noise" | cut -d "," -f 15 | tr -d '\011\012\013\014\015\040')
			RSSI=$(echo "$Quality_Signal_Noise" | cut -d "," -f 16 | tr -d '\011\012\013\014\015\040')
			SINR=$(echo "$Quality_Signal_Noise" | cut -d "," -f 17 | tr -d '\011\012\013\014\015\040')
			echo "$Operator,$Connected,$MODE,$MCC,$MNC,$LAC,$CELLID,$BSIC,$ARFCN,$BAND,$ULBAND,$DLBAND,$TAC,$RSRP,$RSRQ,$RSSI,$SINR" > $ModemAnalyticsFile

			#signal status controller and simswitch signal 
			sh /root/InterfaceManager/script/signal_strength_led_controller.sh "$Connected" "$RSRP" "$modem_number"

			if [[ "$Simswitchbasedon" = "signalstren" ]] 
			then
				sh /root/InterfaceManager/script/Simswitchsignal.sh "$RSRP" "$SINR"
			fi
			
		elif [ "$Connected" = "NSA" ]
		then
			band=$(at-cmd "$ComPort" at+qnwinfo | grep -i "NSA" | cut -d "," -f 3)
			RSRP=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')
			if [ "$band" = "\"\"" ] || [ "$band" = "\" \"" ] && [ $RSRP -eq 0 ] 
			then
				Connected="LTE"
				MODE=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 2 | tr -d '\011\012\013\014\015\040')
				MODE=$(echo "$MODE" | tr -d '"')
				MCC=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 3 | tr -d '\011\012\013\014\015\040')
				MNC=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 4 | tr -d '\011\012\013\014\015\040')
				LAC="-"
				CELLID=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')
				BSIC=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 6 | tr -d '\011\012\013\014\015\040')
				ARFCN=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 7 | tr -d '\011\012\013\014\015\040')
				BAND=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 8 | tr -d '\011\012\013\014\015\040')
				ULBAND_VAL=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 9 | tr -d '\011\012\013\014\015\040')
			
				if [ "${ULBAND_VAL}" = "1" ]
				then
					ULBAND="3 MHz"
				elif [ "${ULBAND_VAL}" = "2" ]
				then
					ULBAND="5 MHz"
				elif [ "${ULBAND_VAL}" = "3" ]                                                                                                                
				then
					ULBAND="10 MHz"
				elif [ "${ULBAND_VAL}" = "4" ]                                                                                                                
				then 
					ULBAND="15 MHz"
				else
					ULBAND="20 MHz"
				fi 
			
				DLBAND_VAL=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 10 | tr -d '\011\012\013\014\015\040')
			
				if [ "${DLBAND_VAL}" = "1" ]                                                                    
				then                                                                                            
					DLBAND="3 MHz"                                                                               
				elif [ "${DLBAND_VAL}" = "2" ]                                                                  
				then                                                                                            
					DLBAND="5 MHz"                                                                                                                             
				elif [ "${DLBAND_VAL}" = "3" ]                                                                                                                
				then                                                                                                                                          
					DLBAND="10 MHz"                                                                                                                            
				elif [ "${DLBAND_VAL}" = "4" ]                                                                                                                
				then                                                                                                                                          
					DLBAND="15 MHz"                                                                                                                            
				else                                                                                                                                          
					DLBAND="20 MHz"                                                                                                                            
				fi 
			
				TAC=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 11 | tr -d '\011\012\013\014\015\040')
				RSRP=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 12 | tr -d '\011\012\013\014\015\040')
				RSRQ=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 13 | tr -d '\011\012\013\014\015\040')
				RSSI=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 14 | tr -d '\011\012\013\014\015\040')
				SINR=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 15 | tr -d '\011\012\013\014\015\040')
			else	
				MODE=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 2 | tr -d '\011\012\013\014\015\040')
				MODE=$(echo "$MODE" | tr -d '"')
				MCC=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 2 | tr -d '\011\012\013\014\015\040')
				MNC=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 3 | tr -d '\011\012\013\014\015\040')
				LAC="-"
				CELLID=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 10 | tr -d '\011\012\013\014\015\040')
				BSIC=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 4 | tr -d '\011\012\013\014\015\040')
				ARFCN=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 8 | tr -d '\011\012\013\014\015\040')
				BAND=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 9 | tr -d '\011\012\013\014\015\040')
				ULBAND_VAL=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 9 | tr -d '\011\012\013\014\015\040')
				
				if [ "${ULBAND_VAL}" = "1" ]
				then
					ULBAND="3 MHz"
				elif [ "${ULBAND_VAL}" = "2" ]
				then
					ULBAND="5 MHz"
				elif [ "${ULBAND_VAL}" = "3" ]                                                                                                                
				then
					ULBAND="10 MHz"
				elif [ "${ULBAND_VAL}" = "4" ]                                                                                                                
				then 
					ULBAND="15 MHz"
				else
					ULBAND="20 MHz"
				fi 
				
				DLBAND_VAL=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 10 | tr -d '\011\012\013\014\015\040')
				
				if [ "${DLBAND_VAL}" = "1" ]                                                                    
				then                                                                                            
					DLBAND="3 MHz"                                                                               
				elif [ "${DLBAND_VAL}" = "2" ]                                                                  
				then                                                                                            
					DLBAND="5 MHz"                                                                                                                             
				elif [ "${DLBAND_VAL}" = "3" ]                                                                                                                
				then                                                                                                                                          
					DLBAND="10 MHz"                                                                                                                            
				elif [ "${DLBAND_VAL}" = "4" ]                                                                                                                
				then                                                                                                                                          
					DLBAND="15 MHz"                                                                                                                            
				else                                                                                                                                          
					DLBAND="20 MHz"                                                                                                                            
				fi 
				
				TAC=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 11 | tr -d '\011\012\013\014\015\040')
				RSRP=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')
				RSRQ=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 7 | tr -d '\011\012\013\014\015\040')
				RSSI=$(echo "$Quality_Signal_Noise1" | cut -d "," -f 14 | tr -d '\011\012\013\014\015\040')
				SINR=$(echo "$Quality_Signal_Noise2" | cut -d "," -f 6 | tr -d '\011\012\013\014\015\040')
			fi
			echo "$Operator,$Connected,$MODE,$MCC,$MNC,$LAC,$CELLID,$BSIC,$ARFCN,$BAND,$ULBAND,$DLBAND,$TAC,$RSRP,$RSRQ,$RSSI,$SINR" > $ModemAnalyticsFile

			#signal status controller and simswitch signal 
			sh /root/InterfaceManager/script/signal_strength_led_controller.sh "$Connected" "$RSRP" "$modem_number"
			
			if [[ "$Simswitchbasedon" = "signalstren" ]] 
			then
				sh /root/InterfaceManager/script/Simswitchsignal.sh "$RSRP" "$SINR"
			fi
			
		else	
			MODE="-"       
			MCC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 4 | tr -d '\011\012\013\014\015\040')                                                      
			MNC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')                                                      
			LAC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 6 | tr -d '\011\012\013\014\015\040')                                                                                                                                       
			CELLID=$(echo "$Quality_Signal_Noise" | cut -d "," -f 7 | tr -d '\011\012\013\014\015\040')                                                   
			BSIC=$(echo "$Quality_Signal_Noise" | cut -d "," -f 8 | tr -d '\011\012\013\014\015\040')                                                     
			ARFCN=$(echo "$Quality_Signal_Noise" | cut -d "," -f 9 | tr -d '\011\012\013\014\015\040')                                                    
			BAND_VAL=$(echo "$Quality_Signal_Noise" | cut -d "," -f 10 | tr -d '\011\012\013\014\015\040')
			
			if [ "${BAND_VAL}" = "0" ]
			then
				BAND="DCS1800"
			elif [ "${BAND_VAL}" = "1" ]
			then
				BAND="PCS1900" 
			else
				BAND="GSM900"
			fi                                                    
			
			ULBAND="-"                                                                              
			DLBAND="-"                                                                                                                            
			TAC="-"                                                    
			RSRP="-"                                                    
			RSRQ="-"                                                    
			SINR="-"                         
			RSSI=$(at-cmd "$ComPort" at+csq | grep +CSQ | cut -d " " -f 2 | cut -d "," -f 1 | tr -d '\011\012\013\014\015\040')
			RSSI=$((31-RSSI))
			RSSI=$((RSSI*2))
			RSSI=$((-51-RSSI))
			echo "$Operator,$Connected,$MODE,$MCC,$MNC,$LAC,$CELLID,$BSIC,$ARFCN,$BAND,$ULBAND,$DLBAND,$TAC,$RSRP,$RSRQ,$RSSI,$SINR" > $ModemAnalyticsFile

			#signal status controller and simswitch signal 
			sh /root/InterfaceManager/script/signal_strength_led_controller.sh "$Connected" "$RSSI" "$modem_number"
		fi
		
		#Get some information about modem through at commands for snmp agent
		sim_Reg_State=$(at-cmd $ComPort AT+CREG? | awk NR==2 | cut -d "," -f 2 | tr -d '\011\012\013\014\015\040')
		SignalStrength=$(at-cmd $ComPort AT+CSQ | awk -F'[ ,"]' '/\+CSQ:/ {print $2}' | tr -d '\011\012\013\014\015\040')
	    OperatorCode=$MCC$MNC
	    SentToday=NA
	    ReceivedToday=NA
	    msent=NA
		mreceived=NA
		
		if [ "$modem_number" = "1" ];then
			uci set modemstatus.modemstatus=interface
			uci delete modemstatus.modemstatus.CellularOperationMode
			uci set modemstatus.modemstatus.CellularOperationMode=$CellularOperationModelocal
			uci delete modemstatus.modemstatus.deviceNoofModem
			uci set modemstatus.modemstatus.deviceNoofModem=$NoOfModem
			uci set modemstatus.modemstatus.Operator=$Operator
			uci set modemstatus.modemstatus.Connected=$Connected
			uci set modemstatus.modemstatus.MODE=$MODE
			uci set modemstatus.modemstatus.MCC=$MCC
			uci set modemstatus.modemstatus.MNC=$MNC
			uci set modemstatus.modemstatus.LAC=$LAC
			uci set modemstatus.modemstatus.CellID=$CELLID
			uci set modemstatus.modemstatus.BSIC=$BSIC
			uci set modemstatus.modemstatus.ARFCN=$ARFCN
			uci set modemstatus.modemstatus.BAND=$BAND
			ULBANDMHz=$(echo $ULBAND | cut -d ' ' -f 1)
			uci set modemstatus.modemstatus.ULBAND="$ULBANDMHz"MHz
			DLBANDMHz=$(echo $DLBAND | cut -d ' ' -f 1)
			uci set modemstatus.modemstatus.DLBAND="$DLBANDMHz"MHz
			uci set modemstatus.modemstatus.TAC=$TAC
			uci set modemstatus.modemstatus.RSRP=$RSRP
			uci set modemstatus.modemstatus.RSRQ=$RSRQ
			uci set modemstatus.modemstatus.RSSI=$RSSI
			uci set modemstatus.modemstatus.SINR=$SINR
			uci set modemstatus.modemstatus.ModemRevision=$ModemRevision
			uci set modemstatus.modemstatus.Manufacturer=$Manufacturer
			uci set modemstatus.modemstatus.IMSI=$IMSI
			uci set modemstatus.modemstatus.Model=$Model
			uci set modemstatus.modemstatus.Imei=$Imei
			uci set modemstatus.modemstatus.sim_Reg_State=$sim_Reg_State
			uci set modemstatus.modemstatus.SignalStrength=$SignalStrength
			uci set modemstatus.modemstatus.OperatorCode=$OperatorCode
			uci set modemstatus.modemstatus.SentToday=$SentToday
			uci set modemstatus.modemstatus.ReceivedToday=$ReceivedToday
			uci set modemstatus.modemstatus.msent=$msent
			uci set modemstatus.modemstatus.mreceived=$mreceived
			
			#Delete modem2_version values when opeartion is not dualcellularsinglesim			
			uci delete modemstatus.modemstatus.Operator2
			uci delete modemstatus.modemstatus.Connected2
			uci delete modemstatus.modemstatus.MODE2
			uci delete modemstatus.modemstatus.MCC2
			uci delete modemstatus.modemstatus.MNC2
			uci delete modemstatus.modemstatus.LAC2
			uci delete modemstatus.modemstatus.CellID2
			uci delete modemstatus.modemstatus.BSIC2
			uci delete modemstatus.modemstatus.ARFCN2
			uci delete modemstatus.modemstatus.BAND2
			uci delete modemstatus.modemstatus.ULBAND2
			uci delete modemstatus.modemstatus.DLBAND2
			uci delete modemstatus.modemstatus.TAC2
			uci delete modemstatus.modemstatus.RSRP2
			uci delete modemstatus.modemstatus.RSRQ2
			uci delete modemstatus.modemstatus.RSSI2
			uci delete modemstatus.modemstatus.SINR2
			uci delete modemstatus.modemstatus.ModemRevision2
			uci delete modemstatus.modemstatus.Manufacturer2
			uci delete modemstatus.modemstatus.IMSI2
			uci delete modemstatus.modemstatus.Model2
			uci delete modemstatus.modemstatus.Imei2
			uci delete modemstatus.modemstatus.sim_Reg_State2
			uci delete modemstatus.modemstatus.SignalStrength2
			uci delete modemstatus.modemstatus.OperatorCode2
			uci delete modemstatus.modemstatus.SentToday2
			uci delete modemstatus.modemstatus.ReceivedToday2
			uci delete modemstatus.modemstatus.msent2
			uci delete modemstatus.modemstatus.mreceived2
			if [ "$CellularOperationModelocal" = "singlecellulardualsim" ] || [ "$CellularOperationModelocal" = "singlecellularsinglesim" ];then
				uci delete modemstatus.modemstatus.QCCID2
				uci delete modemstatus.modemstatus.PinState2
			fi
			
			uci commit modemstatus
		elif [ "$modem_number" = "2" ];then
			uci set modemstatus.modemstatus=interface
			uci delete modemstatus.modemstatus.CellularOperationMode
			uci set modemstatus.modemstatus.CellularOperationMode=$CellularOperationModelocal
			uci delete modemstatus.modemstatus.deviceNoofModem
			uci set modemstatus.modemstatus.deviceNoofModem=$NoOfModem
			uci set modemstatus.modemstatus.Operator2=$Operator
			uci set modemstatus.modemstatus.Connected2=$Connected
			uci set modemstatus.modemstatus.MODE2=$MODE
			uci set modemstatus.modemstatus.MCC2=$MCC
			uci set modemstatus.modemstatus.MNC2=$MNC
			uci set modemstatus.modemstatus.LAC2=$LAC
			uci set modemstatus.modemstatus.CellID2=$CELLID
			uci set modemstatus.modemstatus.BSIC2=$BSIC
			uci set modemstatus.modemstatus.ARFCN2=$ARFCN
			uci set modemstatus.modemstatus.BAND2=$BAND
			ULBANDMHz=$(echo $ULBAND | cut -d ' ' -f 1)
			uci set modemstatus.modemstatus.ULBAND2="$ULBANDMHz"MHz
			DLBANDMHz=$(echo $DLBAND | cut -d ' ' -f 1)
			uci set modemstatus.modemstatus.DLBAND2="$DLBANDMHz"MHz
			uci set modemstatus.modemstatus.TAC2=$TAC
			uci set modemstatus.modemstatus.RSRP2=$RSRP
			uci set modemstatus.modemstatus.RSRQ2=$RSRQ
			uci set modemstatus.modemstatus.RSSI2=$RSSI
			uci set modemstatus.modemstatus.SINR2=$SINR
			uci set modemstatus.modemstatus.ModemRevision2=$ModemRevision2
			uci set modemstatus.modemstatus.Manufacturer2=$Manufacturer2
			uci set modemstatus.modemstatus.IMSI2=$IMSI2
			uci set modemstatus.modemstatus.Model2=$Model2
			uci set modemstatus.modemstatus.Imei2=$Imei2
			uci set modemstatus.modemstatus.sim_Reg_State2=$sim_Reg_State
			uci set modemstatus.modemstatus.SignalStrength2=$SignalStrength
			uci set modemstatus.modemstatus.OperatorCode2=$OperatorCode
			uci set modemstatus.modemstatus.SentToday2=$SentToday
			uci set modemstatus.modemstatus.ReceivedToday2=$ReceivedToday
			uci set modemstatus.modemstatus.msent2=$msent
			uci set modemstatus.modemstatus.mreceived2=$mreceived
			uci commit modemstatus
		fi
		count=$((count+1))
		if [ $count -gt 5 ]
		then
			break
		fi
	done
}

#This function is for snmp agent to get the IP
#Modem1 and Modem2 Sim IP is set in /tmp/modem1_IP and modem2_IP respectively... 
IP()
{
	#This is for both Singlecellularsinglesim and dualcellularsinglesim for modem1... 
	if [ "$1" = "IP_dcss_modem1" ];then
		if [ "$pdp1" = "1" ];then
			IP=$(ifconfig "$ifname1" | awk '/inet addr/{print substr($2,6)}') 
			echo $IP > /tmp/modem1_IP
		elif [ "$pdp1" = "2" ];then
			IP=$(ifconfig "$ifname1" | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
			echo $IP > /tmp/modem1_IP
		elif [ "$pdp1" = "3" ];then
			IPV4=$(ifconfig "$ifname1" | awk '/inet addr/{print substr($2,6)}')
			IPV6=$(ifconfig "$ifname1" | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
			IP=$(echo $IPV4 $IPV6)
			echo $IP > /tmp/modem1_IP
		fi
	
	#This is for dualcellularsinglesim for modem2...
	elif [ "$1" = "IP_dcss_modem2" ];then
		if [ "$pdp2" = "1" ];then
			IP2=$(ifconfig "$ifname2" | awk '/inet addr/{print substr($2,6)}')
			echo $IP2 > /tmp/modem2_IP
		elif [ "$pdp2" = "2" ];then
			IP2=$(ifconfig "$ifname2" | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
			echo $IP2 > /tmp/modem2_IP
		elif [ "$pdp2" = "3" ];then
			IP2V4=$(ifconfig "$ifname2" | awk '/inet addr/{print substr($2,6)}')
			IP2V6=$(ifconfig "$ifname2" | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
			IP2=$(echo $IP2V4 $IP2V6)
			echo $IP2 > /tmp/modem2_IP
		fi

	#This is for singlecellulardualsim...
	elif [ "$1" = "IP_scds" ];then
		if [ "$pdp" = "1" ];then
			IP=$(ifconfig "$ifname" | awk '/inet addr/{print substr($2,6)}')
			echo $IP > /tmp/modem1_IP
		elif [ "$pdp" = "2" ];then
			IP=$(ifconfig "$ifname" | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
			echo $IP > /tmp/modem1_IP
		elif [ "$pdp" = "3" ];then
			IPV4=$(ifconfig "$ifname" | awk '/inet addr/{print substr($2,6)}')
			IPV6=$(ifconfig "$ifname" | awk '/inet6 addr:.*Scope:Global/{gsub(/\/.*$/, "", $3); print $3}')
			IP=$(echo $IPV4 $IPV6)
			echo $IP > /tmp/modem1_IP
		fi
	fi
}

ReadSystemConfigFile
touch /etc/config/modemstatus

#To get the information of modem1 and 2...
source /bin/snmp/modem1_version
source /bin/snmp/modem2_version
		
if [ "$EnableCellular" = "1" ]
then
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
		NoOfModem="2"
		#for modem1...
		ComPort1=$(uci get modem.CWAN1.ComPortSymLink)
		ifname1=$(uci get modem.CWAN1.ifname)
		pdp1=$(uci get modem.CWAN1.pdp)
		#for modem2
		ComPort2=$(uci get modem.CWAN2.ComPortSymLink)
		ifname2=$(uci get modem.CWAN2.ifname)
		pdp2=$(uci get modem.CWAN2.pdp)
		
		if  ifconfig | grep -qE "$ifname1" 
		then
			Signal_strength $ComPort1 1
			IP IP_dcss_modem1
		fi
		if  ifconfig | grep -qE "$ifname2" 
		then
			Signal_strength $ComPort2 2
			IP IP_dcss_modem2
		fi    		
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
		NoOfModem="1"
		modem1_enable1=$(uci get modem.CWAN1_0.modemenable)
		modem1_enable2=$(uci get modem.CWAN1_1.modemenable)
		if [ "$modem1_enable1" = 1 ];then 
			ifname=$(uci get modem.CWAN1_0.ifname)
			pdp=$(uci get modem.CWAN1_0.pdp)
		elif [ "$modem1_enable2" = 1 ];then
			ifname=$(uci get modem.CWAN1_1.ifname)
			pdp=$(uci get modem.CWAN1_1.pdp)
		fi
	
		if  ifconfig | grep -qE "$ifname" 
		then
			simnum=$(cat /tmp/simnumfile)                                                                                         
			if [ "$simnum" = "1" ]                                                                                                
			then
				ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)			
				Signal_strength $ComPort 1
				IP IP_scds
			else
				ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim2interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
				Signal_strength $ComPort 1
				IP IP_scds
			fi
		fi
	else      
		NoOfModem="1"
		ifname1=$(uci get modem.CWAN1.ifname)
		pdp1=$(uci get modem.CWAN1.pdp)
		if  ifconfig | grep -qE "$ifname1" 
		then
			ComPort=$(uci get modem.CWAN1.ComPortSymLink)
			Signal_strength $ComPort 1
			IP IP_dcss_modem1
		fi
	fi

#For snmp agent modem.sh ,port_info.sh and wireless_info.sh script is run to update modem information in config file...
sh /etc/snmp/modem.sh &
sh /etc/snmp/port_info.sh &
sh /etc/snmp/wireless_info.sh &

#Exit if cellular is not enabled.
else
	exit 0
fi

exit 0
