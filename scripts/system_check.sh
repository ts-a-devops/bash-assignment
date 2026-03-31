#!/bin/bash

mkdir -p logs
LOG_FILE="logs/system_report_$(date +%Y-%m-%d_%H-%M-%S).log"

echo "System Check Report - $(date)" | tee "$LOG_FILE"
echo "------------------------------" | tee -a "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Memory Usage:" | tee -a "$LOG_FILE"
if command -v free >/dev/null 2>&1; then
    free -m | tee -a "$LOG_FILE"
else
    vm_stat | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"
echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Disk Warning (above 80%):" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {gsub("%","",$5); if ($5 > 80) print "Warning: " $9 " is at " $5 "%"}' | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Total Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Top 5 Memory-Consuming Processes:" | tee -a "$LOG_FILE"
ps aux | sort -nrk 4 | head -6 | tee -a "$LOG_FILE"
