#!/bin/bash

mkdir -p logs

log_file="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

check_process() {
    local process=$1
    if pgrep -x "$process" > /dev/null; then
        echo "$process: Running"
        echo "$(date): $process is Running" >> "$log_file"
    else
        echo "$process: Stopped — attempting restart..."
        sudo service "$process" start 2>/dev/null
        if pgrep -x "$process" > /dev/null; then
            echo "$process: Restarted successfully"
            echo "$(date): $process was Stopped, now Restarted" >> "$log_file"
        else
            echo "$process: Could not restart"
            echo "$(date): $process could not be restarted" >> "$log_file"
        fi
    fi
}

if [[ ! -z "$1" ]]; then
    check_process "$1"
else
    for service in "${services[@]}"; do
        check_process "$service"
    done
fi
