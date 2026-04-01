#!/bin/bash
# process_monitor.sh - Monitors services and attempts restart if not running (Bonus)

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/process_monitor.log"

# Services to monitor
services=("nginx" "ssh" "docker")

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

echo "==============================="
echo "      PROCESS MONITOR          "
echo "==============================="
echo ""

check_service() {
    local SERVICE=$1

    if pgrep -x "$SERVICE" > /dev/null 2>&1; then
        echo "✅ [$SERVICE] → RUNNING"
        log_action "[$SERVICE] STATUS: Running"
    else
        echo "❌ [$SERVICE] → STOPPED"
        log_action "[$SERVICE] STATUS: Stopped — attempting restart..."

        # Attempt restart (simulate if systemctl not available)
        if command -v systemctl &>/dev/null; then
            systemctl restart "$SERVICE" 2>/dev/null
            if pgrep -x "$SERVICE" > /dev/null 2>&1; then
                echo "   🔄 [$SERVICE] → RESTARTED successfully."
                log_action "[$SERVICE] RESTARTED successfully."
            else
                echo "   ⚠️  [$SERVICE] → Could not restart. May need manual intervention."
                log_action "[$SERVICE] RESTART FAILED."
            fi
        else
            echo "   🔄 [$SERVICE] → Restart simulated (systemctl not available)."
            log_action "[$SERVICE] RESTART SIMULATED (no systemctl)."
        fi
    fi
    echo ""
}

# Accept a process name as input OR monitor all services in array
if [[ -n "$1" ]]; then
    echo "Checking single process: $1"
    echo ""
    check_service "$1"
else
    echo "Checking all monitored services..."
    echo ""
    for SERVICE in "${services[@]}"; do
        check_service "$SERVICE"
    done
fi

echo "Monitoring log saved to: $LOG_FILE"
