#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/process_monitor.log"

services=("nginx" "ssh" "docker")

log_action() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_process() {
  local process_name="$1"

  if pgrep -x "$process_name" > /dev/null 2>&1; then
    echo "✅ $process_name is RUNNING"
    log_action "$process_name - RUNNING"
  else
    echo "⚠️  $process_name is STOPPED. Attempting restart..."
    log_action "$process_name - STOPPED. Attempting restart."

    # Attempt real restart using systemctl, fallback to simulation
    if command -v systemctl &>/dev/null; then
      if systemctl restart "$process_name" 2>/dev/null; then
        echo "✅ $process_name RESTARTED successfully."
        log_action "$process_name - RESTARTED successfully."
      else
        echo "❌ $process_name could not be restarted (simulated)."
        log_action "$process_name - Restart FAILED (simulated)."
      fi
    else
      echo "⚠️  systemctl not available. Simulating restart of $process_name."
      log_action "$process_name - Restart SIMULATED (no systemctl)."
    fi
  fi
}

# Accept optional process name argument or monitor default services array
if [[ $# -ge 1 ]]; then
  check_process "$1"
else
  echo "========================================"
  echo "  Process Monitor - $(date '+%Y-%m-%d %H:%M:%S')"
  echo "========================================"
  for service in "${services[@]}"; do
    check_process "$service"
  done
  echo "========================================"
fi

