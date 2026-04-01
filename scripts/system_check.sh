#!/bin/bash

mkdir -p logs
LOG_FILE="logs/system_report_$(date +%F).log"

echo "===== SYSTEM REPORT =====" | tee -a $LOG_FILE

# Disk usage
echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# Check disk warning
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%" | tee -a $LOG_FILE
fi

# Memory usage
echo "Memory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

# CPU load
echo "CPU Load:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# Total processes
echo "Total Processes: $(ps aux | wc -l)" | tee -a $LOG_FILE

# Top 5 memory processes
echo "Top 5 Memory Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE
