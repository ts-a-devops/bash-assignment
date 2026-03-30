#!/bin/bash

mkdir -p logs
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee -a $LOG_FILE
echo "------------------------" | tee -a $LOG_FILE

echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# Check disk usage warning
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if (( USAGE > 80 )); then
  echo "WARNING: Disk usage is above 80%!" | tee -a $LOG_FILE
fi

echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

echo "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

echo "Total Processes:" | tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

echo "Top 5 Memory Consuming Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE
