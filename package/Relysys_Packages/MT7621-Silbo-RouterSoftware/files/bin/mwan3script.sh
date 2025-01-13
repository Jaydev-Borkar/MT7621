#!/bin/sh

CellularOperationModelocal=$(uci get sysconfig.sysconfig.CellularOperationMode)

if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
then
	# Wait until any one flag is present
	while [ ! -f /tmp/add1_flag ] && [ ! -f /tmp/add2_flag ]; do
	sleep 1
	done

	# Check if either AddInterface_mod1.sh or AddInterface_mod2.sh is still running
	while ps | grep "$(cat /tmp/add1_pid 2>/dev/null)" >/dev/null | grep -v grep || ps | grep "$(cat /tmp/add2_pid 2>/dev/null)" >/dev/null | grep -v grep; do
		sleep 1
	done

	rm /tmp/add1_pid /tmp/add1_flag
	rm /tmp/add2_pid /tmp/add2_flag

	sleep 15

	#Need this for dual modem
	/etc/init.d/firewall restart > /dev/null 2>&1

	sleep 2

	/usr/sbin/mwan3 restart &

else
	# Wait until the flag are present
	while [ ! -f /tmp/add1_flag ]; do
		sleep 1
	done

	# Check if AddInterface_mod1.sh is still running
	while ps | grep "$(cat /tmp/add1_pid 2>/dev/null)" >/dev/null | grep -v grep; do
		sleep 1
	done
	
	rm /tmp/add1_pid /tmp/add1_flag
	
	sleep 15
	
	#Need this for dual modem
	/etc/init.d/firewall restart > /dev/null 2>&1
	
	sleep 2
	
	/usr/sbin/mwan3 restart &
	
fi
