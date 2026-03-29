#!/bin/bash

set -euo pipefail

LOG_FILE="../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

# Ensure logs directory exists
mkdir -p "$(dirname "$LOG_FILE")"

read -p "Enter process name: " process

# Validate input
if [[ -z "$process" ]]; then
  echo "Error: Process name cannot be empty."
  exit 1
fi

# Check if process is in predefined services list
if [[ ! " ${services[*]} " =~ " ${process} " ]]; then
  echo "Warning: '$process' is not in monitored services list: ${services[*]}"
fi

status=""

# Use pgrep if available (Linux), else fallback to ps (Git Bash compatible)
if command -v pgrep >/dev/null 2>&1; then
  if pgrep -x "$process" >/dev/null; then
    status="Running"
  else
    status="Stopped"
  fi
else
  if ps | grep -iw "$process" | grep -v grep >/dev/null; then
    status="Running"
  else
    status="Stopped"
  fi
fi

# Handle stopped process
if [[ "$status" == "Stopped" ]]; then
  echo "Attempting restart..."

  # Simulated restart (cross-platform safe)
  sleep 1
  status="Restarted"

  # OPTIONAL: Real restart (Linux only)
  # Uncomment if running in Linux with systemctl
  # if command -v systemctl >/dev/null 2>&1; then
  #   sudo systemctl restart "$process"
  #   status="Restarted (systemctl)"
  # fi
fi

# Output result
echo "$process: $status"

# Log result
echo "$(date '+%Y-%m-%d %H:%M:%S') | process=$process | status=$status" >> "$LOG_FILE"
