#!/bin/sh

. /lib/functions.sh


if [ ! -f "/etc/x509" ]
then 
   mkdir -p "/etc/x509"
fi

cp /etc/openwisp/remote/etc/x509/* /etc/x509/

if [ ! -f "/etc/dropbear" ]
then 
   mkdir -p "/etc/dropbear"
fi

cp /etc/openwisp/remote/etc/dropbear/authorized_keys /etc/dropbear/


VPN_NAME=$(cat /etc/openwisp/remote/etc/config/openvpn | awk NR==1 | cut -d " " -f 3 | tr -d "'")

AUTH=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".auth)

CA=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".ca)

CERT=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".cert)

CIPER=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".cipher)

DEV=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".dev)

DEV_TYPE=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".dev_type)

ENABLED=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".enabled)

KEEPALIVE=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".keepalive)

KEY=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".key)

MODE_OPENVPN=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".mode)

MUTE=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".mute)

NOBIND=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".nobind)

PERSIST_KEY=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".persist_key)

PERSIST_TUN=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".persist_tun)

PROTO=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".proto)

PULL=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".pull)

REMOTE=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".remote | tr -d "'")

REMOTE_CERT_TLS=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".remote_cert_tls)

RENEG_SEC=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".reneg_sec)

RESOLVE_RETRY=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".resolv_retry)

SCRIPT_SECURITY=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".script_security)

TLS_CLIENT=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".tls_client)

TLS_CRYPT=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".tls_crypt)

Route_NoPull=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".route_nopull) 

TLS_TIMEOUT=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".tls_timeout)

VERB=$(uci get /etc/openwisp/remote/etc/config/openvpn."${VPN_NAME}".verb)

SW_PROTO=$(uci get /etc/openwisp/remote/etc/config/network.SW_LAN.protoswlan)

SWIPADDR=$(uci get /etc/openwisp/remote/etc/config/network.SW_LAN.ipaddr)

EWAN2_GATEWAY=$(uci get /etc/openwisp/remote/etc/config/network.EWAN2.ewan2_gateway)

EWAN2_PROTO=$(uci get /etc/openwisp/remote/etc/config/network.EWAN2.ewan2_proto)

EWAN2_IP=$(uci get /etc/openwisp/remote/etc/config/network.EWAN2.ewan2_ip)


APN=$(uci get /etc/openwisp/remote/etc/config/network.usb0.apn)

APN_SIM2=$(uci get /etc/openwisp/remote/etc/config/network.usb0.APN2)

MODE=$(uci get /etc/openwisp/remote/etc/config/network.usb0.CellularMode)

DUAL_SIM=$(uci get /etc/openwisp/remote/etc/config/network.usb0.Dual_SIM)

SINGLE_SIM=$(uci get /etc/openwisp/remote/etc/config/network.usb0.Single_SIM)

DESTINATION_IP1=$(uci get /etc/openwisp/remote/etc/config/network.rule1.dest)

DESTINATION_IP2=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_Ip2)

DESTINATION_IP3=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_Ip3)

DESTINATION_IP4=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_Ip4)

DESTINATION_PORT1=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_port)

DESTINATION_PORT2=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_port2)

DESTINATION_PORT3=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_port3)

DESTINATION_PORT4=$(uci get /etc/openwisp/remote/etc/config/network.rule1.destination_port4)

SOURCE_PORT1=$(uci get /etc/openwisp/remote/etc/config/network.rule1.source_dport)

SOURCE_PORT2=$(uci get /etc/openwisp/remote/etc/config/network.rule1.source_dport1)

SOURCE_PORT3=$(uci get /etc/openwisp/remote/etc/config/network.rule1.source_dport2)

SOURCE_PORT4=$(uci get /etc/openwisp/remote/etc/config/network.rule1.source_dport3)

ACCOUNT_ID=$(uci get /etc/openwisp/remote/etc/config/network.SIA.account_id)

SERVER_IP=$(uci get /etc/openwisp/remote/etc/config/network.SIA.server_ip)

IPSEC_REMOTE_IP=$(uci get /etc/openwisp/remote/etc/config/network.IPSEC.REMOTE_IP)

IPSEC_REMOTE_ID=$(uci get /etc/openwisp/remote/etc/config/network.IPSEC.REMOTE_ID)

IPSEC_REMOTE_SUBNET1=$(uci get /etc/openwisp/remote/etc/config/network.IPSEC.REMOTE_SUBNET1)

IPSEC_LOCAL_SUBNET1=$(uci get /etc/openwisp/remote/etc/config/network.IPSEC.LOCAL_SUBNET1)

IPSEC_ENABLE=$(uci get /etc/openwisp/remote/etc/config/network.IPSEC.ipsec_enable)

IPSEC_PSK=$(uci get /etc/openwisp/remote/etc/config/network.IPSEC.PSK)

uci delete openvpn."${VPN_NAME}"

uci commit openvpn

uci set openvpn."${VPN_NAME}"=openvpn

uci set openvpn."${VPN_NAME}".auth="${AUTH}"

uci set openvpn."${VPN_NAME}".ca="${CA}" 

uci set openvpn."${VPN_NAME}".cert="${CERT}"

uci set openvpn."${VPN_NAME}".cipher="${CIPER}"

uci set openvpn."${VPN_NAME}".dev="${DEV}"

uci set openvpn."${VPN_NAME}".dev_type="${DEV_TYPE}"

uci set openvpn."${VPN_NAME}".enabled="${ENABLED}"

uci set openvpn."${VPN_NAME}".keepalive="${KEEPALIVE}"

uci set openvpn."${VPN_NAME}".key="${KEY}"

uci set openvpn."${VPN_NAME}".mode="${MODE_OPENVPN}"

uci set openvpn."${VPN_NAME}".mute="${MUTE}"

uci set openvpn."${VPN_NAME}".nobind="${NOBIND}"

uci set openvpn."${VPN_NAME}".persist_key="${PERSIST_KEY}"

uci set openvpn."${VPN_NAME}".persist_tun="${PERSIST_TUN}"

uci set openvpn."${VPN_NAME}".proto="${PROTO}"

uci set openvpn."${VPN_NAME}".pull="${PULL}"

uci set openvpn."${VPN_NAME}".remote="${REMOTE}"

uci set openvpn."${VPN_NAME}".remote_cert_tls="${REMOTE_CERT_TLS}" 

uci set openvpn."${VPN_NAME}".reneg_sec="${RENEG_SEC}"

uci set openvpn."${VPN_NAME}".resolv_retry="${RESOLVE_RETRY}"

uci set openvpn."${VPN_NAME}".script_security="${SCRIPT_SECURITY}"

uci set openvpn."${VPN_NAME}".tls_client="${TLS_CLIENT}"

uci set openvpn."${VPN_NAME}".tls_crypt="${TLS_CRYPT}"

uci set openvpn."${VPN_NAME}".tls_timeout="${TLS_TIMEOUT}"

uci set openvpn."${VPN_NAME}".route_nopull="${Route_NoPull}"

uci set openvpn."${VPN_NAME}".verb="${VERB}" 

uci commit openvpn

uci commit vpnconfig1

#uci commit siaserverconfig

#uci commit firewall

#uci commit sysconfig

/etc/init.d/firewall reload

#/bin/UpdateWanConfig.sh

sleep 2

#/root/InterfaceManager/script/SystemStart.sh

#sleep 2

sleep 2

/root/InterfaceManager/script/IpSecStart.sh

sleep 6

/etc/init.d/openvpn restart

