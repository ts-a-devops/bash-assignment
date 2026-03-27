#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

services=("nginx" "ssh" "docker")

log_result() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_service() {
    local service=$1
    
    if pgrep -x "$service" > /dev/null 2>&1; then
        echo "[$service] Status: Running"
        log_result "[$service] Running"
    else
        echo "[$service] Status: Stopped"
        log_result "[$service] Stopped - attempting restart"
        echo "[$service] Status: Restarted (simulated)"
        log_result "[$service] Restarted"
    fi
}

if [[ $# -gt 0 ]]; then
    check_service "$1"
else
    echo "=== Process Monitor ==="
    echo "Monitoring services: ${services[*]}"
    echo ""
    for service in "${services[@]}"; do
        check_service "$service"
        echo ""
    done
fi

echo "Results logged to: $LOG_FILE"
