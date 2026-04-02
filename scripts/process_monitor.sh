#!/usr/bin/env bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"
services=("nginx" "ssh" "docker")

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <process_name>"
  echo "Allowed examples: ${services[*]}"
  exit 1
fi

process_name="$1"
timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

is_allowed=false
for service in "${services[@]}"; do
  if [[ "$service" == "$process_name" ]]; then
    is_allowed=true
    break
  fi
done

if [[ "$is_allowed" == false ]]; then
  message="[$timestamp] '$process_name' is not in the monitored services list: ${services[*]}"
  echo "$message"
  echo "$message" >> "$LOG_FILE"
  exit 1
fi

if pgrep -x "$process_name" >/dev/null 2>&1; then
  message="[$timestamp] $process_name: Running"
  echo "$message"
  echo "$message" >> "$LOG_FILE"
else
  message="[$timestamp] $process_name: Stopped. Simulating restart..."
  echo "$message"
  echo "$message" >> "$LOG_FILE"

  restart_message="[$timestamp] $process_name: Restarted"
  echo "$restart_message"
  echo "$restart_message" >> "$LOG_FILE"
fi
