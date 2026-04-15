#!/bin/bash

# Define the list of services to check
# Make sure to use the space between the names, not commas!
services=("nginx" "ssh" "docker")

echo "--- Starting Process Monitor ---"

# Loop through each service in the array
for services in "${services[@]}"; do
	# pgrep looks for the process ID (PID)
	if pgrep "$service" > /dev/null; then
		echo "[RUNNING] $service is active."
	else
		echo "[STOPPED] $service is down! Attempting restart..."
		# In a real environment, you'd use 'sudo systemtl restart $service'
		# For the assignment, we simulate the restart 
		echo "[RESTARTED] $service has been brought back online."
	fi
done


