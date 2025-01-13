#!/bin/sh
. /lib/functions.sh

l2tpvpnUCIPath=/etc/config/l2tp_i_config

Readl2tpvpnUCIConfig() {
    config_load "$l2tpvpnUCIPath"
    config_foreach l2tpvpnConfigParameters service
}

l2tpvpnConfigParameters() {
    local l2tpvpnConfigSection="$1"
    config_get Name "$l2tpvpnConfigSection" name
    config_get Type "$pptpvpnConfigSection" type

    # Live status Updated. That is, shows if tunnel is up/down.
    # Check if the l2tp tunnel has been created.

    if [ "$Type" == "CLIENT" ]; then
        tunnel_check=$(ifconfig | grep -o "l2tp-$Name")

        if [ -n "$tunnel_check" ]; then
            Status="UP"
            address=$(ifconfig "pptp-$Name" | awk '/inet / {print $2}' | cut -d: -f2)
        else
            Status="DOWN"
            address=""
        fi
        uci set l2tp_i_config.$Name.status=$Status
        uci set l2tp_i_config.$Name.address=$address
    fi

    if [ "$Type" == "SERVER" ]; then

        for i in 0 1 2 3 4 5 6 7 8 9 10; do
            tunnel_status=$(ifconfig | grep -o "ppp${i}")

            #echo $i
            #echo The value of tunnel_status is : $tunnel_status

            # If the interface is found, set the Status accordingly
            if [ -n "$tunnel_status" ]; then
                Status="UP"
                address=$(ifconfig "ppp${i}" | awk '/inet / {print $2}' | cut -d: -f2)
                break
            else
                Status="DOWN"
                address=""
            fi
        done

        uci set l2tp_i_config.$Name.status=$Status
        uci set l2tp_i_config.$Name.address=$address

    fi

    
}

Readl2tpvpnUCIConfig

uci commit l2tp_i_config
