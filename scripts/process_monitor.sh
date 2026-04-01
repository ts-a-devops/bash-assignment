#!/bin/bash

services=("nginx" "ssh" "docker")
LOG="logs/process_monitor.log"

for service in "${services[@]}"; do
  if pgrep $service > /dev/null
  then
    echo "$service is Running" | tee -a $LOG
  else
    echo "$service is Stopped -> Restarting..." | tee -a $LOG
    # simulate restart
    sleep 1
    echo "$service Restarted" | tee -a $LOG
  fi
done
