#!/bin/bash

datestamp=$(date +%a_%Y_%m_%d)
LOG_FILE="logs/system_report_$datestamp"

# Create Log file
touch "$LOG_FILE"
{
echo "=== SYSTEM REPORT ($datestamp $(date +%T))===" 

# Check Disk Usage
echo "== Disk Usage =="
disk_info=$(df -h)
echo "$disk_info"

# Warn if Disk usage exceeds 80%
disk_usage=$(echo "$disk_info" | awk '$6 == "/" {print $5}' | sed 's/%//')
if [[ $disk_usage -gt 80 ]]
then
    echo "WARNING: YOUR DISK USAGE IS ABOVE 80%. Clear some files to create more space"
fi

echo ""

# Check Memory usage
echo "== Memory Usage =="
free -m 
echo ""

# CPU load
echo "== CPU Load =="
uptime
echo ""
 
} | tee -a "$LOG_FILE"

# Count total running processes
echo "Total Processes Running = $(pgrep -c .)"
echo ""

# Display top 5 memory-consuming processes
echo "== Top 5 Memory-Consuming Processes =="
ps aux --sort=-%mem | head -n 6
