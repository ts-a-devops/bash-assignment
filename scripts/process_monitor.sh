#!/bin/bash

# ── Setup ─────────────────────────────────────
LOG_FILE="../logs/process_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")


# ── Known Services Array ───────────────────────
services=("nginx" "ssh" "docker")

# ── Helpers ───────────────────────────────────
log() {
  local level="$1"
  local msg="$2"
  local entry="[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg"
  echo "$entry" | tee -a "$LOG_FILE"
}

info()    { log "INFO   " "$1"; }
success() { log "RUNNING" "$1"; }
stopped() { log "STOPPED" "$1"; }
restart() { log "RESTART" "$1"; }
warn()    { log "WARN   " "$1"; }
error()   { log "ERROR  " "$1"; }

separator() {
  echo "=============================================" | tee -a "$LOG_FILE"
}

thin_sep() {
  echo "---------------------------------------------" | tee -a "$LOG_FILE"
}

usage() {
  echo ""
  echo "Usage:"
  echo "  ./process_monitor.sh                  Monitor all default services"
  echo "  ./process_monitor.sh <process_name>   Monitor a specific process"
  echo "  ./process_monitor.sh --list           List default monitored services"
  echo ""
  echo "Default services: ${services[*]}"
  echo ""
}

# ── Check if process is running ───────────────
is_running() {
  local proc="$1"
  pgrep -x "$proc" > /dev/null 2>&1
}

# ── Simulate restart ──────────────────────────
simulate_restart() {
  local proc="$1"

  # Check if systemctl is available and service is known
  if command -v systemctl &>/dev/null && systemctl list-unit-files "${proc}.service" &>/dev/null 2>&1; then
    restart "Attempting systemctl restart for '$proc'..."
    systemctl restart "$proc" 2>/dev/null
    sleep 1
    if is_running "$proc"; then
      success "'$proc' restarted successfully via systemctl."
      return 0
    else
      warn "'$proc' could not be restarted via systemctl. Simulating..."
    fi
  fi

  # Simulate restart (for demo/sandboxed environments)
  restart "Simulating restart for '$proc'..."
  sleep 1
  restart "'$proc' restart simulated. [Status: Restarted]"
  return 2  # exit code 2 = simulated
}

# ── Monitor a single process ──────────────────
monitor_process() {
  local proc="$1"

  thin_sep
  info "Checking process: '$proc'"

  if is_running "$proc"; then
    PID=$(pgrep -x "$proc" | head -1)
    MEM=$(ps -p "$PID" -o rss= 2>/dev/null | awk '{printf "%.1f MB", $1/1024}')
    CPU=$(ps -p "$PID" -o %cpu= 2>/dev/null | xargs)
    success "'$proc' is RUNNING  |  PID: $PID  |  CPU: ${CPU}%  |  MEM: $MEM"
  else
    stopped "'$proc' is STOPPED."
    simulate_restart "$proc"
    RESTART_CODE=$?

    if [[ $RESTART_CODE -eq 0 ]]; then
      success "'$proc' is now RUNNING after restart."
    else
      warn "'$proc' restart was simulated (not a real service or no permission)."
    fi
  fi
}

# ── Monitor all default services ──────────────
monitor_all() {
  separator
  info "Monitoring all default services: ${services[*]}"
  separator

  RUNNING_COUNT=0
  STOPPED_COUNT=0
  RESTARTED_COUNT=0

  for svc in "${services[@]}"; do
    if is_running "$svc"; then
      PID=$(pgrep -x "$svc" | head -1)
      MEM=$(ps -p "$PID" -o rss= 2>/dev/null | awk '{printf "%.1f MB", $1/1024}')
      CPU=$(ps -p "$PID" -o %cpu= 2>/dev/null | xargs)
      thin_sep
      success "'$svc' is RUNNING  |  PID: $PID  |  CPU: ${CPU}%  |  MEM: $MEM"
      (( RUNNING_COUNT++ ))
    else
      thin_sep
      stopped "'$svc' is STOPPED."
      simulate_restart "$svc"
      (( STOPPED_COUNT++ ))
      (( RESTARTED_COUNT++ ))
    fi
  done

  # ── Summary ─────────────────────────────────
  separator
  info "Monitoring Summary — $TIMESTAMP"
  separator
  info "  Total services  : ${#services[@]}"
  info "  Running         : $RUNNING_COUNT"
  info "  Stopped         : $STOPPED_COUNT"
  info "  Restart attempts: $RESTARTED_COUNT"
  separator
}

# ══════════════════════════════════════════════
#  ENTRY POINT
# ══════════════════════════════════════════════

# No argument — monitor all default services
if [[ $# -eq 0 ]]; then
  monitor_all
  exit 0
fi

# --list flag
if [[ "$1" == "--list" ]]; then
  echo ""
  echo "Default monitored services:"
  for i in "${!services[@]}"; do
    echo "  [$i] ${services[$i]}"
  done
  echo ""
  exit 0
fi

# --help flag
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  usage
  exit 0
fi

# Specific process name provided
PROCESS="$1"

if [[ -z "$PROCESS" ]]; then
  error "Empty process name provided."
  usage
  exit 1
fi

separator
info "Single process monitor — $TIMESTAMP"
monitor_process "$PROCESS"
separator
info "Done."
separator
