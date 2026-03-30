#!/bin/bash
# process_monitor.sh - Monitor and restart services (simulation)

mkdir -p logs
services=("nginx" "ssh" "docker")
LOG_FILE="logs/process_monitor.log"

for service in "${services[@]}"; do
	if pgrep "$service" >/dev/null; then
		echo "$(date) - $service is Running" | tee -a "$LOG_FILE"
	else
		echo "$(date) - $service Stopped. Attempting restart..." | tee -a "$LOG_FILE"
		# Simulate restart
		# systemctl start $service
		echo "$(date) - $service Restarted" | tee -a "$LOG_FILE"
	fi
done
