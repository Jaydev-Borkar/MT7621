#!/bin/sh

ACTION="$1"
INTERFACE="$2"

logger -t mwan3 "<Iptables Check> ${INTERFACE} ${ACTION}."

# Get all offline interfaces using ubus call
offline_interfaces=$(ubus call mwan3 status 2>/dev/null | jq -r '.interfaces | to_entries[] | select(.value.status != "online") | .key')

if [ -z "$offline_interfaces" ]; then
	logger -t mwan3 "<Iptables Check> No offline interfaces found."
	exit 0
fi

logger -t mwan3 "<Iptables Check> The interfaces with offline status are - $offline_interfaces."

# Process each offline interface
for name in $offline_interfaces; do

	for chain in OUTPUT FORWARD INPUT; do

		# Convert the chain name to lowercase for matching
		chain_lower=$(echo "$chain" | tr '[:upper:]' '[:lower:]')

		while true; do
			# Get the line number to be deleted
			line_number=$(iptables -t filter -L -n --line-numbers | grep -i "zone_${name}_${chain_lower}" | awk '{print $1}' | head -n 1)

			# Validate that line_number is a digit
			if ! echo "$line_number" | grep -qE '^[0-9]+$'; then
				logger -t mwan3 "<Iptables Check> Invalid line number '$line_number'. Exiting loop for chain $chain."
				break
			fi

			# Retry logic for iptables deletion
			retry_count=0
			max_retries=2

			while [ "$retry_count" -lt "$max_retries" ]; do
				logger -t mwan3 "<Iptables Check> Attempting to delete line $line_number of $name from $chain (Attempt $((retry_count + 1)))."

				if iptables -w -D $chain $line_number; then
					logger -t mwan3 "<Iptables Check> Successfully deleted line $line_number of $name from $chain."
					break
				else
					retry_count=$((retry_count + 1))
					logger -t mwan3 "<Iptables Check> Failed to delete line $line_number of $name from $chain. Retrying..."
					sleep 2  # Wait before retrying
				fi
			done

			# Check if retries exceeded the limit
			if [ "$retry_count" -eq "$max_retries" ]; then
				logger -t mwan3 "<Iptables Check> Exceeded maximum retries for deleting line $line_number of $name from $chain. Skipping."
				break
			fi

		done

	done

done

