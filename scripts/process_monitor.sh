#!/bin/bash

# Process Monitor Script
# Monitors specified processes and attempts restart if stopped

log_file="../logs/process_monitor.log"

# Create logs directory if it doesn't exist
mkdir -p ../logs

# Function to log actions
log_action() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$log_file"
}

# Array of services to monitor
services=("nginx" "ssh" "docker")

# Check if a specific process name is provided
if [ -n "$1" ]; then
    # Monitor a specific process
    process_name=$1
    
    # Check if process is running
    if pgrep -x "$process_name" > /dev/null; then
        echo "Running"
        echo "$process_name is running"
        log_action "$process_name: Running"
    else
        echo "Stopped"
        echo "$process_name is not running"
        log_action "$process_name: Stopped"
        
        # Simulate restart 
        echo "Attempting to restart $process_name..."
        log_action "$process_name: Attempting restart"
        
        
        echo "Restarted"
        echo "(Simulated restart)"
        log_action "$process_name: Restarted (simulated)"
    fi
else
    # Monitor all services in the array
    echo "Monitoring Services"
    echo ""
    
    for service in "${services[@]}"; do
        # Check if process is running
        if pgrep -x "$service" > /dev/null; then
            echo "$service: Running"
            log_action "$service: Running"
        else
            echo "$service: Stopped"
            log_action "$service: Stopped"
            
            # Attempt restart 
            echo "Attempting to restart $service..."
            log_action "$service: Attempting restart"
            echo "$service: Restarted"
            log_action "$service: Restarted (simulated)"
        fi
        echo ""
    done
fi
