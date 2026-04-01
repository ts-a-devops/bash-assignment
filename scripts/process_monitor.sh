#!/usr/bin/bash

mkdir -p logs
services=("nginx" "ssh" "docker")
service_name="$1"

	# If no argument was passed, ask the user
{
if [[ -z "$service_name" ]]; then
	read -rp "Enter service name (nginx, ssh, docker): " service_name
fi

	# Check if the entered service is one of the allowed ones

valid_service=false

for service in "${services[@]}"; do
	if [[ "$service_name" == "$service" ]]; then
valid_service=true
        break
	fi
done

if [[ "$valid_service" == false ]]; then
    echo "That service is not supported. Choose from: ${services[*]}"
    exit 1
fi

	# Check if the service is running

if systemctl is-active --quiet "$service_name"; then
status="Running"
	echo -e "[$(date '+%Y-%m-%d %H:%M:%S')]\n$service_name is $status"
else
	echo -e "[$(date '+%Y-%m-%d %H:%M:%S')]\n$service_name is stopped"

    #If you check and it's not running then try restarting it

if sudo systemctl restart "$service_name"; then
	echo -e "[$(date '+%Y-%m-%d %H:%M:%S')]\n$service_name has been restarted successfully"
    else
        echo -e "[$(date '+%Y-%m-%d %H:%M:%S')]\nRestart attempt failed for $service_name"

fi
fi
} | tee -a logs/process_monitor.log
