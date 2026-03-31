#!/bin/bash

LOG_FILE="../logs/process_monitor.log"

services=("nginx" "ssh" "docker")
  
 echo "--- Process Monitoring Report ---" | tee -a "${LOG_FILE}"
 
# Loop through the array to check each service
 
  for service in "${services[@]}"; do
 
# Check if the process is running using pgrep
 
          if pgrep -x "${service}" > /dev/null; then
	      	  echo "${service}: Running" | tee -a "${LOG_FILE}"
 	  else
# If NOT running, simulate a restart 
                  echo "${service}: Stopped" | tee -a "${LOG_FILE}"
      		  echo "Attempting restart for ${service}..." | tee -a "${LOG_FILE}"
 
# Simulating the restart
                  sleep 1 
		  echo "${service}: Restarted" | tee -a "${LOG_FILE}"
	  fi
	  echo "----------------------------" | tee -a "${LOG_FILE}"
  done
