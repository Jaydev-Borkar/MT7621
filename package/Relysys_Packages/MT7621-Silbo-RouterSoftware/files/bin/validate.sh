#!/bin/sh

. /lib/functions.sh

systemstartscript="/root/InterfaceManager/script/SystemStart.sh"
validateTrackIPscript="/bin/ValidateTrackIP.sh"

rm -rf /bin/wanpriorities.txt
touch /bin/wanpriorities.txt
chmod 0777 /bin/wanpriorities.txt

ReadPriority()
{
  config=$1
  config_get WanPriority "$config" wanpriority 
  echo $WanPriority >> /bin/wanpriorities.txt
  
}

rm -rf /bin/priorityvalidationoutput.txt
touch  /bin/priorityvalidationoutput.txt
chmod 0777 /bin/priorityvalidationoutput.txt


config_load "/etc/config/mwan3config" 
config_foreach ReadPriority redirect


output=$(sort /bin/wanpriorities.txt)
echo "output=$output"

if [ "$output" ]  
then 
   echo "Updating Configurations " > /bin/priorityvalidationoutput.txt
   flag=1
   $systemstartscript
    
else
	 echo "Can not update Configurations" > /bin/priorityvalidationoutput.txt
	 flag=0
fi

exit 1
