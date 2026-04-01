#!/bin/bash

# 1. Configuration
LOG_FILE="logs/monitor.log"
mkdir -p logs

# Define the array of default services
services=("nginx" "ssh" "docker")

# 2. Determine which processes to check
# If the user provides an argument, use that. Otherwise, use the array.
if [ -n "$1" ]; then
    targets=("$1")
else
    targets=("${services[@]}")
fi

# 3. The Monitoring Loop
for proc in "${targets[@]}"; do
    # pgrep searches for the process name and returns the PID
    if pgrep "$proc" > /dev/null; then
        echo "$proc: Running"
        echo "$(date): $proc is running" >> "$LOG_FILE"
    else
        echo "$proc: Stopped"
        echo "$(date): $proc was stopped. Attempting restart..." >> "$LOG_FILE"
        
        # Simulate restart
        # In a real environment, you might use: sudo systemctl start $proc
        echo "Restarting $proc..."
        sleep 1 # Simulate work
        
        # Final check after restart
        echo "$proc: Restarted"
        echo "$(date): $proc successfully restarted" >> "$LOG_FILE"
    fi
done
