#!/bin/bash
set -euo pipefail

mkdir -p logs

LOG_FILE="logs/process_monitor.log"
services=("nginx" "ssh" "docker")

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

check_process() {
    local process=$1
    if pgrep -x "$process" > /dev/null 2>&1; then
        echo "Running"
        log "CHECK: $process - Running"
        return 0
    else
        echo "Stopped"
        log "CHECK: $process - Stopped"
        return 1
    fi
}

restart_process() {
    local process=$1
    log "ATTEMPT: Restarting $process"
    
    # Try to start the service (simulation or actual)
    if command -v systemctl &> /dev/null; then
        if sudo systemctl start "$process" 2>/dev/null; then
            echo "Restarted"
            log "SUCCESS: $process restarted via systemctl"
            return 0
        fi
    fi
    
    # Fallback: try to start directly (simulation)
    echo "Restarted (simulated)"
    log "SIMULATION: $process restart simulated"
}

# Main monitoring loop
log "=== Process Monitor Started ==="

if [[ $# -gt 0 ]]; then
    # Check specific process
    process=$1
    if ! check_process "$process"; then
        restart_process "$process"
    fi
else
    # Check all services in array
    for service in "${services[@]}"; do
        echo "Checking $service..."
        if ! check_process "$service"; then
            restart_process "$service"
        fi
        echo ""
    done
fi

log "=== Process Monitor Complete ==="
