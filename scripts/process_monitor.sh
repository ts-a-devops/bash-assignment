#!/bin/bash

# Create logs folder
mkdir logs 2>/dev/null

LOG_FILE="logs/process_monitor.log"

# Define services
services=("nginx" "ssh" "docker")

# Get process name from user
process=$1

# Check if input is provided
if [ -z "$process" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

# Check if process is in allowed services list
found=false
for svc in "${services[@]}"
do
    if [ "$svc" = "$process" ]; then
        found=true
    fi
done

if [ "$found" = false ]; then
    echo "Error: Process not in monitored services list."
    echo "Available: ${services[@]}"
    exit 1
fi

# Check if process is running
if ps aux | grep "$process" | grep -v grep > /dev/null
then
    echo "$process is Running"
    echo "$(date): $process is Running" >> "$LOG_FILE"
else
    echo "$process is Stopped"
    echo "$(date): $process is Stopped" >> "$LOG_FILE"

    # Simulate restart
    echo "Attempting to restart $process..."

    # Real restart (may require sudo)
    # sudo systemctl restart $process

    echo "$process Restarted"
    echo "$(date): $process Restarted" >> "$LOG_FILE"
fi