#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

# Default services to monitor
services=("nginx" "ssh" "docker")

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

check_process() {
    local SERVICE="$1"

    if pgrep -x "$SERVICE" > /dev/null 2>&1; then
        echo "$SERVICE: Running"
        log "[$SERVICE] Running"
    else
        echo "$SERVICE: Stopped — attempting restart..."
        log "[$SERVICE] Stopped — attempting restart"

        # Simulate restart based on whether binary exists
        if command -v "$SERVICE" > /dev/null 2>&1; then
            echo "$SERVICE: Restarted (simulated)"
            log "[$SERVICE] Restarted (simulated)"
        else
            echo "$SERVICE: Restart failed — binary not found"
            log "[$SERVICE] Restart failed — binary not found"
        fi
    fi
}

echo "Process Monitor — $(date '+%Y-%m-%d %H:%M:%S')"
log "Monitor run started"

if (( $# >= 1 )); then
    check_process "$1"
else
    for svc in "${services[@]}"; do
        check_process "$svc"
    done
fi

log "Monitor run complete"
echo "Log saved to: $LOG_FILE"
