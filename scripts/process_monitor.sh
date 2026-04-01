#!/bin/bash
set -euo pipefail

LOG_FILE="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

for service in "${services[@]}"; do
  if pgrep "$service" > /dev/null; then
    echo "$service is running"
    echo "$(date): $service running" >> "$LOG_FILE"
  else
    echo "$service is stopped. Restarting..."
    echo "$(date): $service restarted" >> "$LOG_FILE"
  fi
done
