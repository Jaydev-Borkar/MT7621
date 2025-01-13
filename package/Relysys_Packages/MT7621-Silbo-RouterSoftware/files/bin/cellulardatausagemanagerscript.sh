#!/bin/sh
. /lib/functions.sh

sysconfigUCIPath=/etc/config/sysconfig
sysconfigsection="sysconfig"

simswitchconfigUCIPath=/etc/config/simswitchconfig
simswitchconfigsection="simswitchconfig"

#Load sysconfig file
config_load "$sysconfigUCIPath"
config_get CellularOperationMode "$sysconfigsection" CellularOperationMode 
config_get enablecellular "$sysconfigsection" enablecellular

#Load simswitchconfig file
config_load "$simswitchconfigUCIPath"
config_get Simswitchbasedon "$simswitchconfigsection" simswitch
config_get cellulardatausagemanagerperiodicity "$simswitchconfigsection" cellulardatausagemanagerperiodicity
config_get dayofmonth "$simswitchconfigsection" dayofmonth

if [ "$enablecellular" = "1" ]
then
	if [ "$CellularOperationMode" = "singlecellulardualsim" ]
	then
		if [ "$Simswitchbasedon" = "datalim" ]
		then
			if [ "$cellulardatausagemanagerperiodicity" = "daily" ]
			then      
				# add entry to cron file
				sed -i '/Reset_data_usage.sh/d' /etc/crontabs/root
				echo "*/2 * * * * /root/InterfaceManager/script/Reset_data_usage.sh" >> /etc/crontabs/root
		   
			elif [ "$cellulardatausagemanagerperiodicity" = "monthly" ]
			then      
				# add entry to cron file
				sed -i '/Reset_data_usage.sh/d' /etc/crontabs/root
				echo "*/2 * $dayofmonth * * /root/InterfaceManager/script/Reset_data_usage.sh" >> /etc/crontabs/root
			
			else
				echo "cellulardatausagemanagerperiodicity is not select..."
				sed -i '/Reset_data_usage.sh/d' /etc/crontabs/root
			fi
		else
			echo "Simswitchbasedon is not set as datalim..."
			sed -i '/Reset_data_usage/d' /etc/crontabs/root
		fi
	else
		echo "CellularOperationMode is not set as singlecellulardualsim..."
	fi
else
	echo "enablecellular is not enabled..."
fi
exit 0


