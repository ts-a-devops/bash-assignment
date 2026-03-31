#!/bin/bash
set -euo pipefail

DATE=$(date +%F_%H-%M-%S)
LOG_FILE="logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee -a "$LOG_FILE"

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

  if [ "$usage" -gt 80 ]; then
    echo "WARNING: Disk usage on $partition is above 80%" | tee -a "$LOG_FILE"
  fi
done

# Process count
echo "Total Processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

# Top 5 memory processes
echo "Top 5 Memory Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
