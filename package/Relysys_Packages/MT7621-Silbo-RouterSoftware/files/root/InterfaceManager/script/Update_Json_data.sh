#!/bin/sh

. /lib/functions.sh
. /usr/share/libubox/jshn.sh

IMEI=$(uci get boardconfig.board.imei)

cellularwan1interface="CWAN1"
cellularwan2interface="CWAN2"
cellularwan1sim1interface="CWAN1_0"
cellularwan1sim2interface="CWAN1_1"

ReadSystemConfigFile()
{
   	config_load "$SystemConfigFile"
   	config_get CellularOperationModelocal sysconfig CellularOperationMode
   	config_get EnableCellular sysconfig enablecellular
   	config_get Service sysconfig service
   	config_get Sim2Service sysconfig sim2service
}

SystemConfigFile="/etc/config/sysconfig"

ReadSystemConfigFile

if [ "$EnableCellular" = "1" ]
then
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
	  ComPort1=$(cat "/tmp/InterfaceManager/status/$cellularwan1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
	  ComPort2=$(cat "/tmp/InterfaceManager/status/$cellularwan2interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
	  simnum=$(cat /tmp/simnumfile)                                                                                         
      if [ "$simnum" = "1" ]                                                                                                
      then
        ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
      else
        ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim2interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)     
      fi 
	else
      ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
	fi
fi


Operator_Code=$(gcom -d "$ComPort" -s /etc/gcom/getcarrier.gcom | awk NR==2)

Operator=$(echo "$Operator_Code" | cut -d "," -f 2 | tr -d '\011\012\013\014\015\040')

Code=$(echo "$Operator_Code" | cut -d "," -f 5 | tr -d '\011\012\013\014\015\040')

model=$(uci get sysconfig.sysconfig.model1)

echo "{\""modem"\":{\""3gpp"\":{\""enabled-locks"\":[],\""eps"\":{\""initial-bearer"\":{\""dbus-path"\":\""--"\",\""settings"\":{\""apn"\":\""--"\",\""ip-type"\":\""--"\",\""password"\":\""--"\",\""user"\":\""--"\"}},\""ue-mode-operation"\":\""csps-2"\"},\""imei"\":\""$IMEI"\",\""operator-code"\":"$Code",\""operator-name"\":"$Operator",\""pco"\":\""--"\",\""registration-state"\":\""home"\"},\""cdma"\":{\""activation-state"\":\""--"\",\""cdma1x-registration-state"\":\""--"\",\""esn"\":\""--"\",\""evdo-registration-state"\":\""--"\",\""meid"\":\""--"\",\""nid"\":\""--"\",\""sid"\":\""--"\"},\""dbus-path"\":\""\/org\/freedesktop\/ModemManager1\/Modem\/0"\",\""generic"\":{\""access-technologies"\":[],\""bearers"\":[\""\/org\/freedesktop\/ModemManager1\/Bearer\/0"\"],\""carrier-configuration"\":\""--"\",\""carrier-configuration-revision"\":\""--"\",\""current-bands"\":[],\""current-capabilities"\":[\""gsm-umts, lte"\"],\""current-modes"\":\""allowed: any\; preferred: none"\",\""device"\":\""\/sys\/devices\/platform\/101c0000.ehci\/usb1\/1-1\/1-1.2"\",\""device-identifier"\":\""bfad63a0d36bfd94e3aeedac55fc76ebab30c02b"\",\""drivers"\":[\""option"\"],\""equipment-identifier"\":\""$IMEI"\",\""hardware-revision"\":\""--"\",\""manufacturer"\":\""Quectel"\",\""model"\":\""$model"\",\""own-numbers"\":[],\""plugin"\":\""Quectel"\",\""ports"\":[\""ttyUSB1"\",\""ttyUSB2"\"],\""power-state"\":\""on"\",\""primary-port"\":\""ttyUSB1"\",\""revision"\":\""M0H.020001"\",\""signal-quality"\":{\""recent"\":\""yes"\",\""value"\":\""57"\"},\""sim"\":\""\/org\/freedesktop\/ModemManager1\/SIM\/0"\",\""state"\":\""connected"\",\""state-failed-reason"\":\""--"\",\""supported-bands"\":[],\""supported-capabilities"\":[\""gsm-umts, lte"\"],\""supported-ip-families"\":[\""ipv4"\",\""ipv6"\",\""ipv4v6"\"],\""supported-modes"\":[\""allowed: 2g\; preferred: none"\",\""allowed: 3g\; preferred: none"\",\""allowed: 2g, 3g\; preferred: none"\",\""allowed: 4g\; preferred: none"\",\""allowed: 2g, 4g\; preferred: none"\",\""allowed: 3g, 4g\; preferred: none"\",\""allowed: 2g, 3g, 4g\; preferred: none"\"],\""unlock-required"\":\""--"\",\""unlock-retries"\":[]}}}" > /tmp/ModemManager_Modem_Json.txt

Quality_Signal_Noise=$(gcom -d "$ComPort" -s /etc/gcom/getquality.gcom | awk NR==2)

Connected=$(echo "$Quality_Signal_Noise" | cut -d "," -f 3 | tr -d '\011\012\013\014\015\040')


if [ "$Connected" = \""LTE"\" ]
then
 RSRP=$(echo "$Quality_Signal_Noise" | cut -d "," -f 14 | tr -d '\011\012\013\014\015\040')
 RSRQ=$(echo "$Quality_Signal_Noise" | cut -d "," -f 15 | tr -d '\011\012\013\014\015\040')
 RSSI=$(echo "$Quality_Signal_Noise" | cut -d "," -f 16 | tr -d '\011\012\013\014\015\040')
 SINR=$(echo "$Quality_Signal_Noise" | cut -d "," -f 17 | tr -d '\011\012\013\014\015\040')
 echo "{\""modem"\":{\""signal"\":{\""cdma1x"\":{\""ecio"\":\""--"\",\""rssi"\":\""--"\"},\""evdo"\":{\""ecio"\":\""--"\",\""io"\":\""--"\",\""rssi"\":\""--"\",\""sinr"\":\""--"\"},\""gsm"\":{\""rssi"\":\""--"\"},\""lte"\":{\""rsrp"\":\""$RSRP"\",\""rsrq"\":\""$RSRQ"\",\""rssi"\":\""$RSSI"\",\""snr"\":\""$SINR"\"},\""refresh"\":{\""rate"\":\""10"\"},\""umts"\":{\""ecio"\":\""--"\",\""rscp"\":\""--"\",\""rssi"\":\""--"\"}}}}" > /tmp/ModemManager_Signal_get.txt
else                        
 RSSI=$(gcom -d "$ComPort" -s /etc/gcom/getstrength.gcom | awk NR==2 | cut -d ":" -f 2 | cut -d "," -f 1 | tr -d '\011\012\013\014\015\040')
 RSSI=`expr 31 - "$RSSI"`
 RSSI=`expr "$RSSI" \* 2`
 RSSI=`expr -51 - "$RSSI"`
 echo "{\""modem"\":{\""signal"\":{\""cdma1x"\":{\""ecio"\":\""--"\",\""rssi"\":\""--"\"},\""evdo"\":{\""ecio"\":\""--"\",\""io"\":\""--"\",\""rssi"\":\""--"\",\""sinr"\":\""--"\"},\""gsm"\":{\""rssi"\":\""$RSSI"\"},\""lte"\":{\""rsrp"\":\""--"\",\""rsrq"\":\""--"\",\""rssi"\":\""--"\",\""snr"\":\""--"\"},\""refresh"\":{\""rate"\":\""10"\"},\""umts"\":{\""ecio"\":\""--"\",\""rscp"\":\""--"\",\""rssi"\":\""--"\"}}}}" > /tmp/ModemManager_Signal_get.txt
fi


