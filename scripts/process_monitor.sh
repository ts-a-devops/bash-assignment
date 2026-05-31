rray of services
services=("nginx" "ssh" "docker")

# Accept process name as input
process=$1

# Check if input is provided
if [ -z "$process" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

# Verify process is in the services array
if [[ ! " ${services[@]} " =~ " ${process} " ]]; then
    echo "Process '$process' is not in the monitored services list."
    exit 1
fi

# Check if process is running
if pgrep -x "$process" > /dev/null; then
    echo "Running"
else
    echo "Stopped"

    # Simulate restart
    echo "Attempting restart..."
    # Uncomment the next line for actual restart
    # systemctl restart $process

    echo "Restarted"
fi
