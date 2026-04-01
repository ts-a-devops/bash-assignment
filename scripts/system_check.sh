#!/bin/bash

mkdir -p logs
DATE=$(date +"%Y%m%d")
LOGFILE="logs/system_report_$DATE.log"

echo "===== System Check =====" | tee $LOGFILE
echo "Hostname: $(hostname)" | tee -a $LOGFILE
echo "Kernel: $(uname -r)" | tee -a $LOGFILE
echo "" | tee -a $LOGFILE

echo "--- Disk Usage ---" | tee -a $LOGFILE
df -h / | tee -a $LOGFILE

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 80 ]; then
  echo "WARNING: Disk usage is above 80%!" | tee -a $LOGFILE
fi

echo "" | tee -a $LOGFILE
echo "--- Memory Usage ---" | tee -a $LOGFILE
free -m | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "--- CPU Load ---" | tee -a $LOGFILE
uptime | tee -a $LOGFILE

echo "" | tee -a $LOGFILE
echo "--- Top 5 Memory Processes ---" | tee -a $LOGFILE
ps aux --sort=-%mem | head -6 | tee -a $LOGFILE

echo "Total processes: $(ps aux | wc -l)" | tee -a $LOGFILE
echo "Report saved to $LOGFILE"
