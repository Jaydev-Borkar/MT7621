#!/bin/sh

. /lib/functions.sh

cellularwan1interface="CWAN1"
cellularwan2interface="CWAN2"
cellularwan3interface="CWAN3"
cellularwan1sim1interface="CWAN1_0"
cellularwan1sim2interface="CWAN1_1"

#IPV6 Variables 
cellular1wan6interface="wan6c1"
cellular2wan6interface="wan6c2"

wifiinterface="ra0"
wifi5interface="rai0"
wifiap="ra0_ap"
wifi5ap="rai0_ap"
wifista="sta"
wifiwaninterface="WIFI_WAN"

#To change guest name -- 
wifiap1="ra1"
wifiap51="rai1"
 
#InternetOverWifi="1"

ReadSystemConfigFile()
{
	config_load "$SystemConfigFile"

	#  Cellular
	config_get CellularOperationModelocal sysconfig CellularOperationMode
	config_get CellularModem1 sysconfig cellularmodem1
	config_get Protocol1EC20 sysconfig protocol1EC20
	config_get Manufacturerlocal1 sysconfig Manufacturer1
	config_get Model1 sysconfig model1
	config_get PortType1 sysconfig porttype1
	config_get VendorId1 sysconfig vendorid1
	config_get ProductId1 sysconfig productid1
	config_get DataPort1 sysconfig dataport1
	config_get ComPort1 sysconfig comport1
	config_get SmsPort1 sysconfig smsport1
	config_get SmsEnable1 sysconfig smsenable1
	config_get SmsCenterNumber1 sysconfig smscenternumber1
	config_get DeviceId1 sysconfig smsdeviceid
	config_get ApiKey1 sysconfig smsapikey
	config_get Manufacturerlocal2 sysconfig Manufacturer2
	config_get Model2 sysconfig model2
	config_get PortType2 sysconfig porttype2
	config_get VendorId2 sysconfig vendorid2
	config_get ProductId2 sysconfig productid2
	config_get DataPort2 sysconfig dataport2
	config_get ComPort2 sysconfig comport2
	config_get SmsPort2 sysconfig smsport2
	config_get SmsEnable2 sysconfig smsenable2
	config_get SmsCenterNumber2 sysconfig smscenternumber2
	config_get DeviceId2 sysconfig deviceid2
	config_get ApiKey2 sysconfig apikey2
	config_get MonitorEnable1 sysconfig monitorenable1
	config_get QueryModematAnalytics1 sysconfig querymodematanalytics1
	config_get DataTestEnable1 sysconfig datatestenable1
	config_get PingTestEnable1 sysconfig pingtestenable1
	config_get PingIp1 sysconfig pingip1
	config_get MonitorEnable2 sysconfig monitorenable2
	config_get QueryModematAnalytics2 sysconfig querymodematanalytics2
	config_get DataTestEnable2 sysconfig datatestenable2
	config_get PingTestEnable2 sysconfig pingtestenable2
	config_get PingIp2 sysconfig pingip2
	config_get DataEnable1 sysconfig dataenable
	config_get Cellular1 sysconfig cellular
	config_get Service1 sysconfig service
	config_get Apn1 sysconfig apn
	config_get Pdp1 sysconfig pdp
	config_get PinCode1 sysconfig pincode
	config_get UserName1 sysconfig username
	config_get Password1 sysconfig password
	config_get Auth1 sysconfig auth
	config_get DataEnable2 sysconfig dataenable2
	config_get Cellular2 sysconfig cellular2
	config_get Sim2Service sysconfig sim2service
	config_get Sim2Apn sysconfig sim2apn
	config_get sim2pdp sysconfig sim2pdp
	config_get Sim2PinCode sysconfig sim2pincode
	config_get Sim2UserName sysconfig sim2username
	config_get Sim2Password sysconfig sim2password
	config_get sim2auth sysconfig sim2auth
	config_get EnableCellular sysconfig enablecellular
	config_get UsbBusPath1 sysconfig usbbuspath1
	config_get UsbBusPath2 sysconfig usbbuspath2
	config_get ActionInterval1 sysconfig actioninterval1
	config_get ActionInterval2 sysconfig actioninterval2
	config_get Protocol1 sysconfig protocol1
	config_get Protocol2 sysconfig protocol2
	config_get SmsResponseSenderEnable1 sysconfig smsresponsesenderenable1
	config_get SmsResponseSenderEnable2 sysconfig smsresponsesenderenable2
	config_get SmsResponseServerEnable1 sysconfig smsresponseserverenable1
	config_get SmsResponseServerEnable2 sysconfig smsresponseserverenable2
	config_get SmsServerNumber1 sysconfig smsservernumber1
	config_get SmsServerNumber2 sysconfig smsservernumber2
	config_get SmsServerNumber3 sysconfig smsservernumber3
	config_get SmsServerNumber4 sysconfig smsservernumber4        
	config_get SmsServerNumber5 sysconfig smsservernumber5
	#5g
	config_get support5gnetwork sysconfig support5gnetwork
	config_get networkingmode1 sysconfig networkingmode1
	config_get autoconfigsim1 sysconfig autoconfigsim1
	config_get rattype1 sysconfig rattype1
	config_get nsa_bands1 sysconfig nsa_bands1
	config_get sa_bands1 sysconfig sa_bands1
	config_get ComPortSymLink1 sysconfig ComPortSymLink1
	config_get networkingmode2 sysconfig networkingmode2
	config_get autoconfigsim2 sysconfig autoconfigsim2
	config_get rattype2 sysconfig rattype2
	config_get nsa_bands2 sysconfig nsa_bands2
	config_get sa_bands2 sysconfig sa_bands2
	config_get ComPortSymLink2 sysconfig ComPortSymLink2

	# Wifi 2.4
	config_get WifiDevice wificonfig wifidevice
	config_get channelwidth wificonfig channelwidth
	config_get wifi1protocol wificonfig wifi1protocol
	config_get TxPower wificonfig TxPower
	config_get WifiDevicesChannel wificonfig wifideviceschannel
	config_get CountryCode wificonfig CountryCode
	config_get wifi1CountryRegion wificonfig wifi1CountryRegion
	config_get wifi1enable wificonfig wifi1enable
	config_get Radio0StationEnable wificonfig radio0stationenable
	config_get Wifi1Ssid wificonfig wifi1ssid
	config_get Wifi1Key wificonfig wifi1key
	config_get wifi1mode wificonfig wifi1mode
	config_get Wifi1Authentication wificonfig wifi1authentication
	config_get Wifi1Encryption wificonfig wifi1encryption
	config_get Wifi2Enable wificonfig wifi2enable
	config_get Wifi2Ssid wificonfig wifi2ssid
	config_get Wifi2Key wificonfig wifi2key
	config_get Wifi2Mode wificonfig wifi2mode
	config_get InternetOverWifi wificonfig internetoverwifi
	config_get LanWifiBridgeEnable wificonfig lanwifibridgeenable
	config_get Radio0DhcpIp wificonfig radio0dhcpip
	config_get Radio0DHCPRange wificonfig Radio0DHCPrange
	config_get Radio0DHCPLimit wificonfig Radio0DHCPlimit
	
	config_get enable_dhcpserver wificonfig enable_dhcpserver
	config_get wifi2leasetime wificonfig wifi2leasetime
	config_get wifi2leasetime_duration wificonfig wifi2leasetime_duration
	
	config_get wifienable_bridge wificonfig wifienable_bridge
	config_get wifibridge_interfaces wificonfig wifibridge_interfaces
	
	# wirelessschedule
	config_get ScheduledOnOff wirelessschedule ScheduledOnOff
	
	#2.4G STA
	config_get wifistaencryption wificonfig wifistaencryption
	config_get wifistakey wificonfig wifistakey
	config_get wifistaauth wificonfig wifistaauth
	config_get wifistassid wificonfig wifistassid
	
	# Wifi 5 
	config_get Wifi5Mode wificonfig wifi5mode       
	config_get wifi51protocol wificonfig wifi51protocol       
	config_get wifi5CountryRegion wificonfig wifi5CountryRegion       
	config_get wifi5TxPower wificonfig wifi5TxPower       
	config_get wifi5ssid wificonfig wifi5ssid
	config_get wifi5encryption wificonfig wifi5encryption
	config_get wifi5key wificonfig wifi5key
	config_get wifi5authentication wificonfig wifi5authentication
	config_get wifi5encryption wificonfig wifi5encryption
	config_get wifi5radio0dhcpip wificonfig wifi5radio0dhcpip
	config_get wifi5Radio0DHCPrange wificonfig wifi5Radio0DHCPrange
	config_get wifi5Radio0DHCPlimit wificonfig wifi5Radio0DHCPlimit
	config_get wifi5enable wificonfig wifi5enable
	config_get wifi5channelwidth wificonfig wifi5channelwidth
	config_get wifi5CountryCode wificonfig wifi5CountryCode
	config_get wifi5deviceschannel wificonfig wifi5deviceschannel
	config_get wifi5WmmEnable wificonfig wifi5WmmEnable
	
	config_get wifi5enable_dhcpserver wificonfig wifi5enable_dhcpserver
	config_get wifi5leasetime wificonfig wifi5leasetime
	config_get wifi5leasetime_duration wificonfig wifi5leasetime_duration
	
	config_get wifi5enable_bridge wificonfig wifi5enable_bridge
	config_get wifi5bridge_interfaces wificonfig wifi5bridge_interfaces

	#guest 2.4ghz
	config_get guestwifienable2 guestwifi guestwifienable2
	config_get guestwifissid2 guestwifi guestwifissid2
	config_get guestwifi1authentication2 guestwifi guestwifi1authentication2
	config_get guestwifi1encryption2 guestwifi guest1encryption
	config_get guestwifikey2 guestwifi guestwifikey2
	config_get guestradio0dhcpip2 guestwifi guestradio0dhcpip2
	config_get guestRadio0DHCPrange2 guestwifi guestRadio0DHCPrange2
	config_get guestRadio0DHCPlimit2 guestwifi guestRadio0DHCPlimit2

	#guest 5ghz        
	config_get guestwifienable5 guestwifi guestwifienable5
	config_get guestwifissid5 guestwifi guestwifissid5
	config_get guestwifi1authentication5 guestwifi guestwifi1authentication5
	config_get guestwifi1encryption5 guestwifi guestencryption
	config_get guestwifikey5 guestwifi guestwifikey5
	config_get guestradio0dhcpip5 guestwifi guestradio0dhcpip5
	config_get guestRadio0DHCPrange5 guestwifi guestRadio0DHCPrange5
	config_get guestRadio0DHCPlimit5 guestwifi guestRadio0DHCPlimit5

	#Advanced 2.4ghz
	config_get radiusport sysconfig radiusport
	config_get radiusacctport sysconfig radiusacctport
	config_get TxBurst sysconfig TxBurst
	config_get HTOpMode sysconfig HTOpMode
	config_get HTMpduDensity sysconfig HTMpduDensity
	config_get HTBW sysconfig HTBW
	config_get HTPROTECT sysconfig HTPROTECT
	config_get HTRxStream sysconfig HTRxStream
	config_get HTTxStream sysconfig HTTxStream
	config_get E2pAccessMode sysconfig E2pAccessMode
	config_get WHNAT sysconfig WHNAT
	config_get BeaconPeriod sysconfig BeaconPeriod
	config_get DtimPeriod sysconfig DtimPeriod
	config_get WmmCapable sysconfig WmmCapable
	config_get RTSThreshold sysconfig RTSThreshold
	config_get FragThreshold sysconfig FragThreshold
	config_get IgmpSnEnable sysconfig IgmpSnEnable
	config_get HT_STBC sysconfig HT_STBC
	config_get HT_LDPC sysconfig HT_LDPC
	config_get VHT_STBC sysconfig VHT_STBC
	config_get VHT_LDPC sysconfig VHT_LDPC

	#Advanced 5ghz        
	config_get wifi5radiusport sysconfig wifi5radiusport
	config_get wifi5radiusacctport sysconfig wifi5radiusacctport
	config_get wifi5TxBurst sysconfig wifi5TxBurst
	config_get wifi5HTOpMode sysconfig wifi5HTOpMode
	config_get wifi5HTMpduDensity sysconfig wifi5HTMpduDensity
	config_get wifi5HTBW sysconfig wifi5HTBW
	config_get wifi5HTPROTECT sysconfig wifi5HTPROTECT
	config_get wifi5HTRxStream sysconfig wifi5HTRxStream
	config_get wifi5HTTxStream sysconfig wifi5HTTxStream
	config_get wifi5E2pAccessMode sysconfig wifi5E2pAccessMode
	config_get wifi5WHNAT sysconfig wifi5WHNAT
	config_get wifi5BeaconPeriod sysconfig wifi5BeaconPeriod
	config_get wifi5DtimPeriod sysconfig wifi5DtimPeriod
	config_get wifi5WmmCapable sysconfig wifi5WmmCapable
	config_get wifi5RTSThreshold sysconfig wifi5RTSThreshold
	config_get wifi5FragThreshold sysconfig wifi5FragThreshold
	config_get wifi5IgmpSnEnable sysconfig wifi5IgmpSnEnable
	config_get wifi5HT_STBC sysconfig wifi5HT_STBC
	config_get wifi5HT_LDPC sysconfig wifi5HT_LDPC
	config_get wifi5VHT_STBC sysconfig wifi5VHT_STBC
	config_get wifi5VHT_LDPC sysconfig wifi5VHT_LDPC
}

ReadMwanConfigFile()
{
	#Clear the contents of mwan3 config file.
	echo > /etc/config/mwan3
	
	#Write the globals config.
	uci set mwan3.globals=globals
	uci set mwan3.globals.enabled='1'
	uci set mwan3.globals.mmx_mask='0x3F00'
	uci set mwan3.globals.rtmon_interval='5'
	
	uci set mwan3.default_rule_v6=rule
	uci set mwan3.default_rule_v6.dest_ip='::/0'
	uci set mwan3.default_rule_v6.family='ipv6'
	
	uci set mwan3.default_rule_v4=rule
	uci set mwan3.default_rule_v4.dest_ip='0.0.0.0/0'
	uci set mwan3.default_rule_v4.family='ipv4'
	
	uci commit mwan3
	
	#Load /etc/config/mwan3config
	config_load "$MwanConfigFile"
	config_foreach UpdateMwanConfig redirect
	
	UpdateCellularMwan3Config
}

