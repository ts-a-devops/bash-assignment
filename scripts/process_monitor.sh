#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/process_monitor.log"

PROCESS=${1:-}

[[ -z "$PROCESS" ]] && echo "Provide process name" && exit 1

if pgrep "$PROCESS" > /dev/null; then
  STATUS="Running"
else
  STATUS="Restarted (simulated)"
fi

echo "$PROCESS is $STATUS"
echo "$(date): $PROCESS $STATUS" >> "$LOG_FILE"
