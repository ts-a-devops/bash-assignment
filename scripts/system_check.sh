#!/bin/bash

# system_check.sh - Displays system information and generates a report

# Create logs directory if it doesn't exist
mkdir -p logs

DATE=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="logs/system_report_${DATE}.log"

# Function to log messages
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

log_message "=== System Check Report ==="
log_message "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
log_message ""

# Disk usage
log_message "--- DISK USAGE ---"
df -h | tee -a "$LOG_FILE"
log_message ""

# Check if disk usage exceeds 80%
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if (( DISK_USAGE > 80 )); then
    log_message "⚠️  WARNING: Disk usage is at ${DISK_USAGE}% (exceeds 80% threshold)"
else
    log_message "✓ Disk usage is at ${DISK_USAGE}% (within acceptable range)"
fi
log_message ""

# Memory usage
log_message "--- MEMORY USAGE ---"
free -m | tee -a "$LOG_FILE"
log_message ""

# CPU load
log_message "--- CPU LOAD ---"
uptime | tee -a "$LOG_FILE"
log_message ""

# Total running processes
PROCESS_COUNT=$(ps aux | wc -l)
log_message "Total Running Processes: $((PROCESS_COUNT - 1))"
log_message ""

# Top 5 memory-consuming processes
log_message "--- TOP 5 MEMORY-CONSUMING PROCESSES ---"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"
log_message ""

log_message "=== End of Report ==="
echo ""
echo "✓ System report saved to $LOG_FILE"
