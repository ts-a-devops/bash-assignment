#!/bin/bash

LOG_FILE="../logs/system_report_$(date +%F).log"

echo "System Report - $(date)" | tee "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check disk warning
df -h | awk '$5 > 80 {print "WARNING: High disk usage on " $1}' | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "Total Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "Top 5 Memory Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
