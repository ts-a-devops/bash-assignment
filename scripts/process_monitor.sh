#!/bin/bash

# A script to monitor processes and simulate restarts if they are not running.
# Logs monitoring results to logs/process_monitor.log

LOG_FILE="logs/process_monitor.log"
mkdir -p logs

services=("nginx" "ssh" "docker" "cron")

check_process() {
    local service=$1
    if pgrep -x "$service" > /dev/null; then
        echo "Running: $service"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SERVICE: $service, STATUS: Running" >> "$LOG_FILE"
    else
        echo "Stopped: $service"
        echo "Attempting restart for $service..."
        # Simulate restart
        echo "Restarted: $service"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - SERVICE: $service, STATUS: Stopped, ACTION: Restarted" >> "$LOG_FILE"
    fi
}

echo "--- Process Monitoring ---"
for service in "${services[@]}"; do
    check_process "$service"
done
