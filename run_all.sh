#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
APP_LOG="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "$APP_LOG"
}

run_with_logging() {
  local description="$1"
  shift

  log_message "Starting: $description"
  if "$@"; then
    log_message "Completed: $description"
  else
    log_message "Failed: $description"
    printf 'Action failed: %s\n' "$description"
  fi
}

run_all() {
  read -r -p "Enter a directory to back up: " backup_target
  run_with_logging "system check" "$SCRIPT_DIR/scripts/system_check.sh"
  run_with_logging "backup for $backup_target" "$SCRIPT_DIR/scripts/backup.sh" "$backup_target"
}

run_system_check() {
  run_with_logging "system check" "$SCRIPT_DIR/scripts/system_check.sh"
}

run_backup() {
  read -r -p "Enter a directory to back up: " backup_target
  run_with_logging "backup for $backup_target" "$SCRIPT_DIR/scripts/backup.sh" "$backup_target"
}

while true; do
  printf '\nDevOps Bash Toolkit Menu\n'
  printf '1. Run all\n'
  printf '2. System check\n'
  printf '3. Backup\n'
  printf '4. Exit\n'
  read -r -p "Choose an option: " choice

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
      log_message "Application exited by user"
      printf 'Exiting.\n'
      break
      ;;
    *)
      printf 'Invalid option. Try again.\n'
      log_message "Invalid menu option: $choice"
      ;;
  esac
done
