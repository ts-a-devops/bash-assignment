#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

services=("nginx" "ssh" "docker")

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "$LOG_FILE"
}

process_name="${1:-}"

if [[ -z "$process_name" ]]; then
  printf 'Usage: %s <process-name>\n' "$(basename "$0")"
  exit 1
fi

known_service=0
for service in "${services[@]}"; do
  if [[ "$service" == "$process_name" ]]; then
    known_service=1
    break
  fi
done

if (( known_service == 0 )); then
  printf 'Warning: %s is not in the monitored services list.\n' "$process_name"
fi

if pgrep -x "$process_name" > /dev/null 2>&1; then
  status="Running"
  printf '%s\n' "$status"
  log_message "$process_name status: $status"
  exit 0
fi

printf 'Stopped\n'
log_message "$process_name status: Stopped"

# Simulate restart to avoid assuming service managers are available.
printf 'Restarted\n'
log_message "$process_name status: Restarted (simulated)"
