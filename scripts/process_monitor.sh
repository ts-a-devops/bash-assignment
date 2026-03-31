#!/bin/bash

LOG_FILE="logs/process_monitor.log"
services=("nginx" "ssh" "docker")

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null; then
        echo "$service is Running"
        echo "$(date): $service running" >> "$LOG_FILE"
    else
        echo "$service is Stopped. Restarting..."
        echo "$service Restarted"
        echo "$(date): $service restarted" >> "$LOG_FILE"
    fi
done
