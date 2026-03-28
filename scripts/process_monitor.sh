#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Default services
services=("nginx" "ssh" "docker")

# Check if input provided
if [ -z "$1" ]; then
    echo "No process specified. Monitoring default services..."
    processes=("${services[@]}")
else
    processes=("$1")
fi

# Monitor processes
for process in "${processes[@]}"; do
    if pgrep "$process" > /dev/null 2>&1; then
        echo "$process is Running "
        echo "$(date): $process Running" >> logs/process_monitor.log
    else
        echo "$process is Stopped"
        echo "$(date): $process Stopped" >> logs/process_monitor.log

        echo "Attempting restart..."

        if systemctl start "$process" 2>/dev/null; then
            echo "$process Restarted"
            echo "$(date): $process Restarted" >> logs/process_monitor.log
        else
            echo "$process restart simulated ⚠️"
            echo "$(date): $process Restart Failed" >> logs/process_monitor.log
        fi
    fi
done

echo "Logs saved to logs/process_monitor.log"
