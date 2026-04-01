#!/bin/bash

# =========================================================
# PROCESS MONITOR SCRIPT (Optional Bonus)
# - Checks if a process is running
# - Restarts if not running (simulated)
# - Logs results
# - Uses array of services
# =========================================================


# ---------------- SETUP LOG DIRECTORY ----------------

log_dir="logs"
log_file="${log_dir}/process_monitor.log"

if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi


# ---------------- SERVICES ARRAY ----------------

services=("nginx" "ssh" "docker")


# ---------------- INPUT ----------------

read -p "Enter process name: " process_name


# ---------------- VALIDATION ----------------

if [[ -z "$process_name" ]]; then
  echo "Error: No process name provided."
  exit 1
fi


# ---------------- CHECK IF PROCESS EXISTS IN ARRAY ----------------

found=0

for service in "${services[@]}"; do
  if [[ "$service" == "$process_name" ]]; then
    found=1
    break
  fi
done

if [[ $found -eq 0 ]]; then
  echo "Error: Process not in monitored services list."
  echo "$(date): INVALID PROCESS - $process_name not monitored" >> "$log_file"
  exit 1
fi


# ---------------- CHECK PROCESS STATUS ----------------

if pgrep "$process_name" > /dev/null; then

  echo "Running"
  echo "$(date): $process_name STATUS - RUNNING" >> "$log_file"

else

  echo "Stopped"
  echo "$(date): $process_name STATUS - STOPPED" >> "$log_file"

  # ---------------- SIMULATE RESTART ----------------

  echo "Restarting $process_name..."

  sleep 1

  echo "Restarted"
  echo "$(date): $process_name ACTION - RESTARTED (simulated)" >> "$log_file"

fi
