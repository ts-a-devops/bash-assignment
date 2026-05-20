#!/bin/bash

read -p "Enter process name to check: " process

# Check if process name was provided
if [ -z "$process" ]; then
    echo "Error: No process name provided."
    exit 1
fi

# Check if process is running
if pgrep "$process" > /dev/null 2>&1; then
    echo "Process '$process' is running."
else
    echo "Process '$process' is NOT running."
    echo "Attempting to restart $process..."
    systemctl start "$process" 2>/dev/null || echo "Could not restart '$process'. Manual intervention needed."
fi
