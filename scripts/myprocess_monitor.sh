#!/bin/bash
# Array of allowed services
services=("nginx" "ssh" "docker")
# Log directory and file
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/myprocess_monitor.log"
# Create logs directory if it does not exist
mkdir -p $LOG_DIR

# Check if argument was provided
if [ -z "$1" ]; then
   echo "Usage: $0 <process_name>"
   exit 1
fi
process=$1
found=false

# Check if process is in services array
for service in "${services[@]}"
do
   if [ "$service" == "$process" ]; then
       found=true
       break
   fi
done
if [ "$found" = false ]; then
   echo "Process not in monitored services list"
   echo "$(date) - $process - Not monitored" >> $LOG_FILE
   exit 1
fi

# Check if process is running
if pgrep -x "$process" > /dev/null
then
   echo "Running"
   echo "$(date) - $process - Running" >> $LOG_FILE
else
   echo "Stopped"
   echo "$(date) - $process - Stopped" >> $LOG_FILE
   echo "Attempting restart..."
  
 # Restart attempt (simulation if restart fails)
   if systemctl start "$process" 2>/dev/null
   then
       echo "Restarted"
       echo "$(date) - $process - Restarted" >> $LOG_FILE
   else
       echo "Restart simulated (no permission or service unavailable)"
       echo "$(date) - $process - Restart simulated" >> $LOG_FILE
   fi
fi
