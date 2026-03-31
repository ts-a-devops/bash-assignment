#!/bin/bash

LOG_FILE="../logs/system_report_$(date +%Y%m%d).log"
mkdir -p ../logs

echo "System Report - $(date)" | tee $LOG_FILE

echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# Warn if disk > 80%
df -h | awk 'NR>1 {print $5}' | sed 's/%//' | while read usage
do
    if [ "$usage" -gt 80 ]; then
        echo "WARNING: Disk usage above 80%" | tee -a $LOG_FILE
    fi
done

echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

echo "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

echo "Total Processes:" | tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

echo "Top 5 Memory Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -5 | tee -a $LOG_FILE
