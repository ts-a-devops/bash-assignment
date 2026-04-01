
#!/bin/bash
# This script monitors processes/services
# It checks if a process is running
# If not running, it attempts to restart it (or simulates restart)
# It logs all results into logs/process_monitor.log


# Create logs directory if it does not exist
mkdir -p logs

# Define log file path
LOG_FILE="logs/process_monitor.log"

# Store the current date/time (used in logs)
NOW=$(date +"%Y-%m-%d %H:%M:%S")

# Define an array of services to monitor (as required by assignment)
services=("nginx" "ssh" "docker")


# Function to log a message into the log file
log_action() {
  # $1 is the message passed into the function
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}


# Function to check and restart a process
check_service() {
  # $1 is the service name passed into the function
  SERVICE_NAME=$1

  # Check if the service is running using pgrep
  # pgrep searches for process names and returns exit code
  if pgrep -x "$SERVICE_NAME" > /dev/null; then
    # If the process is running, print and log it
    echo "$SERVICE_NAME is RUNNING"
    log_action "INFO: $SERVICE_NAME is RUNNING"
  else
    # If the process is not running, print and log it
    echo "$SERVICE_NAME is STOPPED"
    log_action "WARNING: $SERVICE_NAME is STOPPED"

    # Attempt to restart the service using systemctl
    # This will only work on systems that use systemd (like Ubuntu Linux)
    echo "Attempting to restart $SERVICE_NAME..."

    # Try restarting and suppress output
    systemctl restart "$SERVICE_NAME" 2>/dev/null

    # After restart attempt, check again if service is running
    if pgrep -x "$SERVICE_NAME" > /dev/null; then
      echo "$SERVICE_NAME successfully RESTARTED"
      log_action "SUCCESS: $SERVICE_NAME successfully RESTARTED"
    else
      # If restart did not work, simulate restart
      echo "Could not restart $SERVICE_NAME (simulated restart)"
      log_action "ERROR: Failed to restart $SERVICE_NAME (simulated restart)"
    fi
  fi
}


# -----------------------------
# MAIN SCRIPT EXECUTION
# -----------------------------

# If the user provides an argument, monitor only that process
# Example: ./process_monitor.sh nginx
if [ -n "$1" ]; then

  # Store argument in a variable
  PROCESS_NAME=$1

  # Print message
  echo "Monitoring process: $PROCESS_NAME"

  # Log monitoring start
  log_action "INFO: Monitoring single process '$PROCESS_NAME'."

  # Call function for the provided process name
  check_service "$PROCESS_NAME"

  # Exit script
  exit 0
fi


# If no argument is provided, monitor all services in the array
echo "No process name provided."
echo "Monitoring default services: nginx, ssh, docker"

# Log monitoring start
log_action "INFO: No argument provided. Monitoring default services array."

# Loop through each service in the array
for service in "${services[@]}"; do

  # Call the check_service function for each service
  check_service "$service"

done


# Print completion message
echo "Process monitoring completed."

# Log completion
log_action "INFO: Process monitoring completed."

# Exit successfully
exit 0
