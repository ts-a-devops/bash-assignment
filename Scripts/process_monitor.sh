#!/bin/bash

# Check if the process is running

if ! pgrep -x "nginx" > /dev/null; then
    echo "Nginx is not running"
    echo "Attempting to restart Nginx..."
    systemctl restart nginx
    if [ $? -eq 0 ]; then
        echo "Nginx restarted successfully"
    else
        echo "Failed to restart Nginx"
    fi
else
    echo "Nginx is running"
fi

Running systemctl status <nginx>
Stopped systemctl stop <nginx>

Restarted systemctl restart <nginx>

Use an array:

services=("nginx")

Log monitoring results