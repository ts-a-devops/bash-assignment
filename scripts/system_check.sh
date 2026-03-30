#!/bin/bash

LOG_FILE="logs/system_report_$(date +%Y%m%d).log"

echo "System Report - $(date)" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

df -h | awk 'NR>1 { if ($5+0 > 80) print "WARNING: High disk usage on " $6 }' | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
vm_stat | tee -a "$LOG_FILE"   

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

echo "Total Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo "Top 5 Memory-Consuming Processes:" | tee -a "$LOG_FILE"
ps aux | sort -nrk 4 | head -n 6 | tee -a "$LOG_FILE"
