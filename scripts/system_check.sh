#!/bin/bash

DATE=$(date +%F)
LOG_FILE="../logs/system_report_$DATE.log"

echo "System Report - $DATE" > "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk warning
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%" | tee -a "$LOG_FILE"
fi

# Process count
echo "Total running processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

# Top 5 memory processes
echo "Top 5 memory-consuming processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"
