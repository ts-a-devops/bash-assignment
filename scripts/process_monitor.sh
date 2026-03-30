#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

read -p "Enter process name: " process

if pgrep -x "$process" > /dev/null; then
  echo "$process is Running"
  echo "$(date): $process Running" >> "$LOG_FILE"
else
  echo "$process is Stopped. Restarting..."
  
  # Simulate restart
  sleep 1
  
  echo "$process Restarted"
  echo "$(date): $process Restarted" >> "$LOG_FILE"
fi
