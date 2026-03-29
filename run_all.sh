#!/bin/bash

set -euo pipefail

LOG_FILE="logs/app.log"

# Ensure logs directory exists
mkdir -p logs

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

run_user_info() {
  log "Running User Info Script"
  ./scripts/user_info.sh "Zinny" 25 "Nigeria"
}

run_system_check() {
  log "Running System Check Script"
  ./scripts/system_check.sh
}

run_file_manager() {
  log "Running File Manager Script"
  ./scripts/file_manager.sh list
}

run_backup() {
  log "Running Backup Script"
  ./scripts/backup.sh "$HOME/bash-assignment"
}

run_process_monitor() {
  log "Running Process Monitor Script"
  ./scripts/process_monitor.sh nginx
}

run_all() {
  log "=============================="
  log "RUNNING ALL SCRIPTS"
  log "=============================="

  run_user_info
  run_system_check
  run_file_manager
  run_backup
  run_process_monitor

  log "All scripts completed"
}

while true; do
  echo "============================"
  echo " Bash Assignment Menu"
  echo "============================"
  echo "1) Run all"
  echo "2) System check"
  echo "3) Backup"
  echo "4) Exit"
  read -p "Choose an option: " choice

  case $choice in
    1)
      run_all
      ;;
    2)
      run_system_check
      ;;
    3)
      run_backup
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid option"
      ;;
  esac

  echo ""
done
