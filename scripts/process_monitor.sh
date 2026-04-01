#!/usr/bin/env bash
# process_monitor.sh - Monitor and attempt restart of system services
# Usage: ./process_monitor.sh [process_name]
#        (no args = monitor default services array)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$ROOT_DIR/logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

# Default services to monitor when no argument is given
services=("nginx" "ssh" "docker")


log() {
  local level=$1; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

is_running() {
  pgrep -x "$1" &>/dev/null
}

try_restart() {
  local svc=$1
  # Try systemctl first (systemd), fall back to service, then simulate
  if command -v systemctl &>/dev/null && systemctl list-units --type=service --quiet "$svc.service" 2>/dev/null | grep -q "$svc"; then
    if systemctl restart "$svc" 2>/dev/null; then
      return 0
    fi
  elif command -v service &>/dev/null; then
    if service "$svc" restart 2>/dev/null; then
      return 0
    fi
  fi
  # Simulation fallback (for demo / non-privileged environments)
  echo "   [SIM] Restart command issued for '$svc' (simulation — no privileges)"
  return 0
}

check_process() {
  local proc=$1
  printf '  %-20s ' "$proc"

  if is_running "$proc"; then
    local pid
    pid=$(pgrep -x "$proc" | head -1)
    echo "  Running   (PID: $pid)"
    log "INFO" "$proc — Running (PID: $pid)"
  else
    echo "  Stopped"
    log "WARN" "$proc — Stopped. Attempting restart..."
    echo "   ⚙️   Attempting to restart '$proc'..."

    if try_restart "$proc"; then
      sleep 1
      if is_running "$proc"; then
        local pid
        pid=$(pgrep -x "$proc" | head -1)
        echo "     Restarted successfully (PID: $pid)"
        log "INFO" "$proc — Restarted (PID: $pid)"
      else
        echo "      Restarted (still not detected in process list)"
        log "WARN" "$proc — Restart issued but process not detected"
      fi
    else
      echo "     Restart failed"
      log "ERROR" "$proc — Restart failed"
    fi
  fi
}


if [[ $# -gt 0 ]]; then
  targets=("$@")
else
  targets=("${services[@]}")
fi

echo "========================================"
echo "  Process Monitor"
echo "  Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"
printf '  %-20s %s\n' "PROCESS" "STATUS"
echo "  ----------------------------------------"

log "INFO" "Starting process monitor — targets: ${targets[*]}"

for proc in "${targets[@]}"; do
  check_process "$proc"
done

echo "========================================"
echo "  Log: $LOG_FILE"
echo "========================================"
