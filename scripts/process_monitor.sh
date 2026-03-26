#!/bin/bash

LOG_FILE="logs/process_monitor.log"

# Predefined services
services=("nginx" "ssh" "docker")

# Input
process_name=$1

# Validate input
if [[ -z "$process_name" ]]; then
    echo "Error: Please provide a process name."
    exit 1
fi

# Check if process is in allowed services (optional but good practice)
is_known=false
for svc in "${services[@]}"; do
    if [[ "$svc" == "$process_name" ]]; then
        is_known=true
        break
    fi
done

if [[ "$is_known" == false ]]; then
    echo "Warning: '$process_name' is not in the monitored services list."
fi

# Check if process is running
if pgrep -x "$process_name" > /dev/null; then
    echo "Running"
    echo "$(date): $process_name is RUNNING" >> "$LOG_FILE"
else
    echo "Stopped"
    echo "$(date): $process_name is STOPPED" >> "$LOG_FILE"

    # Simulate restart
    echo "Attempting restart..."
    
    # --- Simulated restart ---
    echo "Restarted"
    echo "$(date): $process_name RESTART ATTEMPTED (simulated)" >> "$LOG_FILE"

    # --- Real restart (optional - comment in if needed) ---
    # sudo systemctl restart "$process_name"
    # if pgrep -x "$process_name" > /dev/null; then
    #     echo "Restarted"
    #     echo "$(date): $process_name RESTARTED successfully" >> "$LOG_FILE"
    # else
    #     echo "Failed to restart"
    #     echo "$(date): ERROR - Failed to restart $process_name" >> "$LOG_FILE"
    # fi
fi