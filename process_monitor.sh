#!/bin/bash

# This script monitors a process and checks if it is running or stopped

LOG_FILE="logs/process_monitor.log"

# ─── SERVICES ARRAY ───────────────────────────────────────────
# This is the list of known services the script can monitor
services=("nginx" "ssh" "docker")

# ─── VALIDATE INPUT ───────────────────────────────────────────
# Check if the user provided a process name
if [[ -z "$1" ]]; then
    echo "Error: Please provide a process name."
    echo "Usage: ./process_monitor.sh <process_name>"
    echo ""
    echo "Known services: ${services[@]}"
    exit 1
fi

PROCESS=$1  # The process name the user wants to monitor

# ─── CHECK IF PROCESS IS IN THE SERVICES ARRAY ────────────────
# Loop through the services array to see if the input matches
FOUND=false

for service in "${services[@]}"; do
    if [[ "$service" == "$PROCESS" ]]; then
        FOUND=true
        break  # Stop looping once we find a match
    fi
done

# Warn the user if the process is not in the known services list
if [[ "$FOUND" == false ]]; then
    echo "Warning: '$PROCESS' is not in the known services list."
    echo "Known services: ${services[@]}"
    echo ""
fi

# ─── CHECK IF PROCESS IS RUNNING ──────────────────────────────
# pgrep searches for a running process by name
# -x means match the exact process name
# We send the output to /dev/null as we only need the exit status

echo "Checking process: $PROCESS"
echo ""

if pgrep -x "$PROCESS" > /dev/null; then

    # Process is running
    echo "Status: Running"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS - Running" >> "$LOG_FILE"

else

    # Process is NOT running
    echo "Status: Stopped"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS - Stopped" >> "$LOG_FILE"

    # ─── ATTEMPT RESTART ──────────────────────────────────────
    echo "Attempting to restart '$PROCESS'..."

    # Try to restart the process using systemctl
    # 2>/dev/null suppresses any error if systemctl is not available
    systemctl start "$PROCESS" 2>/dev/null

    # Check if the restart was successful by searching for the process again
    if pgrep -x "$PROCESS" > /dev/null; then
        echo "Status: Restarted successfully"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS - Restarted successfully" >> "$LOG_FILE"
    else
        # Simulate a restart if systemctl did not work
        echo "Status: Restarted (simulated — '$PROCESS' could not be started with systemctl)"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS - Restarted (simulated)" >> "$LOG_FILE"
    fi

fi

# ─── DONE ─────────────────────────────────────────────────────
echo ""
echo "Monitoring complete. Results saved to: $LOG_FILE"
