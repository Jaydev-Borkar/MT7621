#!/bin/sh

. /lib/functions.sh

#
# PKG_RELEASE: 1.01
#

#
# Input arguments and Default Parameters
#
SMSEventType="$1"
IncomingSMSFile="$2"
MaxReceivedSMS=20
MaxSentSMS=20
MaxFailedSMS=20
ReceivedSMSDir="/var/spool/sms/incoming"
SentSMSDir="/var/spool/sms/sent"
FailedSMSDir="/var/spool/sms/failed"
OutgoingSMSDir="/var/spool/sms/outgoing/"
statCmd="/usr/bin/stat"
ModemConfig="/etc/config/modem"
SysConfig="/etc/config/sysconfig"
#validreceiverflag = 0 
ReadConfig()
{
  interface=$1
  echo "interface=$interface"
  
  #if [ $interface = "CWAN1_0 show" ]
  #then
      #interface="CWAN1_0"
  #fi
  config_load "$ModemConfig"
 # echo "Modem config loaded"
 
  #config_get SMSDeviceid "$interface" smsdeviceid
  SMSDeviceid=$(uci get modem.$interface.smsdeviceid)
  echo "SMSDeviceid=$SMSDeviceid"
  config_get SMSApikey "$interface" smsapikey
  config_get SmsResponseSenderEnable "$interface" smsresponsesenderenable
  config_get SmsResponseServerEnable "$interface" smsresponseserverenable
  config_get SmsServerNumber1 "$interface" smsservernumber1
  config_get SmsServerNumber2 "$interface" smsservernumber2
  config_get SmsServerNumber3 "$interface" smsservernumber3
  config_get SmsServerNumber4 "$interface" smsservernumber4
  config_get SmsServerNumber5 "$interface" smsservernumber5
  config_get SmsDeviceId "$interface" smsdeviceid
  
 config_load "$SysConfig"
 config_get validsmsreceivernumbers sysconfig validsmsreceivernumbers 
 config_get debugpassword sysconfig debugpassword
 config_get enabledebugsms sysconfig enabledebugsms
}


