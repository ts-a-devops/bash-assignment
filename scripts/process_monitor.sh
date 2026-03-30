#!/bin/bash






# Simple Process Monitor

services=("nginx" "ssh" "docker")  #A list of process names to monitor.

LOG_FILE="../logs/process_monitor.log"

log() {
    echo "[$(date '+%Y-%m-%d: %H:%M:%S')] $1" >> "$LOG_FILE"
}

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null || [[ "$service" == "ssh" && $(pgrep -x sshd) ]]; then

#pgrep -x "$service": Searches for an exact matching process name.
#> /dev/null: Hides the output (we only care about success/failure).
#||: Means "OR".
    
        echo "$service: Running"
        log "$service: Running"
    else
        echo "$service: Stopped"
        log "$service: Stopped - Restarting"
        
        # Simulate restart (or real if you add systemctl)
        echo "$service: Restarted"
        log "$service: Restarted"
    fi
done



































