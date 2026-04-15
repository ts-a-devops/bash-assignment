#!/bin/bash
set -euo pipefail

mkdir -p logs
logfile="logs/process_monitor.log"

services=("nginx" "ssh" "docker")

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logfile"
}

usage() {
    echo "Usage: $0 <process_name>"
    echo "Monitor: ${services[*]}"
    exit 1
}

[[ $# -ne 1 ]] && usage

process="$1"

# Check if in services array
valid=0
for s in "${services[@]}"; do
    [[ "$s" == "$process" ]] && valid=1 && break
done
[[ $valid -eq 0 ]] && echo "Error: $process not monitored" && usage

# Check and act
if pgrep -x "$process" >/dev/null 2>&1; then
    echo "Running"
    log_action "$process - Running"
else
    echo "Stopped"
    log_action "$process - Stopped"
    
    # Simulate restart
    echo "Attempting restart..."
    log_action "$process - Restart attempted (simulated)"
    echo "Restarted"
    log_action "$process - Restarted (simulated)"
fi
