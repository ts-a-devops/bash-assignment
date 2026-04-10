#!/usr/bin/env bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
services=("nginx" "ssh" "docker")

mkdir -p "$LOG_DIR"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log_action() {
  echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

process_name="$1"

if [[ -z "$process_name" ]]; then
  echo "Usage: $0 <process_name>"
  echo "Supported examples: ${services[*]}"
  exit 1
fi

if pgrep -x "$process_name" >/dev/null 2>&1 || pgrep -f "$process_name" >/dev/null 2>&1; then
  log_action "Process '$process_name' status: Running"
  exit 0
fi

log_action "Process '$process_name' status: Stopped"

# Simulate restart for safety in student environments.
log_action "Attempting restart for '$process_name' (simulated)..."
sleep 1
log_action "Process '$process_name' status: Restarted (simulated)"
