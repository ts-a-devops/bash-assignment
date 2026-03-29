#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/process_monitor.log"

services=("nginx" "ssh" "docker")

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null; then
        status="Running"
    else
        status="Stopped - Restarting"
        # Simulate restart
        status="Restarted"
    fi

    echo "$service: $status"
    echo "$(date): $service - $status" >> "$LOG_FILE"
done
