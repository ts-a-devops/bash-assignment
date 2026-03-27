#!/bin/bash

log_file="logs/process_monitor.log"

services=("nginx" "ssh" "docker")
input_process=$1

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

check_process() {
    local process_name=$1

    if pgrep -x "$process_name" > /dev/null; then
        echo "$process_name: Running"
        log_action "$process_name is Running"
    else
        echo "$process_name: Stopped"
        log_action "$process_name is Stopped"

        # Try restart with systemctl, otherwise simulate restart
        if systemctl list-unit-files | grep -q "^${process_name}\.service"; then
            sudo systemctl restart "$process_name" 2>/dev/null

            if systemctl is-active --quiet "$process_name"; then
                echo "$process_name: Restarted"
                log_action "$process_name was Restarted successfully"
            else
                echo "$process_name: Restart attempt failed"
                log_action "$process_name restart failed"
            fi
        else
            echo "$process_name: Restarted (simulated)"
            log_action "$process_name restart simulated"
        fi
    fi
}

# If user provides a process name, check only that one
if [[ -n "$input_process" ]]; then
    check_process "$input_process"
else
    echo "Checking default services..."
    for service in "${services[@]}"; do
        check_process "$service"
    done
fi
