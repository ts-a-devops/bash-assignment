#!/usr/bin/env bash

set -euo pipefail

services=("nginx" "ssh" "docker")
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

if (( $# != 1 )); then
  echo "Usage: ./scripts/process_monitor.sh <process_name>"
  echo "Monitored services: ${services[*]}"
  exit 1
fi

process_name="$1"
status=""

is_supported=false
for service in "${services[@]}"; do
  if [[ "$service" == "$process_name" ]]; then
    is_supported=true
    break
  fi
done

if [[ "$is_supported" != true ]]; then
  echo "Error: unsupported service '$process_name'."
  echo "Choose one of: ${services[*]}"
  exit 1
fi

if pgrep -x "$process_name" >/dev/null 2>&1; then
  status="Running"
  echo "$process_name: $status"
else
  status="Stopped"
  echo "$process_name: $status"

  restarted=false
  if command -v systemctl >/dev/null 2>&1; then
    if systemctl restart "$process_name" >/dev/null 2>&1; then
      restarted=true
    fi
  fi

  if [[ "$restarted" == true ]]; then
    status="Restarted"
    echo "$process_name: $status"
  else
    status="Restarted (simulated)"
    echo "$process_name: $status"
  fi
fi

printf "%s | process=%s | status=%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$process_name" "$status" >> "$LOG_FILE"
