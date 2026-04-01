#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

process=$1
if [ -z "$process" ]; then
  echo "Usage: ./process_monitor.sh <process_name>" | tee -a "$LOG_FILE"
  exit 1
fi

if pgrep -x "$process" > /dev/null
then
  echo "$process is Running" | tee -a "$LOG_FILE"
  status="Running"
else
  echo "$process is Stopped" | tee -a "$LOG_FILE"
  # Simulate restart if in services array
  for svc in "${services[@]}"; do
    if [ "$svc" == "$process" ]; then
      echo "Restarting $process..." | tee -a "$LOG_FILE"
      status="Restarted"
    fi
  done
  if [ -z "$status" ]; then
    status="Stopped"
  fi
fi

echo "$(date): $process -> $status" | tee -a "$LOG_FILE"
