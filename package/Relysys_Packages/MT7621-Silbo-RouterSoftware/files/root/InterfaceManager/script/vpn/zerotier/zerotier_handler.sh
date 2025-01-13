#!/bin/sh

. /lib/functions.sh

zerotirestop="/etc/init.d/zerotier stop"

zerotirestart="/etc/init.d/zerotier start"

Enablezerotire=$(uci get vpnconfig1.general.enablezerotiergeneral)
       wanCount=$(cat /etc/waninterface.txt | wc -l)
       lanCount=$(cat /etc/internetoverlan.txt | wc -l)

if [ "$Enablezerotire" = "1" ]; then
       response=$($zerotirestart)

       #Firewall
       #All the VPN features are working with single ZONE
       uci set firewall.zerotier=zone
       uci set firewall.zerotier.name="zerotier"
       uci set firewall.zerotier.input="ACCEPT"
       uci set firewall.zerotier.output="ACCEPT"
       uci set firewall.zerotier.forward="ACCEPT"
       uci set firewall.zerotier.device="zt+"
       uci set firewall.zerotier.masq="1"
       uci set firewall.zerotier.mtu_fix="1"

       for j in $(seq 1 ${wanCount}); do

              wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)

              #Creating the firewall Forwarding ZONE

              uci set firewall.${wan}zerotier="forwarding"
              uci set firewall.${wan}zerotier.src="Sample"
              uci set firewall.${wan}zerotier.dest=${wan}

              uci set firewall.zerotier${wan}="forwarding"
              uci set firewall.zerotier${wan}.src=${wan}
              uci set firewall.zerotier${wan}.dest="Sample"

       done
       
       for j in $(seq 1 ${lanCount}); do
              lan=$(cat /etc/internetoverlan.txt | head -${j} | tail -1)

              uci set firewall.${lan}zerotier="forwarding"
              uci set firewall.${lan}zerotier.src="Sample"
              uci set firewall.${lan}zerotier.dest=${lan}

              uci set firewall.zerotier${lan}="forwarding"
              uci set firewall.zerotier${lan}.src=${lan}
              uci set firewall.zerotier${lan}.dest="Sample"

       done
else
       response=$($zerotirestop)
       for j in $(seq 1 ${wanCount}); do

              wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)
              uci delete firewall.zerotier${wan}
              uci delete firewall.${wan}zerotier

       done

       for j in $(seq 1 ${lanCount}); do

              lan=$(cat /etc/internetoverlan.txt | head -${j} | tail -1)
              uci delete firewall.zerotier${lan}
              uci delete firewall.${lan}zerotier

       done
    CellularOperationMode=$(uci get sysconfig.sysconfig.CellularOperationMode)    
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]                                                          
	then
		modem1=CWAN1
		modem2=CWAN1
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]                                                          
	then 
		modem1=CWAN1_0
		modem2=CWAN1_1
	else
		modem1=CWAN1
	fi
	
	if [ "$enable_cellular" = "1" ]
	then
		if [ "$CellularOperationModelocal" = "singlecellularsinglesim" ]                                                          
		then 
			uci set firewall.${modem1}zerotier="forwarding"
			uci set firewall.${modem1}zerotier.src="Sample"
			uci set firewall.${modem1}zerotier.dest=${modem1}
		else
			uci set firewall.${modem1}zerotier="forwarding"
			uci set firewall.${modem1}zerotier.src="Sample"
			uci set firewall.${modem1}zerotier.dest=${modem1}
			uci set firewall.${modem2}zerotier="forwarding"
			uci set firewall.${modem2}zerotier.src="Sample"
			uci set firewall.${modem2}zerotier.dest=${modem2}
		fi
	else
		uci delete firewall.${modem1}zerotier
		uci delete firewall.${modem2}zerotier
	fi
fi

uci commit firewall
