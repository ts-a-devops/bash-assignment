#!/bin/bash

LOG_DIR="logs"
DATE=$(date +%F)
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

# ensure logs folder exists
mkdir -p "$LOG_DIR"

echo "===== SYSTEM CHECK REPORT ($DATE) =====" | tee "$LOG_FILE"

echo -e "\n--- DISK USAGE ---" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo -e "\n--- MEMORY USAGE ---" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo -e "\n--- CPU LOAD ---" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo -e "\n--- TOTAL RUNNING PROCESSES ---" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo -e "\n--- TOP 5 MEMORY-CONSUMING PROCESSES ---" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

# check disk usage and warn if above 80%
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -gt 80 ]; then
    echo -e "\nWARNING: Disk usage is above 80%!" | tee -a "$LOG_FILE"
fi

echo -e "\nReport saved to $LOG_FILE"
