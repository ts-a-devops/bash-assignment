#!/bin/bash

mkdir -p logs
exec > >(tee -a "logs/process_monitor.log") 2>&1

#default name of services to check if name is not given
 services=("nginx" "ssh" "docker")

# check one process at time
check_process() {
local name=$1

#pgrep -x loos for a runnong process with this exact name
# it prints matching process IDs if found, nothing if not
if pgrep -x "$name" > /dev/null 2>&1; then
	echo "$name: Running"
else
	echo "$name: Stopped"
        attempt_restart "$name"
fi
}

#function: try to restart a stopped process
attempt_restart() {
	local name=$1
	echo "$name: Attempting restart"
	sleep 1
	echo "$name: Restarted (simulated)"
}
#main logic behind the restart
if [[ -n "$1" ]]; then
	check_process "$1"
else
	echo "No process name given - checking default services list"
	for service in "${services[@]}"; do
		check_process "$service"
	done
fi

echo "Monitoring check complete"

