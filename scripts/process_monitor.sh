#!/bin/bash

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

mkdir -p "$LOG_DIR"

# Using arrays
services=("nginx" "ssh" "docker")

process=$1

if [[ -z "$process" ]]; then
	echo "Usage: $0 <process_name>"
	exit 1
fi

# Logging monitored results
if pgrep -x "$process" > /dev/null; then
	echo "$process is Running"
	echo "$(date): $process running" >> "$LOF_FILE"
else
	echo "$process is Stopped"

	# Simulate restart
	echo "Restarting $process..."
	sleep 1
	echo "$process restarted" >> "LOG_FILE"

	echo "$(date): $process restarted" >> "$LOG_FILE"
fi

