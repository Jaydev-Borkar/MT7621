#!/bin/sh

. /lib/functions.sh

#
# PKG_RELEASE: 1.01
#

#
# Input arguments and Default Parameters
#
InterfaceName="$1"
ScriptStatustDir="/tmp/InterfaceManager/status"
ScriptLogDir="/tmp/InterfaceManager/log"
DeleteStatusFile="$ScriptStatustDir/$InterfaceName"".DeleteIfaceStatus"
AddIfaceStatusFile="$ScriptStatustDir/$InterfaceName"".AddIfaceStatus"
PortDetailsFile="$ScriptStatustDir/$InterfaceName"".ports"
lockfile="/var/run/$InterfaceName""DeleteIface.lockfile"
SleepAfterIfdown=5

[ -d "$ScriptStatustDir" ]  || mkdir -p "$ScriptStatustDir"
[ -d "$ScriptLogDir" ]  || mkdir -p "$ScriptLogDir"

#
# verify input arguments
#
if [ "x$InterfaceName" = "x" ]
then
    echo "Usage: $0 InterfaceName"
    echo "status=Invalid interface" > "$DeleteStatusFile"
    exit 1
fi

#
# 
#
if ( set -o noclobber; echo $$ > "$lockfile") 2> /dev/null
then
    trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
    ifdown "$InterfaceName" > /dev/null 2>&1
    sleep "$SleepAfterIfdown"
    uci delete network."$InterfaceName" > /dev/null 2>&1
    uci commit network
    ubus call network reload
    rm -f "$PortDetailsFile"
    rm -f "$AddIfaceStatusFile"
    echo "status=Disabled" > "$DeleteStatusFile"
    rm -f "$lockfile"
    trap - INT TERM EXIT
fi

exit 0

