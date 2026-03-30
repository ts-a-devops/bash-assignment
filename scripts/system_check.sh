#!/bin/bash

# Create logs directory if it doesn't exist
LOG_DIR="../logs"
mkdir -p "$LOG_DIR"

# Create log file with current date
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

echo "===== SYSTEM HEALTH REPORT =====" | tee -a "$LOG_FILE"
echo "Generated on: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Disk Usage
echo "---- Disk Usage ----" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Warn if disk usage exceeds 80%
echo "---- Disk Usage Warnings ----" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "WARNING: " $6 " is at " $5 "% usage"}' | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Memory Usage
echo "---- Memory Usage (MB) ----" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# CPU Load
echo "---- CPU Load ----" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Total Running Processes
echo "---- Total Running Processes ----" | tee -a "$LOG_FILE"
ps -e --no-headers | wc -l | awk '{print "Total Processes: " $1}' | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Top 5 Memory-Consuming Processes
echo "---- Top 5 Memory-Consuming Processes ----" | tee -a "$LOG_FILE"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "===== END OF REPORT =====" | tee -a "$LOG_FILE"
