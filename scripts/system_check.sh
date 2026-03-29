#!/bin/bash

mkdir -p logs

DATE=$(date +%F)
LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee -a $LOG_FILE

echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

echo "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# Check disk usage (root partition)
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if (( USAGE > 80 )); then
    echo "WARNING: Disk usage above 80%" | tee -a $LOG_FILE
fi

echo "Total running processes:" | tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

echo "Top 5 memory-consuming processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -6 | tee -a $LOG_FILE
