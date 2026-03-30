#!/bin/bash

LOG_FILE="logs/process_monitor.log"

# Accept input or use default services
if [[ -n "$1" ]]; then
    services=("$1")
else
    services=("nginx" "ssh" "docker")
fi

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null; then
        status="Running"
    else
        status="Stopped"
        echo "$service is not running. Restarting..."

        # Simulate restart
        sleep 1

        status="Restarted"
    fi

    echo "$service: $status"
    echo "$(date): $service -> $status" >> "$LOG_FILE"
done
