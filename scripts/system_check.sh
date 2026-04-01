#!/usr/bin/env bash
# system_check.sh - System health report
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
REPORT="$LOG_DIR/system_report_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR"

DISK_WARN_THRESHOLD=80

hr()  { printf '%s\n' "----------------------------------------"; }
hdr() { echo; hr; printf '  %s\n' "$1"; hr; }

tee_report() { tee -a "$REPORT"; }

{
  echo "========================================"
  echo "  System Health Report"
  echo "  Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "  Host: $(hostname)"
  echo "========================================"

  hdr "Disk Usage"
  df -h

  echo
  WARNED=false
  while IFS= read -r line; do
    USE_PCT=$(echo "$line" | awk '{print $5}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $6}')
    if [[ "$USE_PCT" =~ ^[0-9]+$ ]] && (( USE_PCT > DISK_WARN_THRESHOLD )); then
      echo "  WARNING: '$MOUNT' is at ${USE_PCT}% — exceeds ${DISK_WARN_THRESHOLD}% threshold!"
      WARNED=true
    fi
  done < <(df -h | tail -n +2)
  $WARNED || echo "  All filesystems are within safe limits."

  hdr "Memory Usage (MB)"
  free -m

  hdr "CPU Load (uptime)"
  uptime


  hdr "Running Processes"
  PROC_COUNT=$(ps aux --no-headers | wc -l)
  echo "Total running processes: $PROC_COUNT"


  hdr "Top 5 Memory-Consuming Processes"
  printf '%-8s %-8s %-6s %-6s %s\n' "PID" "USER" "%CPU" "%MEM" "COMMAND"
  ps aux --no-headers --sort=-%mem | head -5 | \
    awk '{printf "%-8s %-8s %-6s %-6s %s\n", $2, $1, $3, $4, $11}'

  echo
  echo "========================================"
  echo "  Report saved to: $REPORT"
  echo "========================================"

} | tee_report

echo
echo "  System check complete. Report: $REPORT"
