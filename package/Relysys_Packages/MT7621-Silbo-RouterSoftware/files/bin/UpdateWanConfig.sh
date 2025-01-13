#!/bin/sh
. /lib/functions.sh

sysconfigUCIPath="/etc/config/sysconfig"
sysconfigsection="sysconfig"
wificonfigsection="wificonfig"
loopbackconfigsection="loopbackip"
validatescript="/bin/validate.sh"
wanstatusupdatescript="/bin/mwan3statusupdate.sh"
cellulardatausagemanagerscript="/bin/cellulardatausagemanagerscript.sh"

wanconfigname6="CWAN1"
wanconfigname7="CWAN2"
wanconfigname8="CWAN1_0"
wanconfigname9="CWAN1_1"
wan6configname10="wan6c1"
wan6configname11="wan6c2"

wanconfigname12="WIFI_WAN"

WIFI_WANtrackIp1=0
WIFI_WANtrackIp2=0
WIFI_WANtrackIp3=0
WIFI_WANtrackIp4=0

ReadOldPriority()
{
  config=$1
  config_get WanPriority "$config" wanpriority
  config_get WanWeight "$config" wanweight
  config_get track_method_failover "$config" track_method
  config_get enabled "$config" enabled
  config_get trackIp1 "$config" trackIp1
  config_get trackIp2 "$config" trackIp2
  config_get trackIp3 "$config" trackIp3
  config_get trackIp4 "$config" trackIp4
  config_get reliability "$config" reliability
  config_get count "$config" count
  config_get up "$config" up
  config_get down "$config" down
  config_get validtrackip "$config" validtrackip
  config_get flush_conntrack "$config" flush_conntrack
  config_get initial_state "$config" initial_state
 
  case "$config" in
   "WIFI_WAN") 
					 WIFI_WANpriority=$WanPriority
					 WIFI_WANweight=$WanWeight
					 WIFI_WANenabled=$enabled
					 WIFI_WANtrackmethod_failover=$track_method_failover
					 WIFI_WANvalidtrackip=$validtrackip
					 
					 if [ $WIFI_WANvalidtrackip = "1" ]
					 then
						WIFI_WANtrackIp1=$trackIp1
					 fi
					 if [ $WIFI_WANvalidtrackip = "2" ]
					 then
						WIFI_WANtrackIp1=$trackIp1
						WIFI_WANtrackIp2=$trackIp2
					 fi
					 if [ $WIFI_WANvalidtrackip = "3" ]
					 then
						WIFI_WANtrackIp1=$trackIp1
						WIFI_WANtrackIp2=$trackIp2
						WIFI_WANtrackIp3=$trackIp3
					 fi
					 if [ $WIFI_WANvalidtrackip = "4" ]
					 then
						 WIFI_WANtrackIp1=$trackIp1
						 WIFI_WANtrackIp2=$trackIp2
						 WIFI_WANtrackIp3=$trackIp3
						 WIFI_WANtrackIp4=$trackIp4
					 fi
					 
					 WIFI_WANup=$up
					 WIFI_WANdown=$down
					 WIFI_WANreliability=$reliability
					 WIFI_WANcount=$count
					 WIFI_WANtimeout= "2"
					 WIFI_WANflush_conntrack= "$flush_conntrack"
					 WIFI_WANinitial_state= "$initial_state"
					;;
					
   "CWAN1") 
					CWAN1priority=$WanPriority
					CWAN1weight=$WanWeight
					CWAN1enabled=$enabled
					CWAN1trackmethod_failover=$track_method_failover
					CWAN1validtrackip=$validtrackip
					
					if [ $CWAN1validtrackip = "1" ]
					then
						CWAN1trackIp1=$trackIp1
					fi
					if [ $CWAN1validtrackip = "2" ]
					then
						CWAN1trackIp1=$trackIp1
						CWAN1trackIp2=$trackIp2
					fi
					if [ $CWAN1validtrackip = "3" ]
					then
						CWAN1trackIp1=$trackIp1
						CWAN1trackIp2=$trackIp2
						CWAN1trackIp3=$trackIp3
					fi
					if [ $CWAN1validtrackip = "4" ]
					then
						CWAN1trackIp1=$trackIp1
						CWAN1trackIp2=$trackIp2
						CWAN1trackIp3=$trackIp3
						CWAN1trackIp4=$trackIp4
					fi
					
						CWAN1up=$up
						CWAN1down=$down
						CWAN1reliability=$reliability
						CWAN1count=$count
						CWAN1timeout="2"
						CWAN1flush_conntrack="$flush_conntrack"
					;;
					
   "CWAN2") 
					CWAN2priority=$WanPriority
					CWAN2weight=$WanWeight
					CWAN2enabled=$enabled
					CWAN2trackmethod_failover=$track_method_failover
					CWAN2validtrackip=$validtrackip
					
					if [ $CWAN2validtrackip = "1" ]
					then
						CWAN2trackIp1=$trackIp1
					fi
					if [ $CWAN2validtrackip = "2" ]
					then
						CWAN2trackIp1=$trackIp1
						CWAN2trackIp2=$trackIp2
					fi
					if [ $CWAN2validtrackip = "3" ]
					then
						CWAN2trackIp1=$trackIp1
						CWAN2trackIp2=$trackIp2
						CWAN2trackIp3=$trackIp3
					fi
					if [ $CWAN2validtrackip = "4" ]
					then
						CWAN2trackIp1=$trackIp1
						CWAN2trackIp2=$trackIp2
						CWAN2trackIp3=$trackIp3
						CWAN2trackIp4=$trackIp4
					fi
					
						CWAN2up=$up
						CWAN2down=$down
						CWAN2reliability=$reliability
						CWAN2count=$count
						CWAN2timeout="2"
						CWAN2flush_conntrack="$flush_conntrack"
					;;
					
   "CWAN1_0") 
					CWAN1_0priority=$WanPriority
					CWAN1_0weight=$WanWeight
					CWAN1_0enabled=$enabled
					CWAN1_0trackmethod_failover=$track_method_failover
					CWAN1_0validtrackip=$validtrackip
					
					if [ $CWAN1_0validtrackip = "1" ]
					then
						CWAN1_0trackIp1=$trackIp1
					fi
					if [ $CWAN1_0validtrackip = "2" ]
					then
						CWAN1_0trackIp1=$trackIp1
						CWAN1_0trackIp2=$trackIp2
					fi
					if [ $CWAN1_0validtrackip = "3" ]
					then
						CWAN1_0trackIp1=$trackIp1
						CWAN1_0trackIp2=$trackIp2
						CWAN1_0trackIp3=$trackIp3
					fi
					if [ $CWAN1_0validtrackip = "4" ]
					then
						CWAN1_0trackIp1=$trackIp1
						CWAN1_0trackIp2=$trackIp2
						CWAN1_0trackIp3=$trackIp3
						CWAN1_0trackIp4=$trackIp4
					fi
					
						CWAN1_0up=$up
						CWAN1_0down=$down
						CWAN1_0reliability=$reliability
						CWAN1_0count=$count
						CWAN1_0timeout="2"
						CWAN1_0flush_conntrack="$flush_conntrack"
					;;
					
   "CWAN1_1") 
					CWAN1_1priority=$WanPriority
					CWAN1_1weight=$WanWeight
					CWAN1_1enabled=$enabled
					CWAN1_1trackmethod_failover=$track_method_failover
					CWAN1_1validtrackip=$validtrackip
					
					if [ $CWAN1_1validtrackip = "1" ]
					then
						CWAN1_1trackIp1=$trackIp1
					fi
					if [ $CWAN1_1validtrackip = "2" ]
					then
						CWAN1_1trackIp1=$trackIp1
						CWAN1_1trackIp2=$trackIp2
					fi
					if [ $CWAN1_1validtrackip = "3" ]
					then
						CWAN1_1trackIp1=$trackIp1
						CWAN1_1trackIp2=$trackIp2
						CWAN1_1trackIp3=$trackIp3
					fi
					if [ $CWAN1_1validtrackip = "4" ]
					then
						CWAN1_1trackIp1=$trackIp1
						CWAN1_1trackIp2=$trackIp2
						CWAN1_1trackIp3=$trackIp3
						CWAN1_1trackIp4=$trackIp4
					fi
					
						CWAN1_1up=$up
						CWAN1_1down=$down
						CWAN1_1reliability=$reliability
						CWAN1_1count=$count
						CWAN1_1timeout="2"
						CWAN1_1flush_conntrack="$flush_conntrack"
					;;

   "wan6c1")		         
					CWAN1V6priority=$WanPriority
					CWAN1V6weight=$WanWeight
					CWAN1V6enabled=$enabled
                    CWAN1V6trackmethod_failover=$track_method_failover		
					CWAN1V6validtrackip=$validtrackip
							
					if [ $CWAN1V6validtrackip = "1" ]
					then
						CWAN1V6trackIp1=$trackIp1
					fi
					if [ $CWAN1V6validtrackip = "2" ]
					then
						CWAN1V6trackIp1=$trackIp1
						CWAN1V6trackIp2=$trackIp2
					fi
					if [ $CWAN1V6validtrackip = "3" ]
					then
						CWAN1V6trackIp1=$trackIp1
						CWAN1V6trackIp2=$trackIp2
						CWAN1V6trackIp3=$trackIp3
					fi
					if [ $CWAN1V6validtrackip = "4" ]
					then
						CWAN1V6trackIp1=$trackIp1
						CWAN1V6trackIp2=$trackIp2
						CWAN1V6trackIp3=$trackIp3
						CWAN1V6trackIp4=$trackIp4
					fi
						CWAN1V6up=$up
						CWAN1V6down=$down
						CWAN1V6reliability=$reliability
						CWAN1V6count=$count
						CWAN1V6timeout="4"	
						CWAN1V6flush_conntrack="$flush_conntrack"	
					;;

   "wan6c2")		         
					CWAN2V6priority=$WanPriority
					CWAN2V6weight=$WanWeight
					CWAN2V6enabled=$enabled
					CWAN2V6trackmethod_failover=$track_method_failover
					CWAN2V6validtrackip=$validtrackip
							
					if [ $CWAN2V6validtrackip = "1" ]
					then
						CWAN2V6trackIp1=$trackIp1
					fi
					if [ $CWAN2V6validtrackip = "2" ]
					then
						CWAN2V6trackIp1=$trackIp1
						CWAN2V6trackIp2=$trackIp2
					fi
					if [ $CWAN2V6validtrackip = "3" ]
					then
						CWAN2V6trackIp1=$trackIp1
						CWAN2V6trackIp2=$trackIp2
						CWAN2V6trackIp3=$trackIp3
					fi
					if [ $CWAN2V6validtrackip = "4" ]
					then
						CWAN2V6trackIp1=$trackIp1
						CWAN2V6trackIp2=$trackIp2
						CWAN2V6trackIp3=$trackIp3
						CWAN2V6trackIp4=$trackIp4
					fi
						CWAN2V6up=$up
						CWAN2V6down=$down
						CWAN2V6reliability=$reliability
						CWAN2V6count=$count
						CWAN2V6timeout="4"	
						CWAN2V6flush_conntrack="$flush_conntrack"	
					;;
					
