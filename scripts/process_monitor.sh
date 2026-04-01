#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

for service in "${services[@]}"; do
if pgrep -x "$service" > /dev/null; then
    echo "$service is Running" | tee -a "$LOG_FILE"
else
    echo "$service is Stopped. Restarting..." | tee -a "$LOG_FILE"
# Simulate restart
    echo "$service Restarted" | tee -a "$LOG_FILE"
fi
done
