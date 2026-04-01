#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
mkdir -p ../logs

services=("nginx" "ssh" "docker")

for service in "${services[@]}"
do
    if pgrep "$service" > /dev/null
    then
        echo "$service is Running"
        echo "$(date): $service Running" >> "$LOG_FILE"
    else
        echo "$service is Stopped. Restarting..."
        echo "$(date): $service Restarted" >> "$LOG_FILE"
        
        # Simulated restart
        sleep 1
        echo "$service Restarted"
    fi
done
