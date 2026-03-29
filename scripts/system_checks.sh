#!/bin/bash

mkdir -p logs

DATE=$(date +%F)

LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee "$LOG_FILE"


echo "Disk Usage:" | tee -a "$LOG_FILE"

df -h | tee -a "$LOG_FILE"


echo "Disk Warnings:" | tee -a "$LOG_FILE"

df -h | awk 'NR>1 {gsub("%","",$5); if($5 > 80) print "WARNING: High disk usage on " $6}' | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"

free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"

uptime | tee -a "$LOG_FILE"

echo "Total Running Processes:" | tee -a "$LOG_FILE"

ps -e --no-headers | wc -l | tee -a "$LOG_FILE"

echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"

ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
