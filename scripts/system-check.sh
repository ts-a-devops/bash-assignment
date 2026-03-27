#!/bin/bash

LOG_DIR="logs"
DATE=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

# Ensure logs directory exists
mkdir -p "$LOG_DIR"

echo "===== SYSTEM REPORT ($DATE) =====" | tee "$LOG_FILE"

# Disk Usage
echo -e "\n--- Disk Usage ---" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check disk usage warning (>80%)
echo -e "\n--- Disk Warnings (>80%) ---" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {gsub("%","",$5); if ($5 > 80) print "WARNING: " $0}' | tee -a "$LOG_FILE"

# Memory Usage
echo -e "\n--- Memory Usage (MB) ---" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU Load
echo -e "\n--- CPU Load ---" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total Running Processes
echo -e "\n--- Total Running Processes ---" | tee -a "$LOG_FILE"
PROCESS_COUNT=$(ps -e --no-headers | wc -l)
echo "Total processes: $PROCESS_COUNT" | tee -a "$LOG_FILE"

# Top 5 Memory-Consuming Processes
echo -e "\n--- Top 5 Memory-Consuming Processes ---" | tee -a "$LOG_FILE"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\nReport saved to $LOG_FILE"
