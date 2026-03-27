#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

# Ensure logs directory exists
mkdir -p "$LOG_DIR"

#services array
services=("nginx" "ssh" "docker")

# Function to log messages
log_messages() {
	echo "$(date '+%Y-%m-%d %H:%M:$S') - $1" >> "LOG_FILE"
}

# Validate input
if [[ $# -lt 1 ]]
then
    echo "warning: $PROCESS_NAME is not in monitored services list"
fi

# Check if process is running
if pgrep -x "$PROCESS_NAME" > /dev/null
then
    echo "$PROCESS_NAME: Running"
    log_message "$PROCESS_NAME is RUNNING"
else
    echo "$PROCESS_NAME: Stopped"
    log_message "$PROCESS_NAME is stopped"

    # Attempt restart (simulation)
    echo "Attempting to restart $PROCESS_NAME..."

# Simulated restart (replace with actual command if needed)
    sleep 1
# Example real restart (optional, commented)
# sudo systemctl restart "$PROCESS_NAME"

    echo "$PROCESS_NAME: Restarted"
    log_message "$PROCESS_NAME was RESTARTED"
fi
