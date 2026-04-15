#!/bin/bash

# Define the log file with a time stamp
LOG_FILE="system_report_$(date +%Y%m%d_%H%M).log"
echo "--- Generating system report---" | tee -a $LOG_FILE

# 1: Disk usauge (df -h)
echo -e "\nDisk Space Usage:" >> "$LOG_FILE"
df -h | grep '^/dev/'  >> "$LOG_FILE"

# 2: Memory usage (free -m)
echo -e "\nMMemory Usage:" >> "$LOG_FILE"
free -h >> "$LOG_FILE"

# 3: CPU load (uptime)
echo "CPU Uptime:" >> "$LOG_FILE"
uptime >> "$LOG_FILE"

echo " Report saved to $LOG_FILE"

