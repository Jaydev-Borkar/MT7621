#!/bin/sh

smpirqaffinity=$(uci get sysconfig.offloading.smpirqaffinity)
enableflowoffloading=$(uci get sysconfig.offloading.enableflowoffloading)

Flow_Offloading()
{
	#The Flow_Offloading increase the performance in iperf3/speed of the ethernet throughput. 
	if [ "$enableflowoffloading" = "1" ]
	then
		uci set firewall.@defaults[0].flow_offloading=1
		uci set firewall.@defaults[0].flow_offloading_hw=1
	else
		uci delete firewall.@defaults[0].flow_offloading=1 > /dev/null 2>&1
		uci delete firewall.@defaults[0].flow_offloading_hw=1 > /dev/null 2>&1
	fi
	
	#Smp IRQ Affinity is used to divide the load of the ethernet and the usb.
	if [ "$smpirqaffinity" = "1" ]
	then
		
		#CPU3
		echo 8 > /proc/irq/`grep ethernet /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
		
		#CPU1
		echo 2 > /proc/irq/`grep xhci /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
		
	else
		
		#all cores
		echo f > /proc/irq/`grep ethernet /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
		
		#all cores
		echo f > /proc/irq/`grep xhci /proc/interrupts|awk -F ':' '{print $1}'|xargs`/smp_affinity
	fi
	uci commit firewall	
}

Flow_Offloading

exit 0
