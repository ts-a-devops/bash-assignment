#!/bin/bash

services=("nginx" "ssh" "docker")

{
for service in "${services[@]}"
do
    if pgrep "$service" > /dev/null
    then
        echo "$service is Running"
    else
        echo "$service is Stopped"
        echo "Attempting to restart $service..."
        sudo systemctl start "$service" 2>/dev/null || echo "Could not restart $service"
    fi
done
} >> logs/process_monitor.log

