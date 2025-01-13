
#!/bin/bash


# Specify output file
output_file="/etc/snmp/wireless_info.txt"

# Clear existing content in the output file
> "$output_file"

wifi1enable=$(uci get sysconfig.wificonfig.wifi1enable)
if [ "$wifi1enable" = "0" ]
then 
	exit 0
fi

# Function to get Remaining value from uci and write to file
get_and_write() {
    local uci_key="$1"
    local parameter_name="$2"
    local output_file="$3"
    local value=$(uci get "$uci_key")
    
    echo "$parameter_name : $value" >> "$output_file"
}

# Function to get Bandwidth from uci and write to file
get_and_write_bandwidth() {
    local uci_key="$1"
    local parameter_name="$2"
    local output_file="$3"
    local value=$(uci get "$uci_key")
    
    #WIFI 2.4GHz
    if [ "$uci_key" = "wireless.ra0.htmode" ]
    then
		if [ "$value" = "0" ];then
			value="20 MHz"
		else
			value="20/40 MHz"
		fi		
	else
	#WIFI 5GHz
		if [ "$value" = "VHT20" ];then
			value="20 MHz"
		elif [ "$value" = "VHT40" ];then
			value="20/40 MHz"
		elif [ "$value" = "VHT80" ];then
			value="80 MHz"
		else
			#Input value is disable from GUI
			value=0
		fi	
    fi
    
    echo "$parameter_name : $value" >> "$output_file"
}

# Function to get Country Region from dat file for 2.4 GHz and write to file
get_and_write_country_region()
{
	local uci_key="$1"
    local parameter_name="$2"
    local output_file="$3"
    
    #WIFI 2.4
	if [ "$uci_key" = "CountryRegion_wifi2" ];then
		value=$(cat /etc/wireless/mt7615/mt7615.1.dat | grep -w CountryRegion | cut -d "=" -f 2)
	#WIFI 5
	else
		value="auto"
	fi
	
	echo "$parameter_name : $value" >> "$output_file"
}


# 2.4GHz Information
echo "2.4GHz Configuration:" >> "$output_file"

#check 2.4GHz wifi is working in which mode...
ap_mode=$(uci get wireless.ra0_ap.disabled)
client_mode=$(uci get wireless.sta.disabled)

#If Radio mode is Access Point and Client both...
if [ "$ap_mode" = "0" ] && [ "$client_mode" = "0" ]
then
	echo "Radio_Mode_2.4GHz : apsta" >> "$output_file"
	get_and_write "wireless.ra0.band" "WirelessMode_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.country" "Country_Code_2.4GHz" "$output_file"
	get_and_write_country_region "CountryRegion_wifi2" "Country_Region_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.channel" "Channel_2.4GHz" "$output_file"
	get_and_write_bandwidth "wireless.ra0.htmode" "Channel_Bandwidth_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.txpower" "TXpower_2.4GHz" "$output_file"
	ap_ssid=$(uci get wireless.ra0_ap.ssid)
	client_ssid=$(uci get wireless.sta.ssid)
	echo "Radio_2.4GHz_SSID : ap:$ap_ssid , sta:$client_ssid" >> "$output_file"

#If Radio mode is Client only...	
elif [ "$client_mode" = "0" ]
then
	get_and_write "wireless.sta.mode" "Radio_Mode_2.4GHz" "$output_file"
	echo "WirelessMode_2.4GHz : NA" >> "$output_file"
	echo "Country_Code_2.4GHz : NA" >> "$output_file"
	echo "Country_Region_2.4GHz : NA" >> "$output_file"
	echo "Channel_2.4GHz : NA" >> "$output_file"
	echo "Channel_Bandwidth_2.4GHz : NA" >> "$output_file"
	echo "TXpower_2.4GHz : NA" >> "$output_file"
	get_and_write "wireless.sta.ssid" "Radio_2.4GHz_SSID" "$output_file"
	
#If Radio mode is Access Point only...	
elif [ "$ap_mode" = "0" ]
then
	get_and_write "wireless.ra0_ap.mode" "Radio_Mode_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.band" "WirelessMode_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.country" "Country_Code_2.4GHz" "$output_file"
	get_and_write_country_region "CountryRegion_wifi2" "Country_Region_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.channel" "Channel_2.4GHz" "$output_file"
	get_and_write_bandwidth "wireless.ra0.htmode" "Channel_Bandwidth_2.4GHz" "$output_file"
	get_and_write "wireless.ra0.txpower" "TXpower_2.4GHz" "$output_file"
	get_and_write "wireless.ra0_ap.ssid" "Radio_2.4GHz_SSID" "$output_file"
else
	echo "Select Radio mode..."
fi

#2.4GHz Guest Wifi SSID
#Check 2.4GHz Guest wifi is enabled...
guest_wifi_2=$(uci get sysconfig.guestwifi.guestwifienable2)
if [ "$guest_wifi_2" = "1" ];then
	guest_wifi_ssid_2=$(uci get wireless.ra1_ap.ssid)
	echo "Radio_2.4GHz_guest_wifi_SSID : $guest_wifi_ssid_2" >> "$output_file"
else
	echo "Radio_2.4GHz_guest_wifi_SSID : NA" >> "$output_file"
fi

# Add a separator between 2.4GHz and 5.0GHz sections
echo -e "\n5.0GHz Configuration:" >> "$output_file"

# 5.0GHz Information
get_and_write "wireless.rai0_ap.mode" "Radio_Mode_5.0GHz" "$output_file"
get_and_write "wireless.rai0.band" "WirelessMode_5.0GHz" "$output_file"
get_and_write "wireless.rai0.country" "Country_Code_5.0GHz" "$output_file"
get_and_write_country_region "CountryRegion_wifi5" "Country_Region_5.0GHz" "$output_file"
get_and_write "wireless.rai0.channel" "Channel_5.0GHz" "$output_file"
get_and_write_bandwidth "wireless.rai0.htmode" "Channel_Bandwidth_5.0GHz" "$output_file"
get_and_write "wireless.rai0.txpower" "TXpower_5.0GHz" "$output_file"
get_and_write "wireless.rai0_ap.ssid" "Radio_SSID_5.0GHz" "$output_file"

#5GHz Guest Wifi SSID
#Check 5GHz Guest wifi is enabled...
guest_wifi_5=$(uci get sysconfig.guestwifi.guestwifienable5)
if [ "$guest_wifi_5" = "1" ];then
	guest_wifi_ssid_5=$(uci get wireless.rai1_ap.ssid)
	echo "Radio_guest_wifi_SSID_5.0GHz : $guest_wifi_ssid_5" >> "$output_file"
else
	echo "Radio_guest_wifi_SSID_5.0GHz : NA" >> "$output_file"
fi

echo "Wireless information has been collected and stored in $output_file."
