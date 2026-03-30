#!/bin/bash

DATE=$(date +"%Y")
LOG_FILE="../logs/system_report_${DATE}.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
  echo -e "$1" | tee -a "$LOG_FILE"
}

log "===== SYSTEM REPORT ====="
log "Generated on: $(date)"
log ""

# Disk Usage
log "---------- Disk Usage ----------"
df -h | tee -a "$LOG_FILE"
log ""

# Memory Usage
log "---------- Memory Usage ----------"
free -m | tee -a "$LOG_FILE"
log ""

# CPU Load
log "---------- CPU Load ----------"
uptime | tee -a "$LOG_FILE"
log ""

# Disk warning
USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
if (( USAGE > 80 )); then
  log "WARNING: Disk usage is above 80% (Current: ${USAGE}%)"
fi

# Process count
PROCESS_COUNT=$(ps aux | wc -l)
log ""
log "----- Total running processes: ${PROCESS_COUNT}"

# Top 5 memory-consuming processes
log ""
log "---------- Top 5 memory-consuming processes ----------"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
