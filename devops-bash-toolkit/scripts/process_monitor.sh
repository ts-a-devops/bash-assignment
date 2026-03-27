#!/bin/bash

CHECKER=$(pgrep "$1" | wc -l)
services=("daemon" "nginx" "ssh" "docker")

# check if process is in allowed list
is_valid=false
for service in "${services[@]}"; do
    if [[ "$1" == "$service" ]]; then
        is_valid=true
        break
    fi
done

# check if running AND valid
if [[ $CHECKER -ge 1 && $is_valid == true ]]; then
    echo "Running"
    echo "$1 is Running" >> ../logs/process_monitor.log
fi

#if it's not running, try restarting it
if [[ $CHECKER -eq 0 && $is_valid == true ]]; then
    echo "Stopped"
    echo "$1 is not Running" >> ../logs/process_monitor.log
    sudo systemctl restart $1
    echo "$1 has been restarted, now Running" >> ../logs/process_monitor.log
    echo "Restarted"
fi

