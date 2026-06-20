#!/bin/bash

set -euo pipefail

LOG_FILE="logs/process_monitor.log"
mkdir -p logs

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

services=("nginx" "ssh" "docker")

echo "=== PROCESS MONITOR ==="

# Check predefined services
for service in "${services[@]}"; do
    if pgrep "$service" > /dev/null 2>&1; then
        echo "$service: Running"
        log "$service is running"
    else
        echo "$service: Stopped"
        echo "$service: Restarted (simulated)"
        log "$service was stopped - restart attempted"
    fi
done

echo ""

# Optional user input check
read -p "Enter process name to check: " PROC

if [[ -z "$PROC" ]]; then
    echo "No process entered"
    exit 1
fi

if pgrep "$PROC" > /dev/null 2>&1; then
    echo "$PROC is Running"
    log "$PROC is running (user check)"
else
    echo "$PROC is NOT running"
    log "$PROC is not running (user check)"
fi

echo "Done."
