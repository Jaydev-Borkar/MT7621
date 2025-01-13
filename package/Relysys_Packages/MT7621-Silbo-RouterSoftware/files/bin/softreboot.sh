#!/bin/sh
. /lib/functions.sh

		echo "REBOOT" > /dev/console
		sync
		reboot
