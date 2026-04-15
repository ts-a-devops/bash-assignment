#!/bin/bash

LOG_FILE="../logs/system_report_$(date +%F).log"

echo "System Report - $(date)" | tee "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if (( usage > 80 )); then
    echo "WARNING: Disk usage above 80%" | tee -a "$LOG_FILE"
fi

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "Total Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "Top 5 Memory Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
