#!/bin/bash
# scripts/process_monitor.sh
LOG_FILE="logs/process_monitor.log"
mkdir -p logs

# Define services to monitor
services=("ssh" "docker" "cron")

echo "--- Process Monitor ($(date)) ---"

for svc in "${services[@]}"; do
    # Check if the process is running
    if pgrep -x "$svc" > /dev/null; then
        status="RUNNING"
        echo "[✔] $svc: $status"
    else
        status="STOPPED"
        echo "[✘] $svc: $status. Attempting simulated restart..."
        # In a real environment, you'd use 'sudo systemctl start $svc'
        echo "$(date): Restarted $svc" >> "$LOG_FILE"
        status="RESTARTED"
        echo "[!] $svc: $status"
    fi
    # Log the result
    echo "$(date): $svc status is $status" >> "$LOG_FILE"
done
