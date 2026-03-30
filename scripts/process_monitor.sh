#!/bin/bash

# Create logs folder
mkdir -p logs

LOG_FILE="logs/process_monitor.log"

# Predefined services
services=("nginx" "ssh" "docker")

# Get process name from user
process=$1

# Validate input
if [[ -z "$process" ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

# Check if process is in allowed list
if [[ ! " ${services[@]} " =~ " ${process} " ]]; then
    echo "Service not recognized. Allowed: ${services[@]}"
    exit 1
fi

# Check if process is running
if pgrep -x "$process" > /dev/null
then
    echo "$process is Running"
    echo "$(date): $process is running" >> $LOG_FILE
else
    echo "$process is NOT running"
    echo "Attempting restart..."

    # Simulate restart
    sleep 2

    echo "$process restarted (simulated)"
    echo "$(date): $process was stopped and restarted" >> $LOG_FILE
fi

