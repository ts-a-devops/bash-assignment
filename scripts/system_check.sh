#!/bin/bash

# Creating logs folder
mkdir -p logs

# Log File Path
LogFile="logs/system_report_$(date +%F).log"

#Display Disk Usage

echo "Disk Usage:" | tee -a "$LogFile"
df -h | tee -a "$LogFile"


# Warn If Disk Usage Is > 80%

echo "Warning Alert:" | tee -a "$LogFile"
df -h | tail -n +2 | while read filesytem size used avail usep mount; do
	usage=${usep%\%}
	if [[ "$usage" -gt 80 ]]; then
		echo "Alert! $mount is $usage% full!" | tee -a "$LogFile"
	fi
done


#Display Memory Usage
echo "Memory Usage:" | tee -a "$LogFile"
free -m | tee -a "$LogFile"


#Display CPU Load
echo "CPU Load:" | tee -a "$LogFile"


# Count Total Processes

TotalProcesses=$(ps aux | wc -l)
echo "Total Running Processes: $TotalProcesses" | tee -a "$LogFile"


# Top 5 Memory Consumers

echo "Top 5 Memory Consuming Processes" | tee -a "$LogFile"
ps aux --sort=-%mem | head -n 6 | tee -a "$LogFile"







