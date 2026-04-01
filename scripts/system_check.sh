#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$PROJECT_ROOT/logs/system_report_$DATE.log"

echo "System Report - $DATE" | tee "$LOG_FILE"

echo "Disk Usage:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

echo "Memory Usage:" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

echo "CPU Load:" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Disk warning
df -h | awk '$5 > 80 {print "Warning: Disk usage above 80% on " $6}' | tee -a "$LOG_FILE"

# Process count
echo "Total Processes: $(ps aux | wc -l)" | tee -a "$LOG_FILE"

# Top 5 memory processes
echo "Top 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
