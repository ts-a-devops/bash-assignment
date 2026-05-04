#!/bin/bash
set -euo pipefail

# Redirect input to a .log file
ts=$(date +%d-%m-%y)

# Set Threshold 
threshold=80

# Display Disk usage
diskuse=$(df -P / | awk 'NR>1 {print $5}' | sed 's/%//')

# Display memory usage
free_memory=$(free -m) 
echo "$free_memory"
echo ""

# Display CPU loadtime
sys_uptime=$(uptime)
echo "System uptime: $sys_uptime"
echo ""
# Check if the disk usage exceeds the threshold
if [[ "$diskuse" -gt "$threshold" ]]; then
    echo "Warning! Disk usage is at $diskuse% which exceeds the threshold of $threshold%"
else
    echo "Disk usage is at $diskuse which is below the threshold of $threshold"
fi
echo ""

# count total running processes
ps_count=$(ps aux | wc -l)
echo "Total running processes is: $ps_count"
echo ""

# Display top 5 memory consuming processes
max_memory=$(ps aux | sort -k4 -nr | awk 'NR>=1 {print $4}' | head -n 5)
echo "$max_memory" 
