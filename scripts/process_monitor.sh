#!/bin/bash

PROCESS_NAME=$1
LOG_FILE="logs/process_monitor.log"

# 1. Check if input was provided
if [ -z "$PROCESS_NAME" ]; then
    echo "Usage: ./process_monitor.sh <process_name>"
    exit 1
fi

# 2. Check if process is running
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    STATUS="Running"
    echo "$PROCESS_NAME is $STATUS."
else
    STATUS="Stopped"
    echo "$PROCESS_NAME is $STATUS. Attempting restart..."
    
    # 3. Simulate a restart (In real life, we would use sudo systemctl restart $PROCESS_NAME)
    sleep 2
    echo "Restarting $PROCESS_NAME..."
    STATUS="Restarted"
fi

# 4. Log the result
echo "$(date): $PROCESS_NAME was $STATUS" >> $LOG_FILE