esac
}

SetPriority()
{

	if [ "$enablecellular" = "1" ]
	then
		#dualcellularsinglesim
		if [ "$CellularOperationMode" = "dualcellularsinglesim" ]
		then
			if [ "$PDP1" = "1" ] || [ "$PDP1" = "3" ]
			then
		
				#1st modem
				uci set mwan3config."$wanconfigname6"=redirect
				uci set mwan3config.$wanconfigname6.name=$wanconfigname6
			    uci set mwan3config.$wanconfigname6.track_method=$CWAN1trackmethod_failover
				
				if [ -n "$CWAN1priority" ]
				then
										
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname6.wanpriority="1"
						uci set mwan3config.$wanconfigname6.wanweight=$CWAN1weight
					else
						uci set mwan3config.$wanconfigname6.wanpriority=$CWAN1priority
					fi
					
					uci set mwan3config.$wanconfigname6.enabled=$CWAN1enabled
					
					uci set mwan3config.$wanconfigname6.validtrackip=$CWAN1validtrackip
					if [ "$CWAN1validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
					fi
					if [ "$CWAN1validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
						uci set mwan3config.$wanconfigname6.trackIp2="$CWAN1trackIp2"
					fi
					if [ "$CWAN1validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
						uci set mwan3config.$wanconfigname6.trackIp2="$CWAN1trackIp2"
						uci set mwan3config.$wanconfigname6.trackIp3="$CWAN1trackIp3"
					fi
					if [ "$CWAN1validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
						uci set mwan3config.$wanconfigname6.trackIp2="$CWAN1trackIp2"
						uci set mwan3config.$wanconfigname6.trackIp3="$CWAN1trackIp3"
						uci set mwan3config.$wanconfigname6.trackIp4="$CWAN1trackIp4"
					fi
					
					uci set mwan3config.$wanconfigname6.reliability="$CWAN1reliability"
					uci set mwan3config.$wanconfigname6.count="$CWAN1count"
					uci set mwan3config.$wanconfigname6.timeout="2"
					uci set mwan3config.$wanconfigname6.up="$CWAN1up"
					uci set mwan3config.$wanconfigname6.down="$CWAN1down"
					uci set mwan3config.$wanconfigname6.flush_conntrack="$CWAN1flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname6.wanpriority=1
					else
						uci set mwan3config.$wanconfigname6.wanpriority=6
					fi
					uci set mwan3config.$wanconfigname6.track_method="ping"
					uci set mwan3config.$wanconfigname6.validtrackip=2
					uci set mwan3config.$wanconfigname6.enabled=1
					uci set mwan3config.$wanconfigname6.trackIp1=8.8.8.8
					uci set mwan3config.$wanconfigname6.trackIp2=8.8.4.4
					uci set mwan3config.$wanconfigname6.reliability=1
					uci set mwan3config.$wanconfigname6.count=1
					uci set mwan3config.$wanconfigname6.timeout=2
					uci set mwan3config.$wanconfigname6.up=3
					uci set mwan3config.$wanconfigname6.down=3
					uci set mwan3config.$wanconfigname6.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
			if [ "$PDP1" = "2" ]  
			then
				uci set mwan3config."$wan6configname10"=redirect
				uci set mwan3config.$wan6configname10.name=$wan6configname10
			    uci set mwan3config.$wan6configname10.track_method=$CWAN1V6trackmethod_failover
				
				if [ -n "$CWAN1V6priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname10.wanpriority="1"
						uci set mwan3config.$wan6configname10.wanweight=$CWAN1V6weight
					else
						uci set mwan3config.$wan6configname10.wanpriority=$CWAN1V6priority
					fi
					
					uci set mwan3config.$wan6configname10.enabled=$CWAN1V6enabled
					
					uci set mwan3config.$wan6configname10.validtrackip=$CWAN1V6validtrackip
					if [ "$CWAN1V6validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
					fi
					if [ "$CWAN1V6validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
					fi
					if [ "$CWAN1V6validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
						uci set mwan3config.$wan6configname10.trackIp3="$CWAN1V6trackIp3"
					fi
					if [ "$CWAN1V6validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
						uci set mwan3config.$wan6configname10.trackIp3="$CWAN1V6trackIp3"
						uci set mwan3config.$wan6configname10.trackIp4="$CWAN1V6trackIp4"
					fi
					
					uci set mwan3config.$wan6configname10.reliability="$CWAN1V6reliability"
					uci set mwan3config.$wan6configname10.count="$CWAN1V6count"
					uci set mwan3config.$wan6configname10.timeout="4"
					uci set mwan3config.$wan6configname10.up="$CWAN1V6up"
					uci set mwan3config.$wan6configname10.down="$CWAN1V6down"
					uci set mwan3config.$wan6configname10.flush_conntrack="$CWAN1V6flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname10.wanpriority=1
					else
						uci set mwan3config.$wan6configname10.wanpriority=6
					fi
					uci set mwan3config.$wan6configname10.track_method="ping"
					uci set mwan3config.$wan6configname10.validtrackip=2
					uci set mwan3config.$wan6configname10.enabled=1
					uci set mwan3config.$wan6configname10.trackIp1=2001:4860:4860::8888
					uci set mwan3config.$wan6configname10.trackIp2=2001:4860:4860::8844
					uci set mwan3config.$wan6configname10.reliability=1
					uci set mwan3config.$wan6configname10.count=3
					uci set mwan3config.$wan6configname10.timeout=4
					uci set mwan3config.$wan6configname10.up=3
					uci set mwan3config.$wan6configname10.down=3
					uci set mwan3config.$wan6configname10.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
			if [ "$PDP2" = "1" ] || [ "$PDP2" = "3" ] 
			then
					
				#2nd modem
				uci set mwan3config."$wanconfigname7"=redirect
				uci set mwan3config.$wanconfigname7.name=$wanconfigname7
        	    uci set mwan3config.$wanconfigname7.track_method=$CWAN2trackmethod_failover
				
				if [ -n "$CWAN2priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname7.wanpriority="1"
						uci set mwan3config.$wanconfigname7.wanweight=$CWAN2weight
					else
						uci set mwan3config.$wanconfigname7.wanpriority=$CWAN2priority
					fi
					
					uci set mwan3config.$wanconfigname7.enabled=$CWAN2enabled
					
					uci set mwan3config.$wanconfigname7.validtrackip=$CWAN2validtrackip
					if [ "$CWAN2validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wanconfigname7.trackIp1="$CWAN2trackIp1"
					fi
					if [ "$CWAN2validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wanconfigname7.trackIp1="$CWAN2trackIp1"
						uci set mwan3config.$wanconfigname7.trackIp2="$CWAN2trackIp2"
					fi
					if [ "$CWAN2validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wanconfigname7.trackIp1="$CWAN2trackIp1"
						uci set mwan3config.$wanconfigname7.trackIp2="$CWAN2trackIp2"
						uci set mwan3config.$wanconfigname7.trackIp3="$CWAN2trackIp3"
					fi
					if [ "$CWAN2validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wanconfigname7.trackIp1="$CWAN2trackIp1"
						uci set mwan3config.$wanconfigname7.trackIp2="$CWAN2trackIp2"
						uci set mwan3config.$wanconfigname7.trackIp3="$CWAN2trackIp3"
						uci set mwan3config.$wanconfigname7.trackIp4="$CWAN2trackIp4"
					fi
					
					uci set mwan3config.$wanconfigname7.reliability="$CWAN2reliability"
					uci set mwan3config.$wanconfigname7.count="$CWAN2count"
					uci set mwan3config.$wanconfigname7.timeout="2"
					uci set mwan3config.$wanconfigname7.up="$CWAN2up"
					uci set mwan3config.$wanconfigname7.down="$CWAN2down"
					uci set mwan3config.$wanconfigname7.flush_conntrack="$CWAN2flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname7.wanpriority=1
					else
						uci set mwan3config.$wanconfigname7.wanpriority=7
					fi
					uci set mwan3config.$wanconfigname7.track_method="ping"
					uci set mwan3config.$wanconfigname7.validtrackip=2
					uci set mwan3config.$wanconfigname7.enabled=1
					uci set mwan3config.$wanconfigname7.trackIp1=8.8.8.8
					uci set mwan3config.$wanconfigname7.trackIp2=8.8.4.4
					uci set mwan3config.$wanconfigname7.reliability=1
					uci set mwan3config.$wanconfigname7.count=1
					uci set mwan3config.$wanconfigname7.timeout=2
					uci set mwan3config.$wanconfigname7.up=3
					uci set mwan3config.$wanconfigname7.down=3
					uci set mwan3config.$wanconfigname7.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
			if [ "$PDP2" = "2" ] 
			then
				uci set mwan3config."$wan6configname11"=redirect
				uci set mwan3config.$wan6configname11.name=$wan6configname11
   			    uci set mwan3config.$wan6configname11.track_method=$CWAN2V6trackmethod_failover
				
				if [ -n "$CWAN2V6priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname11.wanpriority="1"
						uci set mwan3config.$wan6configname11.wanweight=$CWAN2V6weight
					else
						uci set mwan3config.$wan6configname11.wanpriority=$CWAN2V6priority
					fi
					
					uci set mwan3config.$wan6configname11.enabled=$CWAN2V6enabled
					
					uci set mwan3config.$wan6configname11.validtrackip=$CWAN2V6validtrackip
					if [ "$CWAN2V6validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
					fi
					if [ "$CWAN2V6validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
						uci set mwan3config.$wan6configname11.trackIp2="$CWAN2V6trackIp2"
					fi
					if [ "$CWAN2V6validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
						uci set mwan3config.$wan6configname11.trackIp2="$CWAN2V6trackIp2"
						uci set mwan3config.$wan6configname11.trackIp3="$CWAN2V6trackIp3"
					fi
					if [ "$CWAN2V6validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
						uci set mwan3config.$wan6configname11.trackIp2="$CWAN2V6trackIp2"
						uci set mwan3config.$wan6configname11.trackIp3="$CWAN2V6trackIp3"
						uci set mwan3config.$wan6configname11.trackIp4="$CWAN2V6trackIp4"
					fi
					
					uci set mwan3config.$wan6configname11.reliability="$CWAN2V6reliability"
					uci set mwan3config.$wan6configname11.count="$CWAN2V6count"
					uci set mwan3config.$wan6configname11.timeout="4"
					uci set mwan3config.$wan6configname11.up="$CWAN2V6up"
					uci set mwan3config.$wan6configname11.down="$CWAN2V6down"
					uci set mwan3config.$wan6configname11.flush_conntrack="$CWAN2V6flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname11.wanpriority=1
					else
						uci set mwan3config.$wan6configname11.wanpriority=7
					fi
					uci set mwan3config.$wan6configname11.track_method="ping"
					uci set mwan3config.$wan6configname11.validtrackip=2
					uci set mwan3config.$wan6configname11.enabled=1
					uci set mwan3config.$wan6configname11.trackIp1=2001:4860:4860::8888
					uci set mwan3config.$wan6configname11.trackIp2=2001:4860:4860::8844
					uci set mwan3config.$wan6configname11.reliability=1
					uci set mwan3config.$wan6configname11.count=3
					uci set mwan3config.$wan6configname11.timeout=4
					uci set mwan3config.$wan6configname11.up=3
					uci set mwan3config.$wan6configname11.down=3
					uci set mwan3config.$wan6configname11.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
		fi
		
		#singlecellulardualsim
		if [ "$CellularOperationMode" = "singlecellulardualsim" ]
		then
			#1st sim
			if [ "$PDP1" = "1" ] || [ "$PDP1" = "3" ]
			then
				uci set mwan3config."$wanconfigname8"=redirect
				uci set mwan3config.$wanconfigname8.name=$wanconfigname8
   			    uci set mwan3config.$wanconfigname8.track_method=$CWAN1_0trackmethod_failover
				
				if [ -n "$CWAN1_0priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname8.wanpriority="1"
						uci set mwan3config.$wanconfigname8.wanweight=$CWAN1_0weight
					else
						uci set mwan3config.$wanconfigname8.wanpriority=$CWAN1_0priority
					fi
					
					uci set mwan3config.$wanconfigname8.enabled=$CWAN1_0enabled
					
					uci set mwan3config.$wanconfigname8.validtrackip=$CWAN1_0validtrackip
					if [ "$CWAN1_0validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wanconfigname8.trackIp1="$CWAN1_0trackIp1"
					fi
					if [ "$CWAN1_0validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wanconfigname8.trackIp1="$CWAN1_0trackIp1"
						uci set mwan3config.$wanconfigname8.trackIp2="$CWAN1_0trackIp2"
					fi
					if [ "$CWAN1_0validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wanconfigname8.trackIp1="$CWAN1_0trackIp1"
						uci set mwan3config.$wanconfigname8.trackIp2="$CWAN1_0trackIp2"
						uci set mwan3config.$wanconfigname8.trackIp3="$CWAN1_0trackIp3"
					fi
					if [ "$CWAN1_0validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wanconfigname8.trackIp1="$CWAN1_0trackIp1"
						uci set mwan3config.$wanconfigname8.trackIp2="$CWAN1_0trackIp2"
						uci set mwan3config.$wanconfigname8.trackIp3="$CWAN1_0trackIp3"
						uci set mwan3config.$wanconfigname8.trackIp4="$CWAN1_0trackIp4"
					fi
					
					uci set mwan3config.$wanconfigname8.reliability="$CWAN1_0reliability"
					uci set mwan3config.$wanconfigname8.count="$CWAN1_0count"
					uci set mwan3config.$wanconfigname8.timeout="2"
					uci set mwan3config.$wanconfigname8.up="$CWAN1_0up"
					uci set mwan3config.$wanconfigname8.down="$CWAN1_0down"
					uci set mwan3config.$wanconfigname8.flush_conntrack="$CWAN1_0flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname8.wanpriority=1
					else
						uci set mwan3config.$wanconfigname8.wanpriority=8
					fi
					uci set mwan3config.$wanconfigname8.track_method="ping"
					uci set mwan3config.$wanconfigname8.validtrackip=2
					uci set mwan3config.$wanconfigname8.enabled=1
					uci set mwan3config.$wanconfigname8.trackIp1=8.8.8.8
					uci set mwan3config.$wanconfigname8.trackIp2=8.8.4.4
					uci set mwan3config.$wanconfigname8.reliability=1
					uci set mwan3config.$wanconfigname8.count=1
					uci set mwan3config.$wanconfigname8.timeout=2
					uci set mwan3config.$wanconfigname8.up=3
					uci set mwan3config.$wanconfigname8.down=3
					uci set mwan3config.$wanconfigname8.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			if [ "$PDP1" = "2" ]  
			then
				uci set mwan3config."$wan6configname10"=redirect
				uci set mwan3config.$wan6configname10.name=$wan6configname10
   			    uci set mwan3config.$wan6configname10.track_method=$CWAN1V6trackmethod_failover
				
				if [ -n "$CWAN1V6priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname10.wanpriority="1"
						uci set mwan3config.$wan6configname10.wanweight=$CWAN1V6weight
					else
						uci set mwan3config.$wan6configname10.wanpriority=$CWAN1V6priority
					fi
					
					uci set mwan3config.$wan6configname10.enabled=$CWAN1V6enabled
					
					uci set mwan3config.$wan6configname10.validtrackip=$CWAN1V6validtrackip
					if [ "$CWAN1V6validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
					fi
					if [ "$CWAN1V6validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
					fi
					if [ "$CWAN1V6validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
						uci set mwan3config.$wan6configname10.trackIp3="$CWAN1V6trackIp3"
					fi
					if [ "$CWAN1V6validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
						uci set mwan3config.$wan6configname10.trackIp3="$CWAN1V6trackIp3"
						uci set mwan3config.$wan6configname10.trackIp4="$CWAN1V6trackIp4"
					fi
					
					uci set mwan3config.$wan6configname10.reliability="$CWAN1V6reliability"
					uci set mwan3config.$wan6configname10.count="$CWAN1V6count"
					uci set mwan3config.$wan6configname10.timeout="4"
					uci set mwan3config.$wan6configname10.up="$CWAN1V6up"
					uci set mwan3config.$wan6configname10.down="$CWAN1V6down"
					uci set mwan3config.$wan6configname10.flush_conntrack="$CWAN1V6flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname10.wanpriority=1
					else
						uci set mwan3config.$wan6configname10.wanpriority=8
					fi
					uci set mwan3config.$wan6configname10.track_method="ping"
					uci set mwan3config.$wan6configname10.validtrackip=2
					uci set mwan3config.$wan6configname10.enabled=1
					uci set mwan3config.$wan6configname10.trackIp1=2001:4860:4860::8888
					uci set mwan3config.$wan6configname10.trackIp2=2001:4860:4860::8844
					uci set mwan3config.$wan6configname10.reliability=1
					uci set mwan3config.$wan6configname10.count=3
					uci set mwan3config.$wan6configname10.timeout=4
					uci set mwan3config.$wan6configname10.up=3
					uci set mwan3config.$wan6configname10.down=3
					uci set mwan3config.$wan6configname10.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			
			fi
			
			if [ "$PDP2" = "1" ] || [ "$PDP2" = "3" ] 
			then
				#2nd sim
				uci set mwan3config."$wanconfigname9"=redirect
				uci set mwan3config.$wanconfigname9.name=$wanconfigname9
   			    uci set mwan3config.$wanconfigname9.track_method=$CWAN1_1trackmethod_failover
				
				if [ -n "$CWAN1_1priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname9.wanpriority="1"
						uci set mwan3config.$wanconfigname9.wanweight=$CWAN1_1weight
					else
						uci set mwan3config.$wanconfigname9.wanpriority=$CWAN1_1priority
					fi
					
					uci set mwan3config.$wanconfigname9.enabled=$CWAN1_1enabled
					
					uci set mwan3config.$wanconfigname9.validtrackip=$CWAN1_1validtrackip
					if [ "$CWAN1_1validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wanconfigname9.trackIp1="$CWAN1_1trackIp1"
					fi
					if [ "$CWAN1_1validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wanconfigname9.trackIp1="$CWAN1_1trackIp1"
						uci set mwan3config.$wanconfigname9.trackIp2="$CWAN1_1trackIp2"
					fi
					if [ "$CWAN1_1validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wanconfigname9.trackIp1="$CWAN1_1trackIp1"
						uci set mwan3config.$wanconfigname9.trackIp2="$CWAN1_1trackIp2"
						uci set mwan3config.$wanconfigname9.trackIp3="$CWAN1_1trackIp3"
					fi
					if [ "$CWAN1_1validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wanconfigname9.trackIp1="$CWAN1_1trackIp1"
						uci set mwan3config.$wanconfigname9.trackIp2="$CWAN1_1trackIp2"
						uci set mwan3config.$wanconfigname9.trackIp3="$CWAN1_1trackIp3"
						uci set mwan3config.$wanconfigname9.trackIp4="$CWAN1_1trackIp4"
					fi
					
					uci set mwan3config.$wanconfigname9.reliability="$CWAN1_1reliability"
					uci set mwan3config.$wanconfigname9.count="$CWAN1_1count"
					uci set mwan3config.$wanconfigname9.timeout="2"
					uci set mwan3config.$wanconfigname9.up="$CWAN1_1up"
					uci set mwan3config.$wanconfigname9.down="$CWAN1_1down"
					uci set mwan3config.$wanconfigname9.flush_conntrack="$CWAN1_1flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname9.wanpriority=1
					else
						uci set mwan3config.$wanconfigname9.wanpriority=9
					fi
					uci set mwan3config.$wanconfigname9.track_method="ping"
					uci set mwan3config.$wanconfigname9.validtrackip=2
					uci set mwan3config.$wanconfigname9.enabled=1
					uci set mwan3config.$wanconfigname9.trackIp1=8.8.8.8
					uci set mwan3config.$wanconfigname9.trackIp2=8.8.4.4
					uci set mwan3config.$wanconfigname9.reliability=1
					uci set mwan3config.$wanconfigname9.count=1
					uci set mwan3config.$wanconfigname9.timeout=2
					uci set mwan3config.$wanconfigname9.up=3
					uci set mwan3config.$wanconfigname9.down=3
					uci set mwan3config.$wanconfigname9.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
			if [ "$PDP2" = "2" ] 
			then
				uci set mwan3config."$wan6configname11"=redirect
				uci set mwan3config.$wan6configname11.name=$wan6configname11
				uci set mwan3config.$wan6configname11.track_method=$CWAN2V6trackmethod_failover

				if [ -n "$CWAN2V6priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname11.wanpriority="1"
						uci set mwan3config.$wan6configname11.wanweight=$CWAN2V6weight
					else
						uci set mwan3config.$wan6configname11.wanpriority=$CWAN2V6priority
					fi
					
					uci set mwan3config.$wan6configname11.enabled=$CWAN2V6enabled
					
					uci set mwan3config.$wan6configname11.validtrackip=$CWAN2V6validtrackip
					if [ "$CWAN2V6validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
					fi
					if [ "$CWAN2V6validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
						uci set mwan3config.$wan6configname11.trackIp2="$CWAN2V6trackIp2"
					fi
					if [ "$CWAN2V6validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
						uci set mwan3config.$wan6configname11.trackIp2="$CWAN2V6trackIp2"
						uci set mwan3config.$wan6configname11.trackIp3="$CWAN2V6trackIp3"
					fi
					if [ "$CWAN2V6validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wan6configname11.trackIp1="$CWAN2V6trackIp1"
						uci set mwan3config.$wan6configname11.trackIp2="$CWAN2V6trackIp2"
						uci set mwan3config.$wan6configname11.trackIp3="$CWAN2V6trackIp3"
						uci set mwan3config.$wan6configname11.trackIp4="$CWAN2V6trackIp4"
					fi
					
					uci set mwan3config.$wan6configname11.reliability="$CWAN2V6reliability"
					uci set mwan3config.$wan6configname11.count="$CWAN2V6count"
					uci set mwan3config.$wan6configname11.timeout="4"
					uci set mwan3config.$wan6configname11.up="$CWAN2V6up"
					uci set mwan3config.$wan6configname11.down="$CWAN2V6down"
					uci set mwan3config.$wan6configname11.flush_conntrack="$CWAN2V6flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname11.wanpriority=1
					else
						uci set mwan3config.$wan6configname11.wanpriority=9
					fi
					uci set mwan3config.$wan6configname11.track_method="ping"
					uci set mwan3config.$wan6configname11.validtrackip=2
					uci set mwan3config.$wan6configname11.enabled=1
					uci set mwan3config.$wan6configname11.trackIp1=2001:4860:4860::8888
					uci set mwan3config.$wan6configname11.trackIp2=2001:4860:4860::8844
					uci set mwan3config.$wan6configname11.reliability=1
					uci set mwan3config.$wan6configname11.count=3
					uci set mwan3config.$wan6configname11.timeout=4
					uci set mwan3config.$wan6configname11.up=3
					uci set mwan3config.$wan6configname11.down=3
					uci set mwan3config.$wan6configname11.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
		fi
		
		#singlecellularsinglesim
		if [ "$CellularOperationMode" = "singlecellularsinglesim" ]
		then
			if [ "$PDP1" = "1" ] || [ "$PDP1" = "3" ]
			then
				uci set mwan3config."$wanconfigname6"=redirect
				uci set mwan3config.$wanconfigname6.name=$wanconfigname6
   			    uci set mwan3config.$wanconfigname6.track_method=$CWAN1trackmethod_failover
				
				if [ -n "$CWAN1priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname6.wanpriority="1"
						uci set mwan3config.$wanconfigname6.wanweight=$CWAN1weight
					else
						uci set mwan3config.$wanconfigname6.wanpriority=$CWAN1priority
					fi
					
					uci set mwan3config.$wanconfigname6.enabled=$CWAN1enabled
					
					uci set mwan3config.$wanconfigname6.validtrackip=$CWAN1validtrackip
					if [ "$CWAN1validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
					fi
					if [ "$CWAN1validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
						uci set mwan3config.$wanconfigname6.trackIp2="$CWAN1trackIp2"
					fi
					if [ "$CWAN1validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
						uci set mwan3config.$wanconfigname6.trackIp2="$CWAN1trackIp2"
						uci set mwan3config.$wanconfigname6.trackIp3="$CWAN1trackIp3"
					fi
					if [ "$CWAN1validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wanconfigname6.trackIp1="$CWAN1trackIp1"
						uci set mwan3config.$wanconfigname6.trackIp2="$CWAN1trackIp2"
						uci set mwan3config.$wanconfigname6.trackIp3="$CWAN1trackIp3"
						uci set mwan3config.$wanconfigname6.trackIp4="$CWAN1trackIp4"
					fi
					
					uci set mwan3config.$wanconfigname6.reliability="$CWAN1reliability"
					uci set mwan3config.$wanconfigname6.count="$CWAN1count"
					uci set mwan3config.$wanconfigname6.timeout="2"
					uci set mwan3config.$wanconfigname6.up="$CWAN1up"
					uci set mwan3config.$wanconfigname6.down="$CWAN1down"
					uci set mwan3config.$wanconfigname6.flush_conntrack="$CWAN1flush_conntrack"
					 
				else
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wanconfigname6.wanpriority=1
					else
						uci set mwan3config.$wanconfigname6.wanpriority=6
					fi
					uci set mwan3config.$wanconfigname6.track_method="ping"					
					uci set mwan3config.$wanconfigname6.validtrackip=2
					uci set mwan3config.$wanconfigname6.enabled=1
					uci set mwan3config.$wanconfigname6.trackIp1=8.8.8.8
					uci set mwan3config.$wanconfigname6.trackIp2=8.8.4.4
					uci set mwan3config.$wanconfigname6.reliability=1
					uci set mwan3config.$wanconfigname6.count=1
					uci set mwan3config.$wanconfigname6.timeout=2
					uci set mwan3config.$wanconfigname6.up=3
					uci set mwan3config.$wanconfigname6.down=3
					uci set mwan3config.$wanconfigname6.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
			if [ "$PDP1" = "2" ]  
			then
				uci set mwan3config."$wan6configname10"=redirect
				uci set mwan3config.$wan6configname10.name=$wan6configname10
   			    uci set mwan3config.$wan6configname10.track_method=$CWAN1V6trackmethod_failover
				
				if [ -n "$CWAN1V6priority" ]
				then
					
					#Add weight only when policy is balanced.
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname10.wanpriority="1"
						uci set mwan3config.$wan6configname10.wanweight=$CWAN1V6weight
					else
						uci set mwan3config.$wan6configname10.wanpriority=$CWAN1V6priority
					fi
					
					uci set mwan3config.$wan6configname10.enabled=$CWAN1V6enabled
					
					uci set mwan3config.$wan6configname10.validtrackip=$CWAN1V6validtrackip
					if [ "$CWAN1V6validtrackip" =  "1" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
					fi
					if [ "$CWAN1V6validtrackip" =  "2" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
					fi
					if [ "$CWAN1V6validtrackip" =  "3" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
						uci set mwan3config.$wan6configname10.trackIp3="$CWAN1V6trackIp3"
					fi
					if [ "$CWAN1V6validtrackip" =  "4" ]
					then 
						uci set mwan3config.$wan6configname10.trackIp1="$CWAN1V6trackIp1"
						uci set mwan3config.$wan6configname10.trackIp2="$CWAN1V6trackIp2"
						uci set mwan3config.$wan6configname10.trackIp3="$CWAN1V6trackIp3"
						uci set mwan3config.$wan6configname10.trackIp4="$CWAN1V6trackIp4"
					fi
					
					uci set mwan3config.$wan6configname10.reliability="$CWAN1V6reliability"
					uci set mwan3config.$wan6configname10.count="$CWAN1V6count"
					uci set mwan3config.$wan6configname10.timeout="4"
					uci set mwan3config.$wan6configname10.up="$CWAN1V6up"
					uci set mwan3config.$wan6configname10.down="$CWAN1V6down"
					uci set mwan3config.$wan6configname10.flush_conntrack="$CWAN1V6flush_conntrack"
					 
				else	
					if [ "$policy_type" = "balanced" ]
					then
						uci set mwan3config.$wan6configname10.wanpriority=1
					else	
						uci set mwan3config.$wan6configname10.wanpriority=6
					fi
					uci set mwan3config.$wan6configname10.track_method="ping"
					uci set mwan3config.$wan6configname10.validtrackip=2
					uci set mwan3config.$wan6configname10.enabled=1
					uci set mwan3config.$wan6configname10.trackIp1=2001:4860:4860::8888
					uci set mwan3config.$wan6configname10.trackIp2=2001:4860:4860::8844
					uci set mwan3config.$wan6configname10.reliability=1
					uci set mwan3config.$wan6configname10.count=3
					uci set mwan3config.$wan6configname10.timeout=4
					uci set mwan3config.$wan6configname10.up=3
					uci set mwan3config.$wan6configname10.down=3
					uci set mwan3config.$wan6configname10.flush_conntrack=1
				fi	

				count=$((count + 1))
				echo "Count = $count"
			fi
			
		fi
	fi
	
	if [ "$wifi1mode" =  "sta" ] || [ "$wifi1mode" =  "apsta" ]
	then
		uci set mwan3config."$wanconfigname12"=redirect
		uci set mwan3config.$wanconfigname12.name=$wanconfigname12
   		uci set mwan3config.$wanconfigname12.track_method=$WIFI_WANtrackmethod_failover
		
		if [ -n "$WIFI_WANpriority" ]
		then
			
			#Add weight only when policy is balanced.
			if [ "$policy_type" = "balanced" ]
			then
				uci set mwan3config.$wanconfigname12.wanpriority="1"
				uci set mwan3config.$wanconfigname12.wanweight=$WIFI_WANweight
			else 
				uci set mwan3config.$wanconfigname12.wanpriority=$WIFI_WANpriority
			fi
			
			uci set mwan3config.$wanconfigname12.enabled=$WIFI_WANenabled
			
			uci set mwan3config.$wanconfigname12.validtrackip=$WIFI_WANvalidtrackip
			if [ "$WIFI_WANvalidtrackip" =  "1" ]
			then 
				uci set mwan3config.$wanconfigname12.trackIp1="$WIFI_WANtrackIp1"
			fi
			if [ "$WIFI_WANvalidtrackip" =  "2" ]
			then 
				uci set mwan3config.$wanconfigname12.trackIp1="$WIFI_WANtrackIp1"
				uci set mwan3config.$wanconfigname12.trackIp2="$WIFI_WANtrackIp2"
			fi
			if [ "$WIFI_WANvalidtrackip" =  "3" ]
			then 
				uci set mwan3config.$wanconfigname12.trackIp1="$WIFI_WANtrackIp1"
				uci set mwan3config.$wanconfigname12.trackIp2="$WIFI_WANtrackIp2"
				uci set mwan3config.$wanconfigname12.trackIp3="$WIFI_WANtrackIp3"
			fi
			if [ "$WIFI_WANvalidtrackip" =  "4" ]
			then 
				uci set mwan3config.$wanconfigname12.trackIp1="$WIFI_WANtrackIp1"
				uci set mwan3config.$wanconfigname12.trackIp2="$WIFI_WANtrackIp2"
				uci set mwan3config.$wanconfigname12.trackIp3="$WIFI_WANtrackIp3"
				uci set mwan3config.$wanconfigname12.trackIp4="$WIFI_WANtrackIp4"
			fi
			
			uci set mwan3config.$wanconfigname12.reliability="$WIFI_WANreliability"
			uci set mwan3config.$wanconfigname12.count="$WIFI_WANcount"
			uci set mwan3config.$wanconfigname12.timeout="2"
			uci set mwan3config.$wanconfigname12.up="$WIFI_WANup"
			uci set mwan3config.$wanconfigname12.down="$WIFI_WANdown"
			uci set mwan3config.$wanconfigname12.flush_conntrack="$WIFI_WANflush_conntrack"
			uci set mwan3config.$wanconfigname12.initial_state="$WIFI_WANinitial_state"
			 
		else
			if [ "$policy_type" = "balanced" ]
			then
				uci set mwan3config.$wanconfigname12.wanpriority=1
			else
				uci set mwan3config.$wanconfigname12.wanpriority=12
			fi
			uci set mwan3config.$wanconfigname12.track_method="ping"
			uci set mwan3config.$wanconfigname12.validtrackip=2
			uci set mwan3config.$wanconfigname12.enabled=1
			uci set mwan3config.$wanconfigname12.trackIp1=8.8.8.8
			uci set mwan3config.$wanconfigname12.trackIp2=8.8.4.4
			uci set mwan3config.$wanconfigname12.reliability=1
			uci set mwan3config.$wanconfigname12.count=1
			uci set mwan3config.$wanconfigname12.timeout=2
			uci set mwan3config.$wanconfigname12.up=3
			uci set mwan3config.$wanconfigname12.down=3
			uci set mwan3config.$wanconfigname12.flush_conntrack=1
		fi	

		count=$((count + 1))
		echo "Count = $count"
	fi
	  
	  echo "Final Count = $count"
	  echo "$count" > "wancount.txt"
	  
 uci commit mwan3config
}

config_load "$sysconfigUCIPath"

#Wireless
config_get wifi1mode "$wificonfigsection" wifi1mode

#Cellular
config_get CellularOperationMode "$sysconfigsection" CellularOperationMode 
config_get enablecellular "$sysconfigsection" enablecellular
config_get cellularmodem1 "$sysconfigsection" cellularmodem1
config_get Manufacturer1 "$sysconfigsection" Manufacturer1
config_get model1 "$sysconfigsection" model1
config_get cellularmodem2 "$sysconfigsection" cellularmodem2
config_get Manufacturer2 "$sysconfigsection" Manufacturer2
config_get model2 "$sysconfigsection" model2
config_get PDP1 "$sysconfigsection" pdp
config_get PDP2 "$sysconfigsection" sim2pdp

#loopback
config_get loopbackip "$loopbackconfigsection" loopbackip
config_get loopbacknetmask "$loopbackconfigsection" loopbacknetmask

#Set loopback
uci set network.loopback.ipaddr=$loopbackip
uci set network.loopback.netmask=$loopbacknetmask

uci commit network 

#Check FAILOVER/LOAD BALANCING.
policy_type=$(uci get mwan3config.general.select)

#MWAN3CONFIG
config_load "/etc/config/mwan3config" 
config_foreach ReadOldPriority redirect

uci delete mwan3config.$wanconfigname6
uci delete mwan3config.$wanconfigname7
uci delete mwan3config.$wanconfigname8
uci delete mwan3config.$wanconfigname9
uci delete mwan3config.$wan6configname10
uci delete mwan3config.$wan6configname11
uci delete mwan3config.$wanconfigname12

#killing the Wifi_monitor.sh, before running SystemStart.sh
pid=$(pgrep -f "/root/InterfaceManager/script/Wifi_monitor.sh")
kill -9 $pid

#$cellulardatausagemanagerscript	     
SetPriority
$validatescript    

exit 0
