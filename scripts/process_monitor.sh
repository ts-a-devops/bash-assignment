#!/bin/bash

set -euo pipefail

LOG_FILE="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

process=${1:-}

if [[ -z "$process" ]]; then
	    echo "Usage: $0 <process_name>"
	        exit 1
fi

if pgrep -x "$process" > /dev/null; then
	    echo "$process is Running" | tee -a "$LOG_FILE"
    else
	        echo "$process is Stopped" | tee -a "$LOG_FILE"
		if [[ " ${services[*]} " =~ " $process " ]]; then
			echo "Restarting $process..." | tee -a "$LOG_FILE"
			sleep 1 
			echo "$process Restarted" | tee -a "$LOG_FILE" 
		else
			echo "$process not in managed services list" | tee -a "$LOG_FILE"
		fi
fi
