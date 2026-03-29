#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

services=("nginx" "ssh" "docker")

PROCESS=$1

if [[ -z "$PROCESS" ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

if ! [[ " ${services[@]} " =~ " ${PROCESS} " ]]; then
    echo "Process not in monitored list."
    exit 1
fi

if pgrep "$PROCESS" > /dev/null; then
    STATUS="Running"
else
    STATUS="Stopped"
    echo "Attempting restart..."
    # Simulated restart
    STATUS="Restarted"
fi

echo "$PROCESS is $STATUS"
echo "$(date) - $PROCESS: $STATUS" >> "$LOG_FILE"
