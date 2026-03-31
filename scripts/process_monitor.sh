#!/usr/bin/env bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"
services=("nginx" "ssh" "docker")

process_name="$1"

if [[ -z "$process_name" ]]; then
  echo "Usage: $0 <process_name>"
  exit 1
fi

if pgrep -x "$process_name" >/dev/null; then
  status="Running"
else
  status="Stopped"
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl restart "$process_name" 2>/dev/null && status="Restarted"
  else
    status="Restart simulated"
  fi
fi

echo "$process_name: $status"
echo "$(date '+%F %T') - $process_name: $status" >> "$LOG_FILE"
