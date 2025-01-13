#!/bin/sh

. /lib/functions.sh

uci set sysconfig.wificonfig.wifi1enable='1'
uci set sysconfig.guestwifi.guestwifienable2='1'
uci set sysconfig.guestwifi.guestwifienable5='1'
uci commit sysconfig

sleep 1
/bin/UpdateWanConfig.sh
