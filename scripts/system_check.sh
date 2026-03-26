#!/bin/bash

# Create logs folder
mkdir -p logs

# Create log file with date
DATE=$(date +%Y-%m-%d)
LOG_FILE="logs/system_report_$DATE.log"

echo "=== SYSTEM REPORT ($DATE) ===" | tee "$LOG_FILE"

# Disk usage
echo -e "\nDisk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Warning for disk > 80%
echo -e "\nDisk Warnings (>80%):" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5, $6}' | while read usage mount
do
  use=${usage%\%}
  if [ "$use" -gt 80 ]; then
    echo "WARNING: $mount is at $usage" | tee -a "$LOG_FILE"
  fi
done

# Memory usage
echo -e "\nMemory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo -e "\nCPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total processes
echo -e "\nTotal Processes:" | tee -a "$LOG_FILE"
ps -e | wc -l | tee -a "$LOG_FILE"

# Top 5 memory processes
echo -e "\nTop 5 Memory Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

echo -e "\n=== END ===" | tee -a "$LOG_FILE"
