#!/bin/bash

mkdir -p logs
log_file="logs/process_monitor.log"

# Services array
services=("nginx" "ssh" "docker")

process=$1

# Validate input
if [[ -z "$process" ]]; then
  echo "Usage: $0 <process_name>"
  exit 1
fi

# Check if process is in allowed services
if [[ ! " ${services[@]} " =~ " ${process} " ]]; then
  echo "Process '$process' not in monitored services list"
  exit 1
fi

# Check if running
if pgrep "$process" > /dev/null; then
  echo "$process is Running"
  echo "$(date): $process is Running" >> "$log_file"
else
  echo "$process is Stopped"
  echo "$(date): $process is Stopped" >> "$log_file"

  # Simulate restart
  echo "Restarting $process..."
  sleep 1
  echo "$process Restarted"
  echo "$(date): $process Restarted" >> "$log_file"
fi
