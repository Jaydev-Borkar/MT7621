#!/bin/sh

# Define the path to the UCI config file to monitor
CONFIG_FOLDER="/etc/config"
CONFIG_FILE="/etc/config/remote"
DAT_FILE="/etc/wireless/mt7615/mt7615.1.dat"
SYSCON_FILE="/etc/config/sysconfig"

# Start monitoring the config file for changes
inotifywait -m -e create "$CONFIG_FOLDER" | while read path action file; do
  echo "The following changes were made to $CONFIG_FOLDER:"
  echo "$file was chnaged $action performed"
  echo "Creating new file"

 # Parse the value of passwd and ssid from the uci config file
   SSID=$(awk -F "[ ']+" '/option ssid/{print $3}' $CONFIG_FILE)
   PASSWD=$(awk -F "[ ']+" '/option passwd/{print $3}' $CONFIG_FILE)
	
  # Update the SSID1 and WPAPSK1 values in the .dat file
   sed -i "s/^\(SSID1=\).*/\1$SSID/" $DAT_FILE
   sed -i "s/^\(WPAPSK1=\).*/\1$PASSWD/" $DAT_FILE
   uci set sysconfig.wificonfig.wifi1ssid=$SSID
   uci set sysconfig.wificonfig.wifi1key=$PASSWD
   wifi
   uci commit sysconfig
done

