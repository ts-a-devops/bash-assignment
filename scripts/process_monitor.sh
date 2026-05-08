#!/bin/bash

# Services array
services=("nginx" "ssh" "docker")

# Log setup
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if process name is provided
if [ -z "${1:-}" ]; then
    echo "Error: Please provide a process name."
    echo "Usage: ./process_monitor.sh <service_name>"
    log_action "CHECK failed - No process name provided"
    exit 1
fi

PROCESS_NAME="$1"

# Validate process is in services array
if [[ ! " ${services[@]} " =~ " ${PROCESS_NAME} " ]]; then
    echo "Error: '$PROCESS_NAME' is not monitored."
    echo "Available services: ${services[*]}"
    log_action "CHECK failed - '$PROCESS_NAME' not in monitored services"
    exit 1
fi

# Check if process is running
if pgrep -x "$PROCESS_NAME" > /dev/null
then
    echo "running"
    log_action "Process '$PROCESS_NAME' is running"
else
    echo "stopped"
    log_action "Process '$PROCESS_NAME' is stopped"

    # Simulated restart
    echo "restarted"
    log_action "Process '$PROCESS_NAME' restarted (simulated)"

    # Optional real restart command
    # sudo systemctl restart "$PROCESS_NAME"
fi

exit 0
