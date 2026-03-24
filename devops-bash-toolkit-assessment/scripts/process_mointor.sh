#!/usr/bin/env bash

LOG_FILE="logs/process_monitor.log"

# Ensure logs directory exists
mkdir -p logs

# Service arrays
services=("nginx" "ssh" "docker")

# Validate input
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

process_name=$1
found=false

# Check if process is in services array
for service in "${services[@]}"; do
    if [[ "$service" == "$process_name" ]]; then
        found=true
        break
    fi
done

if [[ "$found" = false ]]; then
    echo "Error: '$process_name' is not in monitored services."
    exit 1
fi

# Check if process is running
if pgrep -x "$process_name" > /dev/null; then
    echo "$process_name is Running"
    echo "$(date): $process_name - Running" >> "$LOG_FILE"
else
    echo "$process_name is Stopped"
    echo "$(date): $process_name - Stopped" >> "$LOG_FILE"

    # Attempt restart (simulation)
    echo "Attempting to restart $process_name..."

    # Simulated restart (replace with real command if needed)
    sleep 1

    echo "$process_name Restarted"
    echo "$(date): $process_name - Restarted" >> "$LOG_FILE"
fi