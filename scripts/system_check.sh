#!/bin/bash
set -euo pipefail

mkdir -p logs

DATE=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="logs/system_report_${DATE}.log"

log() {
    echo "$1" | tee -a "$LOG_FILE"
}

log "=== System Report - $DATE ==="
log ""

# Disk usage
log "--- Disk Usage ---"
df -h | tee -a "$LOG_FILE"

# Check disk warning
disk_usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
if (( disk_usage > 80 )); then
    log "⚠️  WARNING: Disk usage is at ${disk_usage}% (exceeds 80%)"
fi
log ""

# Memory usage
log "--- Memory Usage ---"
free -m | tee -a "$LOG_FILE"
log ""

# CPU load
log "--- CPU Load ---"
uptime | tee -a "$LOG_FILE"
log ""

# Running processes count
process_count=$(ps aux | wc -l)
log "Total running processes: $((process_count - 1))"

# Top 5 memory-consuming processes
log ""
log "--- Top 5 Memory-Consuming Processes ---"
ps aux --sort=-%mem | head -6 | tee -a "$LOG_FILE"

log ""
log "=== Report saved to $LOG_FILE ==="
