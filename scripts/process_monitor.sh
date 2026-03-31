#!/bin/bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"

# Array of services to monitor
services=("nginx" "ssh" "docker")

check_process() {
    local service=$1
    if pgrep -x "$service" > /dev/null; then
        echo "$service is Running" | tee -a "$LOG_FILE"
    else
        echo "$service is Stopped" | tee -a "$LOG_FILE"
        echo "Attempting to restart $service..." | tee -a "$LOG_FILE"
        sleep 1  # simulate restart
        echo "$service Restarted" | tee -a "$LOG_FILE"
    fi
}

for svc in "${services[@]}"; do
    check_process "$svc"
done
