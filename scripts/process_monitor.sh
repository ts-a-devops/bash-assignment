#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Services to monitor
services=("nginx" "sshd" "docker")

# Logging function with timestamp
log() {
  echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "===== Starting Process Monitor ====="

for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    log "$service is running"
  else
    log "$service is stopped. Attempting restart..."

    # Try restarting service
    if sudo systemctl restart "$service"; then
      log "$service restarted successfully"
    else
      log "Failed to restart $service"
    fi
  fi
done

log "===== Process Monitor Completed ====="
