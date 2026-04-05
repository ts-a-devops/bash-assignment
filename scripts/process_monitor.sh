#!/bin/bash

LOG_FILE="../logs/process_monitor.log"
services=("nginx" "ssh" "docker")

process=$1

if pgrep $process > /dev/null
then
  echo "$process is Running" | tee -a LOG_FILE
else
  echo "$process is stopped. Restarting..." | tee -a $LOG_FILE
  echo "$process Restarted (simulated)" | tee -a $LOG_FILE
fi
