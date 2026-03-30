#!/bin/bash

# Configuration
LOG_FILE="logs/process_monitor.log"
mkdir -p logs

# 1. Define the services array (Update these to match your actual service names)
# Common ones: "nginx", "ssh", "docker", "mysql", "apache2"
services=("ssh" "docker" "nginx")

echo "--- System Process Monitor [$(date)] ---"

for service in "${services[@]}"; do
    # 2. Check if the service is active using systemctl
    if systemctl is-active --quiet "$service"; then
        status="Running"
        echo "[$service] Status: $status"
    else
        status="Stopped"
        echo "[$service] Status: $status. Attempting to restart..."
        
        # 3. Attempt real restart (requires sudo privileges)
        if sudo systemctl start "$service"; then
            status="Restarted"
            echo "[$service] Status: $status successfully."
        else
            status="Failed to Restart"
            echo "[$service] Error: Could not start $service."
        fi
    fi

    # 4. Log the result
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Service: $service - Status: $status" >> "$LOG_FILE"
done

echo "------------------------------------------"
