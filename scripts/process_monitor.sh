#!/bin/bash

# ─── Configuration ───────────────────────────────────────────
LOG_FILE="$(dirname "$0")/../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

# ─── Logging Function ────────────────────────────────────────
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ─── Validate Input ──────────────────────────────────────────
if [ $# -eq 0 ]; then
    log_message "ERROR: No process name provided"
    echo "Usage: ./process_monitor.sh <process_name>"
    echo "Known services: ${services[*]}"
    exit 1
fi

PROCESS_NAME="$1"

# ─── Check if process is in services array ───────────────────
is_known_service() {
    for service in "${services[@]}"; do
        if [ "$service" == "$PROCESS_NAME" ]; then
            return 0
        fi
    done
    return 1
}

# ─── Simulate Restart ────────────────────────────────────────
restart_process() {
    log_message "Attempting to restart '$PROCESS_NAME'..."
    sleep 1
    log_message "RESTARTED: '$PROCESS_NAME' has been restarted successfully"
    echo "Status: Restarted"
}

# ─── Check Process Status ────────────────────────────────────
mkdir -p "$(dirname "$LOG_FILE")"

log_message "Checking status of '$PROCESS_NAME'"

if pgrep -x "$PROCESS_NAME" > /dev/null 2>&1; then
    log_message "RUNNING: '$PROCESS_NAME' is currently running"
    echo "Status: Running"
else
    log_message "STOPPED: '$PROCESS_NAME' is not running"
    echo "Status: Stopped"

    if is_known_service; then
        restart_process
    else
        log_message "INFO: '$PROCESS_NAME' is not in the known services list — skipping restart"
        echo "Info: '$PROCESS_NAME' is not a monitored service. No restart attempted."
    fi
fi

# ─── Monitor All Known Services ──────────────────────────────
echo ""
echo "─── Monitoring All Known Services ───"
log_message "--- Scanning all known services ---"

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null 2>&1; then
        log_message "RUNNING: $service"
        echo "$service → Running"
    else
        log_message "STOPPED: $service"
        echo "$service → Stopped"
    fi
done
