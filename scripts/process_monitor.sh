#!/bin/bash

mkdir -p logs

services=("nginx" "ssh" "docker")

for service in "${services[@]}"; do
    if pgrep $service > /dev/null; then
        echo "$service is running"
    else
        echo "$service is not running. Restarting..."
        echo "$service restarted" >> logs/process_monitor.log
    fi
done
