#!/bin/bash

# Create logs directory
mkdir -p logs

# Get current date
DATE=$(date +"%Y-%m-%d")

LOG_FILE="logs/system_report_$DATE.log"

# Start report
echo "SYSTEM REPORT - $(date)" | tee "$LOG_FILE"
echo "---------------------------------" | tee -a $LOG_FILE

# Disk usage
echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE

# Warn if disk usage exceeds 80%
echo "Disk Warnings:" | tee -a $LOG_FILE

df -h | awk 'NR>1 {print $5,$1}' | while read usage disk
do
    usage_num=$(echo $usage | sed 's/%//')

    if [[ "$usage_num" =~ ^[0-9]+$ ]] && [ "$usage_num" -gt 80 ]
    then
        echo "WARNING: $disk usage is above 80% ($usage)" | tee -a $LOG_FILE
    fi

done

echo "" | tee -a $LOG_FILE

# Memory usage
echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE

# CPU load
echo "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE

# Count running processes
echo "Total Running Processes:" | tee -a $LOG_FILE
ps -e | wc -l | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE

# Top 5 memory consuming processes
echo "Top 5 Memory Consuming Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo "Report saved to $LOG_FILE"
