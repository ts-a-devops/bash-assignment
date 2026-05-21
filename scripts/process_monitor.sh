#!/bin/bash

mkdir -p logs

# Services array
services=("nginx" "ssh" "docker")

# Input process
process=$1

if [ -z "$process" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

# Check if process is in allowed services
if [[ ! " ${services[@]} " =~ " ${process} " ]]; then
    echo "Process not in monitored list."
    exit 1
fi

# Check if running
if pgrep -x "$process" > /dev/null; then
    echo "$process is Running"
    echo "$(date): $process is Running" >> logs/process_monitor.log
else
    echo "$process is Stopped"

    # Simulate restart (safe for assignment)
    echo "Restarting $process..."
    sleep 2

    echo "$process Restarted"
    echo "$(date): $process was stopped → Restarted" >> logs/process_monitor.log
fi
