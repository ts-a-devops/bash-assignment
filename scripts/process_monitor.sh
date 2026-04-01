#!/bin/bash

# 1. Define the services array
services=("nginx" "ssh" "docker")
LOG_FILE="logs/process_monitor.log"

mkdir -p logs

log_status() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

echo "=== Process Monitor: Checking Services ==="

# 2. Loop through each service in the array
for service in "${services[@]}"; do
    
    # 3. Check if the process is running
    # pgrep looks for a process with that name. -x ensures an exact match.
    if pgrep -x "$service" > /dev/null; then
        echo "[$service]: Running"
        log_status "HEALTHY: $service is running."
    else
        # 4. If NOT running, attempt a simulated restart
        echo "[$service]: Stopped"
        log_status "ALERT: $service was stopped. Attempting restart..."
        
        # Simulate restart (In a real server, I'd use: sudo systemctl start $service)
        sleep 1 
        echo "[$service]: Restarting..."
        
        # 5. Final Output Status
        echo "[$service]: Restarted"
        log_status "RECOVERY: $service has been restarted."
    fi
    echo "-----------------------------------"
done

echo "Monitoring complete. Log updated at $LOG_FILE"
