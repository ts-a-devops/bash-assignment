#!/bin/bash

mkdir -p logs
LOG_FILE="logs/system_report_$(date +%Y%m%d).log"

echo "===== SYSTEM REPORT =====" | tee "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk warning
df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
  usage=$(echo $output | awk '{print $1}' | sed 's/%//')
  partition=$(echo $output | awk '{print $2}')

  if [ $usage -gt 80 ]; then
    echo "WARNING: $partition usage is above 80%" | tee -a "$LOG_FILE"
  fi
done

# Process count
echo "Total Running Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

# Top 5 memory processes
echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
