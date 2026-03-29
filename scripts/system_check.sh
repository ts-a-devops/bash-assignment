#!/bin/bash
# Author: Ugoeze Johnny-Obijuru
# Task: DevOps Bash Toolkit Assessment - system_check.sh

# Ensure logs directory exists
mkdir -p logs

# Define log file with current date
LOG_FILE="logs/system_report_$(date +%Y-%m-%d).log"

echo "------------------------------------------"
echo "SYSTEM HEALTH CHECK"
echo "------------------------------------------"

# 1. Disk Usage Check
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo "Disk Usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
else
    echo "Disk space is within safe limits."
fi

# 2. Memory Usage
echo "Memory Usage (MB):"
free -m | grep Mem | awk '{print "Used: "$3"MB / Free: "$4"MB"}'

# 3. CPU Load
echo "CPU Load (Uptime):"
uptime | awk -F'load average:' '{ print $2 }'

# 4. Process Count
PROCESS_COUNT=$(ps aux | wc -l)
echo "Total Running Processes: $PROCESS_COUNT"

# 5. Top 5 Memory Consuming Processes
echo "Top 5 Memory-Consuming Processes:"
ps aux --sort=-%mem | awk 'NR<=6 {print $1, $2, $4, $11}'

# Save output to Log
{
    echo "--- Report Generated: $(date) ---"
    echo "Disk Usage: ${DISK_USAGE}%"
    echo "Processes: $PROCESS_COUNT"
    uptime
    free -m
} >> "$LOG_FILE"

echo "------------------------------------------"
echo "Report saved to $LOG_FILE"
