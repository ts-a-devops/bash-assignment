#!/bin/bash

# Create logs folder if it doesn't exist
mkdir logs 2>/dev/null

# Create filename with date
DATE=$(date +"%Y-%m-%d")
LOG_FILE="logs/system_report_$DATE.log"

echo "===== SYSTEM REPORT ($DATE) =====" > "$LOG_FILE"

# Disk usage
echo "---- Disk Usage ----" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Warn if disk usage exceeds 80%
echo "---- Disk Warning Check ----" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5 " " $1}' | while read usage partition
do
    percent=$(echo $usage | sed 's/%//')

    if [ "$percent" -gt 80 ]; then
        echo "WARNING: $partition is at ${percent}% usage!" | tee -a "$LOG_FILE"
    fi
done

# Memory usage
echo "---- Memory Usage ----" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo "---- CPU Load ----" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total running processes
echo "---- Process Count ----" | tee -a "$LOG_FILE"
ps -e | wc -l | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo "---- Top 5 Memory Consuming Processes ----" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo "===== END OF REPORT =====" | tee -a "$LOG_FILE"

echo "Report saved to $LOG_FILE"