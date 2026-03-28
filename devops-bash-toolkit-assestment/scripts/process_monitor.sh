#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Define services array
services=("nginx" "ssh" "docker")

# Check if a process name was provided
if [ -z "$1" ]; then
    echo "Usage: ./process_monitor.sh <process-name>"
    echo "Monitoring default services..."
    processes=("${services[@]}")
else
    processes=("$1")
fi

# Monitor each process
for process in "${processes[@]}"; do
    if pgrep "$process" > /dev/null 2>&1; then
        echo "$process is Running ✅"
        echo "$process - Running - $(date)" >> logs/process_monitor.log
    else
        echo "$process is Stopped ❌"
        echo "$process - Stopped - $(date)" >> logs/process_monitor.log

        # Attempt to restart
        echo "Attempting to restart $process..."
        if systemctl start "$process" 2>/dev/null; then
            echo "$process Restarted successfully! ✅"
            echo "$process - Restarted - $(date)" >> logs/process_monitor.log
        else
            echo "$process could not be restarted (simulated) ⚠️"
            echo "$process - Restart failed - $(date)" >> logs/process_monitor.log
        fi
    fi
done

echo ""
echo "Monitor log saved to logs/process_monitor.log"
