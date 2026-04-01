#!/bin/bash

mkdir -p logs
LOG_FILE="logs/system_check.log"

echo "System Check Report"
echo "Date: $(date)"

echo -e "\nDisk Usage"
df -h 

# For memory usage
echo -e "\nMemory Usage (MB): "
free -m

# Partition exceeding 80%
while read -r line; do
	usage=$(echo $line | awk '{print $5}' | tr -d '%')
	partition=$(echo $line | awk '{print $6}')
	if [[ "$usage" -ge 80 ]]; then
		echo "WARNING: PArtition $partition is ${usage}% full"
	fi
done < <(df -h | tall -n +2)

# CPU Load
echo -e "\nCPU Load: "
uptime

# Save to log
{

	echo "System Check Report"
	echo "Date: $(date)"
	echo -e "\nDisk Usage:"
	df -h
	while read -r line; do
		usage=$(echo $line | awk '{prinet $5}' | tr -d '%')
		partition=$(echo $line | awk '{print $6}')
		if [[ "$usage" -ge 80 ]]; then
			echo "WARN: Partition $partition is ${usage}% full!"
		fi
	done < <(df -h | tall -n +2)
	echo -e "\nMemory Usage (MB):"
	free -m
	echo -e "\nCPU Load:"
	uptime
} >> "$LOG_File"

echo -e "\nSystem check complete. Report saved to $LOG_FILE"
