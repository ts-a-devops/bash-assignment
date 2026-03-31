#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/.."

# First argument is LOG_DIR (passed from run_all.sh), remaining args are process names
if [[ $# -ge 1 && -d "$1" ]]; then
    LOG_DIR="$1"
    shift
else
    LOG_DIR="$BASE_DIR/logs"
fi

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/process_monitor.log"

# Default services
default_services=("nginx" "ssh" "docker")

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

check_process() {
    local service=$1
    if pgrep -x "$service" > /dev/null; then
        echo "$service is running"
        log "$service is running"
    else
        echo "$service is NOT running. Attempting restart..."
        log "$service is not running"

        if command -v systemctl &>/dev/null; then
            if sudo systemctl restart "$service" 2>/dev/null; then
                echo "$service restarted successfully"
                log "$service restarted successfully"
            else
                echo "Failed to restart $service"
                log "Failed to restart $service"
            fi
        else
            echo "systemctl not available. Simulating restart."
            log "Simulated restart of $service"
        fi
    fi
}

# If args were passed (from run_all.sh), use them directly — skip prompt
if [[ $# -gt 0 ]]; then
    services=("$@")
else
    # Interactive mode — ask the user
    echo "Available processes: nginx, ssh, docker"
    echo "Enter process name(s) to monitor (space separated), or press Enter to monitor all:"
    read -p "> " input

    if [[ -z "$input" ]]; then
        services=("${default_services[@]}")
        echo "Monitoring all default services: ${services[*]}"
    else
        read -a services <<< "$input"

        # Validate each entered process against the allowed list
        valid_services=()
        for s in "${services[@]}"; do
            if [[ " ${default_services[*]} " == *" $s "* ]]; then
                valid_services+=("$s")
            else
                echo "Warning: '$s' is not in the allowed list (nginx, ssh, docker) — skipping."
            fi
        done

        if [[ ${#valid_services[@]} -eq 0 ]]; then
            echo "No valid services entered. Monitoring all defaults."
            services=("${default_services[@]}")
        else
            services=("${valid_services[@]}")
        fi
    fi
fi

for svc in "${services[@]}"; do
    check_process "$svc"
done
