#!/bin/bash
mkdir -p logs
log_file="logs/process_monitor.log"

# Array of standard services
services=("nginx" "ssh" "docker")
input_service=$1

if [ -z "$input_service" ]; then
    echo "Usage: ./scripts/process_monitor.sh <process_name>"
    exit 1
fi

log_action() { echo "$(date): $1" | tee -a "$log_file"; }

if [[ ! " ${services[@]} " =~ " ${input_service} " ]]; then
    log_action "Note: Checking custom non-standard process '$input_service'"
fi

if pgrep -x "$input_service" > /dev/null; then
    log_action "Status: $input_service is Running"
else
    log_action "Status: $input_service is Stopped"
    log_action "Attempting to restart $input_service..."

    # Simulating restart to avoid requiring root/sudo for the assignment
    sleep 1
    log_action "Status: $input_service Restarted (Simulated)"
fi
