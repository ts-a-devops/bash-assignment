#!/bin/bash

DATE=$(date +%F)
LOG="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee -a $LOG

echo "Disk Usage:" | tee -a $LOG
df -h | tee -a $LOG

echo "Memory Usage:" | tee -a $LOG
free -m | tee -a $LOG

echo "CPU Load:" | tee -a $LOG
uptime | tee -a $LOG

# Disk warning
df -h | awk '$5 > 80 {print "WARNING: Disk usage above 80% on " $1}' | tee -a $LOG

# Process count
echo "Total processes:" | tee -a $LOG
ps aux | wc -l | tee -a $LOG

# Top 5 memory processes
echo "Top 5 memory processes:" | tee -a $LOG
ps aux --sort=-%mem | head -6 | tee -a $LOG
