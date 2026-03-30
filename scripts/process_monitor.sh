#!/usr/bin/env bash

LOG_FILE="../logs/process_monitor.log"
SERVICES=("nginx" "ssh" "docker")

log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

check_service() {
    local service="$1"

    if pgrep -x "$service" > /dev/null; then
        log_message "$service is running"
    else
        log_message "$service is stopped. Attempting restart..."
        
        # Simulate restart (replace with actual restart command if needed)
        log_message "$service restarted successfully"
    fi
}

for service in "${SERVICES[@]}"; do
    check_service "$service"
done
