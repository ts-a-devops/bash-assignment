#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log_action() {
  echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

run_system_check() {
  log_action "Running system_check.sh"
  if ./scripts/system_check.sh; then
    log_action "system_check.sh completed successfully"
  else
    log_action "system_check.sh failed"
  fi
}

run_backup() {
  read -r -p "Enter directory path to back up: " backup_dir
  log_action "Running backup.sh for '$backup_dir'"
  if ./scripts/backup.sh "$backup_dir"; then
    log_action "backup.sh completed successfully"
  else
    log_action "backup.sh failed"
  fi
}

run_all() {
  log_action "Running all core scripts"

  if ./scripts/user_info.sh; then
    log_action "user_info.sh completed successfully"
  else
    log_action "user_info.sh failed"
  fi

  run_system_check

  if ./scripts/file_manager.sh list .; then
    log_action "file_manager.sh completed successfully"
  else
    log_action "file_manager.sh failed"
  fi

  read -r -p "Enter directory path for backup in 'Run all': " backup_dir
  if ./scripts/backup.sh "$backup_dir"; then
    log_action "backup.sh completed successfully"
  else
    log_action "backup.sh failed"
  fi
}

show_menu() {
  echo
  echo "===== DevOps Bash Toolkit ====="
  echo "1. Run all"
  echo "2. System check"
  echo "3. Backup"
  echo "4. Exit"
  echo "==============================="
}

main() {
  while true; do
    show_menu
    read -r -p "Choose an option [1-4]: " choice

    case "$choice" in
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
        log_action "Exiting application"
        exit 0
        ;;
      *)
        echo "Invalid choice. Please select 1-4."
        ;;
    esac
  done
}

main
