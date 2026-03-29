#!/bin/bash


# ==== Creating variables ====
LOG_FILE="logs/process_monitor.log"
PROCESS_NAME=$1

# ==== Predefined services ====
services=("nginx" "ssh" "docker")

# ==== Validate input ====
if [ -z "$PROCESS_NAME" ]; then
    echo "Error: Please provide a process name."
    exit 1
fi

# ==== Checks if process is in allowed list ====
FOUND=false
for service in "${services[@]}"
do
    if [ "$PROCESS_NAME" == "$service" ]; then
        FOUND=true
        break
    fi
done

if [ "$FOUND" = false ]; then
    echo "Warning: $PROCESS_NAME is not in monitored services list."
fi

# ==== Checks if process is running ====
if pgrep -x "$PROCESS_NAME" > /dev/null
then
    echo "$PROCESS_NAME is Running"
    echo "$(date) - $PROCESS_NAME: Running" >> $LOG_FILE
else
    echo "$PROCESS_NAME is Stopped"
    echo "$(date) - $PROCESS_NAME: Stopped" >> $LOG_FILE

    # ==== Simulates restart ====
    echo "Attempting to restart $PROCESS_NAME..."
    
    # ==== (Simulation only. Not real restart) ====
    sleep 1

    echo "$PROCESS_NAME Restarted"
    echo "$(date) - $PROCESS_NAME: Restarted" >> $LOG_FILE
fi
