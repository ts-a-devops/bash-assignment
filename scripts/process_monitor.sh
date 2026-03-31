#!/bin/bash

set -euo pipefail

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/process_monitor.log"

# Services array
services=("nginx" "ssh" "docker")

# Logging function
log_action() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

#Thi step checks input and ensures user provides a service
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <service_name>"
    exit 1
fi

SERVICE="$1" #stores input in a meaninful variable

#Validate service is in allowed list
VALID=false
for svc in "${services[@]}"; do
    if [[ "$svc" == "$SERVICE" ]]; then
        VALID=true
        break
    fi
done

if [[ "$VALID" = false ]]; then
    echo "Error: Service '$SERVICE' is not supported."
    log_action "$SERVICE - INVALID SERVICE"
    exit 1
fi

# Check if process is running
if pgrep -x "$SERVICE" > /dev/null; then
    echo "Running"
    log_action "$SERVICE - RUNNING"
else
    echo "Stopped"
    log_action "$SERVICE - STOPPED"


    echo "Restarted"
    log_action "$SERVICE - RESTARTED"
fi
