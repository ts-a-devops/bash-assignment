#!/bin/bash
set -euo pipefail

LOG_FILE="process_monitor.log"

# -------------------------
# Default services array
# -------------------------
services=("nginx" "sshd" "dockered")

# -------------------------
# Accept process name input
# -------------------------
if [ $# -ge 1 ]; then
    services=("$@")   # override with user input
fi

# -------------------------
# Function to check process
# -------------------------
check_process() {
    local service="$1"

    if pgrep -x "$service" >/dev/null 2>&1; then
        echo "$service: Running"
        echo "$(date) - $service: Running" >> "$LOG_FILE"
    else
        echo "$service: Stopped"
        echo "$(date) - $service: Stopped" >> "$LOG_FILE"

        # Attempt restart (simulate or real)
        echo "Attempting to restart $service..."

        if command -v systemctl >/dev/null 2>&1; then
            sudo systemctl restart "$service" 2>/dev/null || true
        else
            echo "(Simulated restart for $service)"
        fi

        # Check again
        if pgrep -x "$service" >/dev/null 2>&1; then
            echo "$service: Restarted"
            echo "$(date) - $service: Restarted" >> "$LOG_FILE"
        else
            echo "$service: Failed to restart"
            echo "$(date) - $service: Failed to restart" >> "$LOG_FILE"
        fi
    fi
}

# -------------------------
# Loop through services
# -------------------------
for svc in "${services[@]}"; do
    check_process "$svc"
done
