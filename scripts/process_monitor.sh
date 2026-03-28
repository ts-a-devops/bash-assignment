#!/bin/bash

services=("nginx" "ssh" "docker")
PROCESS=$1
LOG_FILE="../logs/process_monitor.log"

# Check if input is provided
if [ -z "$PROCESS" ]; then
    echo "Usage: ./process_monitor.sh <process_name>"
    exit 1
fi

# Check if process is in the array
FOUND=false
for service in "${services[@]}"; do
    if [ "$PROCESS" == "$service" ]; then
        FOUND=true
        break
    fi
done

if [ "$FOUND" = false ]; then
    echo "Process not in monitored list"
    exit 1
fi

# Check if process is running
if pgrep -x "$PROCESS" > /dev/null; then
    echo "$PROCESS is Running" | tee -a "$LOG_FILE"
else
    echo "$PROCESS is Stopped" | tee -a "$LOG_FILE"

    # Simulate restart
    echo "Restarting $PROCESS..." | tee -a "$LOG_FILE"
    sleep 1
    echo "$PROCESS Restarted" | tee -a "$LOG_FILE"
fi
