#!/bin/bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"

process=$1

if pgrep $process > /dev/null
then
    echo "$process is running"
else
    echo "$process stopped. Restarting..."
fi
