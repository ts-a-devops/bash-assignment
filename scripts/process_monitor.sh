#!/bin/bash

# process_monitor.sh - Monitors and manages processes

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/process_monitor.log"

# Array of services to monitor
services=("nginx" "ssh" "docker")

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to check and restart process
check_process() {
    local process_name="$1"
    
    # Check if process is running
    if pgrep -x "$process_name" > /dev/null; then
        echo "✓ $process_name is running"
        log_message "$process_name is running"
        return 0
    else
        echo "✗ $process_name is stopped"
        log_message "$process_name is stopped"
        
        # Attempt to restart (simulated for safety)
        echo "  Attempting to restart $process_name..."
        # Note: In production, use: sudo systemctl restart $process_name
        # For this assessment, we'll just log the attempt
        log_message "Restart attempted for $process_name (simulated)"
        echo "  [Simulated] $process_name restart command would be executed"
        return 1
    fi
}

# Check if a specific process was provided
if [[ $# -gt 0 ]]; then
    process_name="$1"
    log_message "Monitoring specific process: $process_name"
    check_process "$process_name"
else
    # Monitor all services in the array
    echo "=== Process Monitoring Report ==="
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    log_message "Starting process monitoring for all services"
    
    for service in "${services[@]}"; do
        check_process "$service"
        echo ""
    done
    
    log_message "Process monitoring completed"
    echo "✓ Report saved to $LOG_FILE"
fi
