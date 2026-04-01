#!/bin/bash
set -euo pipefail
services=("nginx" "ssh" "docker")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."&& pwd)"
LOG_FILE="$SCRIPT_DIR/logs/progress_monitor.log"
mkdir -p "$SCRIPT_DIR/logs"
for service in "${services[@]}"; do
if pgrep "$service" > /dev/null; then
echo "$service is Running"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $service Running" >> "$LOG_FILE"
else
echo "$service is Stopped"
echo "Attempting restart of $service..."
#simulate restart
echo "$service Restarted"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $service Restarted" >> "$LOG_FILE"
fi
done
 
