#!/bin/bash

# System Check Script
# Displays system information including disk usage, memory, CPU load
# Warns if disk usage exceeds 80%
# Logs to logs/system_report_<date>.log

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

# Get current date for log filename
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="logs/system_report_${DATE}.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Initialize log
log_message "========== System Check Report =========="

# Display Disk Usage
log_message ""
log_message "--- Disk Usage ---"
df -h | tee -a "$LOG_FILE"

# Check if disk usage exceeds 80%
log_message ""
log_message "--- Disk Usage Warning Check ---"
df -h | awk 'NR>1 {gsub(/%/,"",$5); if ($5+0 > 80) print "WARNING: " $6 " is " $5 "% full"}' | tee -a "$LOG_FILE"

# Display Memory Usage
log_message ""
log_message "--- Memory Usage ---"
free -m | tee -a "$LOG_FILE"

# Display CPU Load
log_message ""
log_message "--- CPU Load (Uptime) ---"
uptime | tee -a "$LOG_FILE"

# Count total running processes
log_message ""
log_message "--- Total Running Processes ---"
TOTAL_PROCESSES=$(ps aux | wc -l)
log_message "Total processes: $((TOTAL_PROCESSES - 1))"

# Display top 5 memory-consuming processes
log_message ""
log_message "--- Top 5 Memory-Consuming Processes ---"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

log_message ""
log_message "========== End of System Check Report =========="
log_message "Report saved to: $LOG_FILE"