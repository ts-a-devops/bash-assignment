#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="logs/system_report_$DATE.log"

echo "=== System Check Report ===" | tee -a "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Disk Usage
echo "=== Disk Usage ===" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Warn if disk usage exceeds 80%
echo "=== Disk Usage Warnings (>80%) ===" | tee -a "$LOG_FILE"

df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
    usage=$(echo $output | awk '{print $1}' | sed 's/%//g')
    partition=$(echo $output | awk '{print $2}')

    if [ "$usage" -gt 80 ]; then
        warning="WARNING: $partition is at ${usage}% usage!"
        echo "$warning" | tee -a "$LOG_FILE"
    fi
done

echo "" | tee -a "$LOG_FILE"

# Memory Usage
echo "=== Memory Usage (MB) ===" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# CPU Load
echo "=== CPU Load ===" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Total running processes
echo "=== Total Running Processes ===" | tee -a "$LOG_FILE"
process_count=$(ps -e --no-headers | wc -l)
echo "Total processes: $process_count" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo "=== Top 5 Memory-Consuming Processes ===" | tee -a "$LOG_FILE"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"

echo "Report saved to $LOG_FILE"
