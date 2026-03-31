#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
mkdir -p $(dirname "$LOG_FILE")

# Predefined services array
services=("nginx" "ssh" "docker")

# Accept process name as input
PROCESS=$1

# Check if process argument was provided
if [[ -z "$PROCESS" ]]; then
    echo "No process provided. Monitoring default services..."
    echo "Available services: ${services[@]}"
    echo "Usage: ./process_monitor.sh <processname>"
    exit 1
fi

# Check if provided process is in services array
VALID=false
for service in "${services[@]}"; do
    if [[ "$service" == "$PROCESS" ]]; then
        VALID=true
        break
    fi
done

if [[ "$VALID" == false ]]; then
    echo "Error: '$PROCESS' is not in the monitored services list."
    echo "Available services: ${services[@]}"
    exit 1
fi

# Check if process is running
check_process() {
    if pgrep -x "$PROCESS" > /dev/null; then
        echo "$PROCESS is Running"
        echo "$(date): $PROCESS - Running" >> "$LOG_FILE"
        return 0
    else
        echo "$PROCESS is Stopped"
        echo "$(date): $PROCESS - Stopped" >> "$LOG_FILE"
        return 1
    fi
}

# Attempt restart
restart_process() {
    echo "Attempting to restart $PROCESS..."
    if sudo systemctl restart "$PROCESS" 2>/dev/null; then
        echo " $PROCESS restarted successfully"
        echo "$(date): $PROCESS - Restarted successfully" >> "$LOG_FILE"
    else
        # Simulate restart if systemctl fails
        echo "⚠️  Simulating restart of $PROCESS..."
        echo "$(date): $PROCESS - Restart simulated" >> "$LOG_FILE"
    fi
}

# Main logic
echo "=== Process Monitor - $(date) ==="
echo "Checking $PROCESS..."

if ! check_process; then
    restart_process
fi

echo "Done! Log saved to $LOG_FILE"
