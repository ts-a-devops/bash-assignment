#!/bin/bash


mkdir -p logs


LOG_FILE="logs/process_monitor.log"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

services=("nginx" "ssh" "docker")


log_action() {
	echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}
check_service() {
	 SERVICE_NAME=$1
if pgrep -x "$SERVICE_NAME" > /dev/null
then
	echo "$SERVICE_NAME: Running"
	log_action "$SERVICE_NAME is RUNNING"
else
	echo "$SERVICE_NAME: Stopped"
	log_action "$SERVICE_NAME is STOPPED"

	echo "$SERVICE_NAME: Attempting restart..."

if command -v systemctl > /dev/null
then
	sudo systemctl restart "$SERVICE_NAME" 2>/dev/null
fi

    echo "$SERVICE_NAME: Restarted"

    log_action "$SERVICE_NAME was RESTARTED"
fi
}
if [ ! -z "$1" ]; then
	check_service "$1"
else
	for service in "${services[@]}"
	do
		check_service "$service"
	done
fi

