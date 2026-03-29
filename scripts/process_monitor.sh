#!/bin/bash

LOG_FILE="logs/process_monitor.log"
mkdir -p logs

# Predefined services
services=("nginx" "ssh" "docker")

# Check input
if [ -z "$1" ]; then
    echo "Usage: ./process_monitor.sh <process_name>"
    exit 1
fi

process=$1

# Check if process is in allowed services
found=false
for svc in "${services[@]}"; do
    if [ "$svc" == "$process" ]; then
        found=true
        break
    fi
done

if [ "$found" = false ]; then
    echo "Process not monitored. Allowed: ${services[*]}"
    exit 1
fi

# Check if running
if pgrep "$process" > /dev/null; then
    echo "$process is Running"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $process: RUNNING" >> "$LOG_FILE"
else
    echo "$process is Stopped"

    # Simulate restart
    echo "Restarting $process..."
    sleep 1

    echo "$process Restarted"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $process: STOPPED -> RESTARTED" >> "$LOG_FILE"
fi
