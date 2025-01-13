#!/bin/sh

. /lib/functions.sh 

echo  "$1 $2" >>  /tmp/Sig.txt

num_intervals=5

rsrp_total=0
sinr_total=0
rsrp_count=0
sinr_count=0

line=$(wc -l < /tmp/Sig.txt)

if [ $line -gt $((num_intervals-1)) ]
then 
	 for i in $(seq 1 $num_intervals)
	do 
		rsrp=$(cat /tmp/Sig.txt | head -$i | tail -1 | cut -d " " -f 1)
		sinr=$(cat /tmp/Sig.txt | head -$i | tail -1 | cut -d " " -f 2)
		
		rsrp_total=$(expr $rsrp_total + $rsrp) 
		sinr_total=$(expr $sinr_total + $sinr)   
   
	done
	
rsrp_avg=$(expr $rsrp_total / $num_intervals) 
sinr_avg=$(expr $sinr_total / $num_intervals)

threshold_rsrp=$(uci get simswitchconfig.simswitchconfig.threshrsrp)
echo $threshold_rsrp
threshold_sinr=$(uci get simswitchconfig.simswitchconfig.threshsinr)
echo $threshold_sinr

if [[ "$rsrp_avg" -lt "$threshold_rsrp" ]] &&  [[ "$sinr_avg" -lt "$threshold_sinr" ]]
then
	simnumfile=$(cat /tmp/simnumfile)
	if [ "$simnumfile" = "1" ]
	then
		/bin/simswitch 2
	else 
		/bin/simswitch 1
	fi
	rm -rf /tmp/Sig.txt
fi

echo "$(cat /tmp/Sig.txt | tail -$(($num_intervals-1)))" > /tmp/Sig.txt

fi


