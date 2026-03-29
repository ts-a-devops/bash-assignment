#!/bin/bash
set -euo pipefail

DATE=$(date +%F_%H-%M-%S)
LOGFILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee "$LOGFILE"
echo "-----------------------------------" | tee -a "$LOGFILE"

echo -e "\nDisk Usage:" | tee -a "$LOGFILE"
df -h | tee -a "$LOGFILE"

DISK_USE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if (( DISK_USE > 80 )); then
    echo "WARNING: Disk usage above 80%" | tee -a "$LOGFILE"
fi

echo -e "\nMemory Usage:" | tee -a "$LOGFILE"
free -m | tee -a "$LOGFILE"

echo -e "\nCPU Load:" | tee -a "$LOGFILE"
uptime | tee -a "$LOGFILE"

echo -e "\nTotal Running Processes:" | tee -a "$LOGFILE"
ps aux | wc -l | tee -a "$LOGFILE"

echo -e "\nTop 5 Memory Consuming Processes:" | tee -a "$LOGFILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOGFILE"