#!/bin/bash

# Create logs folder if it doesn't exist
mkdir -p logs

LOG_FILE="logs/process_monitor.log"

# Services array
services=("nginx" "ssh" "docker")

# Process name from user input
PROCESS_NAME=$1

# Check if user provided input
if [ -z "$PROCESS_NAME" ]; then
    echo "Usage: ./process_monitor.sh <process_name>"
    exit 1
fi

# Check if process exists in array
FOUND=false
for service in "${services[@]}"
do
    if [ "$service" == "$PROCESS_NAME" ]; then
        FOUND=true
    fi
done

if [ "$FOUND" = false ]; then
    echo "$PROCESS_NAME is not monitored by this script."
    exit 1
fi

# Check if process is running
if pgrep "$PROCESS_NAME" > /dev/null
then
    echo "$PROCESS_NAME is Running"
    echo "[$(date)] $PROCESS_NAME is Running" >> $LOG_FILE
else
    echo "$PROCESS_NAME is Stopped"
    echo "Attempting restart..."

    # Simulated restart
    echo "$PROCESS_NAME Restarted (simulation)"

    echo "[$(date)] $PROCESS_NAME was stopped and restarted" >> $LOG_FILE
fi 
