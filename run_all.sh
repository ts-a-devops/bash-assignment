#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_system_check() {
  log "Running system check..."
  if ./scripts/system_check.sh; then
    log "System check completed successfully."
  else
    log "System check failed."
  fi
}

run_backup() {
  read -rp "Enter directory to back up: " dir
  log "Running backup for directory: $dir"
  if ./scripts/backup.sh "$dir"; then
    log "Backup completed successfully."
  else
    log "Backup failed."
  fi
}

run_all_scripts() {
  log "Running all available scripts..."
  ./scripts/system_check.sh || log "system_check.sh failed"
  ./scripts/user_info.sh || log "user_info.sh failed"

  read -rp "Enter directory to back up for run all: " dir
  ./scripts/backup.sh "$dir" || log "backup.sh failed"
}

show_menu() {
  echo
  echo "===== DevOps Bash Toolkit ====="
  echo "1. Run all"
  echo "2. System check"
  echo "3. Backup"
  echo "4. Exit"
}

while true; do
  show_menu
  read -rp "Choose an option: " choice

  case "$choice" in
    1) run_all_scripts ;;
    2) run_system_check ;;
    3) run_backup ;;
    4)
      log "Exiting application."
      exit 0
      ;;
    *)
      echo "Invalid option. Try again."
      ;;
  esac
done
