#!/bin/bash

# Date and log file
DATE=$(date +%Y-%m-%d)
LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" >> "$LOG_FILE"
echo "----------------------" >> "$LOG_FILE"

# Disk usage
echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check disk usage percentage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "WARNING: Disk usage above 80%" | tee -a "$LOG_FILE"
fi

# Memory usage
    echo "" | tee -a "$LOG_FILE"
      echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
    echo "" | tee -a "$LOG_FILE"
    echo "CPU Load:" | tee -a "$LOG_FILE"
    uptime | tee -a "$LOG_FILE"

# Running processes count
    echo "" | tee -a "$LOG_FILE"
    echo "Total Running Processes:" | tee -a "$LOG_FILE"
    ps -e | wc -l | tee -a "$LOG_FILE"

# Top 5 memory consuming processes
    echo "" | tee -a "$LOG_FILE"
    echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
    ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"
