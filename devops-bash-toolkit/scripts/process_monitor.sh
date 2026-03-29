#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

read -p "Enter process name: " process

if pgrep -x "$process" > /dev/null; then
  status="Running"
else
  status="Stopped"
  echo "Attempting restart..."

  # Simulated restart
  sleep 1
  status="Restarted"
fi

echo "$process: $status"
echo "$(date): $process is $status" >> "$LOG_FILE"
