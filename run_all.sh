#!/bin/bash

set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# -------------------------
# FUNCTIONS
# -------------------------

run_all() {
  log "Running ALL scripts"

  run_script "User Info" "bash scripts/user_info.sh"
  run_script "System Check" "bash scripts/system_check.sh"
  run_script "Backup" "bash scripts/backup.sh scripts"
  run_script "Process Monitor" "bash scripts/process_monitor.sh nginx"
  run_script "File Manager (list)" "bash scripts/file_manager.sh list"
}

run_system_check() {
  log "Running System Check"
  run_script "System Check" "bash scripts/system_check.sh"
}

run_backup() {
  read -p "Enter directory to back up: " DIR
  log "Running Backup on $DIR"
  run_script "Backup" "bash scripts/backup.sh $DIR"
}

# -------------------------
# SAFE EXECUTION HANDLER
# -------------------------
run_script() {
  NAME=$1
  CMD=$2

  echo ""
  echo ">>> $NAME"
  log "START: $NAME"

  if eval "$CMD"; then
    log "SUCCESS: $NAME"
  else
    log "FAILED: $NAME"
    echo "Error occurred in $NAME (continuing...)"
  fi
}

# -------------------------
# MENU
# -------------------------
while true; do
  echo ""
  echo "=============================="
  echo " DEVOPS TOOLKIT MENU"
  echo "=============================="
  echo "1. Run All"
  echo "2. System Check"
  echo "3. Backup"
  echo "4. Exit"
  echo "=============================="

  read -p "Choose an option: " CHOICE

  case $CHOICE in
    1) run_all ;;
    2) run_system_check ;;
    3) run_backup ;;
    4)
      log "Exiting application"
      echo "Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option. Try again."
      ;;
  esac
done
