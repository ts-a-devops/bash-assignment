#!/bin/bash

set -e

# === 1. Define services array ===
services=("nginx" "ssh" "docker")

# === 2. Input process name ===
PROCESS="$1"

# Validate input
if [[ -z "$PROCESS" ]]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

# Check if process is in allowed services
if [[ ! " ${services[@]} " =~ " ${PROCESS} " ]]; then
    echo "Error: '$PROCESS' is not in monitored services: ${services[*]}"
    exit 1
fi

# Setup logging
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/process_monitor.log"
mkdir -p "$LOG_DIR"

# === 3. Check if process is running ===
if pgrep -x "$PROCESS" > /dev/null; then
    echo "Running"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $PROCESS is Running" >> "$LOG_FILE"
else
    echo "Stopped"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $PROCESS is Stopped" >> "$LOG_FILE"

    # === 4. Attempt restart (simulation) ===
    echo "Restarting $PROCESS..."
    
    # Simulate restart (safe for assignment)
    sleep 1
    
    echo "Restarted"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $PROCESS Restarted" >> "$LOG_FILE"
fi