UpdateCellularMwan3Config()
{
   config_get NameWifiwan "$wifiwaninterface" name
   config_get WifiwanPriority "$wifiwaninterface" wanpriority
   config_get WifiwanWeight "$wifiwaninterface" wanweight
   config_get Wifiwanenabled "$wifiwaninterface" enabled
   config_get WifiwanTrackIp1 "$wifiwaninterface" trackIp1
   config_get WifiwanTrackIp2 "$wifiwaninterface" trackIp2
   config_get WifiwanTrackIp3 "$wifiwaninterface" trackIp3
   config_get WifiwanTrackIp4 "$wifiwaninterface" trackIp4
   config_get WifiwanReliability "$wifiwaninterface" reliability 
   config_get WifiwanCount "$wifiwaninterface" count
   config_get WifiwanUp "$wifiwaninterface" up
   config_get WifiwanDown "$wifiwaninterface" down
   config_get WifiwanValidtrackip "$wifiwaninterface" validtrackip
	
   config_get NameCwan1 "$cellularwan1interface" name
   config_get Cwan1Priority "$cellularwan1interface" wanpriority
   config_get Cwan1Weight "$cellularwan1interface" wanweight
   config_get Cwan1enabled "$cellularwan1interface" enabled
   config_get Cwan1TrackIp1 "$cellularwan1interface" trackIp1
   config_get Cwan1TrackIp2 "$cellularwan1interface" trackIp2
   config_get Cwan1TrackIp3 "$cellularwan1interface" trackIp3
   config_get Cwan1TrackIp4 "$cellularwan1interface" trackIp4
   config_get Cwan1Reliability "$cellularwan1interface" reliability 
   config_get Cwan1Count "$cellularwan1interface" count
   config_get Cwan1Up "$cellularwan1interface" up
   config_get Cwan1Down "$cellularwan1interface" down
   config_get Cwan1Validtrackip "$cellularwan1interface" validtrackip
   
   config_get NameCwan2 "$cellularwan2interface" name
   config_get Cwan2Priority "$cellularwan2interface" wanpriority
   config_get Cwan2Weight "$cellularwan2interface" wanweight
   config_get Cwan2enabled "$cellularwan2interface" enabled
   config_get Cwan2TrackIp1 "$cellularwan2interface" trackIp1
   config_get Cwan2TrackIp2 "$cellularwan2interface" trackIp2
   config_get Cwan2TrackIp3 "$cellularwan2interface" trackIp3
   config_get Cwan2TrackIp4 "$cellularwan2interface" trackIp4
   config_get Cwan2Reliability "$cellularwan2interface" reliability 
   config_get Cwan2Count "$cellularwan2interface" count
   config_get Cwan2Up "$cellularwan2interface" up
   config_get Cwan2Down "$cellularwan2interface" down
   config_get Cwan2Validtrackip "$cellularwan2interface" validtrackip
   
   config_get NameCwansim1 "$cellularwan1sim1interface" name
   config_get Cwan1sim1Priority "$cellularwan1sim1interface" wanpriority
   config_get Cwan1sim1Weight "$cellularwan1sim1interface" wanweight
   config_get Cwan1sim1enabled "$cellularwan1sim1interface" enabled
   config_get Cwan1sim1TrackIp1 "$cellularwan1sim1interface" trackIp1
   config_get Cwan1sim1TrackIp2 "$cellularwan1sim1interface" trackIp2
   config_get Cwan1sim1TrackIp3 "$cellularwan1sim1interface" trackIp3
   config_get Cwan1sim1TrackIp4 "$cellularwan1sim1interface" trackIp4
   config_get Cwan1sim1Reliability "$cellularwan1sim1interface" reliability 
   config_get Cwan1sim1Count "$cellularwan1sim1interface" count
   config_get Cwan1sim1Up "$cellularwan1sim1interface" up
   config_get Cwan1sim1Down "$cellularwan1sim1interface" down
   config_get Cwan1sim1Validtrackip "$cellularwan1sim1interface" validtrackip
   
   config_get NameCwansim2 "$cellularwan1sim2interface" name
   config_get Cwan1sim2Priority "$cellularwan1sim2interface" wanpriority
   config_get Cwan1sim2Weight "$cellularwan1sim2interface" wanweight
   config_get Cwan1sim2enabled "$cellularwan1sim2interface" enabled
   config_get Cwan1sim2TrackIp1 "$cellularwan1sim2interface" trackIp1
   config_get Cwan1sim2TrackIp2 "$cellularwan1sim2interface" trackIp2
   config_get Cwan1sim2TrackIp3 "$cellularwan1sim2interface" trackIp3
   config_get Cwan1sim2TrackIp4 "$cellularwan1sim2interface" trackIp4
   config_get Cwan1sim2Reliability "$cellularwan1sim2interface" reliability 
   config_get Cwan1sim2Count "$cellularwan1sim2interface" count
   config_get Cwan1sim2Up "$cellularwan1sim2interface" up
   config_get Cwan1sim2Down "$cellularwan1sim2interface" down
   config_get Cwan1sim2Validtrackip "$cellularwan1sim2interface" validtrackip
   
   #IPV6 variables
	config_get NameCwan6_1 "$cellular1wan6interface" name
	config_get Cwan6_1Priority "$cellular1wan6interface" wanpriority
	config_get Cwan6_1Weight "$cellular1wan6interface" wanweight
	config_get Cwan6_1enabled "$cellular1wan6interface" enabled
	config_get Cwan6_1TrackIp1 "$cellular1wan6interface" trackIp1
	config_get Cwan6_1TrackIp2 "$cellular1wan6interface" trackIp2
	config_get Cwan6_1TrackIp3 "$cellular1wan6interface" trackIp3
	config_get Cwan6_1TrackIp4 "$cellular1wan6interface" trackIp4
	config_get Cwan6_1Reliability "$cellular1wan6interface" reliability
	config_get Cwan6_1Count "$cellular1wan6interface" count
	config_get Cwan6_1Up "$cellular1wan6interface" up
	config_get Cwan6_1Down "$cellular1wan6interface" down
	config_get Cwan6_1validtrackip "$cellular1wan6interface" validtrackip

	config_get NameCwan6_2 "$cellular2wan6interface" name
	config_get Cwan6_2Priority "$cellular2wan6interface" wanpriority
	config_get Cwan6_2Weight "$cellular2wan6interface" wanweight
	config_get Cwan6_2enabled "$cellular2wan6interface" enabled
	config_get Cwan6_2TrackIp1 "$cellular2wan6interface" trackIp1
	config_get Cwan6_2TrackIp2 "$cellular2wan6interface" trackIp2
	config_get Cwan6_2TrackIp3 "$cellular2wan6interface" trackIp3
	config_get Cwan6_2TrackIp4 "$cellular2wan6interface" trackIp4
	config_get Cwan6_2Reliability "$cellular2wan6interface" reliability
	config_get Cwan6_2Count "$cellular2wan6interface" count
	config_get Cwan6_2Up "$cellular2wan6interface" up
	config_get Cwan6_2Down "$cellular2wan6interface" down
	config_get Cwan6_2validtrackip "$cellular2wan6interface" validtrackip
	
	#WIFI_WAN
	if [ "$wifi1enable" = "1" ]
	then 
		#apsta
		if [ "$wifi1mode" = "sta" ] ||  [ "$wifi1mode" = "apsta" ] 
		then
			uci delete mwan3.WIFI_WAN_member > /dev/null 2>&1
			uci set mwan3."${wifiwaninterface}"=interface

			#Check mwan3 enable/disable for individual interfaces
			if [ "$Wifiwanenabled" = "1" ]
			then
				uci set mwan3."${wifiwaninterface}".enabled="1"
			else
				uci set mwan3."${wifiwaninterface}".enabled="0"
			fi

			if [ "$WifiwanValidtrackip" =  "1" ]
			then 
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp1"
			fi
			if [ "$WifiwanValidtrackip" =  "2" ]
			then 
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp1"
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp2"
			fi
			if [ "$WifiwanValidtrackip" =  "3" ]
			then 
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp1"
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp2"
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp3"
			fi
			if [ "$WifiwanValidtrackip" =  "4" ]
			then 
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp1"
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp2"
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp3"
				uci add_list mwan3."${wifiwaninterface}".track_ip="$WifiwanTrackIp4"
			fi

			uci set mwan3."${wifiwaninterface}".family="ipv4"
			uci set mwan3."${wifiwaninterface}".reliability="$WifiwanReliability"
			uci set mwan3."${wifiwaninterface}".count="$WifiwanCount"
			uci set mwan3."${wifiwaninterface}".timeout="2"
			uci set mwan3."${wifiwaninterface}".down="$WifiwanDown"
			uci set mwan3."${wifiwaninterface}".up="$WifiwanUp"

			#member
			uci set mwan3.WIFI_WAN_member=member
			uci set mwan3.WIFI_WAN_member.interface="${wifiwaninterface}"
			uci set mwan3.WIFI_WAN_member.metric="$WifiwanPriority"

			#Add weight only when policy is balanced.
			if [ "$policy_type" = "balanced" ]
			then
				uci set mwan3.WIFI_WAN_member.weight="$WifiwanWeight"
			fi

			if [ "$policy_type" = "balanced" ]
			then
				#balanced_v4
				uci add_list mwan3.balanced_v4.use_member="WIFI_WAN_member"
			elif [ "$policy_type" = "failover" ]
			then
				#failover_v4
				uci add_list mwan3.failover_v4.use_member="WIFI_WAN_member"
			fi

		else
			uci delete mwan3.WIFI_WAN_member > /dev/null 2>&1
		fi
	fi
	
	#Cellular
	if [ "$EnableCellular" = "1" ]
	then
		#dualcellularsinglesim
		if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
		then
			uci delete mwan3.cwan1sim1_member > /dev/null 2>&1
			uci delete mwan3.cwan1sim2_member > /dev/null 2>&1
			uci delete mwan3.cwan1_member > /dev/null 2>&1
			uci delete mwan3.cwan2_member > /dev/null 2>&1
			uci delete mwan3.cwan6_1_member > /dev/null 2>&1
			uci delete mwan3.cwan6_2_member > /dev/null 2>&1
			
			#CWAN1
			#If pdp1 is ipv4 or ipv4v6
			if [ "$Pdp1" = "1" ]  || [ "$Pdp1" = "3" ]
			then
				uci set mwan3."${cellularwan1interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan1enabled" = "1" ]
				then
					uci set mwan3."${cellularwan1interface}".enabled="1"
				else
					uci set mwan3."${cellularwan1interface}".enabled="0"
				fi

				if [ "$Cwan1Validtrackip" =  "1" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1TrackIp1"
				fi
				if [ "$Cwan1Validtrackip" =  "2" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp2"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan1TrackIp2"
				fi
				if [ "$Cwan1Validtrackip" =  "3" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp2"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp3"
				fi
				if [ "$Cwan1Validtrackip" =  "4" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp2"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp3"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp4"
				fi

				uci set mwan3."${cellularwan1interface}".family="ipv4"
				uci set mwan3."${cellularwan1interface}".reliability="$Cwan1Reliability"
				uci set mwan3."${cellularwan1interface}".count="$Cwan1Count"
				uci set mwan3."${cellularwan1interface}".timeout="2"
				uci set mwan3."${cellularwan1interface}".down="$Cwan1Down"
				uci set mwan3."${cellularwan1interface}".up="$Cwan1Up"

				#member
				uci set mwan3.cwan1_member=member
				uci set mwan3.cwan1_member.interface="${cellularwan1interface}"
				uci set mwan3.cwan1_member.metric="$Cwan1Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan1_member.weight="$Cwan1Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v4
					uci add_list mwan3.balanced_v4.use_member="cwan1_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v4
					uci add_list mwan3.failover_v4.use_member="cwan1_member"
				fi
			fi
			
			#If pdp1 is ipv6
			if [ "$Pdp1" = "2" ]
			then
			
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.balanced_v6=policy
					uci set mwan3.balanced_v6.last_resort='default'				
				elif [ "$policy_type" = "failover" ]
				then
					uci set mwan3.failover_v6=policy
					uci set mwan3.failover_v6.last_resort='default'
				fi
				
				uci set mwan3."${cellular1wan6interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan6_1enabled" = "1" ]
				then
					uci set mwan3."${cellular1wan6interface}".enabled="1"
				else
					uci set mwan3."${cellular1wan6interface}".enabled="0"
				fi

				if [ "$Cwan6_1validtrackip" = "1" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_1TrackIp1"
				fi
				if [ "$Cwan6_1validtrackip" = "2" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan6_1TrackIp2"
				fi
				if [ "$Cwan6_1validtrackip" = "3" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp3"
				fi
				if [ "$Cwan6_1validtrackip" = "4" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp3"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp4"
				fi
				uci set mwan3."${cellular1wan6interface}".family="ipv6"
				uci set mwan3."${cellular1wan6interface}".reliability="$Cwan6_1Reliability"
				uci set mwan3."${cellular1wan6interface}".count="$Cwan6_1Count"
				uci set mwan3."${cellular1wan6interface}".timeout="2"
				uci set mwan3."${cellular1wan6interface}".down="$Cwan6_1Down"
				uci set mwan3."${cellular1wan6interface}".up="$Cwan6_1Up"
				
				uci set mwan3.cwan6_1_member=member
				uci set mwan3.cwan6_1_member.interface="${cellular1wan6interface}"
				uci set mwan3.cwan6_1_member.metric="$Cwan6_1Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan6_1_member.weight="$Cwan6_1Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v6
					uci add_list mwan3.balanced_v6.use_member="cwan6_1_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v6
					uci add_list mwan3.failover_v6.use_member="cwan6_1_member"
				fi
			fi 
			
			#CWAN2
			if [ "$sim2pdp" = "1" ]  || [ "$sim2pdp" = "3" ]
			then
				uci set mwan3."${cellularwan2interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan2enabled" = "1" ]
				then
					uci set mwan3."${cellularwan2interface}".enabled="1"
				else
					uci set mwan3."${cellularwan2interface}".enabled="0"
				fi

				if [ "$Cwan2Validtrackip" =  "1" ]
				then 
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem2.ipaddress1="$Cwan2TrackIp1"
					
				fi
				if [ "$Cwan2Validtrackip" =  "2" ]
				then 
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp1"
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp2"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem2.ipaddress1="$Cwan2TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem2.ipaddress2="$Cwan2TrackIp2"
				fi
				if [ "$Cwan2Validtrackip" =  "3" ]
				then 
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp1"
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp2"
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp3"
				fi
				if [ "$Cwan2Validtrackip" =  "4" ]
				then 
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp1"
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp2"
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp3"
					uci add_list mwan3."${cellularwan2interface}".track_ip="$Cwan2TrackIp4"
				fi

				uci set mwan3."${cellularwan2interface}".family="ipv4"
				uci set mwan3."${cellularwan2interface}".reliability="$Cwan2Reliability"
				uci set mwan3."${cellularwan2interface}".count="$Cwan2Count"
				uci set mwan3."${cellularwan2interface}".timeout="2"
				uci set mwan3."${cellularwan2interface}".down="$Cwan2Down"
				uci set mwan3."${cellularwan2interface}".up="$Cwan2Up"

				#member
				uci set mwan3.cwan2_member=member
				uci set mwan3.cwan2_member.interface="${cellularwan2interface}"
				uci set mwan3.cwan2_member.metric="$Cwan2Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan2_member.weight="$Cwan2Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v4
					uci add_list mwan3.balanced_v4.use_member="cwan2_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v4
					uci add_list mwan3.failover_v4.use_member="cwan2_member"
				fi
			fi
			
			#If pdp2 is ipv6
			if [ "$sim2pdp" = "2" ]
			then
				
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.balanced_v6=policy
					uci set mwan3.balanced_v6.last_resort='default'				
				elif [ "$policy_type" = "failover" ]
				then
					uci set mwan3.failover_v6=policy
					uci set mwan3.failover_v6.last_resort='default'
				fi
				
				uci set mwan3."${cellular2wan6interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan6_2enabled" = "1" ]
				then
					uci set mwan3."${cellular2wan6interface}".enabled="1"
				else
					uci set mwan3."${cellular2wan6interface}".enabled="0"
				fi

				if [ "$Cwan6_2validtrackip" = "1" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem2.ipaddress1="$Cwan6_2TrackIp1"
				fi
				if [ "$Cwan6_2validtrackip" = "2" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp2"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem2.ipaddress1="$Cwan6_2TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem2.ipaddress2="$Cwan6_2TrackIp2"
				fi
				if [ "$Cwan6_2validtrackip" = "3" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp2"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp3"
				fi
				if [ "$Cwan6_2validtrackip" = "4" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp2"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp3"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp4"
				fi
				uci set mwan3."${cellular2wan6interface}".family="ipv6"
				uci set mwan3."${cellular2wan6interface}".reliability="$Cwan6_2Reliability"
				uci set mwan3."${cellular2wan6interface}".count="$Cwan6_2Count"
				uci set mwan3."${cellular2wan6interface}".timeout="2"
				uci set mwan3."${cellular2wan6interface}".down="$Cwan6_2Down"
				uci set mwan3."${cellular2wan6interface}".up="$Cwan6_2Up"
				
				uci set mwan3.cwan6_2_member=member
				uci set mwan3.cwan6_2_member.interface="${cellular2wan6interface}"
				uci set mwan3.cwan6_2_member.metric="$Cwan6_2Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan6_2_member.weight="$Cwan6_2Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v6
					uci add_list mwan3.balanced_v6.use_member="cwan6_2_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v6
					uci add_list mwan3.failover_v6.use_member="cwan6_2_member"
				fi
			fi 
		
		#singlecellulardualsim
		#One Variable we are using to update the routerapplicationconfig file. 
		#since sim2 IPaddresses are replaced by sim1 IPaddresses ,We Added editing the file routerapplicationconfig in Modem1RouterlocalpingTestApp.sh script itself(So adding 
		#ipaddresses to the routerapplicationconfig file is removed in this section).
		elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
		then
		
			#Don't delete CWAN1_0 & CWAN1_1 as we did earlier & no need to check if it's CWAN1_0 or CWAN1_1.
			#We need both CWAN1_0 and CWAN1_1 in mwan3 interfaces, else, incase of simswitch utility, 
			#systemstart.sh won't be executed and mwan3 interfaces wont be updated.
			uci delete mwan3.cwan1_member > /dev/null 2>&1
			uci delete mwan3.cwan2_member > /dev/null 2>&1
			uci delete mwan3.cwan6_1_member > /dev/null 2>&1
			uci delete mwan3.cwan6_2_member > /dev/null 2>&1
			
			#CWAN1_0
			#If pdp1 is ipv4 or ipv4v6
			if [ "$Pdp1" = "1" ]  || [ "$Pdp1" = "3" ]
			then

				uci set mwan3."${cellularwan1sim1interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan1sim1enabled" = "1" ]
				then
					uci set mwan3."${cellularwan1sim1interface}".enabled="1"
				else
					uci set mwan3."${cellularwan1sim1interface}".enabled="0"
				fi

				if [ "$Cwan1sim1Validtrackip" =  "1" ]
				then 
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp1"
				fi
				if [ "$Cwan1sim1Validtrackip" =  "2" ]
				then 
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp1"
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp2"
				fi
				if [ "$Cwan1sim1Validtrackip" =  "3" ]
				then 
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp1"
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp2"
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp3"
				fi
				if [ "$Cwan1sim1Validtrackip" =  "4" ]
				then 
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp1"
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp2"
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp3"
					uci add_list mwan3."${cellularwan1sim1interface}".track_ip="$Cwan1sim1TrackIp4"
				fi
			
				uci set mwan3."${cellularwan1sim1interface}".family="ipv4"
				uci set mwan3."${cellularwan1sim1interface}".reliability="$Cwan1sim1Reliability"
				uci set mwan3."${cellularwan1sim1interface}".count="$Cwan1sim1Count"
				uci set mwan3."${cellularwan1sim1interface}".timeout="2"
				uci set mwan3."${cellularwan1sim1interface}".down="$Cwan1sim1Down"
				uci set mwan3."${cellularwan1sim1interface}".up="$Cwan1sim1Up"

				#member
				uci set mwan3.cwan1sim1_member=member
				uci set mwan3.cwan1sim1_member.interface="${cellularwan1sim1interface}"
				uci set mwan3.cwan1sim1_member.metric="$Cwan1sim1Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan1sim1_member.weight="$Cwan1sim1Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v4
					uci add_list mwan3.balanced_v4.use_member="cwan1sim1_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v4
					uci add_list mwan3.failover_v4.use_member="cwan1sim1_member"
				fi
			fi
			
			#If pdp1 is ipv6
			if [ "$Pdp1" = "2" ]
			then
				
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.balanced_v6=policy
					uci set mwan3.balanced_v6.last_resort='default'				
				elif [ "$policy_type" = "failover" ]
				then
					uci set mwan3.failover_v6=policy
					uci set mwan3.failover_v6.last_resort='default'
				fi
				
				uci set mwan3."${cellular1wan6interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan6_1enabled" = "1" ]
				then
					uci set mwan3."${cellular1wan6interface}".enabled="1"
				else
					uci set mwan3."${cellular1wan6interface}".enabled="0"
				fi
				
				if [ "$Cwan6_1validtrackip" = "1" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
				fi
				if [ "$Cwan6_1validtrackip" = "2" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
				fi
				if [ "$Cwan6_1validtrackip" = "3" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp3"
				fi
				if [ "$Cwan6_1validtrackip" = "4" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp3"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp4"
				fi
				uci set mwan3."${cellular1wan6interface}".family="ipv6"
				uci set mwan3."${cellular1wan6interface}".reliability="$Cwan6_1Reliability"
				uci set mwan3."${cellular1wan6interface}".count="$Cwan6_1Count"
				uci set mwan3."${cellular1wan6interface}".timeout="2"
				uci set mwan3."${cellular1wan6interface}".down="$Cwan6_1Down"
				uci set mwan3."${cellular1wan6interface}".up="$Cwan6_1Up"
				
				uci set mwan3.cwan6_1_member=member
				uci set mwan3.cwan6_1_member.interface="${cellular1wan6interface}"
				uci set mwan3.cwan6_1_member.metric="$Cwan6_1Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan6_1_member.weight="$Cwan6_1Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v6
					uci add_list mwan3.balanced_v6.use_member="cwan6_1_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v6
					uci add_list mwan3.failover_v6.use_member="cwan6_1_member"
				fi
			fi 

			#CWAN1_1
			#If pdp2 is ipv4 or ipv4v6
			if [ "$sim2pdp" = "1" ]  || [ "$sim2pdp" = "3" ]
			then
				uci set mwan3."${cellularwan1sim2interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan1sim2enabled" = "1" ]
				then
					uci set mwan3."${cellularwan1sim2interface}".enabled="1"
				else
					uci set mwan3."${cellularwan1sim2interface}".enabled="0"
				fi
				
				if [ "$Cwan1sim2Validtrackip" =  "1" ]
				then 
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp1"
				fi
				if [ "$Cwan1sim2Validtrackip" =  "2" ]
				then 
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp1"
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp2"
				fi
				if [ "$Cwan1sim2Validtrackip" =  "3" ]
				then 
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp1"
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp2"
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp3"
				fi
				if [ "$Cwan1sim2Validtrackip" =  "4" ]
				then 
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp1"
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp2"
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp3"
					uci add_list mwan3."${cellularwan1sim2interface}".track_ip="$Cwan1sim2TrackIp4"
				fi

				uci set mwan3."${cellularwan1sim2interface}".family="ipv4"
				uci set mwan3."${cellularwan1sim2interface}".reliability="$Cwan1sim2Reliability"
				uci set mwan3."${cellularwan1sim2interface}".count="$Cwan1sim2Count"
				uci set mwan3."${cellularwan1sim2interface}".timeout="2"
				uci set mwan3."${cellularwan1sim2interface}".down="$Cwan1sim2Down"
				uci set mwan3."${cellularwan1sim2interface}".up="$Cwan1sim2Up"

				#member
				uci set mwan3.cwan1sim2_member=member
				uci set mwan3.cwan1sim2_member.interface="${cellularwan1sim2interface}"
				uci set mwan3.cwan1sim2_member.metric="$Cwan1sim2Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan1sim2_member.weight="$Cwan1sim2Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v4
					uci add_list mwan3.balanced_v4.use_member="cwan1sim2_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v4
					uci add_list mwan3.failover_v4.use_member="cwan1sim2_member"
				fi				
			fi
			
			#If pdp2 is ipv6
			if [ "$sim2pdp" = "2" ]
			then
				
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.balanced_v6=policy
					uci set mwan3.balanced_v6.last_resort='default'				
				elif [ "$policy_type" = "failover" ]
				then
					uci set mwan3.failover_v6=policy
					uci set mwan3.failover_v6.last_resort='default'
				fi
				
				uci set mwan3."${cellular2wan6interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan6_2enabled" = "1" ]
				then
					uci set mwan3."${cellular2wan6interface}".enabled="1"
				else
					uci set mwan3."${cellular2wan6interface}".enabled="0"
				fi
				
				if [ "$Cwan6_2validtrackip" = "1" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
				fi
				if [ "$Cwan6_2validtrackip" = "2" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp2"
				fi
				if [ "$Cwan6_2validtrackip" = "3" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp2"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp3"
				fi
				if [ "$Cwan6_2validtrackip" = "4" ]
				then
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp1"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp2"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp3"
					uci add_list mwan3."${cellular2wan6interface}".track_ip="$Cwan6_2TrackIp4"
				fi
				uci set mwan3."${cellular2wan6interface}".family="ipv6"
				uci set mwan3."${cellular2wan6interface}".reliability="$Cwan6_2Reliability"
				uci set mwan3."${cellular2wan6interface}".count="$Cwan6_2Count"
				uci set mwan3."${cellular2wan6interface}".timeout="2"
				uci set mwan3."${cellular2wan6interface}".down="$Cwan6_2Down"
				uci set mwan3."${cellular2wan6interface}".up="$Cwan6_2Up"
				
				uci set mwan3.cwan6_2_member=member
				uci set mwan3.cwan6_2_member.interface="${cellular2wan6interface}"
				uci set mwan3.cwan6_2_member.metric="$Cwan6_2Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan6_2_member.weight="$Cwan6_2Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v6
					uci add_list mwan3.balanced_v6.use_member="cwan6_2_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v6
					uci add_list mwan3.failover_v6.use_member="cwan6_2_member"
				fi
			fi 
		
		#singlecellularsinglesim
		else
			uci delete mwan3.cwan1_member > /dev/null 2>&1
			uci delete mwan3.cwan6_1_member > /dev/null 2>&1
			uci delete mwan3.cwan6_2_member > /dev/null 2>&1
			
			#CWAN1
			#If pdp1 is ipv4 or ipv4v6
			if [ "$Pdp1" = "1" ]  || [ "$Pdp1" = "3" ]
			then
				uci set mwan3."${cellularwan1interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan1enabled" = "1" ]
				then
					uci set mwan3."${cellularwan1interface}".enabled="1"
				else
					uci set mwan3."${cellularwan1interface}".enabled="0"
				fi

				if [ "$Cwan1Validtrackip" =  "1" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1TrackIp1"
				fi
				if [ "$Cwan1Validtrackip" =  "2" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp2"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan1TrackIp2"
				fi
				if [ "$Cwan1Validtrackip" =  "3" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp2"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp3"
				fi
				if [ "$Cwan1Validtrackip" =  "4" ]
				then 
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp1"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp2"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp3"
					uci add_list mwan3."${cellularwan1interface}".track_ip="$Cwan1TrackIp4"
				fi

				uci set mwan3."${cellularwan1interface}".family="ipv4"
				uci set mwan3."${cellularwan1interface}".reliability="$Cwan1Reliability"
				uci set mwan3."${cellularwan1interface}".count="$Cwan1Count"
				uci set mwan3."${cellularwan1interface}".timeout="2"
				uci set mwan3."${cellularwan1interface}".down="$Cwan1Down"
				uci set mwan3."${cellularwan1interface}".up="$Cwan1Up"

				#member
				uci set mwan3.cwan1_member=member
				uci set mwan3.cwan1_member.interface="${cellularwan1interface}"
				uci set mwan3.cwan1_member.metric="$Cwan1Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan1_member.weight="$Cwan1Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v4
					uci add_list mwan3.balanced_v4.use_member="cwan1_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v4
					uci add_list mwan3.failover_v4.use_member="cwan1_member"
				fi
			fi
			
			#If pdp1 is ipv6
			if [ "$Pdp1" = "2" ]
			then
				
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.balanced_v6=policy
					uci set mwan3.balanced_v6.last_resort='default'				
				elif [ "$policy_type" = "failover" ]
				then
					uci set mwan3.failover_v6=policy
					uci set mwan3.failover_v6.last_resort='default'
				fi
				
				uci set mwan3."${cellular1wan6interface}"=interface
				
				#Check mwan3 enable/disable for individual interfaces
				if [ "$Cwan6_1enabled" = "1" ]
				then
					uci set mwan3."${cellular1wan6interface}".enabled="1"
				else
					uci set mwan3."${cellular1wan6interface}".enabled="0"
				fi
				
				if [ "$Cwan6_1validtrackip" = "1" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_1TrackIp1"
				fi
				if [ "$Cwan6_1validtrackip" = "2" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress1="$Cwan6_1TrackIp1"
					uci set routerapplicationconfig.routerapplicationlocalconfigModem1.ipaddress2="$Cwan6_1TrackIp2"
				fi
				if [ "$Cwan6_1validtrackip" = "3" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp3"
				fi
				if [ "$Cwan6_1validtrackip" = "4" ]
				then
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp1"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp2"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp3"
					uci add_list mwan3."${cellular1wan6interface}".track_ip="$Cwan6_1TrackIp4"
				fi
				uci set mwan3."${cellular1wan6interface}".family="ipv6"
				uci set mwan3."${cellular1wan6interface}".reliability="$Cwan6_1Reliability"
				uci set mwan3."${cellular1wan6interface}".count="$Cwan6_1Count"
				uci set mwan3."${cellular1wan6interface}".timeout="2"
				uci set mwan3."${cellular1wan6interface}".down="$Cwan6_1Down"
				uci set mwan3."${cellular1wan6interface}".up="$Cwan6_1Up"
				
				uci set mwan3.cwan6_1_member=member
				uci set mwan3.cwan6_1_member.interface="${cellular1wan6interface}"
				uci set mwan3.cwan6_1_member.metric="$Cwan6_1Priority"
				
				#Add weight only when policy is balanced.
				if [ "$policy_type" = "balanced" ]
				then
					uci set mwan3.cwan6_1_member.weight="$Cwan6_1Weight"
				fi

				if [ "$policy_type" = "balanced" ]
				then
					#balanced_v6
					uci add_list mwan3.balanced_v6.use_member="cwan6_1_member"
				elif [ "$policy_type" = "failover" ]
				then
					#failover_v6
					uci add_list mwan3.failover_v6.use_member="cwan6_1_member"
				fi
			fi			
		fi
	
	#If EnableCellular is 0.
	else
		uci delete mwan3.cwan1sim1_member > /dev/null 2>&1
		uci delete mwan3.cwan1sim2_member > /dev/null 2>&1
		uci delete mwan3.cwan1_member > /dev/null 2>&1
		uci delete mwan3.cwan2_member > /dev/null 2>&1
		uci delete mwan3.cwan6_1_member > /dev/null 2>&1
		uci delete mwan3.cwan6_2_member > /dev/null 2>&1
		uci delete mwan3."${cellularwan1interface}"
		uci delete mwan3."${cellularwan1sim1interface}"
		uci delete mwan3."${cellularwan1sim2interface}"
		uci delete mwan3."${cellularwan2interface}"
		uci delete mwan3."${cellular1wan6interface}"
		uci delete mwan3."${cellular2wan6interface}"
	fi
	uci commit mwan3
	uci commit routerapplicationconfig	
}

UpdateMwanConfig()
{
	read_interface="$1"
	
	if [ "$read_interface" != "CWAN1" ] && [ "$read_interface" != "CWAN2" ] && [ "$read_interface" != "CWAN1_0" ] && [ "$read_interface" != "CWAN1_1" ] && [ "$read_interface" != "WIFI_WAN" ]
	then
		config_get name "$read_interface" name
		config_get wanpriority "$read_interface" wanpriority
		config_get wanweight "$read_interface" wanweight
		config_get enabled "$read_interface" enabled
		config_get trackIp1 "$read_interface" trackIp1
		config_get trackIp2 "$read_interface" trackIp2
		config_get trackIp3 "$read_interface" trackIp3
		config_get trackIp4 "$read_interface" trackIp4
		config_get reliability "$read_interface" reliability 
		config_get count "$read_interface" count
		config_get up "$read_interface" up
		config_get down "$read_interface" down
		config_get validtrackip "$read_interface" validtrackip
		
		#Add weight only when policy is balanced.
		if [ "$policy_type" = "balanced" ]
		then
			uci set mwan3.balanced_v4=policy
			uci set mwan3.balanced_v4.last_resort='default'
			#change default_rule as well
			uci set mwan3.default_rule_v4.use_policy='balanced_v4'
			uci set mwan3.default_rule_v6.use_policy='balanced_v6'
		elif [ "$policy_type" = "failover" ]
		then
			#Now create all depending on the user input.
			uci set mwan3.failover_v4=policy
			uci set mwan3.failover_v4.last_resort='default'
			#change default_rule as well
			uci set mwan3.default_rule_v4.use_policy='failover_v4'
			uci set mwan3.default_rule_v6.use_policy='failover_v6'
		fi
		
		uci set mwan3."${name}"=interface
		
		#Check mwan3 enable/disable for individual interfaces
		if [ "$enabled" = "1" ]
		then
			uci set mwan3."${name}".enabled="1"
		else
			uci set mwan3."${name}".enabled="0"
		fi
		
		#Check for validtrackip.
		if [ "$validtrackip" =  "1" ]
		then 
			uci add_list mwan3."${name}".track_ip="$trackIp1"
		fi
		if [ "$validtrackip" =  "2" ]
		then 
			uci add_list mwan3."${name}".track_ip="$trackIp1"
			uci add_list mwan3."${name}".track_ip="$trackIp2"
		fi
		if [ "$validtrackip" =  "3" ]
		then 
			uci add_list mwan3."${name}".track_ip="$trackIp1"
			uci add_list mwan3."${name}".track_ip="$trackIp2"
			uci add_list mwan3."${name}".track_ip="$trackIp3"
		fi
		if [ "$validtrackip" =  "4" ]
		then 
			uci add_list mwan3."${name}".track_ip="$trackIp1"
			uci add_list mwan3."${name}".track_ip="$trackIp2"
			uci add_list mwan3."${name}".track_ip="$trackIp3"
			uci add_list mwan3."${name}".track_ip="$trackIp4"
		fi
		
		uci set mwan3."${name}".family="ipv4"
		uci set mwan3."${name}".reliability="$reliability"
		uci set mwan3."${name}".count="$count"
		uci set mwan3."${name}".timeout="2"
		uci set mwan3."${name}".down="$down"
		uci set mwan3."${name}".up="$up"
		
		#member
		uci set mwan3.${name}_member=member
		uci set mwan3.${name}_member.interface="${name}"
		
		#Add weight only when policy is balanced.
		if [ "$policy_type" = "balanced" ]
		then
			uci set mwan3.${name}_member.metric="1"
			uci set mwan3.${name}_member.weight="$wanweight"
		else
			uci set mwan3.${name}_member.metric="$wanpriority"
		fi
		
		if [ "$policy_type" = "balanced" ]
		then
			#balanced_v4
			uci add_list mwan3.balanced_v4.use_member="${name}_member"
		elif [ "$policy_type" = "failover" ]
		then
			#failover_v4
			uci add_list mwan3.failover_v4.use_member="${name}_member"
		fi
	
	fi
	
	uci commit mwan3

}

UpdateWirelessConfig()
{
	# 1 is for enable; 0 for disable
	if [ "$wifi1enable" = "1" ]
	then
		uci delete network."${wifiinterface}" > /dev/null 2>&1
		uci delete network."${wifi5interface}" > /dev/null 2>&1
		uci delete network."${wifiwaninterface}" > /dev/null 2>&1
		
		#Depending on the wifimode, only 2.4GHZ changes. 5GhZ is always in AP mode.
		#AP
		if [ "$wifi1mode" = "ap" ]
		then
				
			#txpower
			txpower=$(grep -w "TxPower" ${wirelessdatfile})        
			txpower_replace="TxPower=$TxPower"
			sed -i "s/${txpower}/${txpower_replace}/" "$wirelessdatfile"
			
			#countrycode
			countrycode=$(grep -w "CountryCode" ${wirelessdatfile})        
			countrycode_replace="CountryCode=$CountryCode"
			sed -i "s/${countrycode}/${countrycode_replace}/" "$wirelessdatfile"
			
			#channel
			channel=$(grep -w "Channel" ${wirelessdatfile})        
			Channel_replace="Channel=$WifiDevicesChannel"
			sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"

			#ssid
			ssid=$(grep -w "SSID1" ${wirelessdatfile})        
			ssid_replace="SSID1=$Wifi1Ssid"
			sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"
			
			#Psk
			wpapsk=$(grep -w "WPAPSK1" ${wirelessdatfile})        
			wpapsk_replace="WPAPSK1=$Wifi1Key"
			sed -i "s/${wpapsk}/${wpapsk_replace}/" "$wirelessdatfile"
			
			#CountryRegion
			CountryRegion=$(grep -w "CountryRegion" ${wirelessdatfile})        
			CountryRegion_replace="CountryRegion=$wifi1CountryRegion"
			sed -i "s/${CountryRegion}/${CountryRegion_replace}/" "$wirelessdatfile"
			
			#If the encryption is none then the AUTHMODE should be remine empty in the dat file 
			if [ "$Wifi1Encryption" = "NONE" ]
			then
				#AuthMode
				AuthMode=$(grep -w "AuthMode" ${wirelessdatfile})        
				AuthMode_replace="AuthMode= "
				sed -i "s/${AuthMode}/${AuthMode_replace}/" "$wirelessdatfile"
			else
				if [ "$guestwifienable2" = "1" ]
				then
				#guestAuthMode
				AuthMode=$(grep -w "AuthMode" ${wirelessdatfile})        
				AuthMode_replace="AuthMode=WPA2PSK;WPA2PSK"
				sed -i "s/${AuthMode}/${AuthMode_replace}/" "$wirelessdatfile"
				else
				#AuthMode
				AuthMode=$(grep -w "AuthMode" ${wirelessdatfile})        
				AuthMode_replace="AuthMode=WPA2PSK"
				sed -i "s/${AuthMode}/${AuthMode_replace}/" "$wirelessdatfile"
				fi
			fi
			if [ "$guestwifienable2" = "1" ]
			then
				#EncrypType
				EncrypType=$(grep -w "EncrypType" ${wirelessdatfile})        
				EncrypType_replace="EncrypType=$Wifi1Encryption;$Wifi1Encryption"
				sed -i "s/${EncrypType}/${EncrypType_replace}/" "$wirelessdatfile"
			else
				#EncrypType
				EncrypType=$(grep -w "EncrypType" ${wirelessdatfile})        
				EncrypType_replace="EncrypType=$Wifi1Encryption"
				sed -i "s/${EncrypType}/${EncrypType_replace}/" "$wirelessdatfile"
			fi
			#ht_bw
			ht_bw=$(grep -w "HT_BW" ${wirelessdatfile})        
			ht_bw_replace="HT_BW=$channelwidth"
			sed -i "s/${ht_bw}/${ht_bw_replace}/" "$wirelessdatfile"
			
			#WirelessMode
			WirelessMode=$(grep -w "WirelessMode" ${wirelessdatfile})        
			WirelessMode_replace="WirelessMode=$wifi1protocol"
			sed -i "s/${WirelessMode}/${WirelessMode_replace}/" "$wirelessdatfile"
			
			#disable sta when ap is enabled
			uci set wireless."${wifista}".disabled="1"
			
			#ApCliEnable/disable
			#Replacing ApCliEnable value with empty value in dat file disables station mode.
			ApCliEnable=$(grep -w "ApCliEnable" ${wirelessdatfile})        
			ApCliEnable_replace="ApCliEnable="
			sed -i "s/${ApCliEnable}/${ApCliEnable_replace}/" "$wirelessdatfile"	
					
			#The value of ApCliAuthMode should change, because the AuthMode of the 2.4ghz is replacing the value of the ApCliAuthMode
			#Why, because the sed command is replacing the value for both AuthMode and ApCliAuthMode
			#so, that we changing the value of the ApCliAuthMode to which ever the value user has configured.
			#ApCliAuthMode
			ApCliAuthMode=$(grep -w "ApCliAuthMode" ${wirelessdatfile})        
			ApCliAuthMode_replace="ApCliAuthMode=$wifistaauth"
			sed -i "s/${ApCliAuthMode}/${ApCliAuthMode_replace}/" "$wirelessdatfile"
			
			#wifi - 2.4GHZ
			#NETWORK
			uci set network."${wifiinterface}"=interface
			uci set network."${wifiinterface}".netmask="255.255.255.0"
			uci set network."${wifiinterface}".ipaddr="$Radio0DhcpIp"
			uci set network."${wifiinterface}".proto="static"
			uci set network."${wifiinterface}".ifname="ra0"
			
			#Wireless
			#hwmode changed to band
			uci set wireless."${wifiinterface}"="wifi-device"
			uci set wireless."${wifiinterface}".type="mac80211"
			uci set wireless."${wifiinterface}".path="1e140000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0"
			uci set wireless."${wifiinterface}".variant="mt7603e"
			uci set wireless."${wifiinterface}".channel="$WifiDevicesChannel"
			uci set wireless."${wifiinterface}".band="2g"
			uci set wireless."${wifiinterface}".htmode="$channelwidth"
			uci set wireless."${wifiinterface}".disabled="0"
			uci set wireless."${wifiinterface}".country="$CountryCode"
			uci set wireless."${wifiinterface}".txpower="$TxPower"

			uci set wireless."${wifiap}"="wifi-iface"
			uci set wireless."${wifiap}".device="ra0"
			uci set wireless."${wifiap}".mode="ap"
			uci set wireless."${wifiap}".network="ra0"
			uci set wireless."${wifiap}".ifname="ra0"
			uci set wireless."${wifiap}".disabled="0"
			uci set wireless."${wifiap}".key="$Wifi1Key"
			uci set wireless."${wifiap}".encryption="$Wifi1Encryption"
			uci set wireless."${wifiap}".ssid="$Wifi1Ssid"
	
		#STATION
		elif [ "$wifi1mode" =  "sta" ]
		then
			#disable 2.4Ghz Guest wifi
			uci set sysconfig.guestwifi.guestwifienable2='0'
			uci commit sysconfig
			#for station mode the channel for both server board and the client board which is set to sta should be same.
			iwpriv ra0 set SiteSurvey=0
			
			#It takes time to load. Hence, sleep is used. 
			#The channel will be replaced according to device that provides AP to this device.
			#Because both the boards must have same channel, otherwise it will not connect.
			sleep 2
			
			WifiDevicesChannel=$(iwpriv ra0 get_site_survey | grep -i "$wifistassid" | awk '{print $1}')
			
			sleep 2
			
			#ApCliAuthMode
			ApCliAuthMode=$(grep -w "ApCliAuthMode" ${wirelessdatfile})        
			ApCliAuthMode_replace="ApCliAuthMode=$wifistaauth"
			sed -i "s/${ApCliAuthMode}/${ApCliAuthMode_replace}/" "$wirelessdatfile"
								
			#channel
			channel=$(grep -w "Channel" ${wirelessdatfile})        
			Channel_replace="Channel=$WifiDevicesChannel"
			sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"
			
			#BSSID
			BssidNum=$(grep -w "BssidNum" ${wirelessdatfile})        
			BssidNum_replace="BssidNum=4"
			sed -i "s/${BssidNum}/${BssidNum_replace}/" "$wirelessdatfile"
			
			#ApCliEnable
			ApCliEnable=$(grep -w "ApCliEnable" ${wirelessdatfile})        
			ApCliEnable_replace="ApCliEnable=1"
			sed -i "s/${ApCliEnable}/${ApCliEnable_replace}/" "$wirelessdatfile"
			
			#ApCliWPAPSK
			ApCliWPAPSK=$(grep -w "ApCliWPAPSK" ${wirelessdatfile})        
			ApCliWPAPSK_replace="ApCliWPAPSK=$wifistakey"
			sed -i "s/${ApCliWPAPSK}/${ApCliWPAPSK_replace}/" "$wirelessdatfile"
			
			#wifistaencryption
			ApCliEncrypType=$(grep -w "ApCliEncrypType" ${wirelessdatfile})        
			ApCliEncrypType_replace="ApCliEncrypType=$wifistaencryption"
			sed -i "s/${ApCliEncrypType}/${ApCliEncrypType_replace}/" "$wirelessdatfile"
			
			#wifistassid
			ApCliSsid=$(grep -w "ApCliSsid" ${wirelessdatfile})        
			ApCliSsid_replace="ApCliSsid=$wifistassid"
			sed -i "s/${ApCliSsid}/${ApCliSsid_replace}/" "$wirelessdatfile"
			
			#disable ap when sta is enabled
			uci set wireless."${wifiap}".disabled="1"
			
			#wifi - 2.4GHZ
			#network
			uci set network."${wifiwaninterface}"=interface
			uci set network."${wifiwaninterface}".proto="dhcp"
			uci set network."${wifiwaninterface}".ifname="apcli0"
			
			if [ "$policy_type" = "balanced" ]
			then
				uci set network."${wifiwaninterface}".metric="1"
			elif [ "$policy_type" = "failover" ]
			then
				uci set network."${wifiwaninterface}".metric="$WifiwanPriority"
			fi
						
			#Wireless
			uci set wireless."${wifista}"="wifi-iface"
			uci set wireless."${wifista}".device="ra0"
			uci set wireless."${wifista}".mode="sta"
			uci set wireless."${wifista}".network="$wifiwaninterface"
			uci set wireless."${wifista}".ifname="apcli0"
			uci set wireless."${wifista}".disabled="0"
			uci set wireless."${wifista}".key="$wifistakey"
			uci set wireless."${wifista}".encryption="$wifistaencryption"
			uci set wireless."${wifista}".ssid="$wifistassid"

		#AP with STA
		elif [ "$wifi1mode" =  "apsta" ]
		then
			#for station mode the channel for both server board and the client board which is set to sta should be same. 
			iwpriv ra0 set SiteSurvey=0
			
			#It takes time to load. Hence, sleep is used. 
			#The channel will be replaced according to device that provides AP to this device.
			#Because both the boards must have same channel, otherwise it will not connect.
			sleep 2
			
			WifiDevicesChannel=$(iwpriv ra0 get_site_survey | grep -i "$wifistassid" | awk '{print $1}')
			
			sleep 2

			#AP config in dat file
			#txpower
			txpower=$(grep -w "TxPower" ${wirelessdatfile})        
			txpower_replace="TxPower=$TxPower"
			sed -i "s/${txpower}/${txpower_replace}/" "$wirelessdatfile"
			
			#countrycode
			countrycode=$(grep -w "CountryCode" ${wirelessdatfile})        
			countrycode_replace="CountryCode=$CountryCode"
			sed -i "s/${countrycode}/${countrycode_replace}/" "$wirelessdatfile"
			
			#channel
			channel=$(grep -w "Channel" ${wirelessdatfile})        
			Channel_replace="Channel=$WifiDevicesChannel"
			sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"

			#ssid
			ssid=$(grep -w "SSID1" ${wirelessdatfile})        
			ssid_replace="SSID1=$Wifi1Ssid"
			sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"
			
			#Psk
			wpapsk=$(grep -w "WPAPSK1" ${wirelessdatfile})        
			wpapsk_replace="WPAPSK1=$Wifi1Key"
			sed -i "s/${wpapsk}/${wpapsk_replace}/" "$wirelessdatfile"
			
			#CountryRegion
			CountryRegion=$(grep -w "CountryRegion" ${wirelessdatfile})        
			CountryRegion_replace="CountryRegion=$wifi1CountryRegion"
			sed -i "s/${CountryRegion}/${CountryRegion_replace}/" "$wirelessdatfile"
			
			#ht_bw
			ht_bw=$(grep -w "HT_BW" ${wirelessdatfile})        
			ht_bw_replace="HT_BW=$channelwidth"
			sed -i "s/${ht_bw}/${ht_bw_replace}/" "$wirelessdatfile"
			
			#WirelessMode
			WirelessMode=$(grep -w "WirelessMode" ${wirelessdatfile})        
			WirelessMode_replace="WirelessMode=$wifi1protocol"
			sed -i "s/${WirelessMode}/${WirelessMode_replace}/" "$wirelessdatfile"
			
			#STA config in dat file
			#ApCliAuthMode
			ApCliAuthMode=$(grep -w "ApCliAuthMode" ${wirelessdatfile})        
			ApCliAuthMode_replace="ApCliAuthMode=$wifistaauth"
			sed -i "s/${ApCliAuthMode}/${ApCliAuthMode_replace}/" "$wirelessdatfile"
								
			#channel
			channel=$(grep -w "Channel" ${wirelessdatfile})        
			Channel_replace="Channel=$WifiDevicesChannel"
			sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"
			
			#BSSID
			BssidNum=$(grep -w "BssidNum" ${wirelessdatfile})        
			BssidNum_replace="BssidNum=4"
			sed -i "s/${BssidNum}/${BssidNum_replace}/" "$wirelessdatfile"
			
			#ApCliEnable
			ApCliEnable=$(grep -w "ApCliEnable" ${wirelessdatfile})        
			ApCliEnable_replace="ApCliEnable=1"
			sed -i "s/${ApCliEnable}/${ApCliEnable_replace}/" "$wirelessdatfile"
			
			#ApCliWPAPSK
			ApCliWPAPSK=$(grep -w "ApCliWPAPSK" ${wirelessdatfile})        
			ApCliWPAPSK_replace="ApCliWPAPSK=$wifistakey"
			sed -i "s/${ApCliWPAPSK}/${ApCliWPAPSK_replace}/" "$wirelessdatfile"
			
			#wifistaencryption
			ApCliEncrypType=$(grep -w "ApCliEncrypType" ${wirelessdatfile})        
			ApCliEncrypType_replace="ApCliEncrypType=$wifistaencryption"
			sed -i "s/${ApCliEncrypType}/${ApCliEncrypType_replace}/" "$wirelessdatfile"
			
			#wifistassid
			ApCliSsid=$(grep -w "ApCliSsid" ${wirelessdatfile})        
			ApCliSsid_replace="ApCliSsid=$wifistassid"
			sed -i "s/${ApCliSsid}/${ApCliSsid_replace}/" "$wirelessdatfile"
			
			#wifi AP - 2.4GHZ	
			#NETWORK
			uci set network."${wifiinterface}"=interface
			uci set network."${wifiinterface}".netmask="255.255.255.0"
			uci set network."${wifiinterface}".ipaddr="$Radio0DhcpIp"
			uci set network."${wifiinterface}".proto="static"
			uci set network."${wifiinterface}".ifname="ra0"
			
			#Wireless
			#hwmode changed to band
			uci set wireless."${wifiinterface}"="wifi-device"
			uci set wireless."${wifiinterface}".type="mac80211"
			uci set wireless."${wifiinterface}".path="1e140000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0"
			uci set wireless."${wifiinterface}".variant="mt7603e"
			uci set wireless."${wifiinterface}".channel="$WifiDevicesChannel"
			uci set wireless."${wifiinterface}".band="2g"
			uci set wireless."${wifiinterface}".htmode="$channelwidth"
			uci set wireless."${wifiinterface}".disabled="0"
			uci set wireless."${wifiinterface}".country="$CountryCode"
			uci set wireless."${wifiinterface}".txpower="$TxPower"

			uci set wireless."${wifiap}"="wifi-iface"
			uci set wireless."${wifiap}".device="ra0"
			uci set wireless."${wifiap}".mode="ap"
			uci set wireless."${wifiap}".network="ra0"
			uci set wireless."${wifiap}".ifname="ra0"
			uci set wireless."${wifiap}".disabled="0"
			uci set wireless."${wifiap}".key="$Wifi1Key"
			uci set wireless."${wifiap}".encryption="$Wifi1Encryption"
			uci set wireless."${wifiap}".ssid="$Wifi1Ssid"
			
			#wifi STA - 2.4GHZ
			#network
			uci set network."${wifiwaninterface}"=interface
			uci set network."${wifiwaninterface}".proto="dhcp"
			uci set network."${wifiwaninterface}".ifname="apcli0"
			
			if [ "$policy_type" = "balanced" ]
			then
				uci set network."${wifiwaninterface}".metric="1"
			elif [ "$policy_type" = "failover" ]
			then
				uci set network."${wifiwaninterface}".metric="$WifiwanPriority"
			fi
						
			#wireless
			uci set wireless."${wifista}"="wifi-iface"
			uci set wireless."${wifista}".device="ra0"
			uci set wireless."${wifista}".mode="sta"
			uci set wireless."${wifista}".network="$wifiwaninterface"
			uci set wireless."${wifista}".ifname="apcli0"
			uci set wireless."${wifista}".disabled="0"
			uci set wireless."${wifista}".key="$wifistakey"
			uci set wireless."${wifista}".encryption="$wifistaencryption"
			uci set wireless."${wifista}".ssid="$wifistassid"
			
		fi
		
		#wifi - 2.4GHZ
		#DHCP
		if [ "$enable_dhcpserver" = "1" ]
		then
			uci set dhcp."${wifiinterface}"="dhcp"
			uci set dhcp."${wifiinterface}".interface="${wifiinterface}"
			uci set dhcp."${wifiinterface}".dhcpv4="server"
			uci set dhcp."${wifiinterface}".dhcpv6="disabled"
			uci set dhcp."${wifiinterface}".ra="disabled"
			uci set dhcp."${wifiinterface}".leasetime="$wifi2leasetime$wifi2leasetime_duration"
			uci set dhcp."${wifiinterface}".start="$Radio0DHCPRange"
			uci set dhcp."${wifiinterface}".limit="$Radio0DHCPLimit"
		else
			uci set dhcp."${wifiinterface}".dhcpv4="disabled"
		fi
		
		#wifi - 5GHZ	
		#DHCP
		if [ "$wifi5enable_dhcpserver" = "1" ]
		then
			uci set dhcp."${wifi5interface}"="dhcp"
			uci set dhcp."${wifi5interface}".interface="${wifi5interface}"
			uci set dhcp."${wifi5interface}".dhcpv4="server"
			uci set dhcp."${wifi5interface}".dhcpv6="disabled"
			uci set dhcp."${wifi5interface}".ra="disabled"
			uci set dhcp."${wifi5interface}".leasetime="$wifi5leasetime$wifi5leasetime_duration"
			uci set dhcp."${wifi5interface}".limit="$wifi5Radio0DHCPlimit"
			uci set dhcp."${wifi5interface}".start="$wifi5Radio0DHCPrange"
		else
			uci set dhcp."${wifi5interface}".dhcpv4="disabled"
		fi
		
		#NETWORK
		uci set network."${wifi5interface}"=interface
		uci set network."${wifi5interface}".netmask="255.255.255.0"
		uci set network."${wifi5interface}".ipaddr="$wifi5radio0dhcpip"
		uci set network."${wifi5interface}".proto="static"
		uci set network."${wifi5interface}".ifname="wlan0"
		
		#Wireless
		#hwmode changed to band
		uci set wireless."${wifi5interface}"="wifi-device"
		uci set wireless."${wifi5interface}".type="mac80211"
		uci set wireless."${wifi5interface}".path="1e140000.pcie/pci0000:00/0000:00:01.0/0000:02:00.0"
		uci set wireless."${wifi5interface}".variant="mt7663"
		uci set wireless."${wifi5interface}".channel="$wifi5deviceschannel"
		uci set wireless."${wifi5interface}".band="5g"
		uci set wireless."${wifi5interface}".htmode="$wifi5channelwidth"
		uci set wireless."${wifi5interface}".disabled="0"
		uci set wireless."${wifi5interface}".country="$wifi5CountryCode"
		uci set wireless."${wifi5interface}".txpower="$wifi5TxPower"

		uci set wireless."${wifi5ap}"="wifi-iface"
		uci set wireless."${wifi5ap}".device="rai0"
		uci set wireless."${wifi5ap}".mode="ap"
		uci set wireless."${wifi5ap}".network="rai0"
		uci set wireless."${wifi5ap}".ifname="wlan0"
		uci set wireless."${wifi5ap}".disabled="0"
		uci set wireless."${wifi5ap}".key="$wifi5key"
		uci set wireless."${wifi5ap}".encryption="$wifi5encryption"
		uci set wireless."${wifi5ap}".ssid="$wifi5ssid"	
		wifi5ghz_mac_addr=$(uci get boardconfig.board.wifi5ghzmacid)	
		uci set wireless."${wifi5ap}".macaddr="$wifi5ghz_mac_addr"	
		
		#2.4GHz Guest wifi		
		if [ "$guestwifienable2" = "1" ]
		then
			#NETWORK
			uci set network."${wifiap1}"="interface"
			uci set network."${wifiap1}".netmask="255.255.255.0"
			uci set network."${wifiap1}".ipaddr="$guestradio0dhcpip2"
			uci set network."${wifiap1}".proto="static"
			uci set network."${wifiap1}".ifname="ra1"
			
			#WIRELESS
			uci set wireless.ra1_ap="wifi-iface"
			uci set wireless.ra1_ap.device="ra0"
			uci set wireless.ra1_ap.mode="ap"
			uci set wireless.ra1_ap.network="ra1"
			uci set wireless.ra1_ap.ifname="ra1"
			uci set wireless.ra1_ap.disabled="0"
			uci set wireless.ra1_ap.key="$guestwifikey2"
			uci set wireless.ra1_ap.encryption="$Wifi1Encryption"
			uci set wireless.ra1_ap.ssid="$guestwifissid2"
			
			#DHCP
			uci set dhcp."${wifiap1}"="dhcp"
			uci set dhcp."${wifiap1}".interface="${wifiap1}"
			uci set dhcp."${wifiap1}".leasetime="12h"
			uci set dhcp."${wifiap1}".dhcpv6="server"
			uci set dhcp."${wifiap1}".ra="server"
			uci set dhcp."${wifiap1}".limit="$guestRadio0DHCPlimit2"
			uci set dhcp."${wifiap1}".start="$guestRadio0DHCPrange2"
			
			#WIRELESSDATFILE
			bssid=$(grep -w "BssidNum" ${wirelessdatfile}) 
			#bssid is 3 b'cause 2.4G hz has 3 interface such as ra0, ra1, apcli0       
			bssid_replace="BssidNum=4"
			sed -i "s/${bssid}/${bssid_replace}/" "$wirelessdatfile"
			ssid=$(grep -w "SSID2" ${wirelessdatfile})        
			ssid_replace="SSID2=$guestwifissid2"
			sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"
			WPAPSK2=$(grep -w "WPAPSK2" ${wirelessdatfile})        
			WPAPSK2_replace="WPAPSK2=$guestwifikey2"
			sed -i "s/${WPAPSK2}/${WPAPSK2_replace}/" "$wirelessdatfile"
			#WdsEncrypType1=$(grep -w "WdsEncrypType" ${wirelessdatfile})        
			#WdsEncrypType1_replace="WdsEncrypType=$guestwifi1encryption2"
			#sed -i "s/${WdsEncrypType1}/${WdsEncrypType1_replace}/" "$wirelessdatfile"
		else
			uci delete network."${wifiap1}" > /dev/null 2>&1
			uci delete wireless.ra1_ap > /dev/null 2>&1
			uci delete dhcp."${wifiap1}" > /dev/null 2>&1
			bssid=$(grep -w "BssidNum" ${wirelessdatfile})        
			bssid_replace="BssidNum=4"
			sed -i "s/${bssid}/${bssid_replace}/" "$wirelessdatfile"
		fi
		#guest wifi5
		if [ "$guestwifienable5" = "1" ]
		then
			#NETWORK
			uci set network."${wifiap51}"=interface
			uci set network."${wifiap51}".netmask="255.255.255.0"
			uci set network."${wifiap51}".ipaddr="$guestradio0dhcpip5"
			uci set network."${wifiap51}".proto="static"
			uci set network."${wifiap51}".ifname="wlan1"
			
			#DHCP
			uci set dhcp."${wifiap51}"="dhcp"
			uci set dhcp."${wifiap51}".interface="${wifiap51}"
			uci set dhcp."${wifiap51}".leasetime="12h"
			uci set dhcp."${wifiap51}".dhcpv6="server"
			uci set dhcp."${wifiap51}".ra="server"		
			uci set dhcp."${wifiap51}".limit="$guestRadio0DHCPlimit5"
			uci set dhcp."${wifiap51}".start="$guestRadio0DHCPrange5"
			
			#WIRELESS
			uci set wireless.rai1_ap="wifi-iface"
			uci set wireless.rai1_ap.device='rai0'
			uci set wireless.rai1_ap.mode='ap'
			uci set wireless.rai1_ap.network='rai1'
			uci set wireless.rai1_ap.ifname='wlan1'
			uci set wireless.rai1_ap.disabled='0'
			uci set wireless.rai1_ap.key="$guestwifikey5"
			uci set wireless.rai1_ap.encryption="$wifi5encryption"
			uci set wireless.rai1_ap.ssid="$guestwifissid5"
		
			# Original MAC address
			original_mac="$wifi5ghz_mac_addr"
			# Desired 4th byte
			new_byte='90'
			# Use sed to replace the 4th byte
			new_mac=$(echo $original_mac | sed 's/^\(..:..:..:\)..\(.*\)/\1'"$new_byte"'\2/')
			# Print the new MAC address
			echo $new_mac
			uci set wireless.rai1_ap.macaddr="$new_mac"

		else
			uci delete network."${wifiap51}" > /dev/null 2>&1
			uci delete wireless.rai1_ap > /dev/null 2>&1
			uci delete dhcp."${wifiap51}" > /dev/null 2>&1
		fi
		
		#########
		# BRIDGE
		#########
		#Create bridge.
		
		if [ "$wifienable_bridge" = "1" ]
		then
			#AP
			if [ "$wifi1mode" = "ap" ]
			then
				uci set network."${wifiinterface}".type='bridge'
				uci set network."${wifiinterface}".ifname="ra0 wlan0"

				uci set wireless."${wifiap}".network="$wifiinterface"
			fi
		fi
			
	else
		uci delete network."${wifiinterface}" > /dev/null 2>&1
		uci delete network."${wifi5interface}" > /dev/null 2>&1
		uci delete network."${wifiwaninterface}" > /dev/null 2>&1
		uci delete dhcp."${wifiinterface}" > /dev/null 2>&1
		uci delete dhcp."${wifi5interface}" > /dev/null 2>&1
		uci set wireless."${wifiinterface}".disabled="1"
		uci set wireless."${wifiap}".disabled="1"
		uci set wireless."${wifi5interface}".disabled="1"
		uci set wireless."${wifi5ap}".disabled="1"
		
		#Guest WiFi
		uci delete network."${wifiap51}" > /dev/null 2>&1
		uci delete wireless.rai1_ap > /dev/null 2>&1
		uci delete dhcp."${wifiap51}" > /dev/null 2>&1\
		uci delete wireless.ra1_ap > /dev/null 2>&1
		uci delete dhcp."${wifiap1}" > /dev/null 2>&1
		bssid=$(grep -w "BssidNum" ${wirelessdatfile})        
		bssid_replace="BssidNum=2"
		sed -i "s/${bssid}/${bssid_replace}/" "$wirelessdatfile"
		uci set sysconfig.guestwifi.guestwifienable2='0'
		uci set sysconfig.guestwifi.guestwifienable5='0'

		#ApCliEnable/disable
		#Replacing ApCliEnable value with empty value in dat file disables station mode.
		ApCliEnable=$(grep -w "ApCliEnable" ${wirelessdatfile})        
		ApCliEnable_replace="ApCliEnable="
		sed -i "s/${ApCliEnable}/${ApCliEnable_replace}/" "$wirelessdatfile"
	fi
	
	uci commit wireless
	uci commit sysconfig
	uci commit network
	uci commit dhcp

}

UpdateScheduledWifiOnOff() {	
	CronReadListValuesMaintenanceReboot() {
		local value="$1"
		local VarName="$2"
		echo "var is $VarName"
		echo "value is $value"
		eval TmpVal="\$ListValue$VarName"
		eval ListValue"$VarName"="${TmpVal}${value},"
	}

	# Initialize variables
	ListValuefromHours=""
	ListValuefromMinutes=""
	ListValuetoHours=""
	ListValuetoMinutes=""
	ListValueDayOfWeek=""

	# Remove existing scheduled wifi on/off cron jobs
	sed -i '/\/root\/InterfaceManager\/script\/ScheduledWifiOff.sh/d' /etc/crontabs/root
	sed -i '/\/root\/InterfaceManager\/script\/ScheduledWifiOn.sh/d' /etc/crontabs/root
	
	if [ "$ScheduledOnOff" = "1" ]; then
		config_load "$SystemConfigFile"
		
		# Populate variables
		config_list_foreach "wirelessschedule" fromHours CronReadListValuesMaintenanceReboot fromHours
		config_list_foreach "wirelessschedule" fromMinutes CronReadListValuesMaintenanceReboot fromMinutes
		config_list_foreach "wirelessschedule" toHours CronReadListValuesMaintenanceReboot toHours
		config_list_foreach "wirelessschedule" toMinutes CronReadListValuesMaintenanceReboot toMinutes
		config_list_foreach "wirelessschedule" DayOfWeek CronReadListValuesMaintenanceReboot DayOfWeek

		# Debugging: Print the collected values
		echo "Collected fromHours: $ListValuefromHours"
		echo "Collected fromMinutes: $ListValuefromMinutes"
		echo "Collected toHours: $ListValuetoHours"
		echo "Collected toMinutes: $ListValuetoMinutes"
		echo "Collected DayOfWeek: $ListValueDayOfWeek"

		ListValfromHours=$(echo "$ListValuefromHours" | sed 's/,$//')
		ListValfromMinutes=$(echo "$ListValuefromMinutes" | sed 's/,$//')
		ListValtoHours=$(echo "$ListValuetoHours" | sed 's/,$//')
		ListValtoMinutes=$(echo "$ListValuetoMinutes" | sed 's/,$//')
		ListValDayOfWeek=$(echo "$ListValueDayOfWeek" | sed 's/,$//')

		# Debugging: Print the final values
		echo "Final fromHours: $ListValfromHours"
		echo "Final fromMinutes: $ListValfromMinutes"
		echo "Final toHours: $ListValtoHours"
		echo "Final toMinutes: $ListValtoMinutes"
		echo "Final DayOfWeek: $ListValDayOfWeek"

		# Adding the cron jobs for scheduled wifi on and off
		echo "$ListValfromMinutes $ListValfromHours * * $ListValDayOfWeek /root/InterfaceManager/script/ScheduledWifiOff.sh" >> /etc/crontabs/root
		echo "$ListValtoMinutes $ListValtoHours * * $ListValDayOfWeek /root/InterfaceManager/script/ScheduledWifiOn.sh" >> /etc/crontabs/root
	else
		# Ensure any existing entries are removed
		sed -i '/\/root\/InterfaceManager\/script\/ScheduledWifiOff.sh/d' /etc/crontabs/root
		sed -i '/\/root\/InterfaceManager\/script\/ScheduledWifiOn.sh/d' /etc/crontabs/root
	fi
}

UpdateNetworkConfig()
{
	#For medha
	/root/InterfaceManager/script/features/captive_portal/for_medha.sh
	#Go to Network_interface for ethernet configurations.
	/root/InterfaceManager/script/Network_Interface.sh
	
    ubus call firewall reload
    ubus call dhcp reload
    ubus call network reload
}

UpdateModemConfig()
{
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
		######################################################
		#change the Modem Status depending on the cellularmode. 	
		#below line is included in systemboot.sh as well. 
		cp /www/luci2/view/modemstatus1 /www/luci2/view/diagnostics.modemstatus.js
		######################################################
		#change the Monitor Application depending on the cellularmode. 	
		#below line is included in systemboot.sh as well. 
		cp /www/luci2/view/system.routerapplication_dual /www/luci2/view/system.routerapplication.js
		######################################################
		uci set modem.cellularmodule.singlesimsinglemodule="0"
		uci set modem.cellularmodule.singlesimdualmodule="1"
		uci set modem.cellularmodule.dualsimsinglemodule="0"
		uci set modem."${cellularwan1interface}".modemenable="1"
		uci set modem."${cellularwan1sim1interface}".modemenable="0"
		uci set modem."${cellularwan1sim2interface}".modemenable="0"
		uci set modem."${cellularwan2interface}".modemenable="1"
		uci set modem."${cellularwan3interface}".modemenable="0"
		#This is set in hotplug script
		#uci set modem."${cellularwan1interface}".manufacturer="$Manufacturerlocal1"
		#uci set modem."${cellularwan1interface}".model="$Model1"
		#uci set modem."${cellularwan1interface}".porttype="$PortType1"
		#uci set modem."${cellularwan1interface}".vendorid="$VendorId1"
		#uci set modem."${cellularwan1interface}".productid="$ProductId1"
		uci set modem."${cellularwan1interface}".device="$DataPort1"
		#uci set modem."${cellularwan1interface}".comport="$ComPort1"
		uci set modem."${cellularwan1interface}".smsport="$SmsPort1"
		uci set modem."${cellularwan1interface}".smsenable="$SmsEnable1"
		uci set modem."${cellularwan1interface}".smsc="$SmsCenterNumber1"
		uci set modem."${cellularwan1interface}".smsdeviceid="$DeviceId1"
		uci set modem."${cellularwan1interface}".smsapikey="$ApiKey1"
		uci set modem."${cellularwan1interface}".monitorenable="1"
		uci set modem."${cellularwan1interface}".actionmanagerenable="$MonitorEnable1"
		uci set modem."${cellularwan1interface}".analyticsmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1interface}".statusmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1interface}".datatestenable="$DataTestEnable1"
		uci set modem."${cellularwan1interface}".pingtestenable="$PingTestEnable1"
		uci set modem."${cellularwan1interface}".pingip="$PingIp1"
		uci set modem."${cellularwan1interface}".dataenable="$DataEnable1"
		uci set modem."${cellularwan1interface}".service="$Service1"
		uci set modem."${cellularwan1interface}".apn="$Apn1"
		uci set modem."${cellularwan1interface}".pdp="$Pdp1"
		uci set modem."${cellularwan1interface}".username="$UserName1"
		uci set modem."${cellularwan1interface}".password="$Password1"
		uci set modem."${cellularwan1interface}".auth="$Auth1"
		if [ "$policy_type" = "balanced" ]
		then
			uci set modem."${cellularwan1interface}".metric="1"
		elif [ "$policy_type" = "failover" ]
		then
			uci set modem."${cellularwan1interface}".metric="$Cwan1Priority"
		fi
		#uci set modem."${cellularwan1interface}".usbbuspath="$UsbBusPath1"
		uci set modem."${cellularwan1interface}".action1waitinterval="$ActionInterval1"   
		uci set modem."${cellularwan1interface}".smsresponsesenderenable1="$SmsResponseSenderEnable1"
		uci set modem."${cellularwan1interface}".smsresponseserverenable1="$SmsResponseServerEnable1"
		uci set modem."${cellularwan1interface}".smsservernumber1="$SmsServerNumber1"
		uci set modem."${cellularwan1interface}".smsservernumber2="$SmsServerNumber2"
		uci set modem."${cellularwan1interface}".smsservernumber3="$SmsServerNumber3"
		uci set modem."${cellularwan1interface}".smsservernumber4="$SmsServerNumber4"
		uci set modem."${cellularwan1interface}".smsservernumber5="$SmsServerNumber5"
		
		#Only if the modems support 5G.
		#if [ "$ProductId1" = "0800" ] || [ "$ProductId1" = "0900" ]
		#then  
			#Settings_5G $autoconfigsim1 $ComPortSymLink1 $networkingmode1 $rattype1 $nsa_bands1 $sa_bands1
		#fi

		#uci set modem."${cellularwan2interface}".manufacturer="$Manufacturerlocal2"
		#uci set modem."${cellularwan2interface}".model="$Model2"
		#uci set modem."${cellularwan2interface}".porttype="$PortType2"
		#uci set modem."${cellularwan2interface}".vendorid="$VendorId2"
		#uci set modem."${cellularwan2interface}".productid="$ProductId2"
		uci set modem."${cellularwan2interface}".device="$DataPort2"
		#uci set modem."${cellularwan2interface}".comport="$ComPort2"
		uci set modem."${cellularwan2interface}".smsport="$SmsPort2"
		uci set modem."${cellularwan2interface}".smsenable="$SmsEnable2"
		uci set modem."${cellularwan2interface}".smsc="$SmsCenterNumber2"
		uci set modem."${cellularwan2interface}".smsdeviceid="$DeviceId2"
		uci set modem."${cellularwan2interface}".smsapikey="$ApiKey2"
		uci set modem."${cellularwan2interface}".monitorenable="1"
		uci set modem."${cellularwan2interface}".actionmanagerenable="$MonitorEnable2"
		uci set modem."${cellularwan2interface}".analyticsmanagerenable="$QueryModematAnalytics2"
		uci set modem."${cellularwan2interface}".statusmanagerenable="$QueryModematAnalytics2"
		uci set modem."${cellularwan2interface}".datatestenable="$DataTestEnable2"
		uci set modem."${cellularwan2interface}".pingtestenable="$PingTestEnable2"
		uci set modem."${cellularwan2interface}".pingip="$PingIp2"
		uci set modem."${cellularwan2interface}".dataenable="$DataEnable2"
		uci set modem."${cellularwan2interface}".service="$Sim2Service"
		uci set modem."${cellularwan2interface}".apn="$Sim2Apn"
		uci set modem."${cellularwan2interface}".pdp="$sim2pdp"
		uci set modem."${cellularwan2interface}".username="$sim2username"
		uci set modem."${cellularwan2interface}".password="$sim2password"
		uci set modem."${cellularwan2interface}".auth="$sim2auth"
		if [ "$policy_type" = "balanced" ]
		then
			uci set modem."${cellularwan2interface}".metric="1"
		elif [ "$policy_type" = "failover" ]
		then
			uci set modem."${cellularwan2interface}".metric="$Cwan2Priority"
		fi
		#uci set modem."${cellularwan2interface}".usbbuspath="$UsbBusPath2"
		uci set modem."${cellularwan2interface}".action1waitinterval="$ActionInterval2"

		uci set modem."${cellularwan2interface}".smsresponsesenderenable="$SmsResponseSenderEnable2"
		uci set modem."${cellularwan2interface}".smsresponseserverenable="$SmsResponseServerEnable2"
		uci set modem."${cellularwan2interface}".smsservernumber1="$SmsServerNumber1"
		uci set modem."${cellularwan2interface}".smsservernumber2="$SmsServerNumber2"
		uci set modem."${cellularwan2interface}".smsservernumber3="$SmsServerNumber3"
		uci set modem."${cellularwan2interface}".smsservernumber4="$SmsServerNumber4"
		uci set modem."${cellularwan2interface}".smsservernumber5="$SmsServerNumber5"
		#Only if the modems support 5G.
		#if [ "$ProductId2" = "0800" ] || [ "$ProductId2" = "0900" ]
		#then  
			#Settings_5G $autoconfigsim2 $ComPortSymLink2 $networkingmode2 $rattype2 $nsa_bands2 $sa_bands2
		#fi
		
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
    then
    	######################################################
		#change the Modem Status depending on the cellularmode. 	
		#below line is included in systemboot.sh as well. 
		cp /www/luci2/view/modemstatus2 /www/luci2/view/configuration.modemstatus.js
		######################################################
		#change the Monitor Application depending on the cellularmode. 	
		#below line is included in systemboot.sh as well. 
		cp /www/luci2/view/system.routerapplication_single /www/luci2/view/system.routerapplication.js
		######################################################
		uci set modem.cellularmodule.singlesimsinglemodule="0"
		uci set modem.cellularmodule.singlesimdualmodule="0"
		uci set modem.cellularmodule.dualsimsinglemodule="1"
		uci set modem."${cellularwan1interface}".modemenable="0"
		uci set modem."${cellularwan1sim1interface}".modemenable="1"
		uci set modem."${cellularwan1sim2interface}".modemenable="1"
		uci set modem."${cellularwan1sim1interface}".actionmanagerenable="0"
		uci set modem."${cellularwan1sim2interface}".actionmanagerenable="0"
		uci set modem."${cellularwan2interface}".modemenable="0"
		#uci set modem."${cellularwan1sim1interface}".manufacturer="$Manufacturerlocal1"
		#uci set modem."${cellularwan1sim1interface}".model="$Model1"
		#uci set modem."${cellularwan1sim1interface}".porttype="$PortType1"
		#uci set modem."${cellularwan1sim1interface}".vendorid="$VendorId1"
		#uci set modem."${cellularwan1sim1interface}".productid="$ProductId1"
		uci set modem."${cellularwan1sim1interface}".device="$DataPort1"
		#uci set modem."${cellularwan1sim1interface}".comport="$ComPort1"
		uci set modem."${cellularwan1sim1interface}".smsport="$SmsPort1"
		uci set modem."${cellularwan1sim1interface}".smsenable="$SmsEnable1"
		uci set modem."${cellularwan1sim1interface}".smsc="$SmsCenterNumber1"
		uci set modem."${cellularwan1sim1interface}".smsdeviceid="$DeviceId1"
		uci set modem."${cellularwan1sim1interface}".smsapikey="$ApiKey1"
		uci set modem."${cellularwan1sim1interface}".monitorenable="1"
		uci set modem."${cellularwan1sim1interface}".analyticsmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1sim1interface}".statusmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1sim1interface}".datatestenable="$DataTestEnable1"
		uci set modem."${cellularwan1sim1interface}".pingtestenable="$PingTestEnable1"
		uci set modem."${cellularwan1sim1interface}".pingip="$PingIp1"
		uci set modem."${cellularwan1sim1interface}".dataenable="$DataEnable1"
		uci set modem."${cellularwan1sim1interface}".service="$Service1"
		uci set modem."${cellularwan1sim1interface}".apn="$Apn1"
		uci set modem."${cellularwan1sim1interface}".pdp="$Pdp1"
		uci set modem."${cellularwan1sim1interface}".username="$UserName1"
		uci set modem."${cellularwan1sim1interface}".password="$Password1"
		uci set modem."${cellularwan1sim1interface}".auth="$Auth1"
		if [ "$policy_type" = "balanced" ]
		then
			uci set modem."${cellularwan1sim1interface}".metric="1"
		elif [ "$policy_type" = "failover" ]
		then
			uci set modem."${cellularwan1sim1interface}".metric="$Cwan1sim1Priority"
		fi
		#uci set modem."${cellularwan1sim1interface}".usbbuspath="$UsbBusPath1"

		uci set modem."${cellularwan1sim1interface}".smsresponsesenderenable1="$SmsResponseSenderEnable1"
		uci set modem."${cellularwan1sim1interface}".smsresponseserverenable1="$SmsResponseServerEnable1"
		uci set modem."${cellularwan1sim1interface}".smsservernumber1="$SmsServerNumber1"
		uci set modem."${cellularwan1sim1interface}".smsservernumber2="$SmsServerNumber2"
		uci set modem."${cellularwan1sim1interface}".smsservernumber3="$SmsServerNumber3"
		uci set modem."${cellularwan1sim1interface}".smsservernumber4="$SmsServerNumber4"
		uci set modem."${cellularwan1sim1interface}".smsservernumber5="$SmsServerNumber5"

		#uci set modem."${cellularwan1sim2interface}".manufacturer="$Manufacturerlocal1"
		#uci set modem."${cellularwan1sim2interface}".model="$Model1"
		#uci set modem."${cellularwan1sim2interface}".porttype="$PortType1"
		#uci set modem."${cellularwan1sim2interface}".vendorid="$VendorId1"
		#uci set modem."${cellularwan1sim2interface}".productid="$ProductId1"
		uci set modem."${cellularwan1sim2interface}".device="$DataPort1"
		#uci set modem."${cellularwan1sim2interface}".comport="$ComPort1"
		uci set modem."${cellularwan1sim2interface}".smsport="$SmsPort1"
		uci set modem."${cellularwan1sim2interface}".smsenable="$SmsEnable1"
		uci set modem."${cellularwan1sim2interface}".smsc="$SmsCenterNumber2"
		uci set modem."${cellularwan1sim2interface}".smsdeviceid="$DeviceId1"
		uci set modem."${cellularwan1sim2interface}".smsapikey="$ApiKey1"
		uci set modem."${cellularwan1sim2interface}".monitorenable="1"
		uci set modem."${cellularwan1sim2interface}".analyticsmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1sim2interface}".statusmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1sim2interface}".datatestenable="$DataTestEnable1"
		uci set modem."${cellularwan1sim2interface}".pingtestenable="$PingTestEnable1"
		uci set modem."${cellularwan1sim2interface}".pingip="$PingIp1"
		uci set modem."${cellularwan1sim2interface}".dataenable="$DataEnable1"
		uci set modem."${cellularwan1sim2interface}".service="$Sim2Service"
		uci set modem."${cellularwan1sim2interface}".apn="$Sim2Apn"
		uci set modem."${cellularwan1sim2interface}".pdp="$sim2pdp"
		uci set modem."${cellularwan1sim2interface}".username="$sim2username"
		uci set modem."${cellularwan1sim2interface}".password="$sim2password"
		uci set modem."${cellularwan1sim2interface}".auth="$sim2auth"
		if [ "$policy_type" = "balanced" ]
		then
			uci set modem."${cellularwan1sim2interface}".metric="1"
		elif [ "$policy_type" = "failover" ]
		then
			uci set modem."${cellularwan1sim2interface}".metric="$Cwan1sim2Priority"
		fi
		#uci set modem."${cellularwan1sim2interface}".usbbuspath="$UsbBusPath1"

		uci set modem."${cellularwan1sim2interface}".smsresponsesenderenable1="$SmsResponseSenderEnable1"
		uci set modem."${cellularwan1sim2interface}".smsresponseserverenable1="$SmsResponseServerEnable1"
		uci set modem."${cellularwan1sim2interface}".smsservernumber1="$SmsServerNumber1"
		uci set modem."${cellularwan1sim2interface}".smsservernumber2="$SmsServerNumber2"
		uci set modem."${cellularwan1sim2interface}".smsservernumber3="$SmsServerNumber3"
		uci set modem."${cellularwan1sim2interface}".smsservernumber4="$SmsServerNumber4"
		uci set modem."${cellularwan1sim2interface}".smsservernumber5="$SmsServerNumber5"
		

		#Only if the modems support 5G.
		#if [ "$ProductId1" = "0800" ] || [ "$ProductId1" = "0900" ]
		#then  
			#Settings_5G $autoconfigsim1 $ComPortSymLink1 $networkingmode1 $rattype1 $nsa_bands1 $sa_bands1
		#fi
		
	else
	    ######################################################
		#change the Modem Status depending on the cellularmode. 	
		#below line is included in systemboot.sh as well. 
		cp /www/luci2/view/modemstatus2 /www/luci2/view/configuration.modemstatus.js
		######################################################
		#change the Monitor Application depending on the cellularmode. 	
		#below line is included in systemboot.sh as well. 
		cp /www/luci2/view/system.routerapplication_single /www/luci2/view/system.routerapplication.js
		######################################################
		uci set modem.cellularmodule.singlesimsinglemodule="1"
		uci set modem.cellularmodule.singlesimdualmodule="0"
		uci set modem.cellularmodule.dualsimsinglemodule="0"
		uci set modem."${cellularwan1interface}".modemenable="1"
		uci set modem."${cellularwan1sim1interface}".modemenable="0"
		uci set modem."${cellularwan1sim2interface}".modemenable="0"
		uci set modem."${cellularwan2interface}".modemenable="0"
		#uci set modem."${cellularwan1interface}".manufacturer="$Manufacturerlocal1"
		#uci set modem."${cellularwan1interface}".model="$Model1"
		#uci set modem."${cellularwan1interface}".porttype="$PortType1"
		#uci set modem."${cellularwan1interface}".vendorid="$VendorId1"
		#uci set modem."${cellularwan1interface}".productid="$ProductId1"
		uci set modem."${cellularwan1interface}".device="$DataPort1"
		#uci set modem."${cellularwan1interface}".comport="$ComPort1"
		uci set modem."${cellularwan1interface}".smsport="$SmsPort1"
		uci set modem."${cellularwan1interface}".smsenable="$SmsEnable1"
		uci set modem."${cellularwan1interface}".smsc="$SmsCenterNumber1"
		uci set modem."${cellularwan1interface}".smsdeviceid="$DeviceId1"
		uci set modem."${cellularwan1interface}".smsapikey="$ApiKey1"
		uci set modem."${cellularwan1interface}".monitorenable="1"
		uci set modem."${cellularwan1interface}".actionmanagerenable="$MonitorEnable1"
		uci set modem."${cellularwan1interface}".analyticsmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1interface}".statusmanagerenable="$QueryModematAnalytics1"
		uci set modem."${cellularwan1interface}".datatestenable="$DataTestEnable1"
		uci set modem."${cellularwan1interface}".pingtestenable="$PingTestEnable1"
		uci set modem."${cellularwan1interface}".pingip="$PingIp1"
		uci set modem."${cellularwan1interface}".dataenable="$DataEnable1"
		uci set modem."${cellularwan1interface}".service="$Service1"
		uci set modem."${cellularwan1interface}".apn="$Apn1"
		uci set modem."${cellularwan1interface}".pdp="$Pdp1"
		uci set modem."${cellularwan1interface}".username="$UserName1"
		uci set modem."${cellularwan1interface}".password="$Password1"
		uci set modem."${cellularwan1interface}".auth="$Auth1"
		if [ "$policy_type" = "balanced" ]
		then
			uci set modem."${cellularwan1interface}".metric="1"
		elif [ "$policy_type" = "failover" ]
		then
			uci set modem."${cellularwan1interface}".metric="$Cwan1Priority"
		fi
		#uci set modem."${cellularwan1interface}".usbbuspath="$UsbBusPath1"
		uci set modem."${cellularwan1interface}".action1waitinterval="$ActionInterval1"   

		uci set modem."${cellularwan1interface}".smsresponsesenderenable1="$SmsResponseSenderEnable1"
		uci set modem."${cellularwan1interface}".smsresponseserverenable1="$SmsResponseServerEnable1"
		uci set modem."${cellularwan1interface}".smsservernumber1="$SmsServerNumber1"
		uci set modem."${cellularwan1interface}".smsservernumber2="$SmsServerNumber2"
		uci set modem."${cellularwan1interface}".smsservernumber3="$SmsServerNumber3"
		uci set modem."${cellularwan1interface}".smsservernumber4="$SmsServerNumber4"
		uci set modem."${cellularwan1interface}".smsservernumber5="$SmsServerNumber5"
		
		#Only if the modems support 5G.
		#if [ "$ProductId1" = "0800" ] || [ "$ProductId1" = "0900" ]
		#then  
			#Settings_5G $autoconfigsim1 $ComPortSymLink1 $networkingmode1 $rattype1 $nsa_bands1 $sa_bands1
		#fi
		
	fi
	#Restarting the uhttpd for Modem status and Monitor App .js change
	/etc/init.d/uhttpd restart
	
	uci commit modem
	ubus call modem reload
}

UpdateFirewallConfig()
{
	IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
	InternetOverWifi=$(uci get sysconfig.wificonfig.InternetOverWifi)
	if [ "$wifi1enable" = "0" ]
	then 
		uci delete firewall.wifi > /dev/null 2>&1
		uci delete firewall.wifi5 > /dev/null 2>&1
		uci delete firewall.WIFI_WAN > /dev/null 2>&1

	else
		#Guest Wifi
		if [ "$guestwifienable2" = "1" ]
		then 
		uci delete firewall.gwifi > /dev/null 2>&1
		#2.4GHZ
				uci set firewall.gwifi=zone
				uci set firewall.gwifi.name="$wifiap1"
				uci set firewall.gwifi.input="ACCEPT"
				uci set firewall.gwifi.output="ACCEPT"
				uci set firewall.gwifi.forward="ACCEPT"
				uci set firewall.gwifi.network=ra1
				uci set firewall.gwifi.masq="1"
				uci set firewall.gwifi.mtu_fix="1"
		else
			uci delete firewall.gwifi > /dev/null 2>&1
		fi
		
		if [ "$guestwifienable5" = "1" ]
		then 
		uci delete firewall.gwifi5 > /dev/null 2>&1
		#5GHZ
				uci set firewall.gwifi5=zone
				uci set firewall.gwifi5.name="$wifiap51"
				uci set firewall.gwifi5.input="ACCEPT"
				uci set firewall.gwifi5.output="ACCEPT"
				uci set firewall.gwifi5.forward="ACCEPT"
				uci set firewall.gwifi5.network=rai1
				uci set firewall.gwifi5.masq="1"
				uci set firewall.gwifi5.mtu_fix="1"
		else
			uci delete firewall.gwifi5 > /dev/null 2>&1
		fi
		
		#AP Only.
		if  [ "$wifi1mode" = "ap" ]
		then
			uci delete firewall.WIFI_WAN > /dev/null 2>&1
		
			#2.4GHZ
			uci set firewall.wifi=zone
			uci set firewall.wifi.name="$wifiinterface"
			uci set firewall.wifi.input="ACCEPT"
			uci set firewall.wifi.output="ACCEPT"
			uci set firewall.wifi.forward="ACCEPT"
			uci set firewall.wifi.network=ra0
			uci set firewall.wifi.masq="1"
			uci set firewall.wifi.mtu_fix="1"

			#5GHZ
			uci set firewall.wifi5=zone
			uci set firewall.wifi5.name="$wifi5interface"
			uci set firewall.wifi5.input="ACCEPT"
			uci set firewall.wifi5.output="ACCEPT"
			uci set firewall.wifi5.forward="ACCEPT"
			uci set firewall.wifi5.network=rai0
			uci set firewall.wifi5.masq="1"
			uci set firewall.wifi5.mtu_fix="1"
			
				
		elif  [ "$wifi1mode" = "sta" ]
		then
			uci delete firewall.WIFI_WAN > /dev/null 2>&1
			uci delete firewall.wifi > /dev/null 2>&1
			uci delete firewall.wifi5 > /dev/null 2>&1
			
			#WIFI_WAN
			uci set firewall."${wifiwaninterface}"=zone
			uci set firewall."${wifiwaninterface}".name="$wifiwaninterface"
			uci set firewall."${wifiwaninterface}".input='ACCEPT'
			uci set firewall."${wifiwaninterface}".output='ACCEPT'
			uci set firewall."${wifiwaninterface}".forward='ACCEPT'
			uci set firewall."${wifiwaninterface}".network="$wifiwaninterface"
			uci set firewall."${wifiwaninterface}".masq='1'
			uci set firewall."${wifiwaninterface}".mtu_fix='1'
			
		elif  [ "$wifi1mode" = "apsta" ]
		then
			uci delete firewall."${wifiwaninterface}" > /dev/null 2>&1
			uci delete firewall.wifi > /dev/null 2>&1
			uci delete firewall.wifi5 > /dev/null 2>&1
			
			#2.4GHZ
			uci set firewall.wifi=zone
			uci set firewall.wifi.name="$wifiinterface"
			uci set firewall.wifi.input="ACCEPT"
			uci set firewall.wifi.output="ACCEPT"
			uci set firewall.wifi.forward="ACCEPT"
			uci set firewall.wifi.network=ra0
			uci set firewall.wifi.masq="1"
			uci set firewall.wifi.mtu_fix="1"

			#5GHZ
			uci set firewall.wifi5=zone
			uci set firewall.wifi5.name="$wifi5interface"
			uci set firewall.wifi5.input="ACCEPT"
			uci set firewall.wifi5.output="ACCEPT"
			uci set firewall.wifi5.forward="ACCEPT"
			uci set firewall.wifi5.network=rai0
			uci set firewall.wifi5.masq="1"
			uci set firewall.wifi5.mtu_fix="1"	

			#WIFI_WAN
			uci set firewall."${wifiwaninterface}"=zone
			uci set firewall."${wifiwaninterface}".name="$wifiwaninterface"
			uci set firewall."${wifiwaninterface}".input='ACCEPT'
			uci set firewall."${wifiwaninterface}".output='ACCEPT'
			uci set firewall."${wifiwaninterface}".forward='ACCEPT'
			uci set firewall."${wifiwaninterface}".network="$wifiwaninterface"
			uci set firewall."${wifiwaninterface}".masq='1'
			uci set firewall."${wifiwaninterface}".mtu_fix='1'
			
		fi
	fi

	if [ "$EnableCellular" = "1" ]
    then
		if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
		then
			uci delete firewall.cwan1_0 > /dev/null 2>&1
			uci delete firewall.cwan1_1 > /dev/null 2>&1
			uci delete firewall.udp_DHCPv6c1_replies > /dev/null 2>&1
			uci delete firewall.udp_DHCPv6c2_replies > /dev/null 2>&1
			uci delete firewall.wan6c1 > /dev/null 2>&1
			uci delete firewall.wan6c2 > /dev/null 2>&1
			uci set firewall.cwan1=zone
			uci set firewall.cwan1.name="$cellularwan1interface"
			uci set firewall.cwan1.input="ACCEPT"
			uci set firewall.cwan1.output="ACCEPT"
			uci set firewall.cwan1.forward="ACCEPT"
			#don't set the network as below
			#uci set firewall.cwan1.network="$cellularwan1interface $cellular1wan6interface"
			uci set firewall.cwan1.network="$cellularwan1interface"
			uci set firewall.cwan1.masq="1"
			uci set firewall.cwan1.mtu_fix="1"
			uci set firewall.cwan1.extra_src="-m policy --dir in --pol none"
			uci set firewall.cwan1.extra_dest="-m policy --dir out --pol none"

			uci set firewall.cwan2=zone
			uci set firewall.cwan2.name="$cellularwan2interface"
			uci set firewall.cwan2.input="ACCEPT"
			uci set firewall.cwan2.output="ACCEPT"
			uci set firewall.cwan2.forward="ACCEPT"
			#don't set the network as below
			#uci set firewall.cwan2.network="$cellularwan2interface $cellular2wan6interface"
			uci set firewall.cwan2.network="$cellularwan2interface"
			uci set firewall.cwan2.masq="1"
			uci set firewall.cwan2.mtu_fix="1"
			uci set firewall.cwan2.extra_src="-m policy --dir in --pol none"
			uci set firewall.cwan2.extra_dest="-m policy --dir out --pol none"

			if [ "$Pdp1" = "2" ] || [ "$Pdp1" = "3" ] 
			then
				uci set firewall.$cellular1wan6interface=zone
				uci set firewall.$cellular1wan6interface.name="$cellular1wan6interface"
				uci set firewall.$cellular1wan6interface.input="ACCEPT"
				uci set firewall.$cellular1wan6interface.output="ACCEPT"
				uci set firewall.$cellular1wan6interface.forward="ACCEPT"
				uci set firewall.$cellular1wan6interface.network="$cellular1wan6interface"
				uci set firewall.$cellular1wan6interface.masq="1"
				uci set firewall.$cellular1wan6interface.mtu_fix="1"
				uci set firewall.$cellular1wan6interface.extra_src="-m policy --dir in --pol none"
				uci set firewall.$cellular1wan6interface.extra_dest="-m policy --dir out --pol none"
			
				uci set firewall.udp_DHCPv6c1_replies=rule
				uci set firewall.udp_DHCPv6c1_replies.target='ACCEPT'
				uci set firewall.udp_DHCPv6c1_replies.src="$cellular1wan6interface"
				uci set firewall.udp_DHCPv6c1_replies.proto='udp'
				uci set firewall.udp_DHCPv6c1_replies.dest_port='546'
				uci set firewall.udp_DHCPv6c1_replies.name='Allow DHCPv6c1 replies'
				uci set firewall.udp_DHCPv6c1_replies.family='ipv6'
				uci set firewall.udp_DHCPv6c1_replies.src_port='547'  
			fi       
			if [ "$sim2pdp" = "2" ] || [ "$sim2pdp" = "3" ]
			then
				uci set firewall.$cellular2wan6interface=zone
				uci set firewall.$cellular2wan6interface.name="$cellular2wan6interface"
				uci set firewall.$cellular2wan6interface.input="ACCEPT"
				uci set firewall.$cellular2wan6interface.output="ACCEPT"
				uci set firewall.$cellular2wan6interface.forward="ACCEPT"
				uci set firewall.$cellular2wan6interface.network="$cellular2wan6interface"
				uci set firewall.$cellular2wan6interface.masq="1"
				uci set firewall.$cellular2wan6interface.mtu_fix="1"
				uci set firewall.$cellular2wan6interface.extra_src="-m policy --dir in --pol none"
				uci set firewall.$cellular2wan6interface.extra_dest="-m policy --dir out --pol none"
				
				uci set firewall.udp_DHCPv6c2_replies=rule
				uci set firewall.udp_DHCPv6c2_replies.target='ACCEPT'
				uci set firewall.udp_DHCPv6c2_replies.src="$cellular2wan6interface"
				uci set firewall.udp_DHCPv6c2_replies.proto='udp'
				uci set firewall.udp_DHCPv6c2_replies.dest_port='546'
				uci set firewall.udp_DHCPv6c2_replies.name='Allow DHCPv6c2 replies'
				uci set firewall.udp_DHCPv6c2_replies.family='ipv6'
				uci set firewall.udp_DHCPv6c2_replies.src_port='547'      
			fi
			                                               
			uci delete firewall.wificwan1_0 > /dev/null 2>&1
			uci delete firewall.wificwan1_1 > /dev/null 2>&1
			uci delete firewall.wifi5cwan1_0 > /dev/null 2>&1
			uci delete firewall.wifi5cwan1_1 > /dev/null 2>&1
			
			if [ "$InternetOverWifi" = "1" ]
			then
				if [ "$wifi1enable" = "1" ]
				then
					uci set firewall.wificwan1=forwarding
					uci set firewall.wificwan1.src="$wifiinterface"
					uci set firewall.wificwan1.dest="$cellularwan1interface"
					uci set firewall.wificwan2=forwarding
					uci set firewall.wificwan2.src="$wifiinterface"
					uci set firewall.wificwan2.dest="$cellularwan2interface"
					
					uci set firewall.wifi5cwan1=forwarding
					uci set firewall.wifi5cwan1.src="$wifi5interface"
					uci set firewall.wifi5cwan1.dest="$cellularwan1interface"
					uci set firewall.wifi5cwan2=forwarding
					uci set firewall.wifi5cwan2.src="$wifi5interface"
					uci set firewall.wifi5cwan2.dest="$cellularwan2interface"
					if [ "$guestwifienable2" = "1" ]
					then 
						uci set firewall.gwificwan1=forwarding
						uci set firewall.gwificwan1.src="$wifiap1"
						uci set firewall.gwificwan1.dest="$cellularwan1interface"
						uci set firewall.gwificwan2=forwarding
						uci set firewall.gwificwan2.src="$wifiap1"
						uci set firewall.gwificwan2.dest="$cellularwan2interface"
					else
						uci delete firewall.gwificwan1 > /dev/null 2>&1
						uci delete firewall.gwificwan2 > /dev/null 2>&1
					fi
					
					if [ "$guestwifienable5" = "1" ]
					then 
						uci set firewall.gwifi5cwan1=forwarding
						uci set firewall.gwifi5cwan1.src="$wifiap51"
						uci set firewall.gwifi5cwan1.dest="$cellularwan1interface"
						uci set firewall.gwifi5cwan2=forwarding
						uci set firewall.gwifi5cwan2.src="$wifiap51"
						uci set firewall.gwifi5cwan2.dest="$cellularwan2interface"
					else
						uci delete firewall.gwifi5cwan1 > /dev/null 2>&1
						uci delete firewall.gwifi5cwan2 > /dev/null 2>&1
					fi 
				fi 
			fi
		elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
		then
			uci delete firewall.cwan1 > /dev/null 2>&1
			uci delete firewall.cwan2 > /dev/null 2>&1
			uci delete firewall.udp_DHCPv6c1_replies > /dev/null 2>&1
			uci delete firewall.udp_DHCPv6c2_replies > /dev/null 2>&1
			uci delete firewall.wan6c1 > /dev/null 2>&1
			uci delete firewall.wan6c2 > /dev/null 2>&1
			uci set firewall.cwan1_0=zone
			uci set firewall.cwan1_0.name="$cellularwan1sim1interface"
			uci set firewall.cwan1_0.input="ACCEPT"
			uci set firewall.cwan1_0.output="ACCEPT"
			uci set firewall.cwan1_0.forward="ACCEPT"
			#don't set the network as below
			#uci set firewall.cwan1_0.network="$cellularwan1sim1interface $cellular1wan6interface"
			uci set firewall.cwan1_0.network="$cellularwan1sim1interface"
			uci set firewall.cwan1_0.masq="1"
			uci set firewall.cwan1_0.mtu_fix="1"
			uci set firewall.cwan1_0.extra_src="-m policy --dir in --pol none"
			uci set firewall.cwan1_0.extra_dest="-m policy --dir out --pol none"
	
			uci set firewall.cwan1_1=zone
			uci set firewall.cwan1_1.name="$cellularwan1sim2interface"
			uci set firewall.cwan1_1.input="ACCEPT"
			uci set firewall.cwan1_1.output="ACCEPT"
			uci set firewall.cwan1_1.forward="ACCEPT"
			#don't set the network as below
			#uci set firewall.cwan1_1.network="$cellularwan1sim2interface $cellular2wan6interface"
			uci set firewall.cwan1_1.network="$cellularwan1sim2interface"
			uci set firewall.cwan1_1.masq="1"
			uci set firewall.cwan1_1.mtu_fix="1"
			uci set firewall.cwan1_1.extra_src="-m policy --dir in --pol none"
			uci set firewall.cwan1_1.extra_dest="-m policy --dir out --pol none"
		
			if [ "$Pdp1" = "2" ] || [ "$Pdp1" = "3" ] 
			then
				uci set firewall.$cellular1wan6interface=zone
				uci set firewall.$cellular1wan6interface.name="$cellular1wan6interface"
				uci set firewall.$cellular1wan6interface.input="ACCEPT"
				uci set firewall.$cellular1wan6interface.output="ACCEPT"
				uci set firewall.$cellular1wan6interface.forward="ACCEPT"
				uci set firewall.$cellular1wan6interface.network="$cellular1wan6interface"
				uci set firewall.$cellular1wan6interface.masq="1"
				uci set firewall.$cellular1wan6interface.mtu_fix="1"
				uci set firewall.$cellular1wan6interface.extra_src="-m policy --dir in --pol none"
				uci set firewall.$cellular1wan6interface.extra_dest="-m policy --dir out --pol none"				

				uci set firewall.udp_DHCPv6c1_replies=rule
				uci set firewall.udp_DHCPv6c1_replies.target='ACCEPT'
				uci set firewall.udp_DHCPv6c1_replies.src="$cellular1wan6interface"
				uci set firewall.udp_DHCPv6c1_replies.proto='udp'
				uci set firewall.udp_DHCPv6c1_replies.dest_port='546'
				uci set firewall.udp_DHCPv6c1_replies.name='Allow DHCPv6c1 replies'
				uci set firewall.udp_DHCPv6c1_replies.family='ipv6'
				uci set firewall.udp_DHCPv6c1_replies.src_port='547'  
			fi       
			if [ "$sim2pdp" = "2" ] || [ "$sim2pdp" = "3" ]
			then
				uci set firewall.$cellular2wan6interface=zone
				uci set firewall.$cellular2wan6interface.name="$cellular2wan6interface"
				uci set firewall.$cellular2wan6interface.input="ACCEPT"
				uci set firewall.$cellular2wan6interface.output="ACCEPT"
				uci set firewall.$cellular2wan6interface.forward="ACCEPT"
				uci set firewall.$cellular2wan6interface.network="$cellular2wan6interface"
				uci set firewall.$cellular2wan6interface.masq="1"
				uci set firewall.$cellular2wan6interface.mtu_fix="1"
				uci set firewall.$cellular2wan6interface.extra_src="-m policy --dir in --pol none"
				uci set firewall.$cellular2wan6interface.extra_dest="-m policy --dir out --pol none"	

				uci set firewall.udp_DHCPv6c2_replies=rule
				uci set firewall.udp_DHCPv6c2_replies.target='ACCEPT'
				uci set firewall.udp_DHCPv6c2_replies.src="$cellular2wan6interface"
				uci set firewall.udp_DHCPv6c2_replies.proto='udp'
				uci set firewall.udp_DHCPv6c2_replies.dest_port='546'
				uci set firewall.udp_DHCPv6c2_replies.name='Allow DHCPv6c2 replies'
				uci set firewall.udp_DHCPv6c2_replies.family='ipv6'
				uci set firewall.udp_DHCPv6c2_replies.src_port='547'      
			fi
			
			uci delete firewall.wificwan1 > /dev/null 2>&1
			uci delete firewall.wificwan2 > /dev/null 2>&1
			uci delete firewall.wifi5cwan1 > /dev/null 2>&1
			uci delete firewall.wifi5cwan2 > /dev/null 2>&1
			
			if [ "$InternetOverWifi" = "1" ]
			then
				if [ "$wifi1enable" = "1" ]
				then
					uci set firewall.wificwan1_0=forwarding
					uci set firewall.wificwan1_0.src="$wifiinterface"
					uci set firewall.wificwan1_0.dest="$cellularwan1sim1interface"
					uci set firewall.wificwan1_1=forwarding
					uci set firewall.wificwan1_1.src="$wifiinterface"
					uci set firewall.wificwan1_1.dest="$cellularwan1sim2interface"
					
					uci set firewall.wifi5cwan1_0=forwarding
					uci set firewall.wifi5cwan1_0.src="$wifi5interface"
					uci set firewall.wifi5cwan1_0.dest="$cellularwan1sim1interface"
					uci set firewall.wifi5cwan1_1=forwarding
					uci set firewall.wifi5cwan1_1.src="$wifi5interface"
					uci set firewall.wifi5cwan1_1.dest="$cellularwan1sim2interface"
					if [ "$guestwifienable2" = "1" ]
					then 
						uci set firewall.gwificwan1_0=forwarding
						uci set firewall.gwificwan1_0.src="$wifiap1"
						uci set firewall.gwificwan1_0.dest="$cellularwan1interface"
						uci set firewall.gwificwan1_1=forwarding
						uci set firewall.gwificwan1_1.src="$wifiap1"
						uci set firewall.gwificwan1_1.dest="$cellularwan2interface"
					else
						uci delete firewall.gwificwan1_0 > /dev/null 2>&1
						uci delete firewall.gwificwan1_1 > /dev/null 2>&1
					fi
					
					if [ "$guestwifienable5" = "1" ]
					then 
						uci set firewall.gwifi5cwan1_0=forwarding
						uci set firewall.gwifi5cwan1_0.src="$wifiap51"
						uci set firewall.gwifi5cwan1_0.dest="$cellularwan1interface"
						uci set firewall.gwifi5cwan1_1=forwarding
						uci set firewall.gwifi5cwan1_1.src="$wifiap51"
						uci set firewall.gwifi5cwan1_1.dest="$cellularwan2interface"
					else
						uci delete firewall.gwifi5cwan1_0 > /dev/null 2>&1
						uci delete firewall.gwifi5cwan1_1 > /dev/null 2>&1
					fi 
				fi 
			fi 
		else
			uci delete firewall.cwan1_0 > /dev/null 2>&1
			uci delete firewall.cwan1_1 > /dev/null 2>&1
			uci delete firewall.cwan2 > /dev/null 2>&1
			uci delete firewall.udp_DHCPv6c1_replies > /dev/null 2>&1
			uci delete firewall.udp_DHCPv6c2_replies > /dev/null 2>&1
			uci delete firewall.wan6c1 > /dev/null 2>&1
			uci set firewall.cwan1=zone
			uci set firewall.cwan1.name="$cellularwan1interface"
			uci set firewall.cwan1.input="ACCEPT"
			uci set firewall.cwan1.output="ACCEPT"
			uci set firewall.cwan1.forward="ACCEPT"
			#don't set the network as below
			#uci set firewall.cwan1.network="$cellularwan1interface $cellular1wan6interface"
			uci set firewall.cwan1.network="$cellularwan1interface"
			uci set firewall.cwan1.masq="1"
			uci set firewall.cwan1.mtu_fix="1"
			uci set firewall.cwan1.extra_src="-m policy --dir in --pol none"
			uci set firewall.cwan1.extra_dest="-m policy --dir out --pol none"
			
			if [ "$Pdp1" = "2" ] || [ "$Pdp1" = "3" ] 
			then
				uci set firewall.$cellular1wan6interface=zone
				uci set firewall.$cellular1wan6interface.name="$cellular1wan6interface"
				uci set firewall.$cellular1wan6interface.input="ACCEPT"
				uci set firewall.$cellular1wan6interface.output="ACCEPT"
				uci set firewall.$cellular1wan6interface.forward="ACCEPT"
				uci set firewall.$cellular1wan6interface.network="$cellular1wan6interface"
				uci set firewall.$cellular1wan6interface.masq="1"
				uci set firewall.$cellular1wan6interface.mtu_fix="1"
				uci set firewall.$cellular1wan6interface.extra_src="-m policy --dir in --pol none"
				uci set firewall.$cellular1wan6interface.extra_dest="-m policy --dir out --pol none"	
				
				uci set firewall.udp_DHCPv6c1_replies=rule
				uci set firewall.udp_DHCPv6c1_replies.target='ACCEPT'
				uci set firewall.udp_DHCPv6c1_replies.src="$cellular1wan6interface"
				uci set firewall.udp_DHCPv6c1_replies.proto='udp'
				uci set firewall.udp_DHCPv6c1_replies.dest_port='546'
				uci set firewall.udp_DHCPv6c1_replies.name='Allow DHCPv6c1 replies'
				uci set firewall.udp_DHCPv6c1_replies.family='ipv6'
				uci set firewall.udp_DHCPv6c1_replies.src_port='547'  
			fi 
			
			uci delete firewall.wificwan1_0 > /dev/null 2>&1
			uci delete firewall.wificwan1_1 > /dev/null 2>&1
			uci delete firewall.wificwan2 > /dev/null 2>&1
			uci delete firewall.wifi5cwan1_0 > /dev/null 2>&1
			uci delete firewall.wifi5cwan1_1 > /dev/null 2>&1
			uci delete firewall.wifi5cwan2 > /dev/null 2>&1
			
			if [ "$InternetOverWifi" = "1" ]
			then
				if [ "$wifi1enable" = "1" ]
				then
					uci set firewall.wificwan1=forwarding
					uci set firewall.wificwan1.src="$wifiinterface"
					uci set firewall.wificwan1.dest="$cellularwan1interface"
					
					uci set firewall.wifi5cwan1=forwarding
					uci set firewall.wifi5cwan1.src="$wifi5interface"
					uci set firewall.wifi5cwan1.dest="$cellularwan1interface"
					if [ "$guestwifienable2" = "1" ]
					then 
						uci set firewall.gwificwan1=forwarding
						uci set firewall.gwificwan1.src="$wifiap1"
						uci set firewall.gwificwan1.dest="$cellularwan1interface"
					else
						uci delete firewall.gwificwan1 > /dev/null 2>&1
					fi
					
					if [ "$guestwifienable5" = "1" ]
					then 
						uci set firewall.gwifi5cwan1=forwarding
						uci set firewall.gwifi5cwan1.src="$wifiap51"
						uci set firewall.gwifi5cwan1.dest="$cellularwan1interface"
					else
						uci delete firewall.gwifi5cwan1 > /dev/null 2>&1
					fi
				fi 
			fi 
		fi
	else
		uci delete firewall.cwan1 > /dev/null 2>&1
		uci delete firewall.cwan2 > /dev/null 2>&1
		uci delete firewall.cwan1_0 > /dev/null 2>&1
		uci delete firewall.cwan1_1 > /dev/null 2>&1
		uci delete firewall.wificwan1 > /dev/null 2>&1
		uci delete firewall.wificwan2 > /dev/null 2>&1
		uci delete firewall.wificwan1_0 > /dev/null 2>&1
		uci delete firewall.wificwan1_1 > /dev/null 2>&1
		uci delete firewall.wifi5cwan1 > /dev/null 2>&1
		uci delete firewall.wifi5cwan2 > /dev/null 2>&1
		uci delete firewall.wifi5cwan1_0 > /dev/null 2>&1
		uci delete firewall.wifi5cwan1_1 > /dev/null 2>&1
		
		uci delete firewall.gwificwan1 > /dev/null 2>&1
		uci delete firewall.gwificwan2 > /dev/null 2>&1
		uci delete firewall.gwificwan1_0 > /dev/null 2>&1
		uci delete firewall.gwificwan1_1 > /dev/null 2>&1
		uci delete firewall.gwifi5cwan1 > /dev/null 2>&1
		uci delete firewall.gwifi5cwan2 > /dev/null 2>&1
		uci delete firewall.gwifi5cwan1_0 > /dev/null 2>&1
		uci delete firewall.gwifi5cwan1_1 > /dev/null 2>&1
	fi
	
	uci commit firewall
	ubus call firewall reload
}

Flow_Offloading()
{
	/root/InterfaceManager/script/FlowOffloading.sh
}

SystemConfigFile="/etc/config/sysconfig"
MwanConfigFile="/etc/config/mwan3config"
simtmpfile="/tmp/simnumfile"
#wirelessdatfile="/etc/wireless/mt7603e/mt7603e.dat"
wirelessdatfile="/etc/wireless/mt7615/mt7615.1.dat"
wirelessdatfile1="/etc/wireless/mt7663/mt7663.dat"

sleep 1

rm -rf /var/run/mwan3.lock

sleep 1

/etc/init.d/mwan3 stop 2>&1

sleep 5

rm -rf /var/run/mwan3.lock

sleep 1

pids=$(ps w | grep -i "mwan3" | grep -v grep | awk '{print $1}')
kill -9 $pids

sleep 1

set_nr5g_disable_mode="/etc/gcom/set_nr5g_disable_mode.gcom"
set_mode_pref="/etc/gcom/set_mode_pref.gcom"
set_nsa_bands="/etc/gcom/set_nsa_bands.gcom"
set_sa_bands="/etc/gcom/set_sa_bands.gcom"
nr5g_disable_mode="/etc/gcom/nr5g_disable_mode.gcom"
mode_pref="/etc/gcom/mode_pref.gcom"
nsa_bands="/etc/gcom/nsa_bands.gcom"
sa_bands="/etc/gcom/sa_bands.gcom"

SimNumFile="/tmp/simnumfile"

#failover/balanced policy for mwan3.
policy_type=$(uci get mwan3config.general.select)

ReadSystemConfigFile
#Calls UpdateMwanConfig
ReadMwanConfigFile

UpdateWirelessConfig
UpdateScheduledWifiOnOff
UpdateFirewallConfig
UpdateNetworkConfig

if [ "$EnableCellular" = "1" ]
then
	/etc/init.d/smstools3 stop
	UpdateModemConfig
	/etc/init.d/smstools3 start
else
	uci set modem."${cellularwan1interface}".modemenable="0"
	uci set modem."${cellularwan1sim1interface}".modemenable="0"
	uci set modem."${cellularwan1sim2interface}".modemenable="0"
	uci set modem."${cellularwan2interface}".modemenable="0"
	uci set modem."${cellularwan3interface}".modemenable="0"
fi

#Check flow_offloading & Smp IRQ Affinity
Flow_Offloading

/root/InterfaceManager/script/SystemRestart.sh > /dev/null 2>&1 & 

exit 0
