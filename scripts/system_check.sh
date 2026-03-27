#!/bin/bash

set -euo pipefail

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

echo "===== TODAY'S SYSTEM REPORT IS READY =====" | tee "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"


 usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

 if (( usage > 80 )); then
     echo "WARNING: Disk usage above 80%!" | tee -a "$LOG_FILE"
     fi


     echo "Total running processes:" | tee -a "$LOG_FILE"
     ps aux | wc -l | tee -a "$LOG_FILE"

     echo "Top 5 memory-consuming processes:" | tee -a "$LOG_FILE"
     ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
