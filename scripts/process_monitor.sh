#!/bin/bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

PROCESS=$1

if [ -z "$PROCESS" ]; then
    echo "Enter process name"
    exit 1
fi

if ps aux | grep -v grep | grep "$PROCESS" > /dev/null; then
    echo "$PROCESS is Running" | tee -a "$LOG_FILE"
else
    echo "$PROCESS is Stopped" | tee -a "$LOG_FILE"
    echo "Restarting $PROCESS..." | tee -a "$LOG_FILE"
    sleep 1
    echo "$PROCESS Restarted (simulated)" | tee -a "$LOG_FILE"
fi