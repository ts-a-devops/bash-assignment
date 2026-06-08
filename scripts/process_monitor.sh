#!/bin/bash
# process_monitor.sh - Monitor and restart services
# Written by Dave Woks

set -uo pipefail

mkdir -p ~/bash-assignment/logs
LOGFILE=~/bash-assignment/logs/process_monitor.log

log_action() {
    echo "[$(date +%F\ %T)] $1" >> "$LOGFILE"
}

# --- Services to monitor ---
services=("nginx" "ssh" "cron")

echo "--- Process Monitor: $(date) ---"
echo ""

for SERVICE in "${services[@]}"; do
    if systemctl is-active --quiet "$SERVICE"; then
        echo "$SERVICE: Running"
        log_action "$SERVICE: Running"
    else
        echo "$SERVICE: Stopped. Attempting restart..."
        log_action "$SERVICE: Stopped. Attempting restart."
        sudo systemctl restart "$SERVICE" 2>/dev/null && \
            echo "$SERVICE: Restarted successfully." && \
            log_action "$SERVICE: Restarted successfully." || \
            echo "$SERVICE: Restart failed." && \
            log_action "$SERVICE: Restart failed."
    fi
done

echo ""
echo "Monitoring complete. Log saved to: $LOGFILE"
