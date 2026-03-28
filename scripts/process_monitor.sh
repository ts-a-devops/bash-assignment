#!/bin/bash
# process_monitor.sh - Monitor and (simulate) restart processes

set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <process_name>"
    echo "Or run without args to monitor default services."
    exit 1
fi

PROCESS=$1
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/process_monitor.log"
mkdir -p "$LOG_DIR"

log_monitor() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if process is running
if pgrep -x "$PROCESS" > /dev/null; then
    echo "$PROCESS is Running"
    log_monitor "$PROCESS is Running"
else
    echo "$PROCESS is Stopped"
    log_monitor "$PROCESS is Stopped - Attempting restart (simulation)"
    
    # Simulate restart (in real scenario: systemctl restart or similar)
    echo "Simulated restart of $PROCESS"
    log_monitor "Simulated restart of $PROCESS"
    
    echo "$PROCESS has been Restarted (simulation)"
fi

# Bonus: Monitor default services array if no arg or special flag
if [[ "$PROCESS" == "all" ]]; then
    services=("nginx" "ssh" "docker")
    for svc in "${services[@]}"; do
        echo "=== Checking $svc ==="
        if pgrep -x "$svc" > /dev/null || systemctl is-active --quiet "$svc" 2>/dev/null; then
            echo "$svc: Running"
        else
            echo "$svc: Stopped (simulation restart)"
        fi
    done
fi
