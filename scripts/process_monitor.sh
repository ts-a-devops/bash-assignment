#!/bin/bash
# --------------------------------------------------------------------------
# Script: process_monitor.sh
# Description: Accepts a process name. Checks if it's running.
#              Simulates a restart if it's stopped. Logs everything.
# --------------------------------------------------------------------------

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/process_monitor.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ensure user provided a service to check
TARGET_SERVICE="$1"
if [ -z "$TARGET_SERVICE" ]; then
    echo "Usage: ./process_monitor.sh <service-name>"
    echo "Example: ./process_monitor.sh nginx"
    log_action "[ERROR] Process monitor ran without service parameter."
    exit 1
fi

echo "=== Process Monitor: $TARGET_SERVICE ==="

# Define an array of known services (as required by assignment)
# You can loop over these with `for s in "${services[@]}"; do ... done`
services=("nginx" "ssh" "docker" "apache2" "mysql")

# Check if the process is running using `pgrep`
# The `-x` flag looks for an exact match of the process name
# The `> /dev/null` hides the output PID so our console looks clean
if pgrep -x "$TARGET_SERVICE" > /dev/null; then
    echo "Status: Running 🟢"
    log_action "[INFO] Service '$TARGET_SERVICE' is Running."
else
    echo "Status: Stopped 🔴"
    log_action "[WARNING] Service '$TARGET_SERVICE' is Stopped."
    
    echo "Attempting to restart '$TARGET_SERVICE'..."
    
    # Simulate a restart (Beginner Friendly, avoids sudo prompts!)
    sleep 1
    echo "Status: Restarted 🔄 (Simulated)"
    log_action "[INFO] Service '$TARGET_SERVICE' was Simulated Restarted."
    
    # NOTE: To perform a REAL restart, you would replace the above two lines with:
    # sudo systemctl restart "$TARGET_SERVICE"
    # if systemctl is-active --quiet "$TARGET_SERVICE"; then
    #     echo "Status: Restarted 🟢"
    # else
    #     echo "Status: Failed to restart ❌"
    # fi
fi
