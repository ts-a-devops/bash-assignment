#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/system_report_$(date +%F).log"

echo "System Report - $(date)" | tee -a "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

#Disk warning
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if (( usage > 80 )); then
	echo "WARNING: Disk usage above 80%" | tee -a "$LOG_FILE"
fi

#Running processes
echo "Total Processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

#Top 5 memory-consuming processes
echo "Top 5 Memory Processes:" | tee -a "$LOG_FILE"

ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"
