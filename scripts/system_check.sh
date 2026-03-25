#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
REPORT="$LOG_DIR/system_report_$(date '+%Y-%m-%d_%H-%M-%S').log"
DISK_THRESHOLD=80

mkdir -p "$LOG_DIR"

log() {
    echo "$*" | tee -a "$REPORT"
}

log "System Report — $(date '+%Y-%m-%d %H:%M:%S')"
log "Host: $(hostname) | Kernel: $(uname -r)"
log ""

log "DISK USAGE"
df -h | tee -a "$REPORT"
log ""

# Warn if any partition exceeds threshold
while read -r line; do
    USAGE=$(echo "$line" | awk 'NR>1 {gsub(/%/,""); print $5}')
    MOUNT=$(echo "$line" | awk 'NR>1 {print $6}')
    if [[ "$USAGE" =~ ^[0-9]+$ ]] && (( USAGE > DISK_THRESHOLD )); then
        log "WARNING: $MOUNT is at ${USAGE}% — exceeds ${DISK_THRESHOLD}%"
    fi
done < <(df -h)

log ""
log "MEMORY USAGE (MB)"
free -m | tee -a "$REPORT"

log ""
log "CPU LOAD"
uptime | tee -a "$REPORT"

log ""
log "RUNNING PROCESSES"
PROC_COUNT=$(ps aux --no-header | wc -l)
log "Total: $PROC_COUNT"

log ""
log "TOP 5 MEMORY-CONSUMING PROCESSES"
printf "%-6s %-20s %-8s %-8s\n" "PID" "COMMAND" "%CPU" "%MEM" | tee -a "$REPORT"
ps aux --no-header --sort=-%mem | head -5 | \
    awk '{printf "%-6s %-20s %-8s %-8s\n", $2, $11, $3, $4}' | tee -a "$REPORT"

log ""
log "Report saved to: $REPORT"
