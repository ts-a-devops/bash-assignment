#!/bin/bash

mkdir -p logs

process=$1

if pgrep "$process" > /dev/null; then
status="Running"
else 
status="Stopped"
fi

echo "$process is $status"
echo "$(date): $process - $status" >> logs/process_monitor.log