#!/bin/bash
# This is the process monitor script
mkdir -p logs

if [ $# -eq 0 ]; then
    echo "Usage: ./process_monitor.sh processname"
    echo "Example: ./process_monitor.sh nginx"
    exit 1
fi

process_name=$1

if pgrep -x "$process_name" >/dev/null; then
    echo "$process_name is Running"
    echo "$(date) - RUNNING - $process_name" >> logs/process_monitor.log
else
    echo "$process_name is Stopped"
    echo "Trying to restart (this is simulation)..."
    sleep 2
    echo "$process_name has been restarted (simulated)"
    echo "$(date) - RESTARTED - $process_name" >> logs/process_monitor.log
fi