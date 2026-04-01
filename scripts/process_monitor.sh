#!/bin/bash
LOG_FILE="logs/process_monitor.log"
mkdir -p logs

# The list of real services to monitor
services=("ssh" "docker" "nginx")

monitor_process() {
    local PROCESS=$1
    
    # Check if the process is active using systemctl
    if systemctl is-active --quiet "$PROCESS"; then
        echo "[$(date)] $PROCESS: Running" | tee -a "$LOG_FILE"
    else
        echo "[$(date)] $PROCESS: Stopped. Attempting real restart..." | tee -a "$LOG_FILE"
        
        # REAL ACTION: Attempt to start the service
        # Note: This usually requires 'sudo' permissions
        sudo systemctl start "$PROCESS"
        
        # Verify if the restart worked
        if systemctl is-active --quiet "$PROCESS"; then
            echo "[$(date)] $PROCESS: Successfully Restarted" | tee -a "$LOG_FILE"
        else
            echo "[$(date)] $PROCESS: Restart FAILED" | tee -a "$LOG_FILE"
        fi
    fi
}

# Loop through the array
for s in "${services[@]}"; do
    monitor_process "$s"
done
