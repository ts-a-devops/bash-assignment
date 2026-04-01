#!/bin/bash

# =========================================================
# RUN ALL SCRIPT (MENU DRIVER)
# - Calls other scripts from scripts/
# - Logs all actions
# - Handles failures gracefully
# =========================================================

set -euo pipefail


# ---------------- SETUP DIRECTORIES ----------------

log_dir="logs"
log_file="${log_dir}/app.log"


if [[ ! -d "$log_dir" ]]; then
    mkdir -p "$log_dir"
fi


# ---------------- LOG FUNCTION ----------------

log() {
  echo "$(date): $1" | tee -a "$log_file"
}


# ---------------- ERROR HANDLER ----------------

handle_error() {
  log "ERROR: A script failed to execute."
  echo "Something went wrong. Check logs."
}


# Trap any failure
trap handle_error ERR


# ---------------- FUNCTIONS ----------------

run_system_check() {
  log "Running system check..."
  bash scripts/system_check.sh
  log "System check completed."
}


run_backup() {
  log "Running backup..."
  bash scripts/backup.sh
  log "Backup completed."
}


run_all() {
  log "Running ALL scripts..."

  bash scripts/system_check.sh
  bash scripts/backup.sh

  log "All scripts executed successfully."
}


show_menu() {
  echo "=============================="
  echo "      SYSTEM MENU"
  echo "=============================="
  echo "1. Run All"
  echo "2. System Check"
  echo "3. Backup"
  echo "4. Exit"
  echo "=============================="
}


# ---------------- MAIN LOOP ----------------

while true; do

  show_menu
  read -p "Select option: " choice

  if [[ "$choice" == "1" ]]; then
    run_all

  elif [[ "$choice" == "2" ]]; then
    run_system_check

  elif [[ "$choice" == "3" ]]; then
    run_backup

  elif [[ "$choice" == "4" ]]; then
    log "User exited application."
    echo "Goodbye!"
    exit 0

  else
    echo "Invalid option. Try again."
  fi

done
