#!/bin/bash

# 1. Setup logs
mkdir -p logs
LOG_FILE="logs/process_monitor.log"

# 2. Define the array of services to monitor
services=("nginx" "ssh" "docker")

# 3. Get input from user (optional)
input_service=$1

# Function to check and restart a service
check_service() {
    local service=$1
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # Check if the process is running using pgrep
    if pgrep "$service" > /dev/null; then
        echo "$service: Running"
        echo "[$timestamp] $service is Running" >> "$LOG_FILE"
    else
        echo "$service: Stopped"
        echo "[$timestamp] $service was Stopped. Attempting restart..." >> "$LOG_FILE"
        
        # Simulate a restart (In a real scenario, you'd use: sudo systemctl restart $service)
        echo "Restarting $service..."
        sleep 1 # Just for effect
        
        echo "$service: Restarted"
        echo "[$timestamp] $service was Restarted" >> "$LOG_FILE"
    fi
}

# 4. Main Logic
if [ -n "$input_service" ]; then
    # If the user provided a specific name, check only that
    check_service "$input_service"
else
    # Otherwise, loop through the array and check everything
    echo "Monitoring default services: ${services[*]}"
    for s in "${services[@]}"; do
        check_service "$s"
        echo "--------------------"
    done
fi
