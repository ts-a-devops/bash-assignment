#!/bin/bash

mkdir -p logs

PROCESS=$1

if [ -z "$PROCESS" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

LOGFILE="logs/process_monitor.log"

if pgrep -x "$PROCESS" > /dev/null; then
    echo "$PROCESS is Running"
    STATUS="Running"
else
    echo "$PROCESS is Stopped"
    STATUS="Stopped"
    # Simulate restart
    echo "Attempting to restart $PROCESS (simulation)..."
    echo "Restarted $PROCESS"
    STATUS="Restarted"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS: $STATUS" >> "$LOGFILE"