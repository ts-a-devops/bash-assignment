#!/bin/bash

mkdir -p logs
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee -a "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk warning
df -h | awk '$5+0 > 80 {print "WARNING: High disk usage on " $1}' | tee -a "$LOG_FILE"

echo "Total Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"