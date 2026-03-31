#!/bin/bash

mkdir -p ../logs
LOG_FILE="../logs/process_monitor.log"

services=("nginx" "ssh" "docker")
process_name="$1"

if [[ -z "$process_name" ]]; then
    echo "Usage: ./process_monitor.sh <process_name>" | tee -a "$LOG_FILE"
    exit 1
fi

if pgrep "$process_name" > /dev/null; then
    echo "Running" | tee -a "$LOG_FILE"
else
    echo "Stopped" | tee -a "$LOG_FILE"
    echo "Restarted" | tee -a "$LOG_FILE"
fi
