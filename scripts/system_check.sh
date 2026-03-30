#!/bin/bash

# ==========================================
# Script: system_check.sh
# Description: Generates system health report
# Author: David Igbo
# ==========================================

mkdir -p ../logs

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="../logs/system_report_$DATE.log"

echo "========================================" | tee "$LOG_FILE"
echo "System Report - $DATE" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

echo -e "\nDisk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo -e "\nMemory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo -e "\nCPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk warning (root partition only)
USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if (( USAGE > 80 )); then
  echo "WARNING: Disk usage above 80%!" | tee -a "$LOG_FILE"
fi

echo -e "\nTotal Processes:" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

echo -e "\nTop 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo "========================================" | tee -a "$LOG_FILE"

exit 0
