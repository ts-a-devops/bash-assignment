#!/bin/bash
# system_check.sh - System health check and reporting
# Written by Dave Woks

set -uo pipefail

mkdir -p ~/bash-assignment/logs
LOGFILE=~/bash-assignment/logs/system_report_$(date +%F).log

echo "--- System Report: $(date) ---" | tee "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# --- Disk usage ---
echo "DISK USAGE:" | tee -a "$LOGFILE"
df -h | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# --- Warn if disk usage exceeds 80% ---
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [[ $DISK_USAGE -gt 80 ]]; then
    echo "WARNING: Disk usage is at ${DISK_USAGE}%. Consider cleaning up." | tee -a "$LOGFILE"
fi

# --- Memory usage ---
echo "MEMORY USAGE:" | tee -a "$LOGFILE"
free -m | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# --- CPU load ---
echo "CPU LOAD:" | tee -a "$LOGFILE"
uptime | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# --- Running processes ---
PROCESS_COUNT=$(ps aux | wc -l)
echo "Total running processes: $PROCESS_COUNT" | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# --- Top 5 memory consuming processes ---
echo "TOP 5 MEMORY-CONSUMING PROCESSES:" | tee -a "$LOGFILE"
ps aux --sort=-%mem | head -6 | tee -a "$LOGFILE"

echo "" | tee -a "$LOGFILE"
echo "Report saved to: $LOGFILE"
