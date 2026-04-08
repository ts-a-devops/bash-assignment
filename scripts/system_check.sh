#!/bin/bash

mkdir -p logs

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="logs/system_report_$DATE.log"

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log "===== SYSTEM HEALTH REPORT ====="
log "Date: $(date)"
log ""

log "---- Disk Usage ----"
df -h | tee -a "$LOG_FILE"
log ""

log "---- Disk Usage Warnings (>80%) ----"
df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "WARNING: " $1 " is at " $5 "% usage"}' | tee -a "$LOG_FILE"
log ""

log "---- Memory Usage (MB) ----"
free -m | tee -a "$LOG_FILE"
log ""

log "---- CPU Load ----"
uptime | tee -a "$LOG_FILE"
log ""

TOTAL_PROCESSES=$(ps aux | wc -l)
log "---- Total Running Processes ----"
log "$TOTAL_PROCESSES processes running"
log ""

log "---- Top 5 Memory Consuming Processes ----"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
log ""

log "Report saved to $LOG_FILE"
