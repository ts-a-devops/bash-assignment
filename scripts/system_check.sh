#!/bin/bash

#save output to: logs/system_check_${DATE}.log
LOG_DIR="../logs"
mkdir -p "$LOG_DIR"
DATE=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="$LOG_DIR/system_check_${DATE}.log"

echo "SYSTEM CHECK" | tee -a "$LOG_FILE"

# Disk Usage
echo -e "\n Disk Usage " | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Memory Usage
echo -e "\n Memory Usage " | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU Load
echo -e "\n CPU Load " | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Warning
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [[ "$DISK_USAGE" -gt 80 ]]; then
    echo -e "\n Warning: Disk usage is above 80% " | tee -a "$LOG_FILE"
fi

echo -e "\n Total Running Processes " | tee -a "$LOG_FILE"
ps -e | wc -l | tee -a "$LOG_FILE"

echo -e "\n Top 5 Memory Consuming Processes " | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\n Report saved in $LOG_FILE"