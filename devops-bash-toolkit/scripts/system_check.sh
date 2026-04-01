#!/bin/bash

LOG_DIR="../logs"
mkdir -p "$LOG_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

echo "===== SYSTEM REPORT =====" | tee "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check disk usage > 80%
df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
    usage=$(echo $output | awk '{print $1}' | sed 's/%//g')
    partition=$(echo $output | awk '{print $2}')
    
    if [ "$usage" -gt 80 ]; then
        echo "WARNING: $partition is above 80% usage!" | tee -a "$LOG_FILE"
    fi
done

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "Total Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo "Report saved to $LOG_FILE"
