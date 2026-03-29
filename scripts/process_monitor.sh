#!/bin/bash

# process_monitor.sh

if [ -z "$1" ]; then
  echo "Usage: $0 <process_name>"
  exit 1
fi

PROCESS=$1
LOGFILE="process_monitor.log"

echo "Checking process: $PROCESS"

if pgrep -x "$PROCESS" > /dev/null
then
  echo "$(date): $PROCESS is running" | tee -a "$LOGFILE"
else
  echo "$(date): $PROCESS is NOT running" | tee -a "$LOGFILE"
  echo "$(date): Attempting to simulate restart..." | tee -a "$LOGFILE"
  echo "$(date): $PROCESS restarted (simulation)" | tee -a "$LOGFILE"
fi
