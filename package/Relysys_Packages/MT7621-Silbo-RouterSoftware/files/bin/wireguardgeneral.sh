#!/bin/sh

. /lib/functions.sh

wireguardUCIPath=/etc/config/wireguard

Networkrestart="/etc/init.d/network restart"

ReadwireguardUCIConfig() {
    config_load "$wireguardUCIPath"
    config_foreach wireguardConfigParameters wireguard
}

wireguardConfigParameters() {

    local wireguardConfigSection="$1"
    config_get Name "$wireguardConfigSection" name

    echo $Name
    uci delete network.wireguard_$Name

    uci delete network.$Name
    uci delete firewall.wireguard

    wanCount=$(cat /etc/waninterface.txt | wc -l)
    lanCount=$(cat /etc/internetoverlan.txt | wc -l)
    for j in $(seq 1 ${wanCount}); do

        wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)
        uci delete firewall.wireguard${wan}
        uci delete firewall.${wan}wireguard

    done
    for j in $(seq 1 ${lanCount}); do

        lan=$(cat /etc/internetoverlan.txt | head -${j} | tail -1)
        uci delete firewall.wireguard${lan}
        uci delete firewall.${lan}wireguard

    done
}

ReadwireguardUCIConfig

uci commit network
uci commit firewall

/etc/init.d/firewall restart

response=$($Networkrestart)

