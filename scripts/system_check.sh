#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Generate timestamp for filename
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/system_report_$DATE.log"

# Header
echo "=== System check - $(date) ===" | tee "$LOG_FILE"

# Disk usage
echo -e "\n--- Disk Usage ---" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Warn if any partition exceeds 80%
echo -e "\n--- Disk Usage Warnings ---" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {gsub("%","",$5); if($5>80) print "WARNING: Partition "$6" is "$5"% full"}' | tee -a "$LOG_FILE"

# Memory usage
echo -e "\n--- Memory Usage ---" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo -e "\n--- CPU Load ---" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total running processes
echo -e "\n--- Total Running Processes ---" | tee -a "$LOG_FILE"
ps -e --no-headers | wc -l | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo -e "\n--- Top 5 Memory-Consuming Processes ---" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\nReport saved to $LOG_FILE"
