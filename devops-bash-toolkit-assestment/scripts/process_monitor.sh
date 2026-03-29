#!/bin/bash

#Logs folder
mkdir -p ../logs
LOG_FILE="../logs/process_monitor.log"

# Array of services to monitor
services=("nginx" "ssh" "docker")

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Function to check a process
check_process() {
    local service=$1
    if pgrep -x "$service" > /dev/null; then
        echo "$service is running"
        log "$service is running"
    else
        echo "$service is NOT running. Attempting restart..."
        log "$service is not running"
        
        # Try to restart (simulated)
        if command -v systemctl &>/dev/null; then
            sudo systemctl restart "$service" && \
            echo "$service restarted" && log "$service restarted" || \
            echo "Failed to restart $service" && log "Failed to restart $service"
        else
            echo "Systemctl not available. Simulating restart."
            log "Simulated restart of $service"
        fi
    fi
}

# If user provided a process name, monitor that; otherwise, monitor all
if [[ $# -gt 0 ]]; then
    services=("$@")
fi

for svc in "${services[@]}"; do
    check_process "$svc"
done

