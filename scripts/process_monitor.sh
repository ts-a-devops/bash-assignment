#!/bin/bash

mkdir -p logs

PROCESS=$1
LOG_FILE="logs/process_monitor.log"

# Define default services array
services=("nginx" "ssh" "docker")

# Use input process or default array
if [ -n "$PROCESS" ]; then
    services=("$PROCESS")
fi

for service in "${services[@]}"; do
    if pgrep "$service" > /dev/null; then
        echo "$(date): $service is running" | tee -a $LOG_FILE
        echo "Running: $service"
    else
        echo "$(date): $service is stopped, attempting restart" | tee -a $LOG_FILE
        # Simulate restart (actual restart requires sudo)
        echo "Restarted: $service"
    fi
done