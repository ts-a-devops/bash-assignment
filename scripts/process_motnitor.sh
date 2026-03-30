#!/bin/bash

# 1. Setup
LOG="../logs/process_monitor.log"
SERVICES=("nginx" "ssh" "docker")

# Ensure the log directory exists
mkdir -p "$(dirname "$LOG")"

# 2. Define a simple "Check" function
check_service() {
    local name=$1
    
    # pgrep -x looks for the exact process name
    if pgrep -x "$name" > /dev/null; then
        echo "[$(date +%T)] $name: Running" >> "$LOG"
    else
        echo "[$(date +%T)] $name: Stopped. Restarting..." >> "$LOG"
        # Simulate restart logic here
        echo "[$(date +%T)] $name: Fixed" >> "$LOG"
    fi
}

# 3. Run the check for every service in our list
for s in "${SERVICES[@]}"; do
    check_service "$s"
done

echo "Monitoring check complete. See $LOG for details."