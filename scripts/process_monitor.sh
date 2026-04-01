#!/bin/bash

# Resolve project root (important for correct paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

LOG_FILE="$PROJECT_ROOT/logs/process_monitor.log"

# Ensure logs directory exists
mkdir -p "$PROJECT_ROOT/logs"

# Predefined services
services=("nginx" "ssh" "docker")

process=$1

# Validate input
if [[ -z "$process" ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

# Optional: Check if process is in allowed services
if [[ ! " ${services[@]} " =~ " ${process} " ]]; then
    echo "Warning: $process is not in monitored services list"
fi

# Check if running
if pgrep "$process" > /dev/null; then
    status="Running"
else
    status="Stopped"
    echo "$process is not running."

    # Simulate restart (safe for assignment)
    echo "Attempting to restart $process..."

    # Real restart (optional, may require sudo)
    # sudo systemctl restart "$process"

    status="Restarted"
fi

# Output result
echo "$process: $status"

# Log result
echo "$(date): $process - $status" >> "$LOG_FILE"
