#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/app.log"

log() {
  echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

run_all() {
  log "Running all scripts"

  ./scripts/user_info.sh || log "user_info failed"
  ./scripts/system_check.sh || log "system_check failed"

  read -rp "Enter directory to backup: " dir
  ./scripts/backup.sh "$dir" || log "backup failed"
}

run_system_check() {
  ./scripts/system_check.sh && log "system check completed"
}

run_backup() {
  read -rp "Enter directory to backup: " dir
  ./scripts/backup.sh "$dir" && log "backup completed"
}

while true; do
  echo
  echo "===== MENU ====="
  echo "1. Run All"
  echo "2. System Check"
  echo "3. Backup"
  echo "4. Exit"
  echo

  read -rp "Choose an option: " choice

  case "$choice" in
    1) run_all ;;
    2) run_system_check ;;
    3) run_backup ;;
    4) log "Exiting"; exit 0 ;;
    *) echo "Invalid option" ;;
  esac
done
