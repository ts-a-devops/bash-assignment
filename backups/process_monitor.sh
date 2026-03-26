#!/bin/bash
mkdir -p logs
LOG_FILE="logs/process_monitor.log"

PROC=$1
[ -z "$PROC" ] && echo "Provide process name" && exit

if pgrep "$PROC" >/dev/null; then
  echo "$PROC is Running"
else
  echo "$PROC is Stopped"
  echo "Simulating restart..."
  echo "$(date): $PROC restarted" >> "$LOG_FILE"
  echo "Restarted"
fi
