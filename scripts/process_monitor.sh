#!/bin/bash

mkdir -p logs
LOG_FILE="logs/process_monitor.log"

# Predefined services
services=("nginx" "ssh" "docker")

PROCESS_NAME=$1

echo "===== PROCESS MONITOR =====" | tee -a "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# -------------------------
# Validate input
# -------------------------
if [ -z "$PROCESS_NAME" ]; then
  echo "Error: No process name provided." | tee -a "$LOG_FILE"
  echo "Usage: $0 <process_name>" | tee -a "$LOG_FILE"
  exit 1
fi

# -------------------------
# Check if process is in allowed services
# -------------------------
FOUND=false
for svc in "${services[@]}"; do
  if [ "$svc" == "$PROCESS_NAME" ]; then
    FOUND=true
    break
  fi
done

if [ "$FOUND" = false ]; then
  echo "Warning: '$PROCESS_NAME' is not in monitored services list." | tee -a "$LOG_FILE"
fi

# -------------------------
# Check if process is running
# -------------------------
if pgrep -x "$PROCESS_NAME" > /dev/null; then
  echo "Status: Running" | tee -a "$LOG_FILE"
else
  echo "Status: Stopped" | tee -a "$LOG_FILE"

  # Simulate restart
  echo "Attempting to restart $PROCESS_NAME..." | tee -a "$LOG_FILE"
  sleep 1
  echo "Status: Restarted" | tee -a "$LOG_FILE"
fi

echo ""
echo "===== CHECK COMPLETED =====" | tee -a "$LOG_FILE"
