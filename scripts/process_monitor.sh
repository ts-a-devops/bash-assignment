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
 
usage="Usage: $0 <directory_to_backup>"
timestamp="$USER:$(date '+%Y-%m-%d %H:%M:%S')"
date="$(date '+%Y-%m-%d_%H-%M-%S')"


echo "Enter the name of the process you want to check: "
read process

if [[ pgrep -x "$process" &> /dev/null ]]; then
	echo -e "$timestamp - Process is running" >> ../logs/process_monitor.log
else
	systemctl start "$process"



echo "==================================="
echo "Script completed successfully"
echo "Valar Dohaeris"
echo "==================================="
