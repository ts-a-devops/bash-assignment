#!/bin/bash
# =============================================
# system_check.sh - System health check and reporting
# =============================================

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

LOGFILE="logs/system_report_$(date '+%Y-%m-%d').log"

echo "=== System Check Report - $(date '+%Y-%m-%d %H:%M:%S') ===" | tee -a "$LOGFILE"
echo "==================================================" | tee -a "$LOGFILE"

# 1. Disk Usage
echo "Disk Usage:" | tee -a "$LOGFILE"
df -h | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# Check if any disk is over 80% usage and show warning
echo "Disk Usage Warnings:" | tee -a "$LOGFILE"
df -h --output=source,pcent,target | tail -n +2 | while read -r source percent target; do
    usage=${percent%\%}
    if (( usage > 80 )); then
        echo "WARNING: $target is at ${usage}% usage!" | tee -a "$LOGFILE"
    fi
done
echo "" | tee -a "$LOGFILE"

# 2. Memory Usage
echo "Memory Usage:" | tee -a "$LOGFILE"
free -m | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# 3. CPU Load
echo "CPU Load (uptime):" | tee -a "$LOGFILE"
uptime | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# 4. Total Running Processes
total_processes=$(ps -e | wc -l)
echo "Total Running Processes: $total_processes" | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# 5. Top 5 Memory Consuming Processes
echo "Top 5 Memory Consuming Processes:" | tee -a "$LOGFILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

echo "==================================================" | tee -a "$LOGFILE"
echo "System check completed. Report saved to: $LOGFILE"

echo ""
echo " System check completed successfully."
