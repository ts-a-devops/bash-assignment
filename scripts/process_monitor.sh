#!/bin/bash

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Predefined services array
services=("nginx" "ssh" "docker")

# Input process name
PROCESS_NAME=$1

# Validate input
if [[ -z "$PROCESS_NAME" ]]; then
    echo "Error: Please provide a process name."
    echo "Available services: ${services[*]}"
    exit 1
fi

# Check if process is in allowed services
if [[ ! " ${services[@]} " =~ " ${PROCESS_NAME} " ]]; then
    echo "Error: Process not in monitored services list."
    echo "Allowed: ${services[*]}"
    exit 1
fi

# Function to log messages
log_action() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Check if process is running
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "Running"
    log_action "$PROCESS_NAME is RUNNING"
else
    echo "Stopped"
    log_action "$PROCESS_NAME is STOPPED"

    # Attempt restart (simulation for portability)
    echo "Restarting $PROCESS_NAME..."
    
    # Simulated restart (replace with real command if needed)
    # Example real restart (Linux):
    # sudo systemctl restart $PROCESS_NAME

    sleep 2
    echo "Restarted"
    log_action "$PROCESS_NAME RESTARTED (simulated)"
fi
