#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

process_name="${1:-}"

if [[ -z "$process_name" ]]; then
  echo "Usage: $0 <process_name>"
  exit 1
fi

# Check if process is in allowed list
found=false
for service in "${services[@]}"; do
  if [[ "$service" == "$process_name" ]]; then
    found=true
    break
  fi
done

if [[ "$found" == false ]]; then
  msg="Process '$process_name' is not monitored."
  echo "$msg"
  echo "$(date '+%F %T') - $msg" >> "$LOG_FILE"
  exit 1
fi

# Check if running
if pgrep -x "$process_name" > /dev/null 2>&1; then
  msg="$process_name is Running"
else
  msg="$process_name is Stopped. Restarting..."
  echo "$msg"
  
  # Simulate restart (safe for assignment)
  sleep 1
  
  msg2="$process_name Restarted"
  echo "$msg2"
  
  echo "$(date '+%F %T') - $msg" >> "$LOG_FILE"
  echo "$(date '+%F %T') - $msg2" >> "$LOG_FILE"
  exit 0
fi

echo "$msg"
echo "$(date '+%F %T') - $msg" >> "$LOG_FILE"
