#!/bin/bash
set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

services=("nginx" "ssh" "docker")
# Arrays in bash: () with space-separated values — NO commas!

check_process() {
  local proc="$1"
  # local: scopes the variable to this function only (best practice)

  if pgrep -x "$proc" > /dev/null 2>&1; then
    # pgrep -x: search for process by EXACT name
    # > /dev/null: discard stdout | 2>&1: redirect stderr to stdout
    # pgrep exits 0 (found) or 1 (not found) — we only care about that exit code
    log "[$proc] Status: RUNNING"
    echo "✅ $proc is RUNNING"
  else
    log "[$proc] Status: STOPPED — attempting restart..."
    echo "⚠️  $proc is STOPPED"

    echo "🔄 Simulating restart of $proc..."
    sleep 1
    # sleep 1: pause 1 second to simulate restart time

    log "[$proc] Status: RESTARTED (simulated)"
    echo "✅ $proc RESTARTED (simulated)"
  fi
}

TARGET="${1:-}"
# If a process name was passed as argument, check only that one

if [[ -n "$TARGET" ]]; then
  # -n: true if string is NOT empty (opposite of -z)
  check_process "$TARGET"
else
  log "=== Monitoring all services ==="
  for proc in "${services[@]}"; do
    # for ... in "${array[@]}": loop over every element in the array
    # [@]: all elements | quotes + [@] handle elements with spaces correctly
    check_process "$proc"
  done
  # done: ends the for loop
fi
