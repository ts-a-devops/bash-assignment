#!/bin/bash

LOG_FILE="logs/process_monitor.log"
PROCESS=$1

services=("nginx" "ssh" "docker")

# Check if process is in monitored list
if [[ ! " ${services[@]} " =~ " $PROCESS " ]]; then
    echo "Process not monitored."
exit 1
fi

# Check if process is running
if pgrep "$PROCESS" > /dev/null; then
    echo "$PROCESS is running"
     echo "$(date): $PROCESS running" >> "$LOG_FILE"
else
   echo "$PROCESS is stopped. Restarting..."
    echo "$(date): $PROCESS restarted" >> "$LOG_FILE"
fi
