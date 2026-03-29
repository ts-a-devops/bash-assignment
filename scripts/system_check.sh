#!/bin/bash

mkdir -p logs

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="logs/system_report_$DATE.log"

log() {
    echo "$1" | tee -a "$LOG_FILE"
}

log "===== SYSTEM CHECK REPORT ====="
log "Date: $(date)"
log ""

# Disk Usage
log "---- Disk Usage ----"
df -h | tee -a "$LOG_FILE"
log ""

# Disk Warning (>80%)
log "---- Disk Usage Warnings ----"
df -h | awk 'NR>1 {print $5 " " $6}' | while read usage mount; do
    percent=${usage%\%}
    if [ "$percent" -ge 80 ]; then
        log "WARNING: Disk usage on $mount is at ${percent}%"
    fi
done
log ""

# Memory Usage (with fallback)
log "---- Memory Usage ----"
if command -v free >/dev/null 2>&1; then
    free -m | tee -a "$LOG_FILE"
else
    log "Memory info not available (free command not found)"
fi
log ""

# CPU Load
log "---- CPU Load ----"
uptime | tee -a "$LOG_FILE"
log ""

# Process Count (portable)
log "---- Total Running Processes ----"
process_count=$(ps -e | wc -l)
log "Total processes: $process_count"
log ""

# Top 5 Memory Processes (portable)
log "---- Top 5 Memory-Consuming Processes ----"
ps aux | sort -nrk 4 | head -6 | tee -a "$LOG_FILE"
log ""

log "===== END OF REPORT ====="
