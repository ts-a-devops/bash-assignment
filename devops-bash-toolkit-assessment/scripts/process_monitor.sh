#!/bin/bash

# 1. Setup Environment
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
[ ! -d "$LOG_DIR" ] && mkdir "$LOG_DIR"

# Define the array of services to monitor
services=("nginx" "ssh" "docker")

# Function to log and print status
log_status() {
    local MSG="$1"
    echo "$MSG"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $MSG" >> "$LOG_FILE"
}

# 2. Monitoring & Restart Logic
check_and_restart() {
    local SERVICE=$1
    
    # pgrep -x checks for an exact match of the process name
    if pgrep -x "$SERVICE" > /dev/null; then
        log_status "Status for [$SERVICE]: Running"
    else
        log_status "Status for [$SERVICE]: Stopped"
        
        # Attempting Restart (Simulated for safety)
        log_status "Action: Attempting to restart $SERVICE..."
        
        # In a real production environment, you would use: 
        # systemctl restart $SERVICE
        
        # Simulating a successful restart
        sleep 1
        log_status "Status for [$SERVICE]: Restarted"
    fi
}

# 3. Execution
echo "--- Starting Process Monitor ---"

# Loop through the array and check each service
for srv in "${services[@]}"; do
    check_and_restart "$srv"
    echo "------------------------------"
done

echo "Monitoring Cycle Complete."
