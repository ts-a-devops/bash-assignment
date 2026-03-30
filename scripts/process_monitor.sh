#!/bin/bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"
services=("nginx" "ssh" "docker")


process_name="$1"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")


if [[ -z "$process_name" ]]; then
   echo "Usage:$0 <process_name>"
   echo "Available services: ${services[*]}"
   exit 1
fi


found=false
for service in "${services[@]}"; do
    if [[ "$service" == "$process_name" ]]; then
	found=true
	break
    fi
done


if [[ "$found" == false ]]; then
   message="[$timestamp] '$process_name' is not in the allowed service list: ${services[*]}"
   echo "$message"
   echo "$message" >> "LOG_FILE"
   exit 1
fi

if pgrep -x "$process_name" >/dev/null; then
   message="[$timestamp] Status:Running - '$process_name' is active."
   echo "$message"
   echo "$message" >> "$LOG_FILE"

else
   message="[$timestamp] Status:Stopped - '$process_name' is not running."
   echo "$message"
   echo "$message" >> "$LOG_FILE"

   # Simulate restart
   restart_message="[$timestamp] Status: Restarted - Simulated restart of '$process_name'."
   echo "$restart_message"
   echo "$restart_message" >> "$LOG_FILE"
fi

