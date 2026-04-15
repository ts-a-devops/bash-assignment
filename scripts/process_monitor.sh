#!/bin/bash

LOG_FILE="../logs/process_monitor.log"

services=("nginx" "ssh" "docker")

process=$1

if pgrep "$process" > /dev/null
then
    echo "$process is Running"
else
    echo "$process is Stopped. Restarting..."
    echo "Restarted $process (simulated)"
fi

echo "$(date): Checked $process" >> "$LOG_FILE"
