#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[0;37m'
mac_path="/usr/local/bin/Testscripts/Testresult/ReadMACAddr.txt"
serial_number=$(cat "$mac_path" | grep "The serial number is" | cut -d "-" -f 2 | tr -d ' ')
filename=$serial_number
file="/usr/local/bin/Testscripts/Testresult/$filename.txt"

time_stamp=$(date)

Reboot="/usr/local/bin/Testscripts/Testresult/reboot_test.txt"
reboot_test=$(cat $Reboot | cut -d "=" -f2 | tr -d '\011\012\013\014\015\040')

board_test=$(cat $file | grep -o "FAIL" "$file" | head -1)
echo "=====================================================================================                                                   
                                 BOARD TEST                                                                                                   
====================================================================================="  
if [ "$board_test" = "FAIL" ];then	
	echo -e "\e[1;31m [$time_stamp]	Board Test status = FAIL \e[0m"
	board_test="Fail"
else
	echo -e "\e[1;32m [$time_stamp]	Board Test status = PASS \e[0m"
	board_test="Pass"
fi 

model_path="/tmp/sysinfo/model"
device_model=$(cat "$model_path" | sed 's/Invendis//g')
device_name=$(cat "$model_path" | sed 's/Invendis Silbo-//g')
device_type=$(cat "$model_path" | grep -o GW)
if [ -z "$device_type" ];then
	devicetype="Router"
else
	devicetype="Gateway"
fi

