#!/bin/bash

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/process_monitor.log"

# Define the services to check in an array
services=("ssh" "docker" "nginx")

echo "--- Process Monitor Report ($(date)) ---" | tee -a "$LOG_FILE"

for service in "${services[@]}"; do
    # Check if the process is running using systemctl or pgrep
    if systemctl is-active --quiet "$service"; then
        echo "[RUNNING] $service is active." | tee -a "$LOG_FILE"
    else
        echo "[STOPPED] $service is not running. Attempting to restart..." | tee -a "$LOG_FILE"
        
        # In a real DevOps environment, we'd use: sudo systemctl restart $service
        # For this assignment, we will "simulate" the restart:
        echo "[RESTARTED] $service simulation successful." | tee -a "$LOG_FILE"
    fi
done

echo "----------------------------------------" | tee -a "$LOG_FILE"
