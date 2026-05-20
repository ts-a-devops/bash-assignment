#!/bin/bash

mkdir -p logs
DATE=$(date +%Y-%m-%d)
LOGFILE="logs/system_report_$DATE.log"

echo "=== SYSTEM CHECK ===" | tee $LOGFILE
echo "Disk Usage:" | tee -a $LOGFILE
df -h | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "Memory Usage:" | tee -a $LOGFILE
free -m | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "CPU Load:" | tee -a $LOGFILE
uptime | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "Total Processes: $(ps aux | wc -l)" | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "Top 5 Memory-Consuming Processes:" | tee -a $LOGFILE
ps aux --sort=-%mem | head -6 | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "Report saved to $LOGFILE"
