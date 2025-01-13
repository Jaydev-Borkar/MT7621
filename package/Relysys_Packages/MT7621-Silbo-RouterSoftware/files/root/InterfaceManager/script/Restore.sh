#!/bin/sh

. /lib/functions.sh

echo "FACTORY RESET" > /dev/console
		jffs2reset -y && reboot &

exit 0
