#!/bin/bash
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
Date=$(date +%F)
LOG_FILE=logs/system_report_$Date.log
# Display: Disk usage (df -h), Memory usage (free -m), CPU load (uptime)
echo "===== System Report: ====="

threshold=80
Usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
echo " Disk usage " | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"
echo " Memory usage " | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"
echo " CPU load (uptime) " | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"
# Warn if disk usage exceeds 80%
if [[ $Usage -gt $threshold ]] ; then
    echo "Warning : Disk usage exceeds 80%" | tee -a "$LOG_FILE"
else
    echo "Disk usage is within limit" | tee -a "$LOG_FILE"
fi
# Count total running processes
    echo " Total running Processes " | tee -a "$LOG_FILE"
ps -e | wc -l  | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo " Top 5 memory-consuming processes "
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
