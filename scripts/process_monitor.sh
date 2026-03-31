#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
mkdir -p ../logs

services=("nginx" "ssh" "docker")

for service in "${services[@]}"
do
    if pgrep "$service" > /dev/null
    then
        echo "$service: Running"
        echo "$service running" >> $LOG_FILE
    else
        echo "$service: Stopped - Restarting..."
        echo "$service restarted" >> $LOG_FILE
        sleep 1
        echo "$service: Restarted"
    fi
done
