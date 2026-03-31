#!/bin/bash

LOG_FILE="logs/process_monitor.log"
mkdir -p logs

services=("nginx" "ssh" "docker")

process=$1

if [[ -z "$process" ]]; then
    echo "Provide a process name." | tee -a "$LOG_FILE"
    exit 1
fi

if pgrep -x "$process" > /dev/null; then
    echo "$process is Running" | tee -a "$LOG_FILE"
else
    echo "$process is Stopped. Attempting restart..." | tee -a "$LOG_FILE"

    # Simulated restart
    if [[ " ${services[@]} " =~ " ${process} " ]]; then
        echo "$process Restarted" | tee -a "$LOG_FILE"
    else
        echo "Service not recognized." | tee -a "$LOG_FILE"
    fi
fi
