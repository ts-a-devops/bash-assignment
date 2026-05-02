#!/bin/bash

# process_monitor.sh - Process monitoring and restart script (Optional Bonus)
# Monitors running processes and attempts restart if stopped
# Uses an array to manage services

set -euo pipefail

LOG_FILE="logs/process_monitor.log"

# Initialize log file
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to display usage
show_usage() {
    echo "Usage: $0 <process_name>"
    echo ""
    echo "Examples:"
    echo "  $0 nginx"
    echo "  $0 sshd"
    echo "  $0 docker"
    echo ""
    echo "Predefined services to monitor: nginx, ssh, docker"
    echo ""
}

# Array of default services
declare -a services=("nginx" "ssh" "docker")

log_message "=== Process Monitor Started ==="

# Check if process name is provided
if [[ $# -lt 1 ]]; then
    echo "Error: No process name provided"
    show_usage
    
    echo "Monitoring all default services..."
    echo ""
    
    # Monitor all default services
    for service in "${services[@]}"; do
        log_message "Checking service: $service"
        
        if pgrep -f "$service" > /dev/null 2>&1; then
            log_message "  Status: Running"
            echo "✓ $service: Running"
        else
            log_message "  Status: Stopped - Attempting restart"
            echo "⚠️  $service: Stopped - Attempting restart..."
            
            # Simulate restart (actual restart would require sudo/permissions)
            log_message "  Simulating restart for: $service"
            echo "  [SIMULATED] systemctl restart $service"
            echo "✓ $service: Restarted (simulated)"
        fi
        echo ""
    done
    
    log_message "=== Process Monitor Completed ==="
    exit 0
fi

PROCESS_NAME="$1"

log_message "Monitoring process: $PROCESS_NAME"

# Check if process is running
if pgrep -f "$PROCESS_NAME" > /dev/null 2>&1; then
    log_message "Status: Running"
    echo "================================"
    echo "Process: $PROCESS_NAME"
    echo "Status: ✓ Running"
    echo "================================"
    
    # Show process details
    echo ""
    echo "Process Details:"
    pgrep -a -f "$PROCESS_NAME" | head -5
    
else
    log_message "Status: Stopped - Attempting restart"
    echo "================================"
    echo "Process: $PROCESS_NAME"
    echo "Status: ⚠️  Stopped"
    echo "================================"
    echo ""
    echo "Attempting to restart..."
    
    # Simulate restart (actual restart would require sudo/permissions)
    echo "Simulating restart command:"
    echo "  systemctl restart $PROCESS_NAME"
    
    log_message "Simulated restart: systemctl restart $PROCESS_NAME"
    
    # Check if systemctl command exists
    if command -v systemctl &> /dev/null; then
        echo ""
        echo "Note: Restart requires sudo permissions"
        echo "To actually restart, run:"
        echo "  sudo systemctl restart $PROCESS_NAME"
    fi
    
    echo ""
    echo "Status: ✓ Restarted (simulated)"
    log_message "Status: Restarted (simulated)"
fi

log_message "=== Process Monitor Completed ==="

exit 0
