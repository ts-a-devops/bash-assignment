#!/bin/bash

# Displays system data
# Shows disk usage, memory usage, CPU load, running processes

set -euo pipefail

LOG_FILE="logs/system_report_$(date '+%Y-%m-%d_%H-%M-%S').log"


mkdir -p "$(dirname "$LOG_FILE")"


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

# Disk usage exceeding 805
log_message "--- DISK USAGE ALERTS ---"
df -h | awk 'NR>1 {gsub(/%/,"",$5); if ($5 > 80) print " WARNING: " $6 " is " $5 "% full"}' | tee -a "$LOG_FILE"
log_message ""

#memory usage
log_message "--- MEMORY USAGE ---"
if command -v free &> /dev/null; then
    free -m | tee -a "$LOG_FILE"
else
    MEM_INFO=$(wmic OS get TotalVisibleMemorySize,FreePhysicalMemory)
    TOTAL_KB=$(echo "$MEM_INFO" | awk 'NR==2 {print $2}')
    FREE_KB=$(echo "$MEM_INFO" | awk 'NR==2 {print $1}')
    TOTAL_MB=$((TOTAL_KB / 1024))
    FREE_MB=$((FREE_KB / 1024))
    USED_MB=$((TOTAL_MB - FREE_MB))
    echo "Total Memory: ${TOTAL_MB} MB" | tee -a "$LOG_FILE"
    echo "Used Memory: ${USED_MB} MB" | tee -a "$LOG_FILE"
    echo "Free Memory: ${FREE_MB} MB" | tee -a "$LOG_FILE"
fi
log_message ""

# CPU load
log_message "--- CPU LOAD ---"
if command -v uptime &> /dev/null; then
    uptime | tee -a "$LOG_FILE"
else
    # Windows alternative
    CPU_LOAD=$(wmic cpu get loadpercentage | awk 'NR==2 {print $1}')
    echo "CPU Load: ${CPU_LOAD}%" | tee -a "$LOG_FILE"
fi
log_message ""

# Process count
log_message "--- RUNNING PROCESSES ---"
process_count=$(ps aux | wc -l)
log_message "Total Running Processes: $((process_count - 1))"
log_message ""

log_message "--- TOP 5 MEMORY-CONSUMING PROCESSES ---"
ps aux | sort -k4 -nr | head -6 | tee -a "$LOG_FILE"
log_message ""

log_message "=== System Check Report Complete ==="
log_message "Report saved to: $LOG_FILE"

exit 0
