#!/bin/bash

# ── Setup ─────────────────────────────────────
DATE=$(date "+%Y-%m-%d")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="../logs/system_report_${DATE}.log"

# ── Helpers ───────────────────────────────────
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

header() {
  log ""
  log "============================================="
  log "  $1"
  log "============================================="
}

separator() {
  log "---------------------------------------------"
}

# ── Report Header ─────────────────────────────
log "============================================="
log "   SYSTEM HEALTH REPORT — $TIMESTAMP"
log "   Host: $(hostname)"
log "============================================="

# ── 1. Disk Usage ─────────────────────────────
header "1. DISK USAGE"
df -h | tee -a "$LOG_FILE"

log ""
log "[ Disk Warning Check ]"
WARN_FOUND=0

while IFS= read -r line; do
  # Extract use% column (5th field) and mount (6th field)
  USE=$(echo "$line" | awk 'NR>1 {gsub(/%/,""); print $5}')
  MOUNT=$(echo "$line" | awk 'NR>1 {print $6}')

  if [[ "$USE" =~ ^[0-9]+$ ]] && (( USE > 80 )); then
    log "  WARNING: '$MOUNT' is at ${USE}% usage — exceeds 80% threshold!"
    WARN_FOUND=1
  fi
done < <(df -h)

if (( WARN_FOUND == 0 )); then
  log "  OK: All filesystems are within safe limits."
fi

# ── 2. Memory Usage ───────────────────────────
header "2. MEMORY USAGE (MB)"
free -m | tee -a "$LOG_FILE"

log ""
log "[ Memory Summary ]"
TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
USED=$(free -m  | awk '/^Mem:/ {print $3}')
FREE=$(free -m  | awk '/^Mem:/ {print $4}')
AVAIL=$(free -m | awk '/^Mem:/ {print $7}')

log "  Total     : ${TOTAL} MB"
log "  Used      : ${USED} MB"
log "  Free      : ${FREE} MB"
log "  Available : ${AVAIL} MB"

if [[ -n "$TOTAL" && "$TOTAL" -gt 0 ]]; then
  MEM_PCT=$(( USED * 100 / TOTAL ))
  log "  Usage %   : ${MEM_PCT}%"
  if (( MEM_PCT > 80 )); then
    log "  WARNING: Memory usage is at ${MEM_PCT}% — exceeds 80% threshold!"
  else
    log "  OK: Memory usage is within safe limits."
  fi
fi

# ── 3. CPU Load ───────────────────────────────
header "3. CPU LOAD (uptime)"
uptime | tee -a "$LOG_FILE"

log ""
log "[ Load Average Summary ]"
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)
log "  Load averages (1m / 5m / 15m): $LOAD"

CPU_COUNT=$(nproc 2>/dev/null || echo 1)
LOAD_1=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)
log "  CPU cores : $CPU_COUNT"

# Compare load (remove decimal for integer comparison)
LOAD_INT=$(echo "$LOAD_1" | awk '{printf "%d", $1 * 100}')
THRESHOLD=$(( CPU_COUNT * 100 ))
if (( LOAD_INT > THRESHOLD )); then
  log "  WARNING: 1-minute load ($LOAD_1) exceeds number of CPU cores ($CPU_COUNT)!"
else
  log "  OK: CPU load is within normal range."
fi

# ── 4. Running Processes ──────────────────────
header "4. RUNNING PROCESSES"
PROC_COUNT=$(ps aux --no-headers | wc -l)
log "  Total running processes: $PROC_COUNT"

# ── 5. Top 5 Memory-Consuming Processes ───────
header "5. TOP 5 MEMORY-CONSUMING PROCESSES"
log "$(printf '%-10s %-8s %-8s %-6s %-6s %s' 'USER' 'PID' 'MEM%' 'VSZ' 'RSS' 'COMMAND')"
separator

ps aux --no-headers \
  | sort -rk4 \
  | head -5 \
  | awk '{printf "%-10s %-8s %-8s %-6s %-6s %s\n", $1, $2, $4, $5, $6, $11}' \
  | tee -a "$LOG_FILE"

# ── Footer ────────────────────────────────────
header "END OF REPORT"
log "  Report saved to : $LOG_FILE"
log "  Generated at    : $TIMESTAMP"
log "============================================="
log ""
