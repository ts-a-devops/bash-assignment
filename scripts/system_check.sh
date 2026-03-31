#!/bin/bash

DATE=$(date +"%Y")
LOG_FILE="../logs/system_report_$DATE.log"

echo "===== SYSTEM REPORT =====" | tee -a "$LOG_FILE"

echo "---------- Disk Usage ----------" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "---------- Memory Usage ----------" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "---------- CPU Load ----------" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk warning
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if (( USAGE > 80 )); then
  echo "WARNING: Disk usage is above 80%" | tee -a "$LOG_FILE"
  fi

 # Process count
  echo "----- Total running processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

 # Top 5 memory-consuming processes
  echo "---------- Top 5 memory-consuming processes ----------" | tee -a "$LOG_FILE"
  ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
