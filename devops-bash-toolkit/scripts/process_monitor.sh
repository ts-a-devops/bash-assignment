#!/bin/bash

services=("nginx" "ssh" "docker")
log="../logs/process_monitor.log"

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null; then
        echo "$service running"
	echo "$(date +%F) - $service: running" > $log
	exit 0
    else
	echo "$service: stopped"
	echo "$(date +%F) - $service: stopped" > $log
    sudo systemctl start $service
    echo "$service: restarted"
    echo "$(date +%F) - $service: restarted" > $log
    fi
done
