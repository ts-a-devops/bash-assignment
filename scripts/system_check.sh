#!/bin/bash

mkdir -p logs

DATE=$(date +"%Y-%m-%d")
LOGFILE="logs/system_report_$DATE.log"

echo "SYSTEM REPORT - $DATE" | tee -a $LOGFILE
echo "------------------------" | tee -a $LOGFILE

# Disk usage
echo "Disk Usage:" | tee -a $LOGFILE
df -h | tee -a $LOGFILE

# Warning if disk > 80%
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!" | tee -a $LOGFILE
fi

# Memory usage
echo -e "\nMemory Usage:" | tee -a $LOGFILE
free -m | tee -a $LOGFILE

# CPU load
echo -e "\nCPU Load:" | tee -a $LOGFILE
uptime | tee -a $LOGFILE

# Process count
echo -e "\nTotal Running Processes:" | tee -a $LOGFILE
ps aux | wc -l | tee -a $LOGFILE

# Top 5 memory-consuming processes
echo -e "\nTop 5 Memory Consuming Processes:" | tee -a $LOGFILE
ps aux --sort=-%mem | head -6 | tee -a $LOGFILE
