#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
services=("ngnix" "ssh" "docker")

for service in "${services[@]}"; do
  if pgrep -x "$services" > /dev/null; then 
    echo "$service is running" 
    echo "$service is running" >> "$LOG_FILE"
else
    echo "$service is stopped. Restarting..."
    echo "$service Restarted" 
    echo "$service Restarded" >> "$LOG_FILE"
fi
done
