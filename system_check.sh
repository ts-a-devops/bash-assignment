#!/bin/bash

# Define the log file with a time stamp
LOG_FILE="system_report_$(date +%Y%m%d_%H%M).log"
echo "--- Generating system report---" | tee -a $LOG_FILE

# 1: Disk usauge (df -h)
echo -e "\nDisk Space Usage:" >> "$LOG_FILE"
df -h | grep '^/dev/'  >> "$LOG_FILE"

# Alert for disk usage
usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ "$usage" -gt 80 ]; then
	               echo " WARNING: Disk usage is at ${usage}%!" >> "$LOG_FILE"
fi

# 2: Memory usage (free -m)
echo -e "\nMMemory Usage:" >> "$LOG_FILE"
free -h >> "$LOG_FILE"

# 3: CPU load (uptime)
echo "CPU Uptime:" >> "$LOG_FILE"
uptime >> "$LOG_FILE"

# 4: Count total running processes
echo -e "\nTotal Running Processes:" >> "$LOG_FILE"
ps aux | wc -l >> "$LOG_FILE"

# 5: Display top 5 memory consuming processe
echo -e "\nTop 5 Memory-Consuming Processes:" >> "$LOG_FILE"
# ps aux : list proceses, --sort=-%mem: highest memory firt, head -n 6: top 5 + header
ps aux --sort=-%mem | head -n 6 >> "$LOG_FILE"

echo " Report saved to $LOG_FILE"

