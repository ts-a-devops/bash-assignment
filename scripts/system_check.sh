#!/bin/bash

DATE=$(date +"%d-%m-%Y")

LOG_FOLDER="logs"
LOG_FILE="$LOG_FOLDER/system_report_$DATE.log"

# creates the folder if it does not exist
cd ..
mkdir -p "$LOG_FOLDER"

# disk usage
echo "Disk Usage" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# memory usage
echo "Memory Usage" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo "CPU Load" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# show warning if disk usage exceed 80%
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [[ "$USAGE" -ge 80 ]]; then
    echo "Warning: Disk usage at 80%" | tee -a "$LOG_FILE"
fi

# count total running processes
echo "Total running processes" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a  "$LOG_FILE"

# display top 5 memory-consuming processes
echo "Top 5 memory-consuming processes" | tee -a "$LOG_FILE"
ps aux --sort='-%mem' | head -n 6 | tee -a "$LOG_FILE"
