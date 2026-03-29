#!/bin/bash

LOG_DIR="logs"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

mkdir -p "$LOG_DIR"

echo "System Report - $(date)" | tee "$LOG_FILE"

echo -e "\nDisk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check disk usage warning
USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
if (( USAGE > 80 )); then
    echo "WARNING: Disk usage above 80%" | tee -a "$LOG_FILE"
fi

echo -e "\nMemory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo -e "\nCPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo -e "\nTotal Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo -e "\nTop 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
