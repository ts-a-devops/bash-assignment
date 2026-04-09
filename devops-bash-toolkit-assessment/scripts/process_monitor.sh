#!/bin/bash
# Accept a process as input

PROCESS_NAME=$1
LOG_FILE="process_monitor.log"
services=("nginx" "ssh" "docker")

# Check if the process is running
check_process () {
  PROCESS_NAME=$1
  if pgrep -x "$PROCESS_NAME" > /dev/null; then
      echo "$(date) - $PROCESS_NAME is Running" | tee -a "$LOG_FILE"
  else
      echo "$(date) - $PROCESS_NAME is Stopped" | tee -a "$LOG_FILE"

      # Simulate restart
      systemctl restart "$PROCESS_NAME" 2>/dev/null

      if pgrep -x "$PROCESS_NAME" > /dev/null; then
          echo "$(date) - $PROCESS_NAME Restarted successfully" | tee -a "$LOG_FILE"
      else
          echo "$(date) - $PROCESS_NAME Restart failed (or simulated)" | tee -a "$LOG_FILE"
      fi
  fi
}
for service in "${services[@]}"; do
    check_process "$service"
done

