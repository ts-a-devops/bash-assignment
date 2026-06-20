#!/bin/bash

LOG_FILE="logs/system_report_$(date +%F).log"

echo "===== SYSTEM REPORT =====" | tee "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Disk usage
echo "DISK USAGE:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Check disk warning (>80%)
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80% ($USAGE%)" | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"

# Memory usage
echo "MEMORY USAGE:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# CPU load
echo "CPU LOAD:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Process count
echo "TOTAL RUNNING PROCESSES:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Top 5 memory processes
echo "TOP 5 MEMORY CONSUMING PROCESSES:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

echo "Report saved to $LOG_FILE"