if [ "$SMSEventType" = "RECEIVED" ]
then
        #validflag = 0
        # Parse Sender Number & message(which contains actual command)
        Sender=$(awk 'BEGIN {IGNORECASE = 1}/From:[[:blank:]]*/{print $2}' "$IncomingSMSFile")
        Modem=$(grep -i "modem" "$IncomingSMSFile" | head -1 | awk '{print $2}')
        InMsg=$(sed '1,/^$/d' "$IncomingSMSFile")
 
        echo "Modem=$Modem"
        ReadConfig "$Modem"
       # ReadConfig "${$Modem:0:-2}"
  
       echo "*** Message received successfully from $Sender ***"
       msgbrasesremoved=$(echo $InMsg | awk -F '[{}]' '{print $2}')
       deviceid=$(echo "$msgbrasesremoved" | awk -F '[][]' '{print $2}' | cut -d ',' -f 1)
       securekey=$(echo "$msgbrasesremoved" | awk -F '[][]' '{print $2}' | cut -d ',' -f 2)
       command=$(echo "$msgbrasesremoved" | awk -F ',' '{print $3}' | cut -d ':' -f 2)
       argument=$(echo "$msgbrasesremoved" | awk -F ',' '{print $4}' | cut -d ':' -f 2)

       deviceid=$(echo "$deviceid" | tr -d '"')
       securekey=$(echo "$securekey" | tr -d '"')
       command=$(echo "$command" | tr -d '"')
       argument=$(echo "$argument" | tr -d '"')
       
      # echo "validreceiverflag before : $validflag"
		SMSDeviceid=$(uci get system.system.hostname)
		SMSApikey=$(uci get sysconfig.smsconfig.smsapikey)
       if [ "$SMSDeviceid" = "$deviceid" ] && [ "$SMSApikey" = "$securekey" ]
       then
         if [ "$command" = "reboot" ] && [ "$argument" = "hardware" ]
         then
             #if [ "$SmsResponseSenderEnable" = "1" ]
             #then
               #/usr/bin/sendsms "+$Sender" "Reboot message recieved"
             #fi
             if [ "$SmsResponseServerEnable" = "1" ]
             then
				if [ "$validsmsreceivernumbers" -ge 1 ]
                then
					if [ "$SmsServerNumber1" = "$Sender" ]
					then
                        echo "SMS received from valid sender 1"
                        /usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid Reboot message recieved"
                    fi
	              
	            fi
	            if [ "$validsmsreceivernumbers" -ge 2 ]
                then
					if [ "$SmsServerNumber2" = "$Sender" ] || [ "$SmsServerNumber1" = "$Sender" ]
					then 
			             /usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid Reboot message recieved"
				     /usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid Reboot message recieved"
	               fi
                fi
               if [ "$validsmsreceivernumbers" -ge 3 ]
               then
	               if [ "$SmsServerNumber1" = "$Sender" ] || [ "$SmsServerNumber2" = "$Sender" ] || [ "$SmsServerNumber3" = "$Sender" ]
				   then 
						/usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid Reboot message recieved"
						/usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid Reboot message recieved"
						/usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid Reboot message recieved"
				   fi		
               fi
               if [ "$validsmsreceivernumbers" -ge 4 ]
               then
	               if [ "$SmsServerNumber4" = "$Sender" ] ||  [ "$SmsServerNumber3" = "$Sender" ] ||  [ "$SmsServerNumber2" = "$Sender" ] ||  [ "$SmsServerNumber1" = "$Sender" ]
				   then 
		               /usr/bin/sendsms "+$SmsServerNumber4" "$SMSDeviceid Reboot message recieved"
			       /usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid Reboot message recieved"
			       /usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid Reboot message recieved"
			       /usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid Reboot message recieved"
	               fi
	           fi
	           if [ "$validsmsreceivernumbers" -ge 5 ]
               then
	               if [ "$SmsServerNumber5" = "$Sender" ] || [ "$SmsServerNumber4" = "$Sender" ] ||  [ "$SmsServerNumber3" = "$Sender" ] ||  [ "$SmsServerNumber2" = "$Sender" ] ||  [ "$SmsServerNumber1" = "$Sender" ]
				   then     
		                /usr/bin/sendsms "+$SmsServerNumber5" "$SMSDeviceid Reboot message recieved"
				/usr/bin/sendsms "+$SmsServerNumber4" "$SMSDeviceid Reboot message recieved"
				/usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid Reboot message recieved"
				/usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid Reboot message recieved"
				/usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid Reboot message recieved"
	               fi
	           fi    
             fi
            sleep 50
             /root/usrRPC/script/Board_Recycle_12V_Script.sh
         elif [ "$command" = "uptime" ]
         then
              systemuptime=$(uptime | cut -d "," -f 1)
             #if [ "$SmsResponseSenderEnable" = "1" ]
             #then
               #/usr/bin/sendsms "+$Sender" "$systemuptime"
             #fi
             echo "SmsResponseServerEnable=$SmsResponseServerEnable"
             echo "validsmsreceivernumbers=$validsmsreceivernumbers"
             if [ "$SmsResponseServerEnable" = "1" ]
             then
                 if [ "$validsmsreceivernumbers" -ge 1 ]
                 then
	               if [ "$SmsServerNumber1" = "$Sender" ]
				   then 
		                /usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $systemuptime"
	                fi
	             fi   
                if [ "$validsmsreceivernumbers" -ge 2 ]
                then
	                if [ "$SmsServerNumber2" = "$Sender" ] || [ "$SmsServerNumber1" = "$Sender" ]
				    then 
		                /usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $systemuptime"
	                fi
	            fi    
	            if [ "$validsmsreceivernumbers" -ge 3 ]
	            then
		             if [ "$SmsServerNumber3" = "$Sender" ] || [ "$SmsServerNumber2" = "$Sender" ] ||  [ "$SmsServerNumber1" = "$Sender" ]
				    then 
		                /usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $systemuptime"
		             fi   
	            fi    
	            if [ "$validsmsreceivernumbers" -ge 4 ] 
	            then 
		            if [ "$SmsServerNumber4" = "$Sender" ] || [ "$SmsServerNumber3" = "$Sender" ] ||  [ "$SmsServerNumber2" = "$Sender" ] ||  [ "$SmsServerNumber1" = "$Sender" ]
				    then  
		                /usr/bin/sendsms "+$SmsServerNumber4" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $systemuptime"
	                fi
	            fi    
	            if  [ "$validsmsreceivernumbers" -ge 5 ]  
	            then
		             if [ "$SmsServerNumber5" = "$Sender" ] || [ "$SmsServerNumber4" = "$Sender" ] ||  [ "$SmsServerNumber3" = "$Sender" ] ||  [ "$SmsServerNumber2" = "$Sender" ] ||  [ "$SmsServerNumber1" = "$Sender" ]
				     then 
		                /usr/bin/sendsms "+$SmsServerNumber5" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber4" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid $systemuptime"
				/usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $systemuptime"
		             fi   
                fi
             fi 
             
         elif [ "$command" = "enabledebugsms" ] && [ "$argument" = "$debugpassword" ]
         then         
               /sbin/uci set sysconfig.smsconfig.enabledebugsms=1
               /sbin/uci commit sysconfig 
             
             if [ "$SmsResponseServerEnable" = "1" ]
             then
                  /usr/bin/sendsms "+$Sender" "Debug SMS Enabled"
             fi
        elif [ "$command" = "disabledebugsms" ] && [ "$argument" = "$debugpassword" ]
         then         
               /sbin/uci set sysconfig.smsconfig.enabledebugsms=0
               /sbin/uci commit sysconfig 
             
             if [ "$SmsResponseServerEnable" = "1" ]
             then
                  /usr/bin/sendsms "+$Sender" "Debug SMS Disabled"
             fi      
         elif  [ "$command" = "uciset" ]
         then
              if [ $enabledebugsms = '1' ]
              then
	               /sbin/$argument
	               /usr/bin/sendsms "+$Sender" "Success : $argument"
              else
	               /usr/bin/sendsms "+$Sender" "Please enable SMS debug"
	          fi      
               
         elif [ "$command" = "ucicommit" ]
         then
            if [ $enabledebugsms = '1' ]
            then
	               /sbin/$argument
	               /usr/bin/sendsms "+$Sender" "Success : $argument"
            else
	               /usr/bin/sendsms "+$Sender" "Please enable SMS debug"
	        fi  
	             
         elif [ "$command" = "uciget" ]
         then
              if [ $enabledebugsms = '1' ]
              then
	              output=$(/sbin/$argument)                      
	              /usr/bin/sendsms "+$Sender" "$output"
               else
	               /usr/bin/sendsms "+$Sender" "Please enable SMS debug"
	          fi
	    elif [ "$command" = "ucishow" ]
         then       
	          if [ $enabledebugsms = '1' ]
              then
	              output=$(/sbin/$argument)                      
	              /usr/bin/sendsms "+$Sender" "${output}"
              else
	               /usr/bin/sendsms "+$Sender" "Please enable SMS debug"
	          fi
	    elif [ "$command" = "runscript" ]
         then       
	          if [ $enabledebugsms = '1' ]
              then
	              output=$($argument 2>&1)                      
	              /usr/bin/sendsms "+$Sender" "$output"
               else
	               /usr/bin/sendsms "+$Sender" "Please enable SMS debug"
	          fi                  
                
         elif [ "$command" = "gettime" ] && [ "$argument" = "system" ]
         then
            systemtime=$(date)
             #if [ "$SmsResponseSenderEnable" = "1" ]
             #then
               #/usr/bin/sendsms "+$Sender" "$systemtime"
             #fi
             if [ "$SmsResponseServerEnable" = "1" ]
             then
	             if [ "$validsmsreceivernumbers" -ge 1 ]
	             then
		            if [ "$SmsServerNumber1" = "$Sender" ]
				    then 
		               /usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $systemtime"
		            fi   
	             fi
	             if [ "$validsmsreceivernumbers" -ge 2 ]
                 then  
                    if [ "$SmsServerNumber2" = "$Sender" ]
				    then 
		               /usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid $systemtime"
		            fi   
	             fi
	             if [ "$validsmsreceivernumbers" -ge 3 ]
                 then 
                    if [ "$SmsServerNumber3" = "$Sender" ]
				    then  
		               /usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid $systemtime"
	               fi
	             fi
	             if [ "$validsmsreceivernumbers" -ge 4 ]
                 then 
                    if [ "$SmsServerNumber4" = "$Sender" ]
				    then  
		               /usr/bin/sendsms "+$SmsServerNumber4" "$SMSDeviceid $systemtime"
		            fi   
	             fi
	             if [ "$validsmsreceivernumbers" -ge 5 ]
                 then 
                   if [ "$SmsServerNumber5" = "$Sender" ]
				   then  
			           /usr/bin/sendsms "+$SmsServerNumber5" "$SMSDeviceid $systemtime"
			       fi     
	            fi  
             fi
        elif [ "$command" = "gettime" ] && [ "$argument" = "hardware" ]
         then
             hardwaretime=$(hwclock)
             #if [ "$SmsResponseSenderEnable" = "1" ]
             #then
               #/usr/bin/sendsms "+$Sender" "$hardwaretime"
             #fi
             if [ "$SmsResponseServerEnable" = "1" ]
             then
	             if [ "$validsmsreceivernumbers" -ge 1 ]
                 then
					if [ "$SmsServerNumber1" = "$Sender" ]
					then
                        echo "SMS received from valid sender 1"
                        /usr/bin/sendsms "+$SmsServerNumber1" "$SMSDeviceid $hardwaretime"
                    fi
	             fi
	             if [ "$validsmsreceivernumbers" -ge 2 ]
                 then 
					if [ "$SmsServerNumber2" = "$Sender" ]
					then
                        echo "SMS received from valid sender 2"                       
                        /usr/bin/sendsms "+$SmsServerNumber2" "$SMSDeviceid $hardwaretime"
                    fi	              
	             fi
	             if [ "$validsmsreceivernumbers" -ge 3 ]
                 then 
					echo "Sender=$Sender"
					if [ "$SmsServerNumber3" = "$Sender" ]
					then
                        echo "SMS received from valid sender 3"
                        /usr/bin/sendsms "+$SmsServerNumber3" "$SMSDeviceid $hardwaretime"
                    fi  
	               #/usr/bin/sendsms "+$SmsServerNumber3" "$SmsDeviceId $hardwaretime"
	             fi
	             if [ "$validsmsreceivernumbers" -ge 4 ]
                 then  
					if [ "$SmsServerNumber4" = "$Sender" ]
					then
                        echo "SMS received from valid sender 4"                        
                        /usr/bin/sendsms "+$SmsServerNumber4" "$SMSDeviceid $hardwaretime"
                    fi  
	               #/usr/bin/sendsms "+$SmsServerNumber4" "$SmsDeviceId $hardwaretime"
                 fi
                 else [ "$validsmsreceivernumbers" -ge 5 ]
					if [ "$SmsServerNumber5" = "$Sender" ]
					then
                        echo "SMS received from valid sender 5"
                       
                        /usr/bin/sendsms "+$SmsServerNumber5" "$SMSDeviceid $hardwaretime"
                    fi  
                   #/usr/bin/sendsms "+$SmsServerNumber5" "$SmsDeviceId $hardwaretime"
	             fi 
	             #echo "validreceiverflag=$validreceiverflag" 
             fi
             
         else
              
		           echo "invalid command or key"
	         
         fi
       #fi
elif [ "$SMSEventType" = "SENT" ]
then
        # Delete sent messages
        RemoveFiles "$SentSMSDir" "$MaxSentSMS"
        echo "*** Message sent successfully ***"
elif [ "$SMSEventType" = "FAILED" ]
then
        # Delete failed messages
        RemoveFiles "$FailedSMSDir" "$MaxFailedSMS"
        echo "*** Message send failure ***"
else
        echo "*** No actions for event $SMSEventType ***"
fi

exit 0
