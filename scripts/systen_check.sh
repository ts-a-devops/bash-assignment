#!/bin/bash

DATE=$(date =%Y-%m-%d)
LOG_FILE="../logs/system_report_$DATE.log"

echo "--- SYATEM CHECK REPORT: $DATE ---" | tee -a "$LOG_FILE"

#check disk usage
echo -e "\n[DISK USAGE]" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

#check cpu load
echo -e "\n[CPU LOAD]" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

#check memory usage
echo -e "\n[MEMORY USAGE]" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

#Count total running processes
echo -e "\n[PROCESS COUNT]" | tee -a "$LOG_FILE"
echo "Total running processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

#top 5 memory-consuming processes
echo -e "\n[TOP 5 MEMORY PROCESSES]" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

#Warn if disk usage exceeds 80%
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')

if [ "$USAGE" -gt 80 ]; then
    echo -e "\n⚠️WARNING: Disk usage is critically high: $USAGE%" | tee -a "$LOG_FILE"
else
    echo -e "\n Disk usage is healthy: $USAGE%" | tee -a "$LOG_FILE"
fi

echo -e "\nReport saved to $LOG_FILE"
