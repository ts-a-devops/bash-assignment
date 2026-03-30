#!/bin/bash

# Create logs folder if not exists
mkdir -p logs

# Get current date
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" > $LOG_FILE
echo "-----------------------------" >> $LOG_FILE

# Disk usage
echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# Memory usage
echo "" | tee -a $LOG_FILE
echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

# CPU load
echo "" | tee -a $LOG_FILE
echo "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# Process count
echo "" | tee -a $LOG_FILE
echo "Total Running Processes:" | tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

# Top 5 memory consuming processes
echo "" | tee -a $LOG_FILE
echo "Top 5 Memory Consuming Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

# Disk warning
echo "" | tee -a $LOG_FILE
echo "Disk Usage Warning (>80%):" | tee -a $LOG_FILE
df -h | awk '$5+0 > 80 {print}' | tee -a $LOG_FILE

