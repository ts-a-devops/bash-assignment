#!/bin/bash
# ─────────────────────────────────────────
#  process_monitor.sh - Process monitoring tool
# ─────────────────────────────────────────

# ── Log file ──
LOG_FILE="logs/process_monitor.log"

# ── Create logs folder if it doesn't exist ──
mkdir -p logs

# ── Timestamp ──
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# ── Services array ──
services=("nginx" "ssh" "docker")

# ── Function to print and log ──
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

# ── Function to check and monitor a process ──
check_process() {
  local PROCESS=$1

  # ── Check if process is running ──
  if pgrep -x "$PROCESS" > /dev/null 2>&1; then
    log "[$TIMESTAMP] RUNNING:  '$PROCESS' is currently running."

  else
    log "[$TIMESTAMP] STOPPED:  '$PROCESS' is NOT running."
    log "[$TIMESTAMP] RESTARTING: Attempting to restart '$PROCESS'..."

    # ── Attempt restart using systemctl ──
    if command -v systemctl > /dev/null 2>&1; then
      sudo systemctl start "$PROCESS" > /dev/null 2>&1

      # ── Verify if restart was successful ──
      if pgrep -x "$PROCESS" > /dev/null 2>&1; then
        log "[$TIMESTAMP] RESTARTED: '$PROCESS' restarted successfully."
      else
        log "[$TIMESTAMP] FAILED:    '$PROCESS' could not be restarted. (Simulated restart)"
      fi

    else
      # ── Simulate restart if systemctl not available ──
      log "[$TIMESTAMP] SIMULATED: systemctl not available. Simulating restart of '$PROCESS'."
      log "[$TIMESTAMP] RESTARTED: '$PROCESS' has been simulated as restarted."
    fi
  fi

  log "-------------------------------------------"
}

# ─────────────────────────────────────────
log "========================================="
log "  PROCESS MONITOR STARTED - $TIMESTAMP"
log "========================================="
log ""

# ── If a specific process name is provided ──
if [[ ! -z "$1" ]]; then
  log "[$TIMESTAMP] INFO: Checking process '$1'..."
  log "-------------------------------------------"
  check_process "$1"

# ── Otherwise monitor all services in the array ──
else
  log "[$TIMESTAMP] INFO: No process specified. Monitoring default services..."
  log "[$TIMESTAMP] INFO: Services to monitor: ${services[@]}"
  log "-------------------------------------------"

  for SERVICE in "${services[@]}"; do
    check_process "$SERVICE"
  done
fi

log ""
log "========================================="
log "  PROCESS MONITOR COMPLETED - $TIMESTAMP"
log "========================================="
