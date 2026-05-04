#!/bin/bash
# This script monitors a process

services=("nginx" "ssh" "docker")
found=false

# Iterate through array to check for a running process
for ps in ${services[@]}; do
    if [[ $1 == "$ps" ]]; then
        found=true 
        # check if process is running
        if pgrep -x "$ps" > /dev/null; then
            echo "$ps process is running."
        else
            echo "$ps process is not running."
            echo "Attempting to install process..."
            sudo apt install "$ps"
        fi
    # Exit the loop after find and processing service
    break
    fi
done

# Notify if argument doesn't match the array   
if ! $found; then 
    echo "$1 is not a valid argument" 
fi

