#!/bin/bash


mkdir -p logs
LOG_FILE="logs/monitor.log"
services=("nginx" "ssh" "docker")


# Monitoring Loop
{
    echo "--- Monitor Run: $(date '+%Y-%m-%d %H:%M:%S') ---"

    for service in "${services[@]}"; do
        
        if pgrep -x "$service" > /dev/null; then
            echo "[$service]: Running"
        else
            echo "[$service]: Stopped"
            
            # Trying to Restart
            echo "[$service]:  Restarting..."
            
            sleep 1 
            echo "[$service]: Restarted"
        fi
    done
    echo "------------------------------------------"
} | tee -a "$LOG_FILE"
