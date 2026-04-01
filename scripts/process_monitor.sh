#!/bin/bash

mkdir -p logs

LOG_FILE="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

if [[ -z "$1" ]]; then
    echo "Usage: $0 <process_name>"
    echo "Available services: ${services[*]}"
    exit 1
fi

PROCESS_NAME="$1"

if [[ ! " ${services[@]} " =~ " ${PROCESS_NAME} " ]]; then
    log "WARNING: '$PROCESS_NAME' is not in monitored services list (${services[*]})"
fi

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "Running"
    log "STATUS: $PROCESS_NAME is running."
else
    echo "Stopped"
    log "STATUS: $PROCESS_NAME is stopped."

    # Attempt restart (simulation)
    echo "Attempting restart..."

    # Simulated restart (replace with real command if needed)
    sleep 1

    echo "Restarted"
    log "ACTION: $PROCESS_NAME restart attempted (simulated)."
fi
