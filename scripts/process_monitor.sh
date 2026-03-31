#!/bin/bash

read -p "Enter process name: " process

services=("nginx" "ssh" "docker")

check_process() {
    local svc=$1

    if pgrep "$svc" > /dev/null; then
        echo "$svc: Running"
        echo "$(date) - $svc - RUNNING" >> logs/process_monitor.log
    else
        echo "$svc: Stopped"
        echo "$(date) - $svc - STOPPED" >> logs/process_monitor.log

        # simulate restart
        echo "$svc: Restarted"
        echo "$(date) - $svc - RESTARTED" >> logs/process_monitor.log
    fi
}

# Check user input
check_process "$process"

# Check predefined services
for service in "${services[@]}"
do
    check_process "$service"
done   
