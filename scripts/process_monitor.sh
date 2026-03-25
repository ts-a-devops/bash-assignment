#!/bin/bash

# Accept a process name as input
# Check if the process is running
# If NOT running: Attempt restart (or simulate restart)
# Output: Running, Stopped, Restarted
# Use an array: services=("nginx" "ssh" "docker")
# Log monitoring results
#

echo "==================================="
echo "Running Script"
echo "==================================="


if [ -d "../logs" ]; then
        echo
else
	mkdir -p "../logs"
fi
 

date="$(date '+%Y-%m-%d_%H-%M-%S')"


echo "Enter the name{s} of the process you want to check (seperated by spaces)\nExample dockerd, containerd, minikube): "
read -a processes

if [[ ${#processes[@]} -eq 0 ]]; then
    echo "Error: No processes entered."
    exit 1
fi


# loop through the arr of inputes
for process in "${processes[@]}"; do
	timestamp="$USER:$(date '+%Y-%m-%d %H:%M:%S')" # this iis to get the seconds when the loop echos

	if pgrep -x "$process" > /dev/null; then
		echo -e "$timestamp - $process Process is running" >> ../logs/process_monitor.log
	else
		echo -e "$timestamp - $process Process is stopped" >> ../logs/process_monitor.log
		sudo systemctl start "$process"
		echo -e "$timestamp - $process Process is starting" >> ../logs/process_monitor.log
	fi
done


echo "==================================="
echo "Script completed successfully"
echo "Valar Dohaeris"
echo "==================================="
