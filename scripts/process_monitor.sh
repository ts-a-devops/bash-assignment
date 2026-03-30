#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

PROCESS="$1"
services=("nginx" "ssh" "docker")

if [ -z "$PROCESS" ]; then
    echo "Usage: ./process_monitor.sh <process_name>"
    exit 1
fi

is_running=$(pgrep "$PROCESS")

if [ -z "$is_running" ]; then
    echo "$PROCESS is Stopped"
    echo "$(date): $PROCESS stopped — attempting restart" >> "$LOG_FILE"

    echo "Restarting $PROCESS..."
    echo "Restarted"
    echo "$(date): Restarted $PROCESS (simulated)" >> "$LOG_FILE"
else
    echo "$PROCESS is Running"
    echo "$(date): $PROCESS is running" >> "$LOG_FILE"
fi
