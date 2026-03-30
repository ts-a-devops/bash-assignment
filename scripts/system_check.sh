#!/bin/bash

# Create logs directory if not exists
LOG_DIR="logs"
mkdir -p $LOG_DIR

# Date format
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

echo "SYSTEM REPORT ($DATE) " | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

echo " Disk Usage (df -h)" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

echo " Memory Usage (free -m)" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

echo " CPU Load (uptime)" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

echo " Disk Usage Warning (Threshold: 80%)" | tee -a $LOG_FILE
df -h | awk 'NR>1 {gsub("%",""); if ($5+0 > 80) print "WARNING: " $1 " is at " $5 "%"}' | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

echo " Total Running Processes" | tee -a $LOG_FILE
ps -e --no-headers | wc -l | tee -a $LOG_FILE

echo "Top 5 Memory-Consuming Processes" | tee -a $LOG_FILE
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE