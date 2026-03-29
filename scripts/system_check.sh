#!/bin/bash

# A script to display system information and log it.
# Logs to logs/system_report_<date>.log

mkdir -p logs
REPORT_DATE=$(date '+%Y-%m-%d')
LOG_FILE="logs/system_report_$REPORT_DATE.log"

echo "--- System Check Report ---" | tee -a "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"

# Disk usage
echo -e "\nDisk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Warn if disk usage exceeds 80%
# Check the "/" partition as a general indicator
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo -e "\nWARNING: Disk usage at $DISK_USAGE% exceeds 80% threshold!" | tee -a "$LOG_FILE"
fi

# Memory usage
echo -e "\nMemory Usage:" | tee -a "$LOG_FILE"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS memory info
    vm_stat | tee -a "$LOG_FILE"
else
    # Linux memory info
    free -m | tee -a "$LOG_FILE"
fi

# CPU load
echo -e "\nCPU Load (Uptime):" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Process count
PROCESS_COUNT=$(ps -e | wc -l | tr -d ' ')
echo -e "\nTotal running processes: $PROCESS_COUNT" | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo -e "\nTop 5 Memory-Consuming Processes:" | tee -a "$LOG_FILE"
if [[ "$OSTYPE" == "darwin"* ]]; then
    ps -Ao %mem,rss,pid,comm | sort -nr | head -n 5 | tee -a "$LOG_FILE"
else
    ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
fi

