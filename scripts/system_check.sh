#!/bin/bash
# system_check.sh - Check disk, memory, CPU, processes

DATE=$(date +%F)
LOGFILE="logs/system_report_$DATE.log"

mkdir -p logs

echo "System Check Report - $DATE" > $LOGFILE

# Disk usage
echo "Disk Usage:" >> $LOGFILE
df -h >> $LOGFILE
echo "" >> $LOGFILE

# Memory usage
echo "Memory Usage:" >> $LOGFILE
free -m >> $LOGFILE
echo "" >> $LOGFILE

# CPU load
echo "CPU Load:" >> $LOGFILE
uptime >> $LOGFILE
echo "" >> $LOGFILE

# Warn if disk >80%
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%" >> $LOGFILE
fi

# Total running processes
echo "Total Running Processes:" >> $LOGFILE
ps aux | wc -l >> $LOGFILE
echo "" >> $LOGFILE

# Top 5 memory-consuming processes
echo "Top 5 Memory-Consuming Processes:" >> $LOGFILE
ps aux --sort=-%mem | head -n 6 >> $LOGFILE

echo "System check completed. Log saved to $LOGFILE"
