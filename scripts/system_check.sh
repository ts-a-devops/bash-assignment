#!/bin/bash

# Setup the Log File with today's date
DATE=$(date +%Y-%m-%d)
LOG_FILE="../logs/system_report_$DATE.log"

echo "--- SYSTEM CHECK REPORT: $DATE ---" | tee -a "$LOG_FILE"

# Check Disk Usage
echo -e "\n[DISK USAGE]" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check Memory Usage
echo -e "\n[MEMORY USAGE]" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# Check CPU Load
echo -e "\n[CPU LOAD]" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Count Total Running Processes
echo -e "\n[PROCESS COUNT]" | tee -a "$LOG_FILE"
echo "Total running processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

# Top 5 Memory-Consuming Processes
echo -e "\n[TOP 5 MEMORY PROCESSES]" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

# Alert if Disk Usage is over 80%
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')

if [ "$USAGE" -gt 80 ]; then
    echo -e "\n WARNING: Disk usage is critically high: $USAGE%" | tee -a "$LOG_FILE"
else
    echo -e "\n Disk usage is healthy: $USAGE%" | tee -a "$LOG_FILE"
fi

echo -e "\nReport saved to $LOG_FILE"


