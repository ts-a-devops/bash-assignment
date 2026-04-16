#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/service_monitor.log"

mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

# Define service portfolio (operational baseline)
services=("nginx" "ssh" "docker")

check_and_handle_service() {
    local service=$1

    if [[ -z "$service" ]]; then
        echo "No service provided"
        return 1
    fi

    # Check if process is running
    if pgrep -x "$service" > /dev/null; then
        echo "$service: Running"
        log_action "$service STATUS - RUNNING"
    else
        echo "$service: Stopped"
        log_action "$service STATUS - STOPPED"

        # Simulated restart logic
        echo "$service: Restarting..."
        log_action "$service ACTION - RESTART INITIATED"

        # Attempt real restart if systemctl exists, otherwise simulate
        if command -v systemctl >/dev/null 2>&1; then
            systemctl restart "$service" 2>/dev/null
        else
            sleep 1
        fi

        # Re-check status after restart attempt
        if pgrep -x "$service" > /dev/null; then
            echo "$service: Restarted"
            log_action "$service STATUS - RESTARTED SUCCESS"
        else
            echo "$service: Restart simulated (not active)"
            log_action "$service STATUS - RESTART SIMULATED"
        fi
    fi
}

# Execution mode
if [[ -n "$1" ]]; then
    check_and_handle_service "$1"
else
    # Batch monitoring mode
    for svc in "${services[@]}"; do
        check_and_handle_service "$svc"
    done
fi
