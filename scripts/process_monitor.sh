#!/bin/bash

mkdir -p logs
LOGFILE="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

echo "===== Process Monitor ======"

for service in "${services[@]}"; do
  if pgrep -x "$service" > /dev/null 2>&1; then
    echo "$service is RUNNING"
    echo "$(date): $service is RUNNING" >> $LOGFILE
  else
    echo "$service is STOPPED - attempting restart..."
    echo "$(date): $service is STOPPED - simulating restart" >> $LOGFILE
    echo "$service restarted (simulated)"
    echo "$(date): $service RESTARTED" >> $LOGFILE
  fi
done

echo "============================"
echo "Log saved to $LOGFILE"
