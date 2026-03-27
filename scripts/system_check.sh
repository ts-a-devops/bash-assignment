#!/bin/bash

LOG_DIR="logs"
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/system_report_${DATE}.log"

mkdir -p "$LOG_DIR"

log_and_display() {
    echo "$1" | tee -a "$LOG_FILE"
}

log_and_display "=== System Check Report ==="
log_and_display "Generated: $(date)"
log_and_display ""

log_and_display "--- Disk Usage ---"
df -h | tee -a "$LOG_FILE"

disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [[ $disk_usage -gt 80 ]]; then
    log_and_display "⚠️  WARNING: Disk usage at ${disk_usage}% (exceeds 80%)"
else
    log_and_display "✅ Disk usage OK: ${disk_usage}%"
fi

log_and_display ""
log_and_display "--- Memory Usage ---"
free -m | tee -a "$LOG_FILE"

log_and_display ""
log_and_display "--- CPU Load ---"
uptime | tee -a "$LOG_FILE"

log_and_display ""
log_and_display "--- Process Count ---"
process_count=$(ps aux | wc -l)
log_and_display "Total running processes: $process_count"

log_and_display ""
log_and_display "--- Top 5 Memory-Consuming Processes ---"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

log_and_display ""
log_and_display "Report saved to: $LOG_FILE"
