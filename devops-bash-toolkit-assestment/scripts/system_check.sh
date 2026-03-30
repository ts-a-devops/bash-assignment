#!/bin/bash
set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/system_report_$(date '+%Y-%m-%d').log"
# $(...): command substitution — runs date and inserts output into the string
# Each day gets its own report file automatically

mkdir -p "$LOG_DIR"

log() {
  echo "$1" | tee -a "$LOG_FILE"
}

SEP="─────────────────────────────────"

log "=== System Report: $(date) ==="
log "$SEP"

log "📦 DISK USAGE:"
df -h | tee -a "$LOG_FILE"
# df -h: disk free, -h = human-readable sizes (GB/MB instead of bytes)

log "$SEP"
log "🧠 MEMORY USAGE:"
free -m | tee -a "$LOG_FILE"
# free -m: RAM usage in megabytes (total, used, free, available)

log "$SEP"
log "⚙️  CPU LOAD:"
uptime | tee -a "$LOG_FILE"
# uptime: system uptime + load averages for last 1, 5, 15 minutes

log "$SEP"
log "🔢 TOTAL RUNNING PROCESSES: $(ps aux | wc -l)"
# ps aux: list all processes | wc -l: count lines = count processes

log "$SEP"
log "🔥 TOP 5 MEMORY-CONSUMING PROCESSES:"
ps aux --sort=-%mem | awk 'NR<=6 {print}' | tee -a "$LOG_FILE"
# --sort=-%mem: sort by memory, highest first
# awk 'NR<=6': print rows 1–6 (row 1 = header, 2–6 = top 5 processes)

log "$SEP"
log "⚠️  DISK USAGE WARNINGS:"

WARNED=false
# Boolean flag — bash has no real booleans, we use strings

while IFS= read -r line; do
  # while read: loop one line at a time | IFS=: preserve whitespace
  usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
  # awk '{print $5}': get 5th column (Use%) | tr -d '%': remove % sign
  mount=$(echo "$line" | awk '{print $6}')
  # $6 in df output = mount point (e.g. /, /home)

  if [[ "$usage" =~ ^[0-9]+$ ]] && [[ "$usage" -gt 80 ]]; then
    log "WARNING: $mount is at ${usage}% disk usage!"
    WARNED=true
  fi
  # &&: AND — both conditions must be true | -gt: greater than
done < <(df -h | tail -n +2)
# < <(...): process substitution — feeds command output into the while loop
# tail -n +2: skip the first line (df header row)

$WARNED || log "✅ All disks are within safe limits."
# Short-circuit OR: if WARNED=false, run the right side

log "Report saved to $LOG_FILE"
