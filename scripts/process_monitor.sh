#!/bin/bash

# Ensure logs directory exists
mkdir -p logs

# Log file path
LOG_FILE="logs/process_monitor.log"

# Get process name from argument
process=$1

# Validate input
if [[ -z "$process" ]]; then
    echo "Provide a process name."
    exit 1
fi

# Example predefined services (requirement)
services=("nginx" "ssh" "docker")

# Check if process is running
if pgrep "$process" > /dev/null; then
    echo "$process is running"
    status="Running"
else
    echo "$process is stopped"
    echo "Attempting restart..."
    # Restart is simulated here
    status="Restarted (simulated)"
fi

# Log result
echo "$(date): $process - $status" >> "$LOG_FILE"
