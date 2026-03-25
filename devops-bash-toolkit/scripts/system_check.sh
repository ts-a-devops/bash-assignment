#!/bin/bash
# ─────────────────────────────────────────
#  system_check.sh - System health check report
# ─────────────────────────────────────────

# ── Log file with date ──
DATE=$(date +%Y-%m-%d)
LOG_FILE="logs/system_report_$DATE.log"

# ── Create logs folder if it doesn't exist ──
mkdir -p logs

# ── Function to print and log ──
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

log "========================================="
log "  SYSTEM HEALTH REPORT - $DATE"
log "========================================="
log ""

# ── Disk Usage ──
log "--------- DISK USAGE (df -h) ------------"
df -h | tee -a "$LOG_FILE"
log ""

# ── Warn if disk usage exceeds 80% ──
log "--------- DISK USAGE WARNING ------------"
df -h | awk 'NR>1 {gsub(/%/, "", $5); if ($5+0 > 80) print "⚠️  WARNING: " $1 " is at " $5 "% usage!"}' | tee -a "$LOG_FILE"
log ""

# ── Memory Usage ──
log "--------- MEMORY USAGE (free -m) --------"
free -m | tee -a "$LOG_FILE"
log ""

# ── CPU Load ──
log "--------- CPU LOAD (uptime) -------------"
uptime | tee -a "$LOG_FILE"
log ""

# ── Total Running Processes ──
log "--------- TOTAL RUNNING PROCESSES -------"
TOTAL_PROCESSES=$(ps aux | wc -l)
log "Total Running Processes: $TOTAL_PROCESSES"
log ""

# ── Top 5 Memory Consuming Processes ──
log "--------- TOP 5 MEMORY PROCESSES --------"
ps aux --sort=-%mem | awk 'NR<=6 {printf "%-10s %-8s %-8s %s\n", $1, $2, $4, $11}' | tee -a "$LOG_FILE"
log ""

log "========================================="
log "  Report saved to: $LOG_FILE"
log "========================================="
