#!/bin/bash

set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

LOGFILE="logs/process_monitor.log"

# Function to log actions
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
}

# Predefined services to monitor
SERVICES=("nginx" "ssh" "docker")

usage() {
    cat << EOF
Usage: $0 [process_name]

If no process_name is given, it will check the default services:
${SERVICES[*]}

Example:
  ./process_monitor.sh nginx
  ./process_monitor.sh ssh
EOF
}

# Check if a specific process name was provided
if [ $# -gt 0 ]; then
    PROCESS_NAME="$1"
else
    # If no argument, we'll monitor the default services array
    echo "No specific process provided. Monitoring default services..."
    for service in "${SERVICES[@]}"; do
        echo "Checking service: $service"
        if pgrep -x "$service" > /dev/null; then
            echo "Status: Running"
            log_action "CHECK - $service is Running"
        else
            echo "Status: Stopped"
            log_action "CHECK - $service is Stopped"
            # Simulate restart
            echo "Attempting to restart $service (simulation)..."
            log_action "RESTART ATTEMPT - $service (simulated)"
            echo "Status: Restarted (simulated)"
            log_action "RESTARTED - $service (simulated)"
        fi
        echo "----------------------------------------"
    done
    echo "Monitoring completed. Log saved to: $LOGFILE"
    exit 0
fi

# If a specific process name was provided
echo "Monitoring process: $PROCESS_NAME"

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "Status: Running"
    log_action "CHECK - $PROCESS_NAME is Running"
else
    echo "Status: Stopped"
    log_action "CHECK - $PROCESS_NAME is Stopped"
    
    # Simulate restart
    echo "Attempting to restart $PROCESS_NAME (simulation)..."
    log_action "RESTART ATTEMPT - $PROCESS_NAME (simulated)"
    echo "Status: Restarted (simulated)"
    log_action "RESTARTED - $PROCESS_NAME (simulated)"
fi

echo ""
echo "Process monitoring completed. Log saved to: $LOGFILE"
