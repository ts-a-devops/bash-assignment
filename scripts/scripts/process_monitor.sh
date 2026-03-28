#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Log file
log_file="logs/process_monitor.log"

# Function to log actions
log_action() {
    echo "$(date): $1" >> "$log_file"
}

# Define monitored services (array)
services=("nginx" "ssh" "docker")

# Function to check a process
check_process() {
    local proc=$1
    if pgrep -x "$proc" > /dev/null; then
        echo "$proc: Running"
        log_action "$proc: Running"
    else
        echo "$proc: Stopped"
        log_action "$proc: Stopped"
        # Simulate restart
        echo "Attempting to restart $proc..."
        log_action "Attempting restart: $proc"
        # Simulated restart (replace with actual restart command if you have privileges)
        # e.g., sudo systemctl restart $proc
        echo "$proc: Restarted"
        log_action "$proc: Restarted"
    fi
}

# If user provides a process name as argument, check only that
if [ ! -z "$1" ]; then
    check_process "$1"
else
    # Otherwise check all services in the array
    for service in "${services[@]}"; do
        check_process "$service"
        echo "------------------------"
    done
fi
