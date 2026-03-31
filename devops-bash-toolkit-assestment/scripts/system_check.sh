#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/.."
LOG_DIR="$BASE_DIR/logs/system_report.log"

mkdir -p "$LOG_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Accept a log file path from run_all.sh, or build one from LOG_DIR
if [[ -n "$1" ]]; then
    LOG_FILE="$1"
    mkdir -p "$(dirname "$LOG_FILE")"
else
    LOG_FILE="$LOG_DIR/system_report_$DATE.log"
fi

echo "===== SYSTEM REPORT =====" | tee "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Disk usage
echo "---- Disk Usage ----" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Disk warning
echo "" | tee -a "$LOG_FILE"
echo "---- Disk Warning ----" | tee -a "$LOG_FILE"

df -h | awk 'NR>1 {print $5 " " $1}' | while read usage partition; do
    percent=$(echo "$usage" | tr -d '%')
    if [[ "$percent" =~ ^[0-9]+$ ]] && [ "$percent" -gt 80 ]; then
        echo "WARNING: $partition is above 80% usage ($usage)" | tee -a "$LOG_FILE"
    fi
done

# Memory usage
echo "" | tee -a "$LOG_FILE"
echo "---- Memory Usage ----" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo "" | tee -a "$LOG_FILE"
echo "---- CPU Load ----" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Process count
echo "" | tee -a "$LOG_FILE"
echo "---- Running Processes ----" | tee -a "$LOG_FILE"
ps aux | wc -l | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo "" | tee -a "$LOG_FILE"
echo "---- Top 5 Memory Consuming Processes ----" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "Report saved to $LOG_FILE"
