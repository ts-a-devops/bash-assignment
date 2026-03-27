#!/bin/bash

# Task: Use an array of services
services=("nginx" "ssh" "docker")
LOG="../logs/process_monitor.log"

# Ensure log directory exists
mkdir -p ../logs

echo "------------------------------------------" >> "$LOG"
echo "Monitoring Session: $(date)" >> "$LOG"
echo "------------------------------------------" >> "$LOG"

for service in "${services[@]}"; do
    # Check if process is running
    if pgrep -x "$service" > /dev/null; then
        RESULT="$service: Running"
        echo "$RESULT" | tee -a "$LOG"
    else
        echo "$service: Stopped" | tee -a "$LOG"
        
        # Simulate Restart
        echo "Attempting to restart $service..." | tee -a "$LOG"
        sleep 1
        
        RESULT="$service: Restarted"
        echo "$RESULT" | tee -a "$LOG"
    fi
done

echo -e "Session Ended\n" >> "$LOG"