wan_mac_address=$(grep "The wan mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
lan_mac_address=$(grep "The lan mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
lan1_mac_address=$(grep "The lan1 mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
lan2_mac_address=$(grep "The lan2 mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
lan3_mac_address=$(grep "The lan3 mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
lan4_mac_address=$(grep "The lan4 mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
wifi_mac_address_2GHz=$(grep "The wlan0 mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
wifi_mac_address_5GHz=$(grep "The wlan1 mac addr is" "$file" | cut -d "-" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')

if [ -z "$wifi_mac_address_2GHz" ];then
	wifi_mac_address_2GHz="Not Enabled"
fi

if [ -z "$wifi_mac_address_5GHz" ];then
	wifi_mac_address_5GHz="Not Enabled"
fi

firmware_version_1=$(grep "Firmware_Version_1" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
modemname1=$(grep "Modem1_name" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
modemmodel1=$(grep "Modem1_model" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
imei_no_1=$(grep "IMEI Number_1" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
qccid1=$(cat "$file" | grep "QCCID Number_1" | cut -d "=" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
sim1_strength=$(cat "$file" | grep "Signal Strength_1" | cut -d "=" -f 2 | tr -d ' ')

firmware_version_2=$(grep "Firmware_Version_2" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
modemname2=$(grep "Modem2_name" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
modemmodel2=$(grep "Modem2_model" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
imei_no_2=$(grep "IMEI Number_2" "$file" | awk -F '=' '{print $2}' | tr -d ' ')
qccid2=$(cat "$file" | grep "QCCID Number_2" | cut -d "=" -f 2 | tr -d ' ' | tr -d '\007\010\011\012\013\014\015')
sim2_strength=$(cat "$file" | grep "Signal Strength_2" | cut -d "=" -f 2 | tr -d ' ')

sim_switch=$(cat "$file" | grep "Sim Switching TEST for Modem 1" | cut -d "=" -f 2 | tr -d ' ')

ping_test1=$(cat "$file" | grep "lan1 port speed" | cut -d "=" -f 2 | tr -d ' ')
ping_test2=$(cat "$file" | grep "Ethernet eth0.2 Ping Test" | cut -d "=" -f 2 | tr -d ' ')
ping_test3=$(cat "$file" | grep "Ethernet eth0.3 Ping Test" | cut -d "=" -f 2 | tr -d ' ')
ping_test4=$(cat "$file" | grep "Ethernet eth0.4 Ping Test" | cut -d "=" -f 2 | tr -d ' ')
wan_test=$(cat "$file" | grep "Ethernet eth0.5 Ping Test" | cut -d "=" -f 2 | tr -d ' ')
rs_wan_test=$(cat "$file" | grep "Ethernet eth0.3 Ping Test" | cut -d "=" -f 2 | tr -d ' ')
id04_B_wan_test=$(cat "$file" | grep "Ethernet eth0.4 Ping Test" | cut -d "=" -f 2 | tr -d ' ')

pgrm_led_test=$(cat "$file" | grep "pgrm_LED Test" | cut -d "=" -f 2 | tr -d ' ')
sig_str_led_test=$(cat "$file" | grep "Signal Strength LED Test" | cut -d "=" -f 2 | tr -d ' ')
RS485_test=$(cat "$file" | grep "RS485 test" | cut -d "=" -f 2 | tr -d ' ')

if [ "$pgrm_led_test" = "PASS" ] && [ "$sig_str_led_test" = "PASS" ];then
	led_test="PASS"
else
	led_test="FAIL"
fi

modem1_test=$(cat "$file" | grep "Modem1 Ping Test" | cut -d "=" -f 2 | tr -d ' ')
modem2_test=$(cat "$file" | grep "Modem2 Ping Test" | cut -d "=" -f 2 | tr -d ' ')

modem_status=$(cat "$file" | grep "Modem GPIO Test" | cut -d "=" -f 2 | tr -d ' ')

reset_test=$(cat "$file" | grep "Reset Button Test" | cut -d "=" -f 2 | tr -d ' ')
wps_test=$(cat "$file" | grep "WPS_Test" | cut -d "=" -f 2 | tr -d ' ')

wifi_signal_strength_with_unit_2GHz=$(cat "$file" | grep "the signal strength of wifi 2ghz is" | cut -d "=" -f 2 | tr -d ' ')
wifi_signal_strength_with_unit_5GHz=$(cat "$file" | grep "the signal strength of wifi 5ghz is" | cut -d "=" -f 2 | tr -d ' ')

if [ -z "$wifi_signal_strength_with_unit_2GHz" ];then
	wifi_signal_strength_with_unit_2GHz="Not Enabled"
fi

if [ -z "$wifi_signal_strength_with_unit_5GHz" ];then
	wifi_signal_strength_with_unit_5GHz="Not Enabled"
fi

external_usb3_test=$(cat "$file" | grep "External USB3 Test" | cut -d "=" -f 2 | tr -d ' ')
external_usb2_test=$(cat "$file" | grep "External USB2 Test" | cut -d "=" -f 2 | tr -d ' ')
usb_gpio_test=$(cat "$file" | grep "USB GPIO TEST" | cut -d "=" -f 2 | tr -d ' ')

#Wifi led test for RN50 Board
wifi_led_test_2_4=$(cat "$file" | grep "Wifi_2.4GHz_LED Test" | cut -d "=" -f 2 | tr -d ' ')
wifi_led_test_5=$(cat "$file" | grep "Wifi_5GHz_LED Test" | cut -d "=" -f 2 | tr -d ' ')

if [ "$wifi_led_test_2_4" = "PASS" ] && [ "$wifi_led_test_5" = "PASS" ];then
	wifi_led_test="PASS"
else
	wifi_led_test="FAIL"
fi

rm -f /root/.ssh/known_hosts

sleep 2
echo "SENDING DATA TO SERVER.........."

if [ "$device_name" = "RK5X" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"modem2_firmware_version":"$firmware_version_2",
	"modem2_name":"$modemname2",
	"modem2_model":"$modemmodel2",
	"imei_number_for_modem_2":"$imei_no_2",
	"qccid_for_sim2":"$qccid2",
	"sim2_signal_strength":"$sim2_strength", 
	"sim_switch_test":"$sim_switch", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem2_ping_status":"$modem2_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RS5X" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"sim_switch_test":"$sim_switch", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"wan_ping status":"$rs_wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RV00" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$pgrm_led_test",
	"reset_switch_test_status":"$reset_test",
	"external_usb3_test_status":"$external_usb3_test",
	"external_usb2_test_status":"$external_usb2_test",
	"usb_gpio_test_status":"$usb_gpio_test",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RV54-1" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"sim_switch_test":"$sim_switch",
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RV54-2" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"modem2_firmware_version":"$firmware_version_2",
	"modem2_name":"$modemname2",
	"modem2_model":"$modemmodel2",
	"imei_number_for_modem_2":"$imei_no_2",
	"qccid_for_sim2":"$qccid2",
	"sim2_signal_strength":"$sim2_strength", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem2_ping_status":"$modem2_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RVW50" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$pgrm_led_test",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "ID04-B-GW" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan_mac":"$lan_mac_address",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"sim_switch_test":"$sim_switch", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"wan_ping status":"$id04_B_wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"RS485_test":"$RS485_test",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RG04" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"modem2_firmware_version":"$firmware_version_2",
	"modem2_name":"$modemname2",
	"modem2_model":"$modemmodel2",
	"imei_number_for_modem_2":"$imei_no_2",
	"qccid_for_sim2":"$qccid2",
	"sim2_signal_strength":"$sim2_strength", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$pgrm_led_test",
	"modem1_ping_status":"$modem1_test",
	"modem2_ping_status":"$modem2_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RU00" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$pgrm_led_test",
	"reset_switch_test_status":"$reset_test",
	"wps_test_status":"$wps_test",
	"external_usb3_test_status":"$external_usb3_test",
	"external_usb2_test_status":"$external_usb2_test",
	"usb_gpio_test_status":"$usb_gpio_test",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RL5X" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"lan2_mac":"$lan2_mac_address",
	"lan3_mac":"$lan3_mac_address",
	"lan4_mac":"$lan4_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"modem2_firmware_version":"$firmware_version_2",
	"modem2_name":"$modemname2",
	"modem2_model":"$modemmodel2",
	"imei_number_for_modem_2":"$imei_no_2",
	"qccid_for_sim2":"$qccid2",
	"sim2_signal_strength":"$sim2_strength", 
	"lan1_ping_status":"$ping_test1",
	"lan2_ping_status":"$ping_test2",
	"lan3_ping_status":"$ping_test3",
	"lan4_ping_status":"$ping_test4",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem2_ping_status":"$modem2_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RQ5X" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"modem1_firmware_version":"$firmware_version_1",
	"modem1_name":"$modemname1",
	"modem1_model":"$modemmodel1",
	"imei_number_for_modem_1":"$imei_no_1",
	"qccid_for_sim1":"$qccid1",
	"sim1_signal_strength":"$sim1_strength", 
	"sim_switch_test":"$sim_switch", 
	"lan1_ping_status":"$ping_test1",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$led_test",
	"modem1_ping_status":"$modem1_test",
	"modem_on_off_status":"$modem_status",
	"reset_switch_test_status":"$reset_test",
	"wps_test_status":"$wps_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
elif [ "$device_name" = "RN50" ]
then
data=$(cat <<EOF
{
  "device_id": "$serial_number",
  "device_type": "$devicetype",
  "device_model": "$device_model",
  "testing_time": "$time_stamp",
  "board_test_status":"$board_test",
  "json_data": {
	"device_id":"$serial_number",
	"device_type":"$devicetype",
	"device_model":"$device_model",
	"testing_time":"$time_stamp",
	"board_test_status":"$board_test",    
	"wan_mac":"$wan_mac_address",
	"lan1_mac":"$lan1_mac_address",
	"wifi_mac_2GHz":"$wifi_mac_address_2GHz",
	"wifi_mac_5GHz":"$wifi_mac_address_5GHz",
	"lan1_ping_status":"$ping_test1",
	"wan_ping status":"$wan_test", 
	"led_test_status":"$wifi_led_test",
	"reset_switch_test_status":"$reset_test",
	"wifi_signal_strength_2GHz":"$wifi_signal_strength_with_unit_2GHz",
	"wifi_signal_strength_5GHz":"$wifi_signal_strength_with_unit_5GHz",
	"reboot_status":"$reboot_test",
	"record_type":"1"
  }
}
EOF
)
fi

echo "$data"
max_attempts=5
attempts=0

while [ $attempts -lt $max_attempts ]; do
    if ping -c 1 -W 2 "productionapp.silbo.co.in" &> /dev/null; then
        echo "Server is reachable. Sending data..."
        curl --data "$data" -k -v https://productionapp.silbo.co.in/api/save_data/
        break  # exit the loop once data is sent
    else
        echo "Server is not reachable. Retrying in 10 seconds (attempt $((attempts + 1)) of $max_attempts)..."
        sleep 10
        attempts=$((attempts+1))
    fi
done

if [ $attempts -eq $max_attempts ]; then
    echo "Failed to send data after $max_attempts attempts. Exiting with an error."
fi

if [ "$board_test" = "Pass" ];then
	echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt

	echo "
	 ____   _    ____ ____  
	|  _ \ / \  / ___/ ___| 
	| |_) / _ \ \___ \___ \ 
	|  __/ ___ \ ___) |__) |
	|_| /_/   \_\____/____/ 
							
	" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
	 echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
						   
		mv /usr/local/bin/Testscripts/Testresult/$filename.txt /usr/local/bin/Testscripts/Testresult/Pass/$filename.txt
else
	echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
	 
	echo "
	 _____ _    ___ _     
	|  ___/ \  |_ _| |    
	| |_ / _ \  | || |    
	|  _/ ___ \ | || |___ 
	|_|/_/   \_\___|_____|
						  
	" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt
	 echo "==============================================" | tee -a /usr/local/bin/Testscripts/Testresult/$filename.txt

		mv /usr/local/bin/Testscripts/Testresult/$filename.txt /usr/local/bin/Testscripts/Testresult/Fail/$filename.txt
fi  
