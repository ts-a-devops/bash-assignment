#!/bin/bash

LOG_FILE="logs/process_monitor.log"
mkdir -p logs

services=("nginx" "ssh" "docker")

PROCESS=$1

if [[ -z "$PROCESS" ]]; then
  echo "Please provide a process name."
  exit 1
fi

if pgrep -x "$PROCESS" > /dev/null; then
  echo "$PROCESS is Running"
  echo "$(date) - $PROCESS running" >> $LOG_FILE
else
  echo "$PROCESS is Stopped. Restarting..."

  # Simulated restart
  sleep 1

  echo "$PROCESS Restarted"
  echo "$(date) - $PROCESS restarted" >> $LOG_FILE
fi
