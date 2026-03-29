#!/bin/bash

# Create logs directory
mkdir -p logs
log_file="logs/process_monitor.log"

# Define services array
services=("nginx" "ssh" "docker")

# Function to log messages
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Check if process name is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

process_name="$1"

# Check if process is in predefined services
if [[ ! " ${services[@]} " =~ " ${process_name} " ]]; then
    echo "Warning: $process_name is not in monitored services list."
fi

# Check if process is running
if pgrep -x "$process_name" > /dev/null; then
    echo "$process_name: Running"
    log_action "$process_name - RUNNING"
else
    echo "$process_name: Stopped"
    log_action "$process_name - STOPPED"

    # Attempt restart (simulate restart)
    echo "Attempting to restart $process_name..."

    # Simulated restart (replace with real command if needed)
    sleep 2
    echo "$process_name: Restarted"
    log_action "$process_name - RESTARTED"
fi