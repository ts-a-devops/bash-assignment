#!/bin/bash
# process_monitor.sh - monitor and restart services if needed

LOGFILE="logs/process_monitor.log"
mkdir -p logs

# Predefined services
services=("nginx" "ssh" "docker")

# Use input service(s) if provided
if [ $# -ge 1 ]; then
    services=("$@")
fi

for service in "${services[@]}"; do
    if pgrep -x "$service" > /dev/null; then
        echo "$service is running"
        echo "$(date '+%F %T') - RUNNING - $service" >> $LOGFILE
    else
        echo "$service is NOT running"
        echo "$(date '+%F %T') - STOPPED - $service" >> $LOGFILE
        # Simulate restart (replace with actual restart if permissions allow)
        echo "Attempting to restart $service..."
        # sudo systemctl restart $service   # Uncomment if you have permission
        echo "$(date '+%F %T') - RESTARTED - $service" >> $LOGFILE
        echo "$service restarted"
    fi
done
