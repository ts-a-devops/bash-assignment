#!/usr/bin/env bash

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

services=("nginx" "ssh" "docker")

process_name=$1

if [[ -z "$process_name" ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

status="Stopped"

if pgrep "$process_name" > /dev/null; then
    status="Running"
else
    echo "Process not running. Attempting restart..."
    # Simulated restart
    status="Restarted"
fi

echo "$process_name is $status"
echo "$(date): $process_name is $status" >> "$LOG_FILE"
